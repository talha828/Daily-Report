import 'package:daily_report/model/dashboardModel.dart';
import 'package:daily_report/model/employee_model.dart';
import 'package:daily_report/model/my_reports_model.dart';
import 'package:daily_report/view/admin_view/salesmanListScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../generated/assets.dart';
import '../../getx_controller/items_controller.dart';
import '../../getx_controller/shop_report_controller.dart';
import '../../main.dart';
import '../../model/shop_and_items_model.dart';
import '../../model/shop_model.dart';
import '../employee_view/show_report_screen.dart';

class ShopReportScreen extends StatefulWidget {
  final DashboardModel employee;
  const ShopReportScreen({required this.employee, Key? key}) : super(key: key);

  @override
  State<ShopReportScreen> createState() => _ShopReportScreenState();
}

class _ShopReportScreenState extends State<ShopReportScreen> {
  final shopReport = Get.put(ShopReportController());
  final item = Get.put(ItemController());

  List<ShopModel> shops = [];
  getData() async {
    var data = await altogic.db
        .model('users.Reports')
        .filter('shopName == "${widget.employee.shopName}"')
        .get()
        .then((value) {
      // list.clear();
      if (value.errors == null) {
        print(value.data.toString());
        List<MyReportModel> list = [];
        for (var i in value.data) {
          list.add(MyReportModel.fromJson(i));
        }
        shopReport.list
            .add(ShopAndItemsModel(shopName: widget.employee.shopName, list: list));
        setState(() {});
      }
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.employee.shopName!),
            leading:
                InkWell(onTap: () => Get.back(), child: Icon(Icons.arrow_back)),
            bottom: TabBar(
                indicatorColor: Colors.white,
                tabs: [
              Tab(
                // text: "Reports",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      Assets.iconDocument,
                      width: width * 0.05,
                      height: width * 0.05,
                    ),
                    // SizedBox(),
                    Text(
                      "Report",
                      style: TextStyle(
                          color: Colors.white, fontSize: width * 0.04),
                    )
                  ],
                ),
              ),
              Tab(
                // icon: Image.asset(Assets.imgEstateAgent,width:width * 0.02,height: width * 0.02,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Image.asset(
                      Assets.imgEstateAgent,
                      width: width * 0.05,
                      height: width * 0.05,
                    ),
                    Text(
                      "Salesman",
                      style: TextStyle(
                          color: Colors.white, fontSize: width * 0.04),
                    )
                  ],
                ),
              ),
            ]),
          ),
          body: TabBarView(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                    vertical: width * 0.04, horizontal: width * 0.04),
                child: ListView.separated(
                    itemBuilder: (context, index) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.5))),
                        child: ListTile(
                            onTap: () {
                              item.items.value =
                                  shopReport.list[index].list![index];
                              Get.to(ShowReportScreen());
                            },
                            leading: Image.asset(
                              Assets.iconDocument,
                              width: width * 0.08,
                              height: width * 0.08,
                            ),
                            title: Text(shopReport.list.first.list![index].date!.toString()
                                .replaceAll(":", "-")),
                            subtitle: Text(shopReport
                                .list.first.list![index].employeeName!),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "- ${shopReport.list.first.list![index].items!.last.credit!.last}",
                                  style: TextStyle(color: Colors.red),
                                ),
                                Text(
                                  "+ ${shopReport.list.first.list![index].items!.last.debit!.last}",
                                  style: TextStyle(color: Colors.green),
                                ),
                                // Text(shopReport.list.first.list![index].items!.last.differ!.last),
                              ],
                            )),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        height: width * 0.04,
                      );
                    },
                    itemCount: shopReport.list.isNotEmpty
                        ? shopReport.list[0].list!.length
                        : shopReport.list.length),
              ),
              AdminSalesmanListScreen(employeeName: widget.employee.employeeName!,)
            ],
          )),
    );
  }
}
