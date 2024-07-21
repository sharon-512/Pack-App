import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pack_app/screens/Dashboard/nav_bar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:pack_app/custom_style.dart';
import 'package:pack_app/widgets/common_button.dart';
import 'package:hive/hive.dart';
import 'package:pack_app/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/authentication.dart';
import 'enter_details.dart';

class EnterOtp extends StatefulWidget {
  EnterOtp({super.key, required this.mobileNumber});

  final String mobileNumber;

  @override
  State<EnterOtp> createState() => _EnterOtpState();
}

class _EnterOtpState extends State<EnterOtp> {
  final TextEditingController otpController = TextEditingController();
  final AuthenticationService _authService = AuthenticationService();
  bool _isLoading = false;
  String? _errorMessage;

  void _confirmOtp() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous error message
    });

    try {
      final response = await _authService.confirmOtp(widget.mobileNumber, otpController.text);
      print(response);

      setState(() {
        _isLoading = false;
      });

      if (response['status_code'] == 0) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EnterDetails(mobileNumber: widget.mobileNumber),
          ),
        );
      } else if (response['status_code'] == 1) {
        //Already existing user
        final userBox = Hive.box<User>('userBox');
        final user = User.fromJson(response['user']);
        await userBox.put('currentUser', user);
        print('User details stored: $user');
        //Navigate to the home page or dashboard
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true); // Store authentication status
        await prefs.setString('bearerToken', response['token']); // Store the token

        Navigator.push(context, MaterialPageRoute(builder: (context) => BottomNavbar(),));
      } else if (response['status_code'] == 2) {
        setState(() {
          _errorMessage = response['message'] ?? 'Invalid OTP';
        });
      } else {
        // Handle other scenarios
        setState(() {
          _errorMessage = response['message'] ?? 'An unknown error occurred';
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to confirm OTP. Please check your connection.';
      });
      print('Error confirming OTP: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 50),
                      Text(
                        'Verify your\nphone number',
                        style: CustomTextStyles.titleTextStyle,
                      ),
                      const SizedBox(height: 22),
                      Text(
                        'We have sent you a 4 digit code.\nPlease enter here to Verify your Number.',
                        style: CustomTextStyles.subtitleTextStyle,
                      ),
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
                            child: RichText(
                              text: TextSpan(
                                style: CustomTextStyles.subtitleTextStyle.copyWith(fontSize: 20),
                                children: <TextSpan>[
                                  TextSpan(text: '+974'),
                                  TextSpan(
                                    text: '  ${widget.mobileNumber}',
                                    style: CustomTextStyles.subtitleTextStyle.copyWith(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(14),
                              height: 48,
                              width: 48,
                              decoration: BoxDecoration(
                                color: Color(0xffFEC66F),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: SvgPicture.asset('assets/images/pencil.svg'),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'Please enter your OTP',
                          style: CustomTextStyles.subtitleTextStyle.copyWith(color: Colors.black),
                        ),
                      ),
                      Row(
                        children: [
                          _otpBox(context: context),
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
                      const SizedBox(height: 150),
                    ],
                  ),
                  CommonButton(
                    text: 'Continue',
                    onTap: _confirmOtp,
                    isLoading: _isLoading,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _otpBox({required BuildContext context}) {
    return Expanded(
      child: PinCodeTextField(
        appContext: context,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        errorTextSpace: 0,
        length: 4,
        keyboardType: TextInputType.number,
        textStyle: const TextStyle(
          fontSize: 46,
          fontFamily: 'Aeonik',
          fontWeight: FontWeight.w500,
        ),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        enableActiveFill: true,
        showCursor: true,
        obscureText: false,
        autoUnfocus: true,
        cursorColor: Color(0xff124734),
        pinTheme: PinTheme(
          fieldHeight: 78,
          fieldWidth: 78,
          borderWidth: 1,
          borderRadius: BorderRadius.circular(15),
          shape: PinCodeFieldShape.box,
          activeColor: Color(0xFFEDC0B2),
          inactiveColor: Color(0xFFEDC0B2),
          selectedColor: Color(0xFFEDC0B2),
          activeFillColor: Colors.white,
          inactiveFillColor: Colors.white,
          selectedFillColor: Colors.white,
        ),
        onChanged: (value) => {},
        controller: otpController,
        onCompleted: (value) async {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
