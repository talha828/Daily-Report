import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:daily_report/views/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../components/constant/contant.dart';
import '../generated/assets.dart';
import '../getx_controller/user_model.dart';
import '../main.dart';
import '../model/shop_model.dart';

class CreateEmployeeScreen extends StatefulWidget {
  const CreateEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<CreateEmployeeScreen> createState() => _CreateEmployeeScreenState();
}

class _CreateEmployeeScreenState extends State<CreateEmployeeScreen> {
  TextEditingController employeeName = TextEditingController();
  TextEditingController ownerName = TextEditingController();
  TextEditingController ownerUserName = TextEditingController();
  TextEditingController employeeUserName = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  final userData = Get.find<UserModel>();
  List<ShopModel> shops = [];
  late ShopModel dropdownvalue = ShopModel(
      ownerName: "", id: "0", shopName: "please select shop", userName: "");
  getShop() async {
    shops.clear();
    var data = await altogic.db
        .model('users.shop')
        .filter('username == "${userData.username.value}"')
        .get();
    for (var i in data.data) {
      shops.add(ShopModel(
          ownerName: i['ownerName'],
          userName: i['username'],
          shopName: i['shopName'],
          address: i['address'],
          id: i['_id']));
    }
    dropdownvalue = shops[0];
    setState(() {});
  }

  @override
  void initState() {
    getShop();
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
          height: height,
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
                  controller: employeeName, hintText: "Employee Name"),
              DailyReportTextField(
                  controller: employeeUserName,
                  hintText: "username  (employee)"),
              DailyReportTextField(
                  controller: ownerName, hintText: userData.name.value),
              DailyReportTextField(
                  controller: ownerUserName, hintText: userData.username.value),
              SizedBox(
                height: width * 0.02,
              ),
              Text(
                "Assign Shop",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: Colors.grey.withOpacity(0.5))),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<ShopModel>(
                    hint: Text("loading"),
                    isExpanded: true,
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: shops.map((items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items.shopName!),
                      );
                    }).toList(),
                    onChanged: (ShopModel? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),
              ),
              DailyReportTextField(
                  controller: phoneNumber, hintText: "Phone Number (Employee)"),
              SizedBox(
                height: width * 0.04,
              ),
              ElevatedButton(
                  onPressed: () async {
                    //TODO validation and loading
                    altogic.db.model("users.employee").append({
                      "ownerName": ownerName.text.isEmpty
                          ? userData.name.value
                          : ownerName.text,
                      "ownerUserName": ownerUserName.text.isEmpty
                          ? userData.username.value
                          : ownerUserName.text,
                      "employeeName": employeeName.text,
                      "employeeUserName": employeeUserName.text,
                      "phoneNumber": phoneNumber.text,
                      "shopId": dropdownvalue.id,
                      "shopName": dropdownvalue.shopName,
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
                  },
                  child: Text("Create Employee")),
            ],
          ),
        ),
      ),
    );
  }
}
