import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:pack_app/widgets/common_button.dart';

class MapSelectionScreen extends StatefulWidget {
  @override
  _MapSelectionScreenState createState() => _MapSelectionScreenState();
}

class _MapSelectionScreenState extends State<MapSelectionScreen> {
  LatLng? _selectedLocation;
  String _address = 'Select a location';

  void _onMapCreated(GoogleMapController controller) {
    // Initialize map controller if needed
  }

  void _onTap(LatLng position) async {
    setState(() {
      _selectedLocation = position;
    });
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      setState(() {
        _address =
            '${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(25.3548, 51.1839), // Center of Qatar
              zoom: 10.0, // Adjust the initial zoom level as needed
            ),
            onTap: _onTap,
            markers: _selectedLocation != null
                ? {
              Marker(
                markerId: MarkerId('selected-location'),
                position: _selectedLocation!,
              ),
            }
                : {},
            // Restrict user interaction and visible area to Qatar
            liteModeEnabled: false, // Enables full-featured maps
            myLocationButtonEnabled: true, // Show button to move to current location
            mapType: MapType.normal, // Use normal map view
            cameraTargetBounds: CameraTargetBounds(
              LatLngBounds(
                southwest: LatLng(24.3963, 50.6977), // Bottom-left boundary (latitude, longitude)
                northeast: LatLng(26.5108, 51.2156), // Top-right boundary (latitude, longitude)
              ),
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Select Location',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12),

                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.black87,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _address,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 25),
                  CommonButton(
                    text: 'Continue',
                    onTap: () {
                      if (_selectedLocation != null) {
                        Navigator.pop(context, {
                          'location': _selectedLocation,
                          'address': _address,
                        });
                      }
                    },
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
