import 'package:daily_report/components/constant/contant.dart';
import 'package:daily_report/generated/assets.dart';
import 'package:daily_report/getx_controller/user_model.dart';
import 'package:daily_report/view/common_view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../main.dart';


import 'my_employee_screen.dart';
import 'my_shop_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final userData = Get.find<UserModel>();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Dashboard"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(Icons.edit),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                userData!.name.value.toUpperCase(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: width * 0.06),
              ),
              accountEmail: Text(userData!.phoneNumber.value,
                  style: TextStyle(color: Colors.white)),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  userData!.name.value.toUpperCase().substring(0, 1),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: width * 0.09,
                      color: appMainColor),
                ),
              ),
            ),
            ListTile(
              leading: Image.asset(Assets.iconShop,
                  width: width * 0.07, height: width * 0.07),
              title: const Text(' My Shops '),
              onTap: () {
                Navigator.pop(context);
                Get.to(MyShopScreen());
              },
            ),
            ListTile(
              leading: Image.asset(Assets.iconMan,
                  width: width * 0.07, height: width * 0.07),
              title: const Text(' My Employee '),
              onTap: () {
                Navigator.pop(context);
                Get.to(MyEmployeeScreen());
              },
            ),
            ListTile(
              leading: Image.asset(Assets.iconEdit,
                  width: width * 0.07, height: width * 0.07),
              title: const Text(' Edit Profile '),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Image.asset(Assets.iconLogout,
                  width: width * 0.07, height: width * 0.07),
              title: const Text('LogOut'),
              onTap: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString("phone", "");
                prefs.setString("password", "");
                final errors = await altogic.auth.signOutAll();
                Get.to(SplashScreen());
              },
            ),
          ],
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: width * 0.04, horizontal: width * 0.04),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  border:
                      Border.all(width: 2, color: Colors.grey.withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(7)),
              child: ListTile(
                leading: Icon(
                  Icons.add,
                  color: Colors.grey,
                ),
                title: Text("Create New Report"),
              ),
            ),
            SizedBox(
              height: width * 0.04,
            ),
          ],
        ),
      ),
    );
  }
}
