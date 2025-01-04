import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'base_service.dart';

class LocationService extends BaseService {
  // Singleton instance
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  // Get current location
  Future<Position> getCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        final requestPermission = await Geolocator.requestPermission();
        if (requestPermission == LocationPermission.denied) {
          throwError('Location permissions are denied');
        }
      }

      if (permission == LocationPermission.deniedForever) {
        throwError('Location permissions are permanently denied');
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      logInfo(
          'Current location retrieved: ${position.latitude}, ${position.longitude}');
      return position;
    } catch (e) {
      logError('Failed to get current location', e);
      rethrow;
    }
  }

  // Get address from coordinates
  Future<String> getAddressFromCoordinates(LatLng coordinates) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        coordinates.latitude,
        coordinates.longitude,
      );

      if (placemarks.isEmpty) {
        throwError('No address found for the given coordinates');
      }

      final place = placemarks.first;
      final address = [
        place.street,
        place.locality,
        place.administrativeArea,
        place.postalCode,
        place.country,
      ].where((element) => element != null && element.isNotEmpty).join(', ');

      logInfo('Address retrieved: $address');
      return address;
    } catch (e) {
      logError('Failed to get address from coordinates', e);
      rethrow;
    }
  }

  // Get coordinates from address
  Future<LatLng> getCoordinatesFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);

      if (locations.isEmpty) {
        throwError('No coordinates found for the given address');
      }

      final location = locations.first;
      final coordinates = LatLng(location.latitude, location.longitude);

      logInfo(
          'Coordinates retrieved: ${coordinates.latitude}, ${coordinates.longitude}');
      return coordinates;
    } catch (e) {
      logError('Failed to get coordinates from address', e);
      rethrow;
    }
  }

  // Calculate distance between two coordinates
  double calculateDistance(LatLng start, LatLng end) {
    try {
      final distanceInMeters = Geolocator.distanceBetween(
        start.latitude,
        start.longitude,
        end.latitude,
        end.longitude,
      );

      final distanceInKm = distanceInMeters / 1000;
      logInfo('Distance calculated: $distanceInKm km');
      return distanceInKm;
    } catch (e) {
      logError('Failed to calculate distance', e);
      rethrow;
    }
  }

  // Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    try {
      final isEnabled = await Geolocator.isLocationServiceEnabled();
      logInfo('Location services enabled: $isEnabled');
      return isEnabled;
    } catch (e) {
      logError('Failed to check location services status', e);
      rethrow;
    }
  }

  // Get location permission status
  Future<LocationPermission> getLocationPermission() async {
    try {
      final permission = await Geolocator.checkPermission();
      logInfo('Location permission status: $permission');
      return permission;
    } catch (e) {
      logError('Failed to get location permission status', e);
      rethrow;
    }
  }

  // Request location permission
  Future<LocationPermission> requestLocationPermission() async {
    try {
      final permission = await Geolocator.requestPermission();
      logInfo('Location permission requested: $permission');
      return permission;
    } catch (e) {
      logError('Failed to request location permission', e);
      rethrow;
    }
  }

  // Open location settings
  Future<bool> openLocationSettings() async {
    try {
      final opened = await Geolocator.openLocationSettings();
      logInfo('Location settings opened: $opened');
      return opened;
    } catch (e) {
      logError('Failed to open location settings', e);
      rethrow;
    }
  }

  // Open app settings
  Future<bool> openAppSettings() async {
    try {
      final opened = await Geolocator.openAppSettings();
      logInfo('App settings opened: $opened');
      return opened;
    } catch (e) {
      logError('Failed to open app settings', e);
      rethrow;
    }
  }

  // Get last known position
  Future<Position?> getLastKnownPosition() async {
    try {
      final position = await Geolocator.getLastKnownPosition();
      if (position != null) {
        logInfo(
            'Last known position retrieved: ${position.latitude}, ${position.longitude}');
      } else {
        logInfo('No last known position available');
      }
      return position;
    } catch (e) {
      logError('Failed to get last known position', e);
      rethrow;
    }
  }

  // Stream position updates
  Stream<Position> getPositionStream({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int distanceFilter = 0,
  }) {
    try {
      return Geolocator.getPositionStream(
        locationSettings: LocationSettings(
          accuracy: accuracy,
          distanceFilter: distanceFilter,
        ),
      );
    } catch (e) {
      logError('Failed to get position stream', e);
      rethrow;
    }
  }
}
