import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/app_localizations.dart';
import '../../services/language_selection.dart';
import '../../widgets/common_button.dart';
import 'enter_number.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final localizations = AppLocalizations.of(context)!;
    final localeNotifier = Provider.of<LocaleNotifier>(context);

    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Color(0xffFFF7EE),
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/payment_bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Stack(
                children: [
                  Container(
                    height: screenHeight * 0.7,
                    child: Image.asset(
                      'assets/images/start_image.png',
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      height: screenHeight * 0.7,
                      decoration: BoxDecoration(
                        color: Color(0xff2F2D28).withOpacity(0.75),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 30.0,
                    top: screenHeight * 0.7 * 0.2,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10.0, bottom: 26.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(localizations.translate('gatewayToHealth'),
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Aeonik',
                                fontWeight: FontWeight.w700,
                                fontSize: 58.0,
                                height: 60.0 / 64.0,
                                letterSpacing: -0.41,
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.width * 0.4),
                            Text(
                              localizations!.translate('packAppTagline'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontFamily: 'Aeonik',
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: CommonButton(
                      text: localizations!.translate('getStarted'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EnterNumber(),
                          ),
                        );
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          localeNotifier.changeLocale('en'); // Change to English
                        },
                        child: Text(
                          'EN',
                          style: TextStyle(
                            color: localeNotifier.locale?.languageCode == 'en' ? Color(0xFF124734) : Color(0xFFBEBEBE),
                          ),
                        ),
                      ),
                      Text(
                        ' | ',
                        style: TextStyle(color: Color(0xFFBEBEBE)),
                      ),
                      GestureDetector(
                        onTap: () {
                          localeNotifier.changeLocale('ar'); // Change to Arabic
                        },
                        child: Text(
                          'AR',
                          style: TextStyle(
                            color: localeNotifier.locale?.languageCode == 'ar' ? Color(0xFF124734) : Color(0xFFBEBEBE),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 1),
            ],
          ),
        ),
      ),
    );
  }
}
