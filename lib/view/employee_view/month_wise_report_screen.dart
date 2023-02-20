import 'package:daily_report/view/employee_view/show_report_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../generated/assets.dart';
import '../../getx_controller/items_controller.dart';
import '../../model/month.dart';
import '../admin_view/shop_report_screen.dart';

class MonthWiseReportScreen extends StatefulWidget {
  final MonthName data;
  const MonthWiseReportScreen({required this.data,Key? key}) : super(key: key);

  @override
  State<MonthWiseReportScreen> createState() => _MonthWiseReportScreenState();
}

class _MonthWiseReportScreenState extends State<MonthWiseReportScreen> {
  final item = Get.put(ItemController());

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("February"),
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.04, vertical: width * 0.04),
        child: ListView.separated(
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: width * 0.04),
                decoration: BoxDecoration(
                    border: Border.all(color:Colors.grey.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(7)
                ),
                child: ListTile(
                  onTap: () {
                    // Get.to(
                        item.items.value = widget.data.reports[index];
                        Get.to(ShowReportScreen());
                       // ShopReportScreen(employee: widget.data.reports[index]));
                  },
                  title: Text(
                    widget.data.reports[index].date!,
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
                        Text(double.parse( widget.data.reports[index].items![0].credit!.last.toString()).toStringAsFixed(0),style: TextStyle(color: Colors.red),),
                        Text(double.parse( widget.data.reports[index].items![0].credit!.last.toString()).toStringAsFixed(0),style: TextStyle(color: Colors.blue),),
                        Text(double.parse( widget.data.reports[index].items![0].credit!.last.toString()).toStringAsFixed(0),style: TextStyle(color: Colors.green),),
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
            itemCount: widget.data.reports.length),
      ),
    );
  }
}
