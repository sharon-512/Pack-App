import 'package:flutter/material.dart';
import 'package:pack_app/screens/onboarding/slide_effect/main_page.dart';
import 'package:pack_app/widgets/common_textfield.dart';
import 'package:provider/provider.dart';
import '../../custom_style.dart';
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

    //final registrationService = RegistrationService();

    // try {
    //   final response = await registrationService.newRegister(firstName, email, mobileNumber, lastName);
    //
    //   if (response['response_code'] == 3) {
    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => UserDetailsPage(),
    //       ),
    //     );
    //   } else if (response['response_code'] == 0) {
    //     _showErrorSnackBar('Existing email ID');
    //   } else {
    //     _showErrorSnackBar('Failed to register');
    //   }
    // } catch (error) {
    //   // Handle errors appropriately
    //   print('Failed to register user: $error');
    //   _showErrorSnackBar('Failed to register');
    // } finally {
    //   setState(() {
    //     _isLoading = false;
    //   });
    // }
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
    if (value == null || value.isEmpty) {
      return 'Please enter your first name';
    } else if (value.length < 2) {
      return 'First name should be at least 2 characters';
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your last name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 500,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'Enter your details',
                      style: CustomTextStyles.titleTextStyle,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'First Name',
                      style: CustomTextStyles.labelTextStyle.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    CommonTextField(
                      hintText: 'Enter your first name',
                      controller: nameController,
                      validator: _validateName, // Use the validation method here
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Last Name',
                      style: CustomTextStyles.labelTextStyle.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    CommonTextField(
                      hintText: 'Enter your last name',
                      controller: lastNameController,
                      validator: _validateLastName, // Use the validation method here
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Email',
                      style: CustomTextStyles.labelTextStyle.copyWith(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    CommonTextField(
                      hintText: 'Enter your email',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail, // Use the validation method here
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              CommonButton(
                text: 'Continue',
                onTap: _registerUser,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
