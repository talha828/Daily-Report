import 'package:altogic/altogic.dart';
import 'package:daily_report/components/constant/contant.dart';
import 'package:daily_report/main.dart';
import 'package:daily_report/view/admin_view/dashboard_screen.dart';
import 'package:daily_report/view/common_view/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/widgets/loadingIndicator.dart';
import '../../components/widgets/textField.dart';
import '../../getx_controller/user_model.dart';
import '../employee_view/user_not_found.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userData = Get.put(UserModel());
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: height,
              padding: EdgeInsets.symmetric(
                  vertical: width * 0.04, horizontal: width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Image.asset(
                    "assets/img/login.png",
                    width: width * 0.7,
                    height: width * 0.5,
                  ),
                  Text(
                    "Login",
                    style: TextStyle(
                        fontSize: width * 0.08, fontWeight: FontWeight.bold),
                  ),
                  DailyReportTextField(
                      controller: phoneNumber, hintText: "Phone No"),
                  DailyReportTextField(controller: password, hintText: "password"),
                  InkWell(
                    onTap: ()async{

                    },
                    child: Text(
                      "Forget Password??",
                      textAlign: TextAlign.end,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, color: appMainColor),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        if(validation()){
                          setLoading(true);
                          UserSessionResult response = await altogic.auth
                              .signInWithPhone(phoneNumber.text, password.text)
                              .then((value) async {
                            SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            if (value.user != null) {
                              prefs.setString('phone', phoneNumber.text);
                              prefs.setString('password', password.text.toString());
                              userData.phoneNumber.value = value.user!.phone!;
                              userData.id.value = value.user!.id!;
                              userData.name.value = value.user!.name!;
                              userData.username.value = value.user!['username'];
                              userData.status.value == "Employee"
                                  ? Get.to(UserNotFoundScreen())
                                  : Get.to(DashboardScreen());
                            }
                            setLoading(false);
                            return value;
                          });
                        }else{
                            setLoading(false);
                          Fluttertoast.showToast(
                              msg: "Please fill all missing credential correctly",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                              textColor: Colors.white,
                              fontSize: 16.0);
                        }
                      },
                      child: Text("Login")),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Register New Account? "),
                      InkWell(
                          onTap: () => Get.to(SignUpScreen()),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                                color: appMainColor, fontWeight: FontWeight.bold),
                          )),
                    ],
                  )
                ],
              ),
            ),
          ),
          isLoading?LoadingIndicator():Container()
        ],
      ),
    );
  }

  bool validation() {
    if (phoneNumber.text.trim().isEmpty) return false;
    if (phoneNumber.text.length < 11) return false;
    if (password.text.trim().isEmpty) return false;
    return true;
  }

  bool isLoading = false;
  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
}
