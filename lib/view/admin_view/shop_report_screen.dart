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
import '../../model/month.dart';
import '../../model/shop_and_items_model.dart';
import '../../model/shop_model.dart';
import '../employee_view/month_wise_report_screen.dart';
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
  List<MonthName> month=[];
  List<String> monthsname=["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November" , "December"];

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
      for(int i = 0; i < 12; i++){
        List<MyReportModel> temp=[];
        double credit =0.0;
        double debit =0.0;
        double differ =0.0;
        for (int j=0;j<shopReport.list[0].list!.length;j++) {
          print(shopReport.list[0].list![i].date!);
          print(shopReport.list[0].list![i].date!.substring(3,5));
          if("0"+(i+1).toString() == shopReport.list[0].list![j].date!.substring(3,5)){
            temp.add(shopReport.list[0].list![j]);
            debit=debit+ double.parse(shopReport.list[0].list![j].items![0].debit!.last) ?? 0;
            credit=credit+double.parse(shopReport.list[0].list![j].items![0].credit!.last) ?? 0;
            differ=differ+double.parse(shopReport.list[0].list![j].items![0].differ!.last) ?? 0;
          }
        }
        month.add(MonthName(name: monthsname[i],reports:temp,credit: credit,differ: differ,debit: debit ));
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
                      return  Visibility(
                        visible: month[index].reports.length<1?false:true,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: width * 0.04),
                          decoration: BoxDecoration(
                              border: Border.all(color:Colors.grey.withOpacity(0.5)),
                              borderRadius: BorderRadius.circular(7)
                          ),
                          child: ListTile(
                            onTap: ()=>Get.to(MonthWiseReportScreen(data:month[index],)),
                            title: Text(
                              month[index].name,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: width * 0.05,
                                  fontWeight: FontWeight.bold),
                            ),
                            leading: Image.asset(
                              Assets.iconDocument,
                              width: width * 0.1,
                              height: width * 0.1,
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(double.parse( month[index].credit.toString()).toStringAsFixed(0),style: TextStyle(color: Colors.red),),
                                  Text(double.parse( month[index].debit.toString()).toStringAsFixed(0),style: TextStyle(color: Colors.blue),),
                                  Text(double.parse( month[index].differ.toString()).toStringAsFixed(0),style: TextStyle(color: Colors.green),),
                                ],
                              ),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios_outlined),
                          ),
                        ),
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
