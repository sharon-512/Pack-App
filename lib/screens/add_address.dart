import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hive/hive.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../widgets/common_button.dart';
import '../custom_style.dart';
import '../widgets/info_container.dart';
import 'Summary/map.dart';
import 'package:http/http.dart' as http;

class AddAddress extends StatefulWidget {
  const AddAddress({Key? key}) : super(key: key);

  @override
  State<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _selectedIndex = 0;
  LatLng? _selectedLocation;
  late TextEditingController addressline;
  final TextEditingController streetNumber = TextEditingController();
  final TextEditingController houseName = TextEditingController();
  final TextEditingController flatNumber = TextEditingController();
  late TextEditingController name;
  late TextEditingController contactNumber;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final userBox = Hive.box<User>('userBox');
    final user = userBox.get('currentUser');
    addressline = TextEditingController(text: 'Fetching current location...');
    name = TextEditingController(text: user!.firstname);
    contactNumber = TextEditingController(text: user.mobno);
    _requestLocationPermission();
    _loadAddressesFromLocalStorage(); // Load addresses from local storage
  }

  Future<void> _loadAddressesFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> storedAddresses = prefs.getStringList('addresses') ?? [];
    // Do something with the storedAddresses if needed
  }


  Future<void> _requestLocationPermission() async {
    var status = await Permission.location.status;
    if (status.isDenied) {
      status = await Permission.location.request();
    }
    if (status.isGranted) {
      _fetchCurrentLocation();
    } else {
      setState(() {
        addressline.text = 'Location permission denied';
      });
    }
  }

  Future<void> _fetchCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      _selectedLocation = LatLng(position.latitude, position.longitude);
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        setState(() {
          addressline.text =
              '${placemarks.first.street ?? ''}, ${placemarks.first.locality ?? ''}, ${placemarks.first.country ?? ''}';
        });
      } else {
        setState(() {
          addressline.text = 'Unknown address';
        });
      }
    } catch (e) {
      setState(() {
        addressline.text = 'Error fetching location';
      });
    }
  }

  void _handleLocationSelected(LatLng location, String address) {
    setState(() {
      _selectedLocation = location;
      addressline.text = address;
    });
  }

  @override
  void dispose() {
    addressline.dispose();
    streetNumber.dispose();
    houseName.dispose();
    flatNumber.dispose();
    name.dispose();
    contactNumber.dispose();
    super.dispose();
  }

  void _addAddress() async {
    setState(() {
      _isLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      final userBox = Hive.box<User>('userBox');
      final user = userBox.get('currentUser');
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('bearerToken');

      final response = await http.post(
        Uri.parse('https://interfuel.qa/packupadmin/api/save-address'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'user_id': user!.id.toString(), // Ensure this matches the API requirements
          'addresline': addressline.text,
          'street': streetNumber.text,
          'floor': houseName.text,
          'flat': flatNumber.text,
        },
      );

      if (response.statusCode == 200) {
        // Successfully saved the address
        final responseData = json.decode(response.body);

        // Save the new address to local storage
        List<String> storedAddresses = prefs.getStringList('addresses') ?? [];
        storedAddresses.add(jsonEncode({
          'address': addressline.text,
          'streetNo': streetNumber.text,
          'buildingNo': houseName.text,
          'flatNo': flatNumber.text,
          'mobileNo': contactNumber.text,
        }));
        await prefs.setStringList('addresses', storedAddresses);

        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context, {
          'address': addressline.text,
          'streetNo': streetNumber.text,
          'buildingNo': houseName.text,
          'flatNo': flatNumber.text,
          'mobileNo': contactNumber.text,
        });
      } else {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save address')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Stack(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black,
                          width: 1.0,
                        ),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 18,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Add Address',
                      style: CustomTextStyles.titleTextStyle
                          .copyWith(fontSize: 24),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 250,
                child: MapWidget(
                  initialLocation: _selectedLocation ??
                      const LatLng(25.276987, 51.520008), // Center of Doha
                  onLocationSelected: _handleLocationSelected,
                ),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Address',
                          style: CustomTextStyles.titleTextStyle
                              .copyWith(fontSize: 16),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            for (int i = 0; i < 3; i++)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedIndex = i;
                                  });
                                },
                                child: Container(
                                  width: 80,
                                  height: 37,
                                  margin:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 20),
                                  decoration: BoxDecoration(
                                    color: _selectedIndex == i
                                        ? const Color(0xFFEDC0B2)
                                        : Colors.transparent,
                                    border: Border.all(
                                        color: const Color(0xFFEDC0B2)),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    i == 0
                                        ? 'Home'
                                        : i == 1
                                            ? 'Office'
                                            : 'Other',
                                    style: TextStyle(
                                      color: _selectedIndex == i
                                          ? Colors.white
                                          : Colors.black,
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Aeonik',
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        AddressWidget(
                          label: 'Address Line',
                          address: addressline.text,
                          textEditingController: addressline,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the address line';
                            }
                            return null;
                          },
                        ),
                        AddressWidget(
                          label: 'Street Number',
                          address: 'Ex: 10th street',
                          textEditingController: streetNumber,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the street number';
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: AddressWidget(
                                label: 'House/Floor Number',
                                address: 'Ex: 02',
                                textEditingController: houseName,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the house/floor number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: AddressWidget(
                                label: 'Flat Number',
                                address: 'Ex: 2B',
                                textEditingController: flatNumber,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the flat number';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        AddressWidget(
                          label: 'Contact Person Name',
                          address: 'Muhammed Sheharin',
                          hintStyle: CustomTextStyles.labelTextStyle
                              .copyWith(fontSize: 14),
                          textEditingController: name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the contact person name';
                            }
                            return null;
                          },
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Contact Number',
                              style: CustomTextStyles.labelTextStyle.copyWith(
                                  fontSize: 12, fontWeight: FontWeight.w400),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              height: 44,
                              width: double.infinity,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 18.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: const Color(0xff000000)
                                        .withOpacity(.07)),
                                borderRadius: BorderRadius.circular(17),
                              ),
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Image.asset('assets/images/flag.png'),
                                  Text(
                                    '  +974',
                                    style: CustomTextStyles.labelTextStyle
                                        .copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextFormField(
                                      controller: contactNumber,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: '30567890',
                                        hintStyle: CustomTextStyles
                                            .labelTextStyle
                                            .copyWith(fontSize: 14),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter the contact number';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CommonButton(
                          text: 'Continue',
                          onTap: _addAddress,
                          isLoading: _isLoading,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
