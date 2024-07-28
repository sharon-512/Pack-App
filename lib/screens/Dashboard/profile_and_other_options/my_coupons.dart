import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../custom_style.dart';
import '../../../widgets/green_appbar.dart';

class Coupon {
  final String title;
  final String description;
  final String imageUrl;

  Coupon(
      {required this.title, required this.description, required this.imageUrl});

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      title: json['title'] ?? 'No Title',
      description: json['description'] ?? 'No Description',
      imageUrl: json['imageUrl'] ?? 'default_image_url',
    );
  }
}

Future<List<Coupon>> fetchCoupons() async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('bearerToken');
  final url = Uri.parse('https://interfuel.qa/packupadmin/api/all-coupon');
  final response = await http.get(
    url, // Use GET if that's what the endpoint expects
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json', // Ensure correct Accept header if needed
    },
  );

  print('Request URL: ${url.toString()}');
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List<dynamic> couponsJson = data['coupons'] ?? [];
    return couponsJson.map((json) => Coupon.fromJson(json)).toList();
  } else {
    throw Exception(
        'Failed to load coupons. Status code: ${response.statusCode}');
  }
}

class MyCoupons extends StatefulWidget {
  const MyCoupons({super.key});

  @override
  _MyCouponsState createState() => _MyCouponsState();
}

class _MyCouponsState extends State<MyCoupons> {
  late Future<List<Coupon>> _couponsFuture;

  @override
  void initState() {
    super.initState();
    _couponsFuture = fetchCoupons(); // Initialize the future
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          GreenAppBar(showBackButton: true, titleText: 'My Coupons'),
          Expanded(
            child: FutureBuilder<List<Coupon>>(
              future: _couponsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No coupons found'));
                }

                final coupons = snapshot.data!;
                return ListView.builder(
                  itemCount: coupons.length,
                  itemBuilder: (context, index) {
                    final coupon = coupons[index];
                    return coupenCard(coupon);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget coupenCard(Coupon coupon) {
    return Container(
      height: 155,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color(0xffFFF2E1),
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: AssetImage('assets/images/selected_pack_bg2.png'),
                fit: BoxFit.cover,
              ),
            ),
            alignment: Alignment.topRight,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(coupon.imageUrl, height: 120),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      coupon.title,
                      style: CustomTextStyles.titleTextStyle.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff124734),
                      ),
                    ),
                    SizedBox(height: 15),
                    Container(
                      height: 30,
                      width: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            coupon.description,
                            style: CustomTextStyles.titleTextStyle.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.file_copy_rounded,
                              size: 16, color: Colors.grey[300]),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
