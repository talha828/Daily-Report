import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:daily_report/components/constant/contant.dart';
import 'package:daily_report/getx_controller/items_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../getx_controller/report_view_controller.dart';
import '../../getx_controller/user_model.dart';
import '../../main.dart';
import '../../model/emploeey_shop_details_model.dart';
import '../../model/my_reports_model.dart';

class ShowReportScreen extends StatefulWidget {
  const ShowReportScreen({Key? key}) : super(key: key);

  @override
  State<ShowReportScreen> createState() => _ShowReportScreenState();
}

class _ShowReportScreenState extends State<ShowReportScreen> {
  final controller = Get.find<ItemController>();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios)),
        title: Text("View Report"),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.04, vertical: width * 0.04),
        child: ElevatedButton(
          onPressed: () async {},
          child: Text("Okay"),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              vertical: width * 0.04, horizontal: width * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                controller.items.value.shopName!,
                style: TextStyle(
                    fontSize: width * 0.08, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: width * 0.02,
              ),
              Text(
                controller.items.value.employeeName!,
                style: TextStyle(fontSize: width * 0.05, color: Colors.grey),
              ),
              SizedBox(
                height: width * 0.02,
              ),
              Text(
                "Date:  " +
                    DateFormat('dd-MM-yyyy').format(DateTime.now()).toString(),
                style: TextStyle(
                  fontSize: width * 0.04,
                ),
              ),
              SizedBox(
                height: width * 0.04,
              ),
              DataTable(
                sortAscending: false,
                // checkboxHorizontalMargin: 2,
                columnSpacing: width * 0.05,
                showBottomBorder: true,
                columns: [
                  DataColumn(
                    label: Text('Product'),
                  ),
                  DataColumn(
                    numeric: true,
                    label: Text('Debit'),
                  ),
                  DataColumn(
                    numeric: true,
                    label: Text('Credit'),
                  ),
                  DataColumn(
                    numeric: true,
                    label: Text('Differ'),
                  ),
                ],
                rows:  [
                  for(int i=0; i< controller.items.value.items![0].productName!.length;i++)
                    DataRow(cells: [
                      DataCell(Text(
                        controller.items.value.items![0].productName![i].length > 10
                            ? controller.items.value.items![0].productName![i].substring(0, 11)
                            : controller.items.value.items![0].productName![i].toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                      DataCell(Text(controller.items.value.items![0].credit![i].toString())),
                      DataCell(Text(controller.items.value.items![0].debit![i].toString())),
                      DataCell(Text(controller.items.value.items![0].differ![i].toString())),
                    ])
                    ]


              )
            ],
          ),
        ),
      ),
    );
  }
}
