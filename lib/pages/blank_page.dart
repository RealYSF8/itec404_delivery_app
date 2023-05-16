import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class BlankPage extends StatefulWidget {
  @override
  _BlankPageState createState() => _BlankPageState();
}

class _BlankPageState extends State<BlankPage> {
  GoogleMapController? _mapController;
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
    LocationPermission permission;

    // Check if location services are enabled
    bool serviceEnabled;
    try {
      serviceEnabled = await geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are disabled
        return;
      }
    } catch (e) {
      // Error occurred while checking location service status
      return;
    }

    // Request location permission
    permission = await geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      // Location permission is permanently denied, show error message or request manual permission through device settings
      return;
    }

    if (permission == LocationPermission.denied) {
      // Location permission is denied, ask for permission
      permission = await geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        // Location permission is not granted, show error message or request manual permission through device settings
        return;
      }
    }

    // Get the current position
    Position? position;
    try {
      position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      // Error occurred while getting the current position
      position = null;
    }

    setState(() {
      _currentPosition = position;
    });

    // Move the camera to the current position
    _moveToCurrentPosition();
  }

  void _moveToCurrentPosition() {
    if (_mapController != null && _currentPosition != null) {
      final CameraPosition newPosition = CameraPosition(
        target: LatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        ),
        zoom: 14,
      );
      _mapController!.animateCamera(CameraUpdate.newCameraPosition(newPosition));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blank Page'),
      ),
      body: SizedBox(
        width: 100,
        height: 200,
        child: Stack(
          children: [
        GoogleMap(
        initialCameraPosition: CameraPosition(
        target: LatLng(
          _currentPosition?.latitude ?? 0,
          _currentPosition?.longitude ?? 0,
        ),
        zoom: 14,
      ),
      onMapCreated: (GoogleMapController controller) {
        _mapController = controller;
      },
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      markers: Set<Marker>.from([
        Marker(
          markerId: MarkerId('marker_1'),
          position: LatLng(
            _currentPosition?.latitude ?? 0,
            _currentPosition?.longitude ?? 0,
          ),
          infoWindow: InfoWindow(
            title: 'Marker 1',
          ),
        ),
      ]),
    ),

            Positioned(
              bottom: 16.0,
              right: 16.0,
              child: FloatingActionButton(
                onPressed: _moveToCurrentPosition,
                child: Icon(Icons.my_location),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
