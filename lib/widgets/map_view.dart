import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import 'package:coffee_app/widgets/cafe_grid.dart';
import '../services/map_service.dart';
import '../services/foursquare_service.dart';
import '../models/cafe.dart';

class MapView extends StatefulWidget {
  final Function(List<Cafe>)? onCafesLoaded;

  const MapView({
    super.key,
    this.onCafesLoaded,
  });

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with WidgetsBindingObserver {
  MapboxMap? _mapboxMap;
  final _mapService = MapService();
  CameraOptions? _initialCameraPosition;
  bool _isMapReady = false;
  bool _isInitialLocationSet = false;
  bool _isCameraCentered = false;
  final _foursquareService = FoursquareService();
  List<Cafe> _nearbyCafes = [];
  Timer? _cameraUpdateTimer;
  Point? _lastCenter;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    MapboxOptions.setAccessToken(_mapService.mapboxAccessToken);
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameraPosition =
          await _mapService.getInitialCameraPosition(context);
      if (mounted) {
        setState(() {
          _initialCameraPosition = cameraPosition;
          _isInitialLocationSet = true;
        });

        // Load cafes after getting initial position
        final center = cameraPosition.center!.coordinates;
        if (center.length >= 2) {
          await _loadNearbyCafes(
            center[1]!.toDouble(), // latitude
            center[0]!.toDouble(), // longitude
          );
        }

        // Start tracking only after we have the initial position
        _startLocationTracking();
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void _showCafeDetails(Cafe cafe) {
    // Print detailed cafe data when tapped
    print('''
\n=== Tapped Cafe Details ===
Name: ${cafe.name}
Address: ${cafe.address}
Distance: ${cafe.distance}m
Rating: ${cafe.rating}
Latitude: ${cafe.latitude}
Longitude: ${cafe.longitude}
ID: ${cafe.id}
Photo URL: ${cafe.photoUrl}
Is Open: ${cafe.isOpen}
=========================''');

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cafe.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            if (cafe.address != null) Text(cafe.address!),
            const SizedBox(height: 8),
            Text('${(cafe.distance).round()}m away'),
            if (cafe.rating != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  Text(' ${cafe.rating}'),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _loadNearbyCafes(double latitude, double longitude) async {
    try {
      final cafeData =
          await _foursquareService.searchCafes(latitude, longitude);
      if (mounted) {
        setState(() {
          _nearbyCafes =
              cafeData.map((data) => Cafe.fromFoursquare(data)).toList();
        });

        // Notify parent about loaded cafes
        widget.onCafesLoaded?.call(_nearbyCafes);

        // Print all cafe data when loaded
        print('\n=== Nearby Cafes Loaded ===');
        for (var cafe in _nearbyCafes) {
          print('''
Cafe Details:
  Name: ${cafe.name}
  Address: ${cafe.address}
  Distance: ${cafe.distance}m
  Rating: ${cafe.rating}
  Latitude: ${cafe.latitude}
  Longitude: ${cafe.longitude}
  ID: ${cafe.id}
  Photo URL: ${cafe.photoUrl}
  Is Open: ${cafe.isOpen}
  -------------------''');
        }

        if (_mapboxMap != null) {
          await _mapService.addCafeMarkers(
            _mapboxMap!,
            _nearbyCafes,
            onTap: _showCafeDetails,
          );
        }
      }
    } catch (e) {
      print('Error loading nearby cafes: $e');
    }
  }

  void _startLocationTracking() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _mapService.startLocationUpdates((position) {
          if (_mapboxMap != null && _isMapReady && mounted) {
            _mapService.animateToLocation(_mapboxMap!, position);
            // Refresh cafes when location updates significantly
            _loadNearbyCafes(position.latitude, position.longitude);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _cameraUpdateTimer?.cancel();
    _mapService.clearCafeMarkers();
    _mapService.stopLocationUpdates();
    _mapService.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (_mapboxMap != null && _isMapReady) {
      _mapService.updateMapStyle(_mapboxMap!, Theme.of(context).brightness);
    }
  }

  Future<void> _startCameraUpdateTimer(MapboxMap mapboxMap) async {
    _cameraUpdateTimer?.cancel();
    var lastUpdate = DateTime.now();

    _cameraUpdateTimer =
        Timer.periodic(const Duration(milliseconds: 500), (timer) async {
      if (!mounted || !_isMapReady) return;

      try {
        final center =
            await mapboxMap.getCameraState().then((state) => state.center);
        if (center != null && center != _lastCenter) {
          // Debounce updates to once per second
          final now = DateTime.now();
          if (now.difference(lastUpdate) < const Duration(seconds: 1)) return;
          lastUpdate = now;

          final coordinates = center.coordinates;
          if (coordinates.length >= 2) {
            final lat = coordinates[1]!.toDouble(); // latitude
            final lng = coordinates[0]!.toDouble(); // longitude
            if (_shouldRefreshCafes(lat, lng)) {
              print('Refreshing cafes at: $lat, $lng');
              await _loadNearbyCafes(lat, lng);
            }
          }
          _lastCenter = center;
        }
      } catch (e) {
        print('Error handling map movement: $e');
      }
    });
  }

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    print('Map created, initializing...');
    _mapboxMap = mapboxMap;

    try {
      // Load style and setup gestures
      await _mapService.updateMapStyle(mapboxMap, Theme.of(context).brightness);
      await mapboxMap.gestures.updateSettings(
        GesturesSettings(
          rotateEnabled: false,
          scrollEnabled: true,
          doubleTapToZoomInEnabled: false,
          doubleTouchToZoomOutEnabled: false,
          quickZoomEnabled: false,
          pinchToZoomEnabled: false,
        ),
      );

      // Set initial camera position
      if (_initialCameraPosition != null) {
        print('Setting initial camera position...');
        await mapboxMap.setCamera(_initialCameraPosition!);

        setState(() {
          _isMapReady = true;
          _isCameraCentered = true;
        });
      }

      // Start camera update timer
      await _startCameraUpdateTimer(mapboxMap);

      print('Map initialization complete');
    } catch (e) {
      print('Error in map creation: $e');
    }
  }

  bool _shouldRefreshCafes(double newLat, double newLng) {
    if (_initialCameraPosition?.center == null) return true;

    final oldCenter = _initialCameraPosition!.center!.coordinates;
    if (oldCenter.length < 2) return true;

    final oldLat = oldCenter[1]!.toDouble(); // latitude
    final oldLng = oldCenter[0]!.toDouble(); // longitude

    // Calculate rough distance (in degrees) - about 0.01 degrees = 1km
    final distance = ((newLat - oldLat) * (newLat - oldLat) +
            (newLng - oldLng) * (newLng - oldLng))
        .abs();

    return distance > 0.01; // Refresh if moved more than ~1km
  }

  Future<Uint8List> _loadCafeIcon() async {
    final iconData = Icons.local_cafe;
    final pictureRecorder = ui.PictureRecorder();
    final canvas = Canvas(pictureRecorder);
    final paint = Paint()..color = Colors.brown;

    // Draw the icon
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(iconData.codePoint),
        style: TextStyle(
          fontSize: 48,
          fontFamily: iconData.fontFamily,
          color: paint.color,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);

    final picture = pictureRecorder.endRecording();
    final image = await picture.toImage(48, 48);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialLocationSet || _initialCameraPosition == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CupertinoActivityIndicator(radius: 15),
            const SizedBox(height: 16),
            const Text('Getting your location...'),
          ],
        ),
      );
    }

    return Stack(
      children: [
        MapWidget(
          key: const ValueKey("mapWidget"),
          onMapCreated: _onMapCreated,
          cameraOptions: _initialCameraPosition!,
          styleUri: _mapService.getMapStyle(Theme.of(context).brightness),
          textureView: true,
        ),
        if (!_isCameraCentered)
          Container(
            color: Colors.black45,
            child: const Center(
              child: CupertinoActivityIndicator(radius: 15),
            ),
          ),
      ],
    );
  }
}
