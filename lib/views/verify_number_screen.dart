import 'package:daily_report/views/signup_screen.dart';
import 'package:flutter/material.dart';

import '../components/constant/contant.dart';

class VerifyNumberScreen extends StatefulWidget {
  const VerifyNumberScreen({Key? key}) : super(key: key);

  @override
  State<VerifyNumberScreen> createState() => _VerifyNumberScreenState();
}

class _VerifyNumberScreenState extends State<VerifyNumberScreen> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: width * 0.04, horizontal: width * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/img/verify.png",
              scale: 5,
            ),
            SizedBox(
              height: width * 0.12,
            ),
            Text(
              "Verify Your Number",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: width * 0.07, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: width * 0.08,
            ),
            Text(
              "Please enter your number to verify your account and proceed",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: width * 0.04,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: width * 0.2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DailyReportPinField(width: width, controller: _controller),
                DailyReportPinField(width: width, controller: _controller),
                DailyReportPinField(width: width, controller: _controller),
                DailyReportPinField(width: width, controller: _controller),
                DailyReportPinField(width: width, controller: _controller),
                DailyReportPinField(width: width, controller: _controller),
              ],
            ),
            SizedBox(
              height: width * 0.2,
            ),
            ElevatedButton(onPressed: () {}, child: Text("Verify"))
          ],
        ),
      ),
    );
  }
}

class DailyReportPinField extends StatelessWidget {
  const DailyReportPinField({
    Key? key,
    required this.width,
    required TextEditingController controller,
  })  : _controller = controller,
        super(key: key);

  final double width;
  final TextEditingController _controller;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: width / 11,
        child: TextField(
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          controller: _controller,
          decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              focusedBorder: UnderlineInputBorder(
                  borderSide: new BorderSide(color: appMainColor)),
              disabledBorder: UnderlineInputBorder(
                  borderSide: new BorderSide(color: appMainColor)),
              border: UnderlineInputBorder(
                  borderSide: new BorderSide(color: appMainColor)),
              hintText: "*",
              hintStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: width * 0.07)),
        ));
  }
}
