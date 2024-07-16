import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../custom_style.dart';
import '../../../models/plan_model.dart';
import '../../../widgets/green_appbar.dart';
import 'package:http/http.dart' as http;

import '../../Mealselection/meal_selection.dart';

class Packs extends StatefulWidget {
  const Packs({super.key});

  @override
  State<Packs> createState() => _PacksState();
}

class _PacksState extends State<Packs> {
  Future<List<Plan>> fetchPlans() async {
    final response = await http.get(Uri.parse('https://interfuel.qa/packupadmin/api/get-diet-data'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<dynamic> planList = data['plan'];
      return planList.map((plan) => Plan.fromJson(plan)).toList();
    } else {
      throw Exception('Failed to load plans');
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    padding: EdgeInsets.symmetric(horizontal: 2, vertical: 20),
                    height: 480,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: snapshot.data!.sublist(0, (snapshot.data!.length / 2).ceil()).map((plan) {
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MealSelection(planId: plan.planId,)),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.grey), // Placeholder color
                                          alignment: Alignment.topRight,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
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
                                            style: CustomTextStyles.titleTextStyle.copyWith(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w500,
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
                            children: snapshot.data!.sublist((snapshot.data!.length / 2).ceil()).map((plan) {
                              return Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => MealSelection(planId: plan.planId,)),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Stack(
                                      alignment: Alignment.bottomLeft,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
                                              color: Colors.grey), // Placeholder color
                                          alignment: Alignment.topRight,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(20),
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
                                            style: CustomTextStyles.titleTextStyle.copyWith(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w500,
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
