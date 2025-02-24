import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'otp_verification.dart';

class PhoneLoginScreen extends StatefulWidget {
  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  bool isButtonEnabled = false;

  void _validatePhoneInput() {
    final String phone = phoneController.text.trim();
    setState(() {
      isButtonEnabled = phone.length == 10; // Enable button if phone number is valid
    });
  }

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_validatePhoneInput);
  }

  @override
  void dispose() {
    phoneController.removeListener(_validatePhoneInput);
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Phone Login",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 40),
                TextField(
                  controller: phoneController,
                  decoration: InputDecoration(
                    labelText: "Mobile Number (+91)",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    errorText: phoneController.text.isNotEmpty && phoneController.text.length != 10
                        ? "Enter a valid 10-digit number"
                        : null,
                  ),
                  keyboardType: TextInputType.phone,
                  maxLength: 10,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                SizedBox(height: 40),
                ElevatedButton(
                  onPressed: isButtonEnabled
                      ? () {
                    Navigator.pushNamed(
                      context,
                      '/otpVerification',
                      arguments: {
                        'phone': phoneController.text,
                        'isSignUp': false,
                      },
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: Text("Send OTP"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}