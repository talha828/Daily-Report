import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../getx_controller/report_view_controller.dart';
import '../../getx_controller/user_model.dart';
import '../../main.dart';
import '../../model/emploeey_shop_details_model.dart';

class ViewReportScreen extends StatefulWidget {
  const ViewReportScreen({Key? key}) : super(key: key);

  @override
  State<ViewReportScreen> createState() => _ViewReportScreenState();
}

class _ViewReportScreenState extends State<ViewReportScreen> {
  final userData = Get.find<UserModel>();
  final employee = Get.find<EmployeeShopDetails>();
  final controller = Get.find<ReportViewController>();
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
          onPressed: () async {

            // altogic.db.model("users.reports").append({
            //   "shopName":employee.shopName.value,
            //   "shopId":employee.shopId.value,
            //   "ownerName":employee.ownerName.value,
            //   "employeeId":employee.id.value,
            //   "employeeName":employee.employeeName,
            //   "date":DateFormat('dd:MM:yy').format(DateTime.now())
            // },userData.id.value).then((value){
            //   controller.controller.forEach((element) {
            //     altogic.db.model("users.reports").append({
            //       "product":element.product,
            //       "credit":element.credit,
            //       "debit":element.debit,
            //     },userData.id.value);
            //   });
            // });
          },
          child: Text("Submit"),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            vertical: width * 0.04, horizontal: width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              employee.shopName.value,
              style: TextStyle(
                  fontSize: width * 0.08, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: width * 0.02,
            ),
            Text(
              employee.ownerName.value,
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
              // checkboxHorizontalMargin: 2,
              columnSpacing: width * 0.05,
              showBottomBorder: true,
              columns: [
                DataColumn(
                  label: Text('Product'),
                ),
                DataColumn(
                  label: Text('Credit'),
                ),
                DataColumn(
                  label: Text('Debit'),
                ),
                DataColumn(
                  label: Text('Differ'),
                ),
              ],
              rows: controller.controller
                  .map((element) => DataRow(cells: [
                        DataCell(Text(element.product!.length > 10?element.product!.substring(0,11): element.product.toString(),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                        DataCell(Text(element.credit.toString())),
                        DataCell(Text(element.debit.toString())),
                        DataCell(Text(element.ramming.toString())),
                      ]))
                  .toList(),
            )
          ],
        ),
      ),
    );
  }
}
