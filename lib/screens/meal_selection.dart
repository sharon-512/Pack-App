import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../custom_style.dart';
import '../widgets/common_button.dart';
import 'date_picker.dart';
import 'number_of_meals.dart'; // Import NumberOfMeals page

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

  @override
  void initState() {
    super.initState();
    fetchPlanDetails();
  }

  Future<void> fetchPlanDetails() async {
    try {
      final response = await http.get(Uri.parse('https://interfuel.qa/packupadmin/api/get-diet-data'));

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
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    'Choose Your Meal\nDuration?',
                    style: CustomTextStyles.titleTextStyle,
                  ),
                  const SizedBox(height: 50),
                  // Options are generated here
                  for (int i = 0; i < subPlans.length; i++)
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedOption = i + 1; // +1 because options start from 1
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: selectedOption == i + 1
                              ? Color(0xFFEDC0B2)
                              : Colors.transparent,
                          border: Border.all(color: Color(0xFFEDC0B2)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            '${subPlans[i]['subplan_name']}',
                            style: TextStyle(
                              color: selectedOption == i + 1 ? Colors.white : Colors.black,
                              fontFamily: 'Aeonik',
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            CommonButton(
              text: 'Continue',
              onTap: () {
                // Find the selected subplan based on selectedOption
                String selectedSubplanName = subPlans[selectedOption - 1]['subplan_name'];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NumberOfMeals(
                      subplanName: selectedSubplanName,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
