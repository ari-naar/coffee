import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../widgets/custom_snackbar.dart';
import '../models/cafe.dart';

class MapService {
  static final MapService _instance = MapService._internal();
  factory MapService() => _instance;
  MapService._internal();

  String get mapboxAccessToken => dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';
  static const _defaultZoom = 10.0;

  OverlayEntry? _currentOverlay;

  StreamSubscription<geo.Position>? _locationSubscription;

  PointAnnotationManager? _pointAnnotationManager;
  final Map<String, Cafe> _cafeMarkers = {};

  void startLocationUpdates(void Function(geo.Position) onLocationUpdate) {
    _locationSubscription?.cancel();
    _locationSubscription = geo.Geolocator.getPositionStream(
      locationSettings: const geo.LocationSettings(
        accuracy: geo.LocationAccuracy.high,
        distanceFilter: 10, // Update every 10 meters
      ),
    ).listen(onLocationUpdate);
  }

  void stopLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  Future<void> animateToLocation(
      MapboxMap mapboxMap, geo.Position position) async {
    final cameraOptions = CameraOptions(
      center: Point(
        coordinates: Position(
          position.longitude,
          position.latitude,
        ),
      ).toJson(),
      zoom: _defaultZoom,
    );

    await mapboxMap.flyTo(
      cameraOptions,
      MapAnimationOptions(duration: 500, startDelay: 0),
    );
  }

  void _showSnackBar(BuildContext context, SnackBarType type,
      {VoidCallback? onActionPressed}) {
    _currentOverlay?.remove();

    _currentOverlay = OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).padding.bottom,
        left: 0,
        right: 0,
        child: CustomSnackBar(
          type: type,
          onActionPressed: onActionPressed,
        ),
      ),
    );

    Overlay.of(context).insert(_currentOverlay!);

    // Auto-dismiss after 4 seconds unless it's a permanent error
    if (type != SnackBarType.locationDeniedForever) {
      Future.delayed(const Duration(seconds: 4), () {
        _currentOverlay?.remove();
        _currentOverlay = null;
      });
    }
  }

  Future<geo.Position?> _getCurrentLocation(BuildContext context) async {
    bool serviceEnabled;
    geo.LocationPermission permission;
    final scaffoldContext = context;

    try {
      // Test if location services are enabled
      serviceEnabled = await geo.Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        print('Location services are disabled');
        if (scaffoldContext.mounted) {
          _showSnackBar(
            scaffoldContext,
            SnackBarType.locationDisabled,
            onActionPressed: () async {
              await geo.Geolocator.openLocationSettings();
            },
          );
        }
        return null;
      }

      // Request permission proactively
      permission = await geo.Geolocator.checkPermission();
      if (permission == geo.LocationPermission.denied) {
        print('Requesting location permission...');
        permission = await geo.Geolocator.requestPermission();

        if (permission == geo.LocationPermission.denied) {
          print('Location permissions denied');
          if (scaffoldContext.mounted) {
            _showSnackBar(
              scaffoldContext,
              SnackBarType.locationDenied,
              onActionPressed: () async {
                final newPermission = await geo.Geolocator.requestPermission();
                if (newPermission != geo.LocationPermission.denied) {
                  await _getCurrentLocation(scaffoldContext);
                }
              },
            );
          }
          return null;
        }
      }

      if (permission == geo.LocationPermission.deniedForever) {
        print('Location permissions permanently denied');
        if (scaffoldContext.mounted) {
          _showSnackBar(
            scaffoldContext,
            SnackBarType.locationDeniedForever,
            onActionPressed: () async {
              await geo.Geolocator.openAppSettings();
            },
          );
        }
        return null;
      }

      print('Getting current position...');
      return await geo.Geolocator.getCurrentPosition(
        locationSettings: const geo.LocationSettings(
          accuracy: geo.LocationAccuracy.high,
          timeLimit: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      print('Error getting location: $e');
      if (e is TimeoutException) {
        try {
          return await geo.Geolocator.getCurrentPosition(
            locationSettings: const geo.LocationSettings(
              accuracy: geo.LocationAccuracy.medium,
              timeLimit: Duration(seconds: 3),
            ),
          );
        } catch (e2) {
          print('Error getting location with lower accuracy: $e2');
        }
      }
      // Handle no internet connection
      if (e.toString().contains('network')) {
        if (scaffoldContext.mounted) {
          _showSnackBar(
            scaffoldContext,
            SnackBarType.noInternet,
            onActionPressed: () => _getCurrentLocation(scaffoldContext),
          );
        }
      } else {
        // Handle other errors
        print('Unexpected error getting location: $e');
      }
      return null;
    }
  }

  Future<CameraOptions> getInitialCameraPosition(BuildContext context) async {
    final position = await _getCurrentLocation(context);

    final latitude = position?.latitude ?? -25.897;
    final longitude = position?.longitude ?? 120.215;

    print(
        'Setting camera position: lat=$latitude, lng=$longitude, zoom=$_defaultZoom');

    return CameraOptions(
      center: <String, dynamic>{
        'lng': longitude,
        'lat': latitude,
      },
      zoom: _defaultZoom,
    );
  }

  String getMapStyle(Brightness brightness) {
    return brightness == Brightness.dark
        ? MapboxStyles.DARK
        : MapboxStyles.LIGHT;
  }

  Future<void> updateMapStyle(
      MapboxMap mapboxMap, Brightness brightness) async {
    try {
      final style = getMapStyle(brightness);
      print('Loading map style: $style');
      await mapboxMap.loadStyleURI(style);

      // Verify style loaded successfully
      final loadedStyle = await mapboxMap.style.getStyleURI();
      print('Successfully loaded style: $loadedStyle');
    } catch (e, stackTrace) {
      print('Error updating map style: $e');
      print('Stack trace: $stackTrace');
    }
  }

  Future<void> addCafeMarkers(MapboxMap mapboxMap, List<Cafe> cafes) async {
    _pointAnnotationManager ??=
        await mapboxMap.annotations.createPointAnnotationManager();

    // Clear existing markers
    await _pointAnnotationManager?.deleteAll();
    _cafeMarkers.clear();

    for (final cafe in cafes) {
      try {
        final options = PointAnnotationOptions(
          geometry: Point(
            coordinates: Position(
              cafe.longitude,
              cafe.latitude,
            ),
          ).toJson(),
          iconSize: 1.2,
          iconImage: 'cafe_marker', // We'll need to add this asset
          textField: cafe.name,
          textOffset: [0, 1.2],
          textColor: Colors.black.value,
          textHaloColor: Colors.white.value,
          textHaloWidth: 1.0,
        );

        final point = await _pointAnnotationManager?.create(options);
        if (point != null) {
          _cafeMarkers[point.id.toString()] = cafe;
        }
      } catch (e) {
        print('Error adding cafe marker: $e');
      }
    }
  }

  Cafe? getCafeFromMarkerId(String markerId) {
    return _cafeMarkers[markerId];
  }

  void clearCafeMarkers() {
    _pointAnnotationManager?.deleteAll();
    _cafeMarkers.clear();
  }

  @override
  void dispose() {
    stopLocationUpdates();
    clearCafeMarkers();
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}
