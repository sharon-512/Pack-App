import 'package:flutter/material.dart';
import 'package:pack_app/screens/onboarding/slide_effect/main_page.dart';
import 'package:pack_app/widgets/common_textfield.dart';
import 'package:provider/provider.dart';
import '../../custom_style.dart';
import '../../providers/app_localizations.dart';
import '../../providers/user_registration_provider.dart';
import '../../services/registraction.dart';
import '../../widgets/common_button.dart';
import '../test_user_details.dart';

class EnterDetails extends StatefulWidget {
  final String mobileNumber;
  const EnterDetails({super.key, required this.mobileNumber});

  @override
  _EnterDetailsState createState() => _EnterDetailsState();
}

class _EnterDetailsState extends State<EnterDetails> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _registerUser() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // setState(() {
    //   _isLoading = true;
    // });

    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.updateFirstName(nameController.text);
    userProvider.updateLastName(lastNameController.text);
    userProvider.updateEmail(emailController.text);
    userProvider.updateMobileNumber(widget.mobileNumber);

    Navigator.push(context, MaterialPageRoute(builder: (context) => OnboardingScreen(),));
  }

  void _showErrorSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.red),
      ),
      backgroundColor: Colors.white,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  String? _validateName(String? value) {
    final localizations = AppLocalizations.of(context)!;

    if (value == null || value.isEmpty) {
      return localizations.translate('errorFirstNameEmpty');
    } else if (value.length < 2) {
      return localizations.translate('errorFirstNameShort');
    }
    return null;
  }

  String? _validateLastName(String? value) {
    final localizations = AppLocalizations.of(context)!;

    if (value == null || value.isEmpty) {
      return localizations.translate('errorLastNameEmpty');
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final localizations = AppLocalizations.of(context)!;

    if (value == null || value.isEmpty) {
      return localizations.translate('errorEmailEmpty');
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return localizations.translate('errorEmailInvalid');
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height*0.75,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        localizations!.translate('enterDetails'),
                        style: CustomTextStyles.titleTextStyle,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        localizations!.translate('firstName'),
                        style: CustomTextStyles.labelTextStyle.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      CommonTextField(
                        hintText: localizations!.translate('enterFirstName'),
                        controller: nameController,
                        validator: _validateName, // Use the validation method here
                      ),
                      const SizedBox(height: 20),
                      Text(
                        localizations!.translate('lastName'),
                        style: CustomTextStyles.labelTextStyle.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      CommonTextField(
                        hintText: localizations!.translate('enterLastName'),
                        controller: lastNameController,
                        validator: _validateLastName, // Use the validation method here
                      ),
                      const SizedBox(height: 20),
                      Text(
                        localizations!.translate('email'),
                        style: CustomTextStyles.labelTextStyle.copyWith(fontSize: 14),
                      ),
                      const SizedBox(height: 8),
                      CommonTextField(
                        hintText: localizations!.translate('enterEmail'),
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail, // Use the validation method here
                      ),

                    ],
                  ),
                ),
                CommonButton(
                  text: localizations!.translate('continue'),
                  onTap: _registerUser,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
