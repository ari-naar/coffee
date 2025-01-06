class Cafe {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final String? address;
  final double? rating;
  final String? photoUrl;
  final bool isOpen;
  final double distance; // in meters

  Cafe({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address,
    this.rating,
    this.photoUrl,
    this.isOpen = false,
    required this.distance,
  });

  factory Cafe.fromFoursquare(Map<String, dynamic> json) {
    final location = json['geocodes']['main'];
    final address = json['location'];

    return Cafe(
      id: json['fsq_id'],
      name: json['name'],
      latitude: location['latitude'],
      longitude: location['longitude'],
      address: address['formatted_address'],
      rating: json['rating']?.toDouble(),
      photoUrl: null, // We'll need to make a separate call for photos
      isOpen: json['hours']?['is_open'] ?? false,
      distance: json['distance']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'rating': rating,
      'photoUrl': photoUrl,
      'isOpen': isOpen,
      'distance': distance,
    };
  }
}
