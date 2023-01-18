import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../components/constant/contant.dart';
import '../../components/widgets/textField.dart';
import '../../generated/assets.dart';
import '../../getx_controller/user_model.dart';
import '../../main.dart';
import '../../model/emploeey_shop_details_model.dart';
import '../../model/shop_model.dart';
import '../common_view/signup_screen.dart';

class CreateSalsemanScreen extends StatefulWidget {
  const CreateSalsemanScreen({Key? key}) : super(key: key);

  @override
  State<CreateSalsemanScreen> createState() => _CreateSalsemanScreenState();
}

class _CreateSalsemanScreenState extends State<CreateSalsemanScreen> {

  TextEditingController salesmanName = TextEditingController();
  TextEditingController product = TextEditingController();
  TextEditingController about = TextEditingController();
  final userData = Get.find<UserModel>();
  final employee = Get.find<EmployeeShopDetails>();


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios)),
        title: Text("Create Employee"),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: height - 100,
          padding: EdgeInsets.symmetric(horizontal: width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(
                Assets.imgEmployee,
                width: width * 0.5,
                height: width * 0.7,
              ),
              DailyReportTextField(
                  controller: salesmanName, hintText: "Salesman Name"),
              DailyReportTextField(
                  controller: product, hintText: "product Name"),
              DailyReportTextField(controller: about, hintText: "About"),
              SizedBox(
                height: width * 0.04,
              ),
              ElevatedButton(
                  onPressed: () async {
                    if(salesmanName.text.isNotEmpty){
                      if(product.text.isNotEmpty){
                        if(about.text.isNotEmpty){
                          altogic.db.model("users.salesman").append({
                            "owner_name": employee.ownerName.value,
                            "employee_name": employee.employeeName.value,
                            "salesman_name": salesmanName.text,
                            "product": product.text,
                            "shopId": employee.shopId.value,
                            "about": about.text,
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
                          Fluttertoast.showToast(msg: "Enter About salesman");
                        }
                      }else{
                          Fluttertoast.showToast(msg: "Enter product Name");
                      }
                    }else{
                      Fluttertoast.showToast(msg: "Enter Salesman Name");
                    }
                  },
                  child: Text("save")),
            ],
          ),
        ),
      ),
    );
  }
}
