import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/constant/contant.dart';
import '../../generated/assets.dart';
import '../../main.dart';
import '../common_view/splash_screen.dart';

class UserNotFoundScreen extends StatefulWidget {
  const UserNotFoundScreen({Key? key}) : super(key: key);

  @override
  State<UserNotFoundScreen> createState() => _UserNotFoundScreenState();
}

class _UserNotFoundScreenState extends State<UserNotFoundScreen> {
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        color: appMainColor.withOpacity(0.4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Assets.imgError,scale: 4,),
            SizedBox(height: width * 0.04,),
            Text("Sorry, Contact To your Admin",textAlign: TextAlign.center,style:TextStyle(fontWeight: FontWeight.bold,fontSize: width * 0.06),),
            SizedBox(height: width * 0.04,),
            Text("We don't have any record of you in our database please contact to your shop keeper or use a similar phone Number as you registered",textAlign: TextAlign.center,),
            SizedBox(height: width * 0.13,),
            ElevatedButton(onPressed: ()async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString("phone", "");
              prefs.setString("password", "");
              final errors = await altogic.auth.signOutAll();
              Get.to(SplashScreen());
            }, child: Text("LogOut")),
          ],
        ),
      ),
    );
  }
}
