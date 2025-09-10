import 'package:flutter/material.dart';
import 'package:laundry_jaya/extension/navigtaion.dart';
import 'package:laundry_jaya/shared_preferences/shared_preferences.dart';
import 'package:laundry_jaya/utils/app_image.dart';
import 'package:laundry_jaya/views/buttomNav.dart';
import 'package:laundry_jaya/views/login_api_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const id = "/splash_screen";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    isLogin();
  }

  void isLogin() async {
    bool? isLogin = await PreferenceHandler.getLogin();

    Future.delayed(Duration(seconds: 3)).then((value) async {
      print(isLogin);
      if (isLogin == true) {
        context.pushReplacementNamed(ButtomNav.id);
      } else {
        context.push(LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF03A9F4),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              width: 200,
              child: Image.asset(AppImage.logo),
            ),
            SizedBox(height: 20),
            Text(
              "Laundry Jaya",
              style: TextStyle(fontFamily: "Montserrat_Bold"),
            ),
          ],
        ),
      ),
    );
  }
}
