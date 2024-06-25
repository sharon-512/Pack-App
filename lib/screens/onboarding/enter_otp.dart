import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../custom_style.dart';
import '../../widgets/common_button.dart';
import 'enter_details.dart';

class EnterOtp extends StatefulWidget {
  EnterOtp({super.key});

  @override
  State<EnterOtp> createState() => _EnterOtpState();
}

class _EnterOtpState extends State<EnterOtp> {
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height, // Set minimum height
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
                          style: CustomTextStyles.subtitleTextStyle),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Container(
                            height: 48,
                            alignment: Alignment.center,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border:
                                  Border.all(color: const Color(0xffBEBEBE)),
                            ),
                            child: RichText(
                              text: TextSpan(
                                style: CustomTextStyles.subtitleTextStyle
                                    .copyWith(fontSize: 20),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: '+974',
                                  ),
                                  TextSpan(
                                    text: '  32145626',
                                    style: CustomTextStyles.subtitleTextStyle
                                        .copyWith(
                                            color: Colors.black, fontSize: 20),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Container(
                            padding: EdgeInsets.all(14),
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                                color: Color(0xffFEC66F),
                                borderRadius: BorderRadius.circular(8)),
                            child: SvgPicture.asset(
                              'assets/images/pencil.svg',
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          'Please enter your OTP',
                          style: CustomTextStyles.subtitleTextStyle
                              .copyWith(color: Colors.black),
                        ),
                      ),
                      Row(
                        children: [
                          _otpBox(context: context),
                        ],
                      ),
                      const SizedBox(height: 150),
                    ],
                  ),
                  CommonButton(
                    text: 'Continue',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EnterDetails(),
                          ));
                    },
                  )
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
        //autoFocus: true,
        textStyle: const TextStyle(
            fontSize: 46, fontFamily: 'Aeonik', fontWeight: FontWeight.w500),
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
        onChanged: (value) => {
          setState(() {
            // if (value.length == 1 && index < _focusNodes.length - 1) {
            //   _focusNodes[index + 1].requestFocus();
            // }
          })
        },
        controller: TextEditingController(),
        onCompleted: (value) async {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }
}
