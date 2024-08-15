import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shimmer/shimmer.dart';

import '../../custom_style.dart';
import '../../services/api.dart';
import '../../widgets/common_button.dart';
import '../../widgets/no_network_widget.dart';
import '../Datepicker/date_picker.dart';

class MealSelection extends StatefulWidget {
  final int planId;

  const MealSelection({Key? key, required this.planId}) : super(key: key);

  @override
  State<MealSelection> createState() => _MealSelectionState();
}

class _MealSelectionState extends State<MealSelection> {
  int selectedOption = 0; // 0 for none, 1 for Day Pack, 2 for One Week, etc.
  List<dynamic> subPlans = [];
  bool isLoading = true;
  String? errorMessage;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.wifi];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;


  @override
  void initState() {
    super.initState();
    fetchPlanDetails();
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

  Future<void> fetchPlanDetails() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/get-diet-data'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Assuming data['plan'] is a list, find the plan with matching plan_id
        Map<String, dynamic>? selectedPlan;
        for (var plan in data['plan']) {
          if (plan['plan_id'] == widget.planId) {
            selectedPlan = plan;
            break;
          }
        }

        if (selectedPlan != null) {
          setState(() {
            // Assign subplan details based on the selected plan
            subPlans = selectedPlan?['sub_plans'];
            isLoading = false;
          });
        } else {
          throw Exception('Selected plan not found');
        }
      } else {
        throw Exception('Failed to load plan details: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Failed to load plan details: $e';
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50,),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Choose Your Meal Duration?',
                      style: CustomTextStyles.titleTextStyle,
                    ),
                    const SizedBox(height: 50),
                    // Show shimmer effect while loading
                    isLoading
                        ? Column(
                      children: List.generate(3, (index) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 6),
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      )),
                    )
                        : Column(
                      children: subPlans.map((subPlan) {
                        int index = subPlans.indexOf(subPlan);
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedOption = index + 1; // +1 because options start from 1
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: selectedOption == index + 1
                                  ? Color(0xFFEDC0B2)
                                  : Colors.transparent,
                              border: Border.all(color: Color(0xFFEDC0B2)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            height: 50,
                            width: double.infinity,
                            child: Center(
                              child: Text(
                                '${subPlan['subplan_name']}',
                                style: TextStyle(
                                  color: selectedOption == index + 1 ? Colors.white : Colors.black,
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
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        child: CommonButton(
          text: 'Continue',
          onTap: () {
            // Find the selected subplan based on selectedOption
            int selectedSubplanId = subPlans[selectedOption - 1]['subplan_id'];
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DatePicker(
                  selectedSubplanId: selectedSubplanId,
                ),
              ),
            );

          },
        ),
      ),
    );
  }
}
