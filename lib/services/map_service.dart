import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class MapService {
  static final MapService _instance = MapService._internal();
  factory MapService() => _instance;
  MapService._internal();

  String get mapboxAccessToken => dotenv.env['MAPBOX_ACCESS_TOKEN'] ?? '';

  static const _defaultLatitude = 37.7749; // San Francisco
  static const _defaultLongitude = -122.4194;
  static const _defaultZoom = 11.0;

  CameraOptions getInitialCameraPosition() {
    return CameraOptions(
      center: <String, dynamic>{
        'lng': _defaultLongitude,
        'lat': _defaultLatitude,
      },
      zoom: _defaultZoom,
    );
  }

  String getMapStyle(Brightness brightness) {
    return brightness == Brightness.dark
        ? 'mapbox://styles/mapbox/dark-v11'
        : 'mapbox://styles/mapbox/light-v11';
  }

  Future<void> updateMapStyle(
      MapboxMap mapboxMap, Brightness brightness) async {
    final style = getMapStyle(brightness);
    await mapboxMap.loadStyleURI(style);
  }
}
