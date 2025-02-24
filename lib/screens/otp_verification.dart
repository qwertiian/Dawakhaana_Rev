import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Added for OTP verification
import 'location_page.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phone;
  final bool isSignUp;

  OTPVerificationScreen({required this.phone, required this.isSignUp});

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final TextEditingController otpController = TextEditingController();
  bool isOTPEntered = false;
  bool isResendEnabled = true;
  int resendCooldown = 300;
  int resendAttempts = 0;
  bool isOTPExpired = false;
  int otpTimer = 300;

  void _startOTPTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (otpTimer > 0) {
        setState(() {
          otpTimer--;
        });
        _startOTPTimer();
      } else {
        setState(() {
          isOTPExpired = true;
        });
        _autoSubmitOTP();
      }
    });
  }

  void _autoSubmitOTP() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("OTP expired. Please retry."),
        duration: Duration(seconds: 3),
      ),
    );
    _startResendCooldown();
  }

  void _startResendCooldown() {
    setState(() {
      isResendEnabled = false;
    });

    Future.delayed(Duration(seconds: resendCooldown), () {
      setState(() {
        isResendEnabled = true;
      });
    });

    resendAttempts++;
    resendCooldown = 300 + (resendAttempts * 300);
  }

  @override
  void initState() {
    super.initState();
    otpController.addListener(() {
      setState(() {
        isOTPEntered = otpController.text.length == 6;
      });
    });
    _startOTPTimer();
  }

  @override
  void dispose() {
    otpController.dispose();
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
                  "Verify OTP",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Enter OTP sent to ${widget.phone}",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Time remaining: ${otpTimer ~/ 60}:${(otpTimer % 60).toString().padLeft(2, '0')}",
                  style: TextStyle(
                    fontSize: 16,
                    color: isOTPExpired ? Colors.red : Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: otpController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(6),
                        ],
                        decoration: InputDecoration(
                          labelText: "OTP",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          counterText: "",
                        ),
                      ),                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isOTPEntered && !isOTPExpired
                            ? () {
                          Navigator.pushReplacementNamed(context, '/location'
                          ,arguments: {'isLoginFlow': true},);
                        }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                        ),
                        child: Text("Verify"),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: isResendEnabled
                            ? () {
                          _startResendCooldown();
                          setState(() {
                            otpTimer = 300;
                            isOTPExpired = false;
                          });
                          _startOTPTimer();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Re-sending OTP..."),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                            : null,
                        child: Text(
                          isResendEnabled
                              ? "Re-send OTP"
                              : "Re-send OTP in ${resendCooldown ~/ 60} minutes",
                          style: TextStyle(
                            color: isResendEnabled ? Colors.blue : Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Go Back to Sign Up",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
