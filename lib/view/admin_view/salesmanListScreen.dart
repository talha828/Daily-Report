import 'package:daily_report/main.dart';
import 'package:daily_report/model/salesmanModel.dart';
import 'package:daily_report/view/employee_view/view_salesman_report-screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../getx_controller/user_model.dart';

class AdminSalesmanListScreen extends StatefulWidget {
  final String employeeName;
  const AdminSalesmanListScreen({required this.employeeName,Key? key}) : super(key: key);

  @override
  State<AdminSalesmanListScreen> createState() => _AdminSalesmanListScreenState();
}

class _AdminSalesmanListScreenState extends State<AdminSalesmanListScreen> {
  // final user = Get.find<UserModel>();
  List<SalesmanModel> list = [];
  getData() async {
    altogic.db
        .model("users.salesman")
        .filter(' employee_name == "${widget.employeeName}"')
        .get()
        .then(
          (value) {
        if (value.errors == null) {
          value.data.forEach((i) {
            list.add(SalesmanModel(
                ownerName: i['owner_name'],
                employeeName: i['employee_name'],
                salesmanName: i["salesman_name"],
                product: i['product'],
                shopId: i['shopId'],
                about: i["about"],
                id: i["_id"]));
            setState(() {});
          });
        }
      },
    );
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
          padding: EdgeInsets.symmetric(
              vertical: width * 0.04, horizontal: width * 0.04),
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(
                height: width * 0.04,
              );
            },
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    border: Border.all(color: Colors.grey.withOpacity(0.5))),
                child: ListTile(
                  onTap: ()=>Get.to(ViewSalesmanReportScreen(id: list[index].id,salesmanName:list[index].salesmanName ,)),
                  title: Text(list[index].salesmanName),
                  subtitle: Text(list[index].product),
                  trailing: Icon(Icons.arrow_forward_ios_outlined),
                ),
              );
            },
            itemCount: list.length,
          )),
    );
  }
}
