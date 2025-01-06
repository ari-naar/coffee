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
    final location = json['geocodes']?['main'] ?? {};
    final address = json['location'] ?? {};

    // Handle missing or null values
    final lat = location['latitude'] ?? 0.0;
    final lng = location['longitude'] ?? 0.0;
    final formattedAddress = address['formatted_address'] as String?;
    final rating = json['rating']?.toDouble();
    final distance = (json['distance'] ?? 0).toDouble();
    final isOpen = json['hours']?['is_open'] ?? false;

    return Cafe(
      id: json['fsq_id'] ?? '',
      name: json['name'] ?? 'Unknown Cafe',
      latitude: lat is int ? lat.toDouble() : lat,
      longitude: lng is int ? lng.toDouble() : lng,
      address: formattedAddress,
      rating: rating != null
          ? (rating / 2).clamp(0.0, 5.0)
          : null, // Convert to 5-star scale
      photoUrl: null, // We'll need to make a separate call for photos
      isOpen: isOpen,
      distance: distance,
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
