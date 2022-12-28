import 'package:daily_report/components/constant/contant.dart';
import 'package:daily_report/view/common_view/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../getx_controller/user_model.dart';

class GetStartScreen extends StatefulWidget {
  const GetStartScreen({Key? key}) : super(key: key);

  @override
  State<GetStartScreen> createState() => _GetStartScreenState();
}

class _GetStartScreenState extends State<GetStartScreen> {
  final userData = Get.put(UserModel());
  String label = "Shop Owner";
  var onTap = () {};
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: width * 0.06),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Welcome",
              style: TextStyle(
                  fontSize: width * 0.06, fontWeight: FontWeight.bold),
            ),
            Text(
              "Daily Report",
              style: TextStyle(
                  fontSize: width * 0.07, fontWeight: FontWeight.bold),
            ),
            Image.asset(
              "assets/img/getstart.png",
            ),
            Text(
              "Continues as",
              style: TextStyle(
                  fontSize: width * 0.07, fontWeight: FontWeight.w500),
            ),
            DailyReportButton(
                onTap: () {
                  userData.status.value="Admin";
                  Get.to(SignUpScreen());
                },
                width: width,
                label: "Admin"),
            DailyReportButton(onTap: () {
              userData.status.value="Employee";
              Get.to(SignUpScreen());
            }, width: width, label: "Employee"),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class DailyReportButton extends StatelessWidget {
  const DailyReportButton({
    Key? key,
    required this.onTap,
    required this.width,
    required this.label,
  }) : super(key: key);

  final Null Function() onTap;
  final double width;
  final String label;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: width * 0.04),
        decoration: BoxDecoration(
          border: Border.all(color: appMainColor),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Text(label),
      ),
    );
  }
}
