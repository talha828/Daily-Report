import 'dart:async';

import 'package:altogic/altogic.dart';
import 'package:daily_report/components/constant/contant.dart';
import 'package:daily_report/getx_controller/user_model.dart';
import 'package:daily_report/views/get_start_screen.dart';
import 'package:daily_report/views/dashboard_screen.dart';
import 'package:daily_report/views/verify_number_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:validation_plus/validate.dart';

import '../main.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final userData = Get.put(UserModel());

  TextEditingController phoneNumber = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordConfirm = TextEditingController();
  String hintText = "Full Name";

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: height,
          child: Padding(
            padding: EdgeInsets.symmetric(
                vertical: width * 0.04, horizontal: width * 0.06),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  "assets/img/signup.png",
                  scale: 2,
                ),
                Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: width * 0.08, fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: width / 2.5,
                        child: DailyReportTextField(
                            controller: name, hintText: "FUll Name")),
                    Container(
                        width: width / 2.5,
                        child: DailyReportTextField(
                            controller: username, hintText: "#Username")),
                  ],
                ),
                DailyReportTextField(
                    controller: phoneNumber, hintText: "Phone No"),
                DailyReportTextField(
                    controller: password, hintText: "password"),
                DailyReportTextField(
                    controller: passwordConfirm, hintText: "Confirm Password"),
                ElevatedButton(
                    onPressed: () async {
                      // TODO :// set text feild validation for signup page
                      if (true) {
                        UserSessionResult response = await altogic.auth
                            .signUpWithPhone(
                                phoneNumber.text, passwordConfirm.text)
                            .then((value) async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();

                          if (value.user != null) {
                            prefs.setString('phone', phoneNumber.text);
                            prefs.setString('password', password.text);
                            userData.id.value = value.user!.id;
                            userData.name.value = name.text;
                            userData.username.value = username.text;
                            userData.phoneNumber.value = value.user!.phone!;
                            var result = await altogic.db
                                .model('users')
                                .object(value.user!.id)
                                .update({
                              'name': name.text,
                            });
                            var response =
                                await altogic.db.model('users.username').set({
                              "username": username.text,
                            }, value.user!.id);
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "Error: " + value.errors!.items[0].message!,
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                          return value;
                        });
                      } else {
                        Fluttertoast.showToast(
                            msg: "Error: phone Number",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    },
                    child: Text("Continue")),
                Row(
                  children: [
                    Text("Your Already Have an Account? "),
                    InkWell(
                        onTap: () => Get.to(LoginScreen()),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              color: appMainColor, fontWeight: FontWeight.bold),
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DailyReportTextField extends StatelessWidget {
  const DailyReportTextField({
    Key? key,
    required TextEditingController controller,
    required this.hintText,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
              borderSide: new BorderSide(color: appMainColor)),
          disabledBorder: UnderlineInputBorder(
              borderSide: new BorderSide(color: appMainColor)),
          border: UnderlineInputBorder(
              borderSide: new BorderSide(color: appMainColor)),
          hintText: hintText),
    );
  }
}
