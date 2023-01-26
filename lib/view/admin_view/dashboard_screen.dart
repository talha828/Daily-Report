import 'package:altogic/altogic.dart';
import 'package:daily_report/components/constant/contant.dart';
import 'package:daily_report/generated/assets.dart';
import 'package:daily_report/getx_controller/user_model.dart';
import 'package:daily_report/model/dashboardModel.dart';
import 'package:daily_report/view/admin_view/shop_report_screen.dart';
import 'package:daily_report/view/common_view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/widgets/loadingIndicator.dart';
import '../../getx_controller/items_controller.dart';
import '../../getx_controller/shop_report_controller.dart';
import '../../main.dart';

import '../../model/employee_model.dart';
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
   // final shopReport = Get.put(ShopReportController());
  // final item = Get.put(ItemController());
  List<Employee> employee = [];
  List<DashboardModel>mylist=[];
  getEmployee() async {
    mylist.clear();
    employee.clear();
    var data = await altogic.db
        .model('users.employee')
        .filter('ownerUserName == "${userData.username.value}"')
        .get();
    for (var i in data.data) {
      employee.add(
        Employee(
            ownerName: i['ownerName'],
            ownerUserName: i['ownerUserName'],
            shopName: i['shopName'],
            shopId: i['shopId'],
            id: i['_id'],
            employeeName: i['employeeName'],
            employeeUserName: i['employeeUserName'],
            phoneNumber: i['phoneNumber']),
      );
    }
    setState(() {});
    // shopReport.list.clear();
    setLoading(true);
    shops.clear();

    List<List<MyReportModel>> list2 = [];
    var data1 = await altogic.db
        .model('users.shop')
        .filter('username == "${userData.username.value}"')
        .get()
        .then((value) async {
      if (value.errors == null ) {
        if(value.data.length > 0){
          for (var i in value.data) {
            shops.add(ShopModel(
                ownerName: i['ownerName'],
                userName: i['username'],
                shopName: i['shopName'],
                address: i['address'],
                id: i['_id']));
          }

          for(int i=0;i<shops.length;i++){
            var data = await altogic.db
                .model('users.Reports')
                .filter('shopName == "${shops[i].shopName}"')
                .get()
                .then((value) {
              // list.clear();
              if (value.errors == null) {
                print(value.data.toString());
                List<MyReportModel> list = [];
                for(var i in value.data){
                  list.add(MyReportModel.fromJson(i));
                }
                int date=DateTime.now().month;
                double ctotal=0;
                double dtotal=0;
                double dftotal=0;
                for(var i in list){
                  if(int.parse(i.date!.substring(3,5)) == date){
                    ctotal=ctotal+double.parse(i.items![0].credit!.last.toString());
                    dtotal=dtotal+double.parse(i.items![0].debit!.last.toString());
                    dftotal=dftotal+double.parse(i.items![0].differ!.last.toString());
                  }
                }
                mylist.add(DashboardModel(credit:ctotal.toString() ,debit:dtotal.toString() ,differ:dftotal.toString() ,shopName:list[0].shopName ,employeeName:list[0].employeeName ));
                // shopReport.list.add(
                //     ShopAndItemsModel(shopName: shops[i].shopName, list: list));
              }
            });

          }

        }else{
          setLoading(false);
        }
      }else{
        setLoading(false);
      }
    }).catchError((e){
      setLoading(false);
      print(e.toString());
    });
  }
  List<ShopModel> shops = [];


  @override
  void initState() {
    getEmployee();
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
            onTap: (){
              getEmployee();},
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
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: width * 0.04, horizontal: width * 0.04),
              child: Column(
                children: [
                  mylist.isNotEmpty
                      ? ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, i) {
                            return   Container(
                              decoration: BoxDecoration(
                                border: Border.all(color:Colors.grey.withOpacity(0.5)),
                                borderRadius: BorderRadius.circular(7)
                              ),
                              child: ListTile(
                                onTap: ()=>Get.to(ShopReportScreen(employee:  mylist[i])),
                                title: Text(
                                  "${mylist[i].shopName!} (${mylist[i].employeeName!})",
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: width * 0.05,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(double.parse(mylist[i].credit!).toStringAsFixed(0),style: TextStyle(color: Colors.red),),
                                      Text(double.parse(mylist[i].debit!).toStringAsFixed(0),style: TextStyle(color: Colors.blue),),
                                      Text(double.parse(mylist[i].differ!).toStringAsFixed(0),style: TextStyle(color: Colors.green),),
                                    ],
                                  ),
                                ),
                                trailing: Icon(Icons.arrow_forward_ios_outlined),
                              ),
                            );
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(height: width * 0.04);
                          },
                          itemCount: mylist.length)
                      : Container()
                ],
              ),
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
// SizedBox(
//   height: width * 0.04,
// ),
// ListView.separated(
//   physics: NeverScrollableScrollPhysics(),
//   separatorBuilder: (context, index) {
//     return SizedBox(
//       height: width * 0.04,
//     );
//   },
//   itemBuilder: (context, index) {
//     return Container(
//       margin: EdgeInsets.symmetric(
//           horizontal: width * 0.04),
//       decoration: BoxDecoration(
//           border: Border.all(color: appMainColor),
//           borderRadius: BorderRadius.circular(7)),
//       child: ListTile(
//         onTap: () {
//           item.items.value =
//               shopReport.list[i].list![index];
//           Get.to(ShowReportScreen());
//         },
//         leading: Image.asset(
//           Assets.iconDocument,
//           width: width * 0.08,
//           height: width * 0.08,
//         ),
//         title: Text(shopReport
//             .list[i].list![index].date!
//             .replaceAll(":", "-")),
//         subtitle: Text(shopReport
//             .list[i].list![index].employeeName!),
//         trailing: Icon(
//             Icons.arrow_forward_ios_outlined),
//       ),
//     );
//   },
//   itemCount: shopReport.list[i].list!.length,
//   shrinkWrap: true,
// )