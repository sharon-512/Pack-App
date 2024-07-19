// map_widget.dart
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

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

  final LatLngBounds _qatarBounds = LatLngBounds(
    southwest: LatLng(24.280059, 50.898183),
    northeast: LatLng(26.383488, 51.692782),
  );

  void _onMapCreated(GoogleMapController controller) {}

  void _onTap(LatLng position) async {
    if (_qatarBounds.contains(position)) {
      setState(() {
        _selectedLocation = position;
      });
      List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        String address =
            '${placemarks.first.street}, ${placemarks.first.locality}, ${placemarks.first.country}';
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
        child: GestureDetector(
          onVerticalDragStart: (_) {},
          onVerticalDragUpdate: (_) {},
          onVerticalDragEnd: (_) {},
          child: GoogleMap(
            scrollGesturesEnabled: true,
            zoomControlsEnabled: true,
            zoomGesturesEnabled: true,
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: widget.initialLocation ?? LatLng(25.276987, 51.520008),
              zoom: 12.0,
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
            liteModeEnabled: false,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
          ),
        ),
      ),
    );
  }
}
