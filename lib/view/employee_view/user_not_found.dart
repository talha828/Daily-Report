import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/constant/contant.dart';
import '../../generated/assets.dart';
import '../../getx_controller/user_model.dart';
import '../../main.dart';
import '../../model/emploeey_shop_details_model.dart';
import '../common_view/splash_screen.dart';
import 'main_screen.dart';

class UserNotFoundScreen extends StatefulWidget {
  const UserNotFoundScreen({Key? key}) : super(key: key);

  @override
  State<UserNotFoundScreen> createState() => _UserNotFoundScreenState();
}

class _UserNotFoundScreenState extends State<UserNotFoundScreen> {
  final userData = Get.find<UserModel>();
  final employeeData = Get.put(EmployeeShopDetails());
  checkUserRecord() async {
    await altogic.db
        .model('users.employee')
        .filter('phoneNumber == "${userData.phoneNumber.value}"')
        .get()
        .then((value) {
      if (value.data != null) {
        employeeData.employeeName.value = value.data[0]["employeeName"];
        employeeData.employeeUserName.value = value.data[0]["employeeUserName"];
        employeeData.employeePhoneNumber.value = value.data[0]['phoneNumber'];
        employeeData.ownerName.value = value.data[0]['ownerName'];
        employeeData.ownerUserName.value = value.data[0]['ownerUserName'];
        employeeData.shopName.value = value.data[0]['shopName'];
        employeeData.shopId.value = value.data[0]['shopId'];
        employeeData.id.value = value.data[0]['_id'];
        Get.to(MainScreen());
      }
    });
  }

  @override
  void initState() {
    checkUserRecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        color: appMainColor.withOpacity(0.4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              Assets.imgError,
              scale: 4,
            ),
            SizedBox(
              height: width * 0.04,
            ),
            Text(
              "Sorry, Contact To your Admin",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: width * 0.06),
            ),
            SizedBox(
              height: width * 0.04,
            ),
            Text(
              "We don't have any record of you in our database please contact to your shop keeper or use a similar phone Number as you registered",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: width * 0.13,
            ),
            ElevatedButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString("phone", "");
                  prefs.setString("password", "");
                  final errors = await altogic.auth.signOutAll();
                  Get.to(SplashScreen());
                },
                child: Text("LogOut")),
          ],
        ),
      ),
    );
  }
}
