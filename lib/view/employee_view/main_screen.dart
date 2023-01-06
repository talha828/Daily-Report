import 'dart:async';

import 'package:altogic/altogic.dart';
import 'package:daily_report/getx_controller/user_model.dart';
import 'package:daily_report/model/my_reports_model.dart';
import 'package:daily_report/view/employee_view/show_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../../components/constant/contant.dart';
import '../../generated/assets.dart';
import '../../getx_controller/items_controller.dart';
import '../../getx_controller/save_reports_controller.dart';
import '../../main.dart';
import '../../model/emploeey_shop_details_model.dart';
import '../common_view/splash_screen.dart';
import 'new_report-screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final userData = Get.find<UserModel>();
  final employee = Get.find<EmployeeShopDetails>();
  final reports = Get.put(MyReportController());
  final item = Get.put(ItemController());
  late String _timeString;

  getData() async {
    List<MyReportModel> list = [];
    print(employee.id);
    var data = await altogic.db
        .model('users.Reports')
        .filter('_parent == "${userData.id}"')
        .get()
        .then((value) {
      if (value.errors == null) {
        print(value.data.toString());
        value.data!.forEach((element) {
          list.add(MyReportModel.fromJson(element));
        });
        reports.reports.clear();
        reports.reports.addAll(list);
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          InkWell(
            onTap: getData,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.refresh),
            ),
          ),
        ],
        //title: Text("Daily Report"),
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
              accountEmail: Text(
                userData!.phoneNumber.value,
                style: TextStyle(color: Colors.white),
              ),
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
              leading: Image.asset(Assets.iconHouse,
                  width: width * 0.07, height: width * 0.07),
              title: const Text(' Home '),
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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: appMainColor,
                height: width * 0.5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      employee.shopName.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.1,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: width * 0.04,
                    ),
                    Text(
                      employee.ownerName.value,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.05,
                          color: Colors.white),
                    ),
                    SizedBox(
                      height: width * 0.04,
                    ),
                    Text(
                      _timeString,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: width * 0.15,
                          color: Colors.white),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: width * 0.04,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                              width: 2, color: Colors.grey.withOpacity(0.5))),
                      child: ListTile(
                        onTap: () => Get.to(NewReportScreen()),
                        leading: Icon(
                          Icons.add,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                        title: Text(
                          "New Report",
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: width * 0.04,
              ),
              reports.reports != null
                  ? ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: width * 0.04),
                          decoration: BoxDecoration(
                              border: Border.all(color: appMainColor),
                              borderRadius: BorderRadius.circular(7)),
                          child: ListTile(
                            onTap: () {
                              item.items.value = reports.reports[index];
                              Get.to(ShowReportScreen());
                            },
                            leading: Image.asset(
                              Assets.iconDocument,
                              width: width * 0.07,
                              height: width * 0.07,
                            ),
                            title: Text(reports.reports[index].date!
                                .replaceAll(":", "-")),
                            trailing: Icon(Icons.arrow_forward_ios_outlined),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: width * 0.04,
                        );
                      },
                      itemCount: reports.reports.length)
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm:ss').format(dateTime);
  }
}
