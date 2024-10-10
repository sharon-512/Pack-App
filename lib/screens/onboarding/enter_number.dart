import 'package:flutter/material.dart';
import 'package:pack_app/custom_style.dart';
import 'package:pack_app/widgets/common_button.dart';
import 'package:pack_app/services/authentication.dart';
import 'package:pack_app/widgets/common_textfield.dart';
import '../../providers/app_localizations.dart';
import 'enter_otp.dart';

class EnterNumber extends StatefulWidget {
  EnterNumber({super.key});

  @override
  _EnterNumberState createState() => _EnterNumberState();
}

class _EnterNumberState extends State<EnterNumber> {
  final TextEditingController mobileNumber = TextEditingController();
  final AuthenticationService _authService = AuthenticationService();
  bool _isLoading = false;
  String? _errorMessage;

  void _sendMobileNumber() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous error message
    });

    try {
      final response = await _authService.sendMobileNumber(mobileNumber.text);

      if (response['response_code'] == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnterOtp(mobileNumber: mobileNumber.text),
          ),
        );
      } else {
        setState(() {
          _errorMessage = response['message'] ?? 'An unknown error occurred';
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = '$error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 20),
              Text(
                localizations!.translate('welcomeToPlusPack'),
                style: CustomTextStyles.titleTextStyle,
              ),
              const SizedBox(height: 22),
              Text(
                  localizations!.translate('enterPhoneNumber'),
                  style: CustomTextStyles.subtitleTextStyle),
              const SizedBox(height: 40),
              Row(
                children: [
                  Container(
                    height: 48,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xffBEBEBE)),
                    ),
                    child: Text(
                      '+974',
                      style: CustomTextStyles.subtitleTextStyle.copyWith(fontSize: 20),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CommonTextField(
                      hintText: localizations.translate('yourPhoneNumber'),
                      controller: mobileNumber,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                        fontFamily: 'Aeonik',
                        fontWeight: FontWeight.w400
                      ),
                    ),
                  ),
                ],
              ),
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              SizedBox(height: 40),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: CommonButton(
          text: localizations!.translate('continue'),
          onTap: _sendMobileNumber,
          isLoading: _isLoading,
        ),
      ),
    );
  }
}
