import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FoursquareService {
  static final FoursquareService _instance = FoursquareService._internal();
  factory FoursquareService() => _instance;
  FoursquareService._internal();

  final String _baseUrl = 'api.foursquare.com';
  final String _version = '20231201'; // Current API version
  String get _apiKey => dotenv.env['FOURSQUARE_API_KEY'] ?? '';

  Future<List<Map<String, dynamic>>> searchCafes(
      double latitude, double longitude,
      {int radius = 5000, // Reduced radius to 5km for more relevant results
      int limit = 50}) async {
    try {
      final queryParameters = {
        'query': 'coffee',
        'll': '$latitude,$longitude',
        'radius': radius.toString(),
        'limit': limit.toString(),
        'categories': '13032,13035,13065', // Coffee Shop, Cafe, Coffee Roaster
        'sort': 'DISTANCE',
        'fields': 'fsq_id,name,geocodes,location,distance,rating,hours,photos',
        'v': _version,
      };

      final uri = Uri.https(_baseUrl, '/v3/places/search', queryParameters);

      final response = await http.get(
        uri,
        headers: {
          'Authorization': _apiKey,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['results'] == null) {
          print('No results found in response');
          return [];
        }

        final results = List<Map<String, dynamic>>.from(data['results']);
        // Filter out results with missing critical data
        return results.where((result) {
          return result['fsq_id'] != null &&
              result['name'] != null &&
              result['geocodes']?['main'] != null;
        }).toList();
      } else {
        print('Error fetching cafes: ${response.statusCode}');
        print('Response body: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error searching cafes: $e');
      return [];
    }
  }

  Future<Map<String, dynamic>?> getCafeDetails(String placeId) async {
    try {
      final uri = Uri.https(_baseUrl, '/v3/places/$placeId');

      final response = await http.get(
        uri,
        headers: {
          'Authorization': _apiKey,
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Error fetching cafe details: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error getting cafe details: $e');
      return null;
    }
  }
}
