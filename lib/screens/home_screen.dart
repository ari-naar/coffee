import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../providers/coffee_shops_provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  bool _isLoading = true;
  bool _isMapView = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location services are disabled.')),
        );
      }
      return;
    }

    // Check location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied.')),
          );
        }
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location permissions are permanently denied.'),
          ),
        );
      }
      return;
    }

    // Get current position
    final position = await Geolocator.getCurrentPosition();
    if (mounted) {
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });
      _loadNearbyCoffeeShops();
    }
  }

  Future<void> _loadNearbyCoffeeShops() async {
    if (_currentPosition == null) return;

    final coffeeShopsProvider =
        Provider.of<CoffeeShopsProvider>(context, listen: false);
    await coffeeShopsProvider.fetchNearbyCoffeeShops(_currentPosition!);

    if (mounted) {
      setState(() {
        _markers = coffeeShopsProvider.shops.map((shop) {
          return Marker(
            markerId: MarkerId(shop.id),
            position: LatLng(
              shop.location.latitude,
              shop.location.longitude,
            ),
            infoWindow: InfoWindow(
              title: shop.name,
              snippet: 'Rating: ${shop.rating}',
            ),
          );
        }).toSet();

        // Add current location marker
        _markers.add(
          Marker(
            markerId: const MarkerId('currentLocation'),
            position: LatLng(
              _currentPosition!.latitude,
              _currentPosition!.longitude,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
            infoWindow: const InfoWindow(title: 'You are here'),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('CoffeeTrack'),
        actions: [
          // Toggle view button
          IconButton(
            icon: Icon(_isMapView ? Icons.list : Icons.map),
            onPressed: () {
              setState(() {
                _isMapView = !_isMapView;
              });
            },
          ),
          // Profile button
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).pushNamed('/profile');
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(),
    );
  }

  Widget _buildContent() {
    if (_currentPosition == null) {
      return const Center(
        child: Text('Unable to get location. Please enable location services.'),
      );
    }

    return _isMapView ? _buildMapView() : _buildListView();
  }

  Widget _buildMapView() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        ),
        zoom: 15,
      ),
      markers: _markers,
      onMapCreated: (controller) {
        _mapController = controller;
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
    );
  }

  Widget _buildListView() {
    final coffeeShops = Provider.of<CoffeeShopsProvider>(context).shops;

    return ListView.builder(
      itemCount: coffeeShops.length,
      itemBuilder: (context, index) {
        final shop = coffeeShops[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(shop.imageUrl),
              onBackgroundImageError: (_, __) {
                // Handle image load error
              },
              child:
                  shop.imageUrl.isEmpty ? const Icon(Icons.local_cafe) : null,
            ),
            title: Text(shop.name),
            subtitle: Text(shop.address),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber),
                Text(shop.rating.toStringAsFixed(1)),
              ],
            ),
            onTap: () {
              // Navigate to shop details screen
              // TODO: Implement shop details navigation
            },
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
