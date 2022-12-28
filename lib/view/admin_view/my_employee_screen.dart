import 'package:daily_report/components/constant/contant.dart';
import 'package:daily_report/getx_controller/user_model.dart';
import 'package:daily_report/model/employee_model.dart';
import 'package:daily_report/view/admin_view/create_employee_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../generated/assets.dart';
import '../../main.dart';



class MyEmployeeScreen extends StatefulWidget {
  const MyEmployeeScreen({Key? key}) : super(key: key);

  @override
  State<MyEmployeeScreen> createState() => _MyEmployeeScreenState();
}

class _MyEmployeeScreenState extends State<MyEmployeeScreen> {
  final userData = Get.find<UserModel>();
  List<Employee> employee = [];
  getEmployee() async {
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
  }

  @override
  void initState() {
    getEmployee();
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
        title: Text("My Employee"),
        actions: [
          InkWell(
            onTap: () => getEmployee(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.refresh),
            ),
          ),
          InkWell(
            onTap: () => Get.to(CreateEmployeeScreen()),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.add),
            ),
          )
        ],
      ),
      body: Container(
        height: height,
        padding: EdgeInsets.symmetric(
            vertical: width * 0.04, horizontal: width * 0.04),
        child: Column(
          children: [
            ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                        radius: width * 0.06,
                        backgroundColor: appMainColor,
                        child: Image.asset(
                          Assets.iconMan,
                        )),
                    title: Text(
                      employee[index].employeeName! +
                          "   (${employee[index].shopName})",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(employee[index].phoneNumber!),
                    trailing: InkWell(
                        onTap: () async {
                          var result = await altogic.db
                              .model('users.employee')
                              .object(employee[index].id)
                              .delete()
                              .then((value) => getEmployee());
                        },
                        child: Icon(Icons.delete)),
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: width * 0.04);
                },
                itemCount: employee.length)
          ],
        ),
      ),
    );
  }
}
