import 'package:flutter/material.dart';
import 'package:pack_app/custom_style.dart';
import 'package:pack_app/widgets/common_button.dart';
import 'package:pack_app/widgets/green_appbar.dart';
import 'package:provider/provider.dart';

import '../../../providers/app_localizations.dart';
import '../../../services/language_selection.dart';

class SelectLanguage extends StatefulWidget {
  const SelectLanguage({Key? key}) : super(key: key);

  @override
  State<SelectLanguage> createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {
  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    // Access LocaleNotifier to get the current language
    final localeNotifier = Provider.of<LocaleNotifier>(context);
    final selectedLanguage = localeNotifier.locale?.languageCode ?? 'EN';

    return Scaffold(
      body: Column(
        children: [
          GreenAppBar(showBackButton: true, titleText: localizations!.translate('language'),),
          Expanded(
            child: ListView(
              children: <Widget>[
                LanguageSelectionItem(
                  languageName: 'Arabic',
                  languageCode: 'ar',
                  selectedLanguage: selectedLanguage,
                  onSelected: (languageCode) {
                    localeNotifier.changeLocale(languageCode); // Update locale
                  },
                ),
                LanguageSelectionItem(
                  languageName: 'English',
                  languageCode: 'en',
                  selectedLanguage: selectedLanguage,
                  onSelected: (languageCode) {
                    localeNotifier.changeLocale(languageCode); // Update locale
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CommonButton(
                text: localizations!.translate('saveChanges'),
                onTap: () {
                  Navigator.pop(context); // Navigate back after saving
                }
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
