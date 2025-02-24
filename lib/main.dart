import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/location_page.dart';
import 'screens/login_page.dart';
import 'screens/logout_page.dart';
import 'screens/lubricants_page.dart';
import 'screens/multivitamins_page.dart';
import 'screens/omega3_page.dart';
import 'screens/order_page.dart';
import 'screens/otp_verification.dart';
import 'screens/painkillers_page.dart';
import 'screens/product_cart.dart';
import 'screens/profile_page.dart';
import 'screens/protein_powders_page.dart';
import 'screens/setting_page.dart';
import 'screens/sexual_wellness_page.dart';
import 'screens/sign_up.dart';
import 'screens/supplements_page.dart';
import 'screens/vitamins_page.dart';
import 'screens/antibiotics_page.dart';
import 'screens/common_medicines_page.dart';
import 'screens/condoms_page.dart';
import 'screens/cough_syrups_page.dart';
import 'screens/final_payment.dart';
import 'screens/get_started.dart';
import 'screens/health_kits_page.dart';
import 'screens/health_supplements_page.dart';
import 'screens/herbal_supplements_page.dart';
import 'screens/home_page.dart';
import 'screens/favorite_manager.dart';
import 'screens/survey_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyDMoNZu2ZLmEiTGRQSwZJZv_Ku8a9nvVXk",
        authDomain: "dawakhaana-aa75c.firebaseapp.com",
        projectId: "dawakhaana-aa75c",
        storageBucket: "dawakhaana-aa75c.appspot.com",
        messagingSenderId: "1094255195129",
        appId: "1:1094255195129:web:0c1e9c147c399857374328",
        measurementId: "G-QFTWWKT6LD",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(DawakhaanaApp());
}

class DawakhaanaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Medicine Delivery App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (context) => GetStartedScreen());
          case '/signup':
            return MaterialPageRoute(builder: (context) => SignUpScreen());
          case '/login':
            return MaterialPageRoute(builder: (context) => PhoneLoginScreen());
          case '/otpVerification':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (context) => OTPVerificationScreen(
                phone: args['phone'],
                isSignUp: args['isSignUp'],
              ),
            );
          case '/location':
            final args = settings.arguments as Map<String, dynamic>?;
            final bool isLoginFlow = args?['isLoginFlow'] ?? false;
            return MaterialPageRoute(
              builder: (context) => LocationPage(isLoginFlow: isLoginFlow),
            );
          case '/survey':
            return MaterialPageRoute(builder: (context) => SurveyPage());
          case '/home':
            return MaterialPageRoute(builder: (context) => HomePage());
          default:
            return MaterialPageRoute(builder: (context) => GetStartedScreen());
        }
      },
    );
  }
}