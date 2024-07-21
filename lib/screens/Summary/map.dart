import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../widgets/common_button.dart';

class MapWidget extends StatefulWidget {
  final LatLng? initialLocation;
  final Function(LatLng, String) onLocationSelected;

  const MapWidget({
    Key? key,
    this.initialLocation,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  LatLng? _selectedLocation;
  LatLng? _currentLocation;

  final LatLngBounds _qatarBounds = LatLngBounds(
    southwest: LatLng(24.280059, 50.898183),
    northeast: LatLng(26.383488, 51.692782),
  );

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    // Request location permission
    PermissionStatus permission = await Permission.location.request();
    if (permission.isGranted) {
      // Get current location
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
      });
    } else {
      // Handle permission denied case
      print("Location permission denied");
    }
  }

  void _onMapCreated(GoogleMapController controller) {}

  void _onTap(LatLng position) async {
    if (_qatarBounds.contains(position)) {
      setState(() {
        _selectedLocation = position;
      });
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        String address = '${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}';
        widget.onLocationSelected(position, address);
      } else {
        widget.onLocationSelected(position, 'Unknown address');
      }
    } else {
      widget.onLocationSelected(position, 'Please select a location within Qatar');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GoogleMap(
          scrollGesturesEnabled: true,
          zoomControlsEnabled: true,
          zoomGesturesEnabled: true,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _currentLocation ?? widget.initialLocation ?? LatLng(25.276987, 51.520008),
            zoom: 12.0,
          ),
          onTap: _onTap,
          markers: {
            if (_currentLocation != null)
              Marker(
                markerId: MarkerId('current-location'),
                position: _currentLocation!,
                infoWindow: InfoWindow(title: 'Current Location'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
              ),
            if (_selectedLocation != null)
              Marker(
                markerId: MarkerId('selected-location'),
                position: _selectedLocation!,
                infoWindow: InfoWindow(title: 'Selected Location'),
                icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
              ),
          },
          liteModeEnabled: false,
          myLocationButtonEnabled: true,
          mapType: MapType.normal,
        ),
      ),
    );
  }
}
