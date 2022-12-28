import 'dart:async';
import 'package:daily_report/getx_controller/user_model.dart';
import 'package:daily_report/main.dart';
import 'package:daily_report/views/get_start_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final userData = Get.put(UserModel());

  getLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phone = prefs.getString("phone");
    String? password = prefs.getString("password");
    print(phone);
    print(password);
    if (phone != null || password != null) {
      altogic!.auth.signInWithPhone(phone!, password!).then((value) {
        if (value.user != null) {
          userData.phoneNumber.value = value.user!.phone!;
          userData.id.value = value.user!.id!;
          userData.name.value = value.user!.name!;
          userData.username.value = value.user!['username']['username'];
          Get.to(DashboardScreen());
        }
      });
    } else {
      Timer(Duration(seconds: 2), () => Get.to(GetStartScreen()));
    }
  }

  @override
  void initState() {
    getLogin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/logo/logo.png",
          scale: 3,
        ),
      ),
    );
  }
}
