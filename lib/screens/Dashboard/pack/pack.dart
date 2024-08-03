import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../custom_style.dart';
import '../../../models/plan_model.dart';
import '../../../widgets/green_appbar.dart';
import 'package:http/http.dart' as http;

import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../widgets/no_network_widget.dart';
import '../../Mealselection/meal_selection.dart';

class Packs extends StatefulWidget {
  const Packs({super.key});

  @override
  State<Packs> createState() => _PacksState();
}

class _PacksState extends State<Packs> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.wifi];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  Future<List<Plan>> fetchPlans() async {
    final response = await http
        .get(Uri.parse('https://interfuel.qa/packupadmin/api/get-diet-data'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> planList = data['plan'];
      return planList.map((plan) => Plan.fromJson(plan)).toList();
    } else {
      throw Exception('Failed to load plans');
    }
  }

  @override
  void initState() {
    super.initState();
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
    if (_connectionStatus.last == ConnectivityResult.none) {
      return NoNetworkWidget();
    }
      return Scaffold(
        body: FutureBuilder<List<Plan>>(
          future: fetchPlans(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No plans available'));
            } else {
              return Column(
                children: [
                  GreenAppBar(showBackButton: false, titleText: 'Packs'),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 2, vertical: 20),
                      height: 480,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: snapshot.data!
                                  .sublist(
                                      0, (snapshot.data!.length / 2).ceil())
                                  .map((plan) {
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MealSelection(
                                                  planId: plan.planId,
                                                )),
                                      );
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Stack(
                                        alignment: Alignment.bottomLeft,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors
                                                    .grey), // Placeholder color
                                            alignment: Alignment.topRight,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.network(
                                                plan.planImage,
                                                fit: BoxFit.fill,
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              plan.planName,
                                              style: CustomTextStyles
                                                  .titleTextStyle
                                                  .copyWith(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: snapshot.data!
                                  .sublist((snapshot.data!.length / 2).ceil())
                                  .map((plan) {
                                return Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MealSelection(
                                                  planId: plan.planId,
                                                )),
                                      );
                                    },
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Stack(
                                        alignment: Alignment.bottomLeft,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors
                                                    .grey), // Placeholder color
                                            alignment: Alignment.topRight,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.network(
                                                plan.planImage,
                                                fit: BoxFit.fill,
                                                width: double.infinity,
                                                height: double.infinity,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Text(
                                              plan.planName,
                                              style: CustomTextStyles
                                                  .titleTextStyle
                                                  .copyWith(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      );
  }
}
