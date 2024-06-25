import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pack_app/custom_style.dart';
import 'package:pack_app/widgets/common_button.dart';
import 'package:pack_app/widgets/green_appbar.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({Key? key}) : super(key: key);

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  String selectedLanguage = 'EN'; // Default selected language code

  void _handleLanguageSelection(String languageCode) {
    setState(() {
      selectedLanguage = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const GreenAppBar(showBackButton: true, titleText: 'Language'),
          Expanded(
            child: ListView(
              children: <Widget>[
                LanguageSelectionItem(
                  languageName: 'Arabic',
                  languageCode: 'AR',
                  selectedLanguage: selectedLanguage,
                  onSelected: _handleLanguageSelection,
                ),
                LanguageSelectionItem(
                  languageName: 'English',
                  languageCode: 'EN',
                  selectedLanguage: selectedLanguage,
                  onSelected: _handleLanguageSelection,
                ),
                // Add more LanguageSelectionItem widgets here as needed
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CommonButton(
                text: 'Save',
                onTap: () {}
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageSelectionItem extends StatelessWidget {
  final String languageName;
  final String languageCode;
  final String selectedLanguage;
  final ValueChanged<String> onSelected;

  const LanguageSelectionItem({
    super.key,
    required this.languageName,
    required this.languageCode,
    required this.selectedLanguage,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Radio(
            value: languageCode,
            groupValue: selectedLanguage,
            onChanged: (String? value) {
              onSelected(value!);
            },
            fillColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.selected)) {
                return primaryGreen; // Color when item is selected
              }
              return Colors.grey; // Color for unselected items
            }),
          ),
          title: Text('$languageName ($languageCode)'),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            color: Color(0x275A5A1F),
            thickness: 1,
            height: 1,
          ),
        ),
      ],
    );
  }
}

