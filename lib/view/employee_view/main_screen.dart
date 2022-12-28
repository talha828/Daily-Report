import 'package:daily_report/getx_controller/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/constant/contant.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../common_view/splash_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final userData=Get.find<UserModel>();
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar:AppBar(
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios)),
        title: Text("Daily Report"),
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
    );
  }
}
