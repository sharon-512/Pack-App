import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shimmer/shimmer.dart';

import '../../custom_style.dart';
import '../../widgets/common_button.dart';
import '../../widgets/no_network_widget.dart';
import '../Food_selection/daily_nutrition.dart';

class NumberOfMeals extends StatefulWidget {
  final int subplanId;
  const NumberOfMeals({
    Key? key,
    required this.subplanId,
  }) : super(key: key);

  @override
  State<NumberOfMeals> createState() => _NumberOfMealsState();
}

class _NumberOfMealsState extends State<NumberOfMeals> {
  int selectedOption = 0; // 0 for none, 1 for One Meal, 2 for Two Meal, etc.
  List<dynamic> mealOptions = [];
  bool isLoading = true;
  String? errorMessage;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    fetchMealOptions(widget.subplanId);
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

  Future<void> fetchMealOptions(int subplanId) async {
    try {
      final response = await http
          .get(Uri.parse('https://interfuel.qa/packupadmin/api/get-diet-data'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Assuming data['plan'] is a list, find the plan with matching subplan_id
        Map<String, dynamic>? selectedSubplan;
        for (var plan in data['plan']) {
          final subplans = plan['sub_plans'] as List<dynamic>;
          selectedSubplan = subplans.firstWhere(
            (subplan) => subplan['subplan_id'] == subplanId,
            orElse: () => null,
          );
          if (selectedSubplan != null) {
            break;
          }
        }

        if (selectedSubplan != null && selectedSubplan['meal_plan'] != null) {
          setState(() {
            mealOptions =
                List<Map<String, dynamic>>.from(selectedSubplan?['meal_plan']);
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load meal options: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load meal options: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_connectionStatus.last == ConnectivityResult.none) {
      return NoNetworkWidget();
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: EdgeInsets.all(5),
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
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          'Select the no.of meals per day',
                          style: CustomTextStyles.titleTextStyle,
                        ),
                        const SizedBox(height: 50),
                        // Display shimmer effect while loading
                        isLoading
                            ? Column(
                                children: List.generate(
                                    3,
                                    (index) => Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 6),
                                            height: 50,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                          ),
                                        )),
                              )
                            : Column(
                                children: mealOptions.map((mealOption) {
                                  int index = mealOptions.indexOf(mealOption);
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedOption = index +
                                            1; // +1 to match your meal options (1-based)
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                          vertical: 6, horizontal: 5),
                                      decoration: BoxDecoration(
                                        color: selectedOption == index + 1
                                            ? Color(0xFFEDC0B2)
                                            : Colors.transparent,
                                        border: Border.all(
                                            color: Color(0xFFEDC0B2)),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      height: 50,
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(
                                          '${mealOption['mealtype_name']} meal', // Displaying integer with meal type name
                                          style: TextStyle(
                                            color: selectedOption == index + 1
                                                ? Colors.white
                                                : Colors.black,
                                            fontFamily: 'Aeonik',
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'You can freeze your plan through your profile. This is a weekly ongoing subscription. You can freeze up to 3 days.',
                      style: CustomTextStyles.labelTextStyle
                          .copyWith(fontSize: 11, fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  CommonButton(
                    text: 'Continue',
                    onTap: () {
                      if (selectedOption > 0) {
                        int selectedMealType =
                            mealOptions[selectedOption - 1]['mealtype_id'];
                        int totalMeals =
                            mealOptions[selectedOption - 1]['mealtype_name'];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DailyNutrition(
                                subplanId: widget.subplanId,
                                mealtypeId: selectedMealType,
                                numberofMeals: 3),
                          ),
                        );
                      } else {
                        // Show an error or a message to select an option
                      }
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
