import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:geolocator/geolocator.dart' as geo;
import '../services/map_service.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
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
        // Start tracking only after we have the initial position
        _startLocationTracking();
      }
    } catch (e) {
      print('Error initializing camera: $e');
    }
  }

  void _startLocationTracking() {
    // Add a small delay before starting location updates
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _mapService.startLocationUpdates((position) {
          if (_mapboxMap != null && _isMapReady && mounted) {
            _mapService.animateToLocation(_mapboxMap!, position);
          }
        });
      }
    });
  }

  @override
  void dispose() {
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

  Future<void> _onMapCreated(MapboxMap mapboxMap) async {
    print('Map created, initializing...');
    _mapboxMap = mapboxMap;

    try {
      // Small delay to ensure network connection is ready
      await Future.delayed(const Duration(milliseconds: 300));

      // Set initial camera position immediately
      await mapboxMap.setCamera(_initialCameraPosition!);

      // Run style loading and gesture setup in parallel
      await Future.wait([
        _mapService
            .updateMapStyle(mapboxMap, Theme.of(context).brightness)
            .timeout(
          const Duration(seconds: 5),
          onTimeout: () {
            print('Style loading timed out, retrying...');
            return _mapService.updateMapStyle(
                mapboxMap, Theme.of(context).brightness);
          },
        ),
        mapboxMap.gestures.updateSettings(
          GesturesSettings(
            rotateEnabled: true,
            scrollEnabled: true,
            doubleTapToZoomInEnabled: true,
            doubleTouchToZoomOutEnabled: true,
            quickZoomEnabled: true,
            pinchToZoomEnabled: true,
          ),
        ),
      ]);

      setState(() {
        _isMapReady = true;
      });

      // Immediately animate to user location
      print('Animating to initial position...');
      await _mapService.animateToLocation(
        mapboxMap,
        geo.Position(
          latitude: _initialCameraPosition!.center!['lat'] as double,
          longitude: _initialCameraPosition!.center!['lng'] as double,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          heading: 0,
          speed: 0,
          speedAccuracy: 0,
          altitudeAccuracy: 0,
          headingAccuracy: 0,
        ),
      );

      setState(() {
        _isCameraCentered = true;
      });
      print('Map initialization complete');
    } catch (e, stackTrace) {
      print('Error in map creation: $e');
      print('Stack trace: $stackTrace');
    }
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
          resourceOptions: ResourceOptions(
            accessToken: _mapService.mapboxAccessToken,
          ),
          styleUri: _mapService.getMapStyle(Theme.of(context).brightness),
          cameraOptions: _initialCameraPosition!,
          onMapCreated: _onMapCreated,
          textureView: true,
        ),
        if (!_isCameraCentered)
          Container(
            color: Colors.black45,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CupertinoActivityIndicator(radius: 15),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
