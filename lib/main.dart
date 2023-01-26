import 'package:final_prac_exam/utils/splashscreen.dart';
import 'package:final_prac_exam/view/screen/homepage.dart';
import 'package:final_prac_exam/view/screen/loginpage.dart';
import 'package:final_prac_exam/view/screen/registrationpage.dart';
import 'package:final_prac_exam/view/screen/votepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/intro_screen',
      getPages: <GetPage>[
        GetPage(name: '/intro_screen', page: () => IntroScreen()),
        GetPage(name: '/', page: () => HomePage()),
        GetPage(name: '/login_page', page: () => LoginPage()),
        GetPage(name: '/result_page', page: () => VotePage()),
        GetPage(name: '/r_page', page: () => RegistrationPage()),
      ],
    ),
  );
}
