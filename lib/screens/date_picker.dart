import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../custom_style.dart';
import '../widgets/common_button.dart';
import 'number_of_meals.dart';

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

  @override
  Widget build(BuildContext context) {
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
                  'Pick your starting date',
                  style: CustomTextStyles.titleTextStyle,
                ),
                const SizedBox(height: 20),
                Text(
                  'Starting Day',
                  style: CustomTextStyles.labelTextStyle.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    DateSelectionField(
                      hintText: 'Select starting date',
                      controller: start,
                      onDateSelected: (DateTime date) {
                        setState(() {
                          selectedStartDate = date;
                          // Update end date based on selected start date and subplan name
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
                  'Ending Day',
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
                          hintText: selectedStartDate != null
                              ? DateFormat('EEEE, MMMM d, yyyy').format(selectedStartDate!)
                              : 'Select starting date first',
                          hintStyle: CustomTextStyles.hintTextStyle,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12.0),
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
                    'You can freeze your plan through your profile. This is a weekly ongoing subscription. You can freeze up to 3 days.',
                    style: CustomTextStyles.labelTextStyle.copyWith(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                CommonButton(
                  text: 'Continue',
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString(
                      'startDate',
                      DateFormat('EEEE, MMMM d, yyyy').format(selectedStartDate!),
                    );
                    await prefs.setString('endDate', end.text);
                    print( end.text);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NumberOfMeals(
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
    if (selectedStartDate != null) {
      DateTime endDate = calculateEndDate(selectedStartDate!, widget.selectedSubplanId);
      setState(() {
        end.text = DateFormat('EEEE, MMMM d, yyyy').format(endDate);
      });
    }
  }

  DateTime calculateEndDate(DateTime startDate, int subplanId) {
    int daysToAdd = 7; // Default to 1 week

    if (subplanId == 1) {
      daysToAdd = 8; // Adjust daysToAdd based on subplanId
    } else if (subplanId == 2) {
      daysToAdd = 16;
    } else if (subplanId == 3) {
      daysToAdd = 24;
    } else if (subplanId == 4) {
      daysToAdd = 30;
    }

    // Calculate end date excluding Fridays
    DateTime endDate = startDate.add(Duration(days: daysToAdd));
    if (endDate.weekday == DateTime.friday) {
      endDate = endDate.add(Duration(days: 2)); // Skip to Saturday if ends on Friday
    }

    return endDate;
  }

}

void updateEndDateInSharedPreferences(String endText) async {
  final prefs = await SharedPreferences.getInstance();

  // Parse endText to DateTime using DateFormat
  DateTime endDate = DateFormat('EEEE, MMMM d, yyyy').parse(endText);

  // Store endDate in SharedPreferences
  await prefs.setString(
    'endDate',
    DateFormat('EEEE, MMMM d, yyyy').format(endDate),
  );
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
      child: InkWell(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: disablePastDates ? DateTime.now() : DateTime(2000),
            lastDate: DateTime(2101),
            selectableDayPredicate: (DateTime date) {
              if (date.year == DateTime.now().year &&
                  date.month == DateTime.now().month &&
                  date.day == DateTime.now().day) {
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
      ),
    );
  }
}
