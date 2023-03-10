import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:daily_report/components/constant/contant.dart';
import 'package:daily_report/main.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../components/widgets/textField.dart';
import '../../generated/assets.dart';
import '../../getx_controller/user_model.dart';
import '../common_view/signup_screen.dart';

class CreateShopScreen extends StatefulWidget {
  const CreateShopScreen({Key? key}) : super(key: key);

  @override
  State<CreateShopScreen> createState() => _CreateShopScreenState();
}

class _CreateShopScreenState extends State<CreateShopScreen> {
  final userData = Get.find<UserModel>();
  TextEditingController shopName = TextEditingController();
  TextEditingController ownerName = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController address = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios)),
        title: Text("Create Shop"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height,
          padding: EdgeInsets.symmetric(horizontal: width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                Assets.imgShop,
                width: width * 0.5,
                height: width * 0.7,
              ),
              DailyReportTextField(controller: shopName, hintText: "Shop Name"),
              DailyReportTextField(
                  controller: ownerName, hintText: userData.name.value),
              DailyReportTextField(controller: address, hintText: "Address"),
              DailyReportTextField(
                  controller: userName, hintText: userData.username.value),
              ElevatedButton(
                  onPressed: () async {
                    //TODO validation and loading
                    if(validation()){
                      altogic.db.model("users.shop").append({
                        "_parent": userData.id.value,
                        "shopName": shopName.text,
                        "ownerName": ownerName.text.isEmpty
                            ? userData.name.value
                            : ownerName.text,
                        "address": address.text,
                        "username": userName.text.isEmpty
                            ? userData.username.value
                            : userName.text,
                      }, userData.id.value).then((value) async {
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.info,
                          animType: AnimType.rightSlide,
                          title: 'Congratulation',
                          desc: 'Your Shop successfully created',
                          btnOkColor: appMainColor,
                          btnOkOnPress: () {
                            Navigator.of(context)..pop();
                          },
                        )..show();
                      });
                    }else{
                      Fluttertoast.showToast(
                          msg: "Please fill all missing credential correctly",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  child: Text("Create Shop"))
            ],
          ),
        ),
      ),
    );
  }
  bool validation(){
    if(shopName.text.isEmpty) return false;
    if(ownerName.text.isEmpty
        ? userData.name.value.isEmpty
        : ownerName.text.isEmpty) return false;
    if(address.text.isEmpty) return false;
    if( userName.text.isEmpty
        ? userData.username.value.isEmpty
        : userName.text.isEmpty) return false;
    return true;
  }
}
