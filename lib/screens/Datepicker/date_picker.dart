import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../custom_style.dart';
import '../../providers/app_localizations.dart';
import '../../services/api.dart';
import '../../services/language_selection.dart';
import '../../widgets/common_button.dart';
import '../Numberofmeals/number_of_meals.dart';


class DatePicker extends StatefulWidget {
  final int selectedSubplanId;

  const DatePicker({Key? key, required this.selectedSubplanId}) : super(key: key);

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  final TextEditingController start = TextEditingController();
  final TextEditingController end = TextEditingController();
  DateTime? selectedStartDate;
  int? dayCount;

  @override
  void initState() {
    super.initState();
    fetchSubplanDetails(widget.selectedSubplanId);
  }

  Future<void> fetchSubplanDetails(int subplanId) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/api/get-diet-data'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Find the subplan using subplanId
        for (var plan in data['plan']) {
          for (var subplan in plan['sub_plans']) {
            if (subplan['subplan_id'] == subplanId) {
              setState(() {
                dayCount = subplan['days_count'];
              });
              break;
            }
          }
        }
      } else {
        throw Exception(
            'Failed to load subplan details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching subplan details: $e');
      // Handle error as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final locale = Provider.of<LocaleNotifier>(context).locale;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
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
                const SizedBox(height: 30),
                Text(
                  localizations.translate('pickStartingDate'),
                  style: CustomTextStyles.titleTextStyle,
                ),
                const SizedBox(height: 20),
                Text(
                    localizations.translate('startingDay'),
                    style: CustomTextStyles.labelTextStyle.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    DateSelectionField(
                      hintText: localizations.translate('pickStartingDate'),
                      controller: start,
                      onDateSelected: (DateTime date) {
                        setState(() {
                          selectedStartDate = date;
                          // Update end date based on selected start date and day count
                          updateEndDate();
                        });
                      },
                      disablePastDates: true,
                      disableFridays: true,
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  localizations.translate('endingDay'),
                  style: CustomTextStyles.labelTextStyle.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: end,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFEDC0B2)),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFEDC0B2)),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          hintText: end.text.isNotEmpty
                              ? end.text
                              : localizations.translate('selectStartingDateFirst'),
                          hintStyle: CustomTextStyles.hintTextStyle,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12.0),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    localizations.translate('freezePlan'),
                    style: CustomTextStyles.labelTextStyle.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                CommonButton(
                  text: localizations.translate('continue'),
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString(
                      'startDate',
                      DateFormat('EEEE, MMMM d, yyyy').format(
                          selectedStartDate!),
                    );
                    await prefs.setString('endDate', end.text);
                    print(end.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NumberOfMeals(
                              subplanId: widget.selectedSubplanId,
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void updateEndDate() {
    if (selectedStartDate != null && dayCount != null) {
      DateTime endDate = selectedStartDate!.add(Duration(days: dayCount! - 1));

      setState(() {
        end.text = DateFormat('EEEE, MMMM d, yyyy').format(endDate);
      });
    }
  }
}

  class DateSelectionField extends StatelessWidget {
  DateSelectionField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.onDateSelected,
    this.disablePastDates = false,
    this.disableFridays = false,
  }) : super(key: key);

  final String hintText;
  final TextEditingController controller;
  final Function(DateTime) onDateSelected;
  final bool disablePastDates;
  final bool disableFridays;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:InkWell(
        onTap: () async {
          DateTime now = DateTime.now();
          DateTime initialDate;

          if (now.weekday == DateTime.wednesday) {
            initialDate = now.add(Duration(days: 3));
          } else {
            initialDate = now.add(Duration(days: 2));
          }

          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: initialDate,
            firstDate: disablePastDates ? initialDate : DateTime(2000),
            lastDate: DateTime(2101),
            selectableDayPredicate: (DateTime date) {
              if (date.year == now.year &&
                  date.month == now.month &&
                  date.day == now.day) {
                return true;
              }

              // Disable selection for all other Fridays
              if (disableFridays && date.weekday == DateTime.friday) {
                return false;
              }

              return true;
            },
          );
          if (pickedDate != null) {
            String formattedDate = DateFormat('EEEE, MMMM d, yyyy').format(pickedDate);
            controller.text = formattedDate;
            onDateSelected(pickedDate);
          }
        },
        child: IgnorePointer(
          child: TextField(
            controller: controller,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFEDC0B2)),
                borderRadius: BorderRadius.circular(8.0),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFEDC0B2)),
                borderRadius: BorderRadius.circular(8.0),
              ),
              hintText: hintText,
              hintStyle: CustomTextStyles.hintTextStyle,
              contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
              suffixIcon: Icon(Icons.calendar_today, color: Color(0xffD8D8D8)),
            ),
            readOnly: true,
          ),
        ),
      )

    );
  }
}
