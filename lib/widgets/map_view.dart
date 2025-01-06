import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import '../services/map_service.dart';

class MapView extends StatefulWidget {
  const MapView({super.key});

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> with WidgetsBindingObserver {
  MapboxMap? _mapboxMap;
  final _mapService = MapService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    if (_mapboxMap != null) {
      _mapService.updateMapStyle(_mapboxMap!, Theme.of(context).brightness);
    }
  }

  void _onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    _mapService.updateMapStyle(mapboxMap, Theme.of(context).brightness);
  }

  @override
  Widget build(BuildContext context) {
    return MapWidget(
      key: const ValueKey("mapWidget"),
      resourceOptions: ResourceOptions(
        accessToken: _mapService.mapboxAccessToken,
      ),
      styleUri: _mapService.getMapStyle(Theme.of(context).brightness),
      cameraOptions: _mapService.getInitialCameraPosition(),
      onMapCreated: _onMapCreated,
    );
  }
}
