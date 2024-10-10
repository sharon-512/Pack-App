// lib/screens/my_coupons.dart

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../custom_style.dart';
import '../../../models/coupon_model.dart';
import '../../../providers/app_localizations.dart';
import '../../../services/coupon_api.dart';
import '../../../widgets/green_appbar.dart';
import '../../../widgets/no_network_widget.dart';

class MyCoupons extends StatefulWidget {
  const MyCoupons({super.key});

  @override
  _MyCouponsState createState() => _MyCouponsState();
}

class _MyCouponsState extends State<MyCoupons> {
  late Future<List<Coupon>> _couponsFuture;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.wifi];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    _couponsFuture = fetchCoupons();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late List<ConnectivityResult> result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print('Couldn\'t check connectivity status');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
    });
    if (_connectionStatus.last == ConnectivityResult.none) {
      print('No internet connection');
    } else {
      print('Connected to the internet');
    }
    // ignore: avoid_print
    print('Connectivity changed: $_connectionStatus');
  }


  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    if (_connectionStatus.last == ConnectivityResult.none) {
      return NoNetworkWidget();
    }
    return Scaffold(
      body: Column(
        children: [
          GreenAppBar(showBackButton: true, titleText: localizations!.translate('myCoupons'),),
          Expanded(
            child: FutureBuilder<List<Coupon>>(
              future: _couponsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text(localizations!.translate('noCouponsFound'),));
                }

                final coupons = snapshot.data!;
                return ListView.builder(
                  itemCount: coupons.length,
                  itemBuilder: (context, index) {
                    final coupon = coupons[index];
                    return couponCard(coupon);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget couponCard(Coupon coupon) {
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Coupon code copied!')),
                                  );
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
