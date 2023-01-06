import 'package:altogic/altogic.dart';
import 'package:daily_report/components/constant/contant.dart';
import 'package:daily_report/generated/assets.dart';
import 'package:daily_report/getx_controller/user_model.dart';
import 'package:daily_report/view/common_view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/widgets/loadingIndicator.dart';
import '../../getx_controller/items_controller.dart';
import '../../getx_controller/shop_report_controller.dart';
import '../../main.dart';

import '../../model/my_reports_model.dart';
import '../../model/shop_and_items_model.dart';
import '../../model/shop_model.dart';
import '../employee_view/show_report_screen.dart';
import 'my_employee_screen.dart';
import 'my_shop_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final userData = Get.find<UserModel>();
  final shopReport = Get.put(ShopReportController());
  final item = Get.put(ItemController());

  List<ShopModel> shops = [];
  getReports() async {
    setLoading(true);
    shops.clear();
    List<MyReportModel> list = [];
    var data = await altogic.db
        .model('users.shop')
        .filter('username == "${userData.username.value}"')
        .get()
        .then((value) async {
      if (value.errors == null) {
        for (var i in value.data) {
          shops.add(ShopModel(
              ownerName: i['ownerName'],
              userName: i['username'],
              shopName: i['shopName'],
              address: i['address'],
              id: i['_id']));
        }
        shops.forEach((element) async {
          var data = await altogic.db
              .model('users.Reports')
              .filter('shopName == "${element.shopName}"')
              .get()
              .then((value) {
            if (value.errors == null) {
              print(value.data.toString());
              value.data!.forEach((element) {
                list.add(MyReportModel.fromJson(element));
              });
              shopReport.list.clear();
              shopReport.list.add(
                  ShopAndItemsModel(shopName: element.shopName, list: list));
              setLoading(false);
            }
          });
        });
      }
    }).catchError((e){
      setLoading(false);
      print(e.toString());
    });
  }

  @override
  void initState() {
    getReports();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Dashboard"),
        actions: [
          InkWell(
            onTap: getReports,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.refresh),
            ),
          ),
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
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                vertical: width * 0.04, horizontal: width * 0.04),
            child: Column(
              children: [
                shopReport.list != null
                    ? ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                shopReport.list[i].shopName!,
                                style: TextStyle(
                                    fontSize: width * 0.08,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: width * 0.04,
                              ),
                              ListView.separated(
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    height: width * 0.04,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: width * 0.04),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: appMainColor),
                                        borderRadius: BorderRadius.circular(7)),
                                    child: ListTile(
                                      onTap: () {
                                        item.items.value =
                                            shopReport.list[i].list![index];
                                        Get.to(ShowReportScreen());
                                      },
                                      leading: Image.asset(
                                        Assets.iconDocument,
                                        width: width * 0.08,
                                        height: width * 0.08,
                                      ),
                                      title: Text(shopReport
                                          .list[i].list![index].date!
                                          .replaceAll(":", "-")),
                                      subtitle: Text(shopReport
                                          .list[i].list![index].employeeName!),
                                      trailing: Icon(
                                          Icons.arrow_forward_ios_outlined),
                                    ),
                                  );
                                },
                                itemCount: shopReport.list[i].list!.length,
                                shrinkWrap: true,
                              )
                            ],
                          );
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(height: width * 0.04);
                        },
                        itemCount: shopReport.list.length)
                    : Container()
              ],
            ),
          ),
          isLoading ? LoadingIndicator() : Container()
        ],
      ),
    );
  }

  bool isLoading = false;
  void setLoading(bool value) {
    setState(() {
      isLoading = value;
    });
  }
}
