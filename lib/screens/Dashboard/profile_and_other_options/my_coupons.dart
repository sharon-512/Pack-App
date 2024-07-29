import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../custom_style.dart';
import '../../../widgets/green_appbar.dart';

class Coupon {
  final String code;
  final String value;
  final String expiry;

  Coupon({
    required this.code,
    required this.value,
    required this.expiry,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      code: json['code'] ?? 'No Code',
      value: json['value'] ?? 'No Value',
      expiry: json['expiry'] ?? 'No Expiry',
    );
  }
}

Future<List<Coupon>> fetchCoupons() async {
  final prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('bearerToken');
  final url = Uri.parse('https://interfuel.qa/packupadmin/api/all-coupon');
  final response = await http.get(
    url, // Changed from POST to GET
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    },
  );

  print('Request URL: ${url.toString()}');
  print('Response status: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List<dynamic> couponsJson = data['data'] ?? [];
    return couponsJson.map((json) => Coupon.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load coupons. Status code: ${response.statusCode}');
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
    _couponsFuture = fetchCoupons();
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
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Container(
        height: 155,
        margin: EdgeInsets.only(bottom: 16),
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
                child: Image.asset(
                  'assets/images/coupons2.png',
                  height: 120,
                ),
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
                        '${coupon.value}% off',
                        style: CustomTextStyles.titleTextStyle.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff124734),
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        height: 30,
                        width: 100,
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white,
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Text(
                                coupon.code,
                                style: CustomTextStyles.titleTextStyle.copyWith(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 8),
                            GestureDetector(
                              onTap: () {
                                // Copy the text to clipboard
                                Clipboard.setData(ClipboardData(text: coupon.code)).then((_) {
                                });
                              },
                              child: Icon(
                                Icons.file_copy_rounded,
                                size: 16,
                                color: Colors.grey[300],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'EXPIRES ON ${coupon.expiry}',
                        style: CustomTextStyles.titleTextStyle.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

}
