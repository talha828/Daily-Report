import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:daily_report/components/widgets/textField.dart';
import 'package:daily_report/main.dart';
import 'package:daily_report/view/employee_view/add_salesman_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../components/constant/contant.dart';
import '../../components/widgets/dailyDropDown.dart';
import '../../components/widgets/loadingIndicator.dart';
import '../../getx_controller/user_model.dart';
import '../../model/salesmanModel.dart';

class SalesmanScreen extends StatefulWidget {
  const SalesmanScreen({Key? key}) : super(key: key);

  @override
  State<SalesmanScreen> createState() => _SalesmanScreenState();
}

class _SalesmanScreenState extends State<SalesmanScreen> {

  double creditValue=0;
  double debitValue=0;
  // double dd=creditValue -debitValue;

  TextEditingController date = TextEditingController();
  TextEditingController debit = TextEditingController();
  TextEditingController credit = TextEditingController();
  TextEditingController remaining = TextEditingController();

  late SalesmanModel dropdownvalue;

  var items = [
    'Select salesman',
  ];
  final userData = Get.find<UserModel>();
  List<SalesmanModel> salesman = [
    SalesmanModel(
        ownerName: "",
        employeeName: "",
        salesmanName: "Select Salesman",
        product: "",
        shopId: "",
        about: "",
        id: "")
  ];

  getSalesman() async {
    var data = altogic.db
        .model("users.salesman")
        .filter('_parent == "${userData.id.value}"')
        .get()
        .then((value) {
      if (value.errors == null) {
        salesman.clear();
        salesman.add( SalesmanModel(
            ownerName: "",
            employeeName: "",
            salesmanName: "Select Salesman",
            product: "",
            shopId: "",
            about: "",
            id: ""));
        dropdownvalue = salesman[0];
        setState(() {});
        value.data.forEach((i) {
          salesman.add(SalesmanModel(
              ownerName: i['owner_name'],
              employeeName: i['employee_name'],
              salesmanName: i["salesman_name"],
              product: i['product'],
              shopId: i['shopId'],
              about: i["about"],
              id: i["_id"]));
          setState(() {});
        });
      } else {
        Fluttertoast.showToast(msg: value.errors!.statusText);
      }
    });
  }

  bool isLoading = false;
  setLoading(bool value) => setState(() => isLoading = value);
  onChange(SalesmanModel val) => setState(() => dropdownvalue = val);

  @override
  void initState() {
    getSalesman();
    dropdownvalue = salesman[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => Get.back(), icon: Icon(Icons.arrow_back)),
        title: Text("Salesman"),
        actions: [
          InkWell(
            onTap: () => getSalesman(),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.refresh),
            ),
          ),
          InkWell(
            onTap: () => Get.to(CreateSalsemanScreen()),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: width * 0.04, horizontal: width * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Salesman Name",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: width * 0.06, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: width * 0.02,
                  ),
                  DailyReportDropDown(
                    width: width,
                    dropdownvalue: dropdownvalue,
                    items: salesman,
                    ontap: (SalesmanModel? newValue) => onChange(newValue!),
                  ),
                  SizedBox(
                    height: width * 0.04,
                  ),
                  Text(
                    "Date",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: width * 0.06, fontWeight: FontWeight.bold),
                  ),
                  DailyReportTextField(
                      controller: date,
                      enable: false,
                      hintText: DateFormat('dd-MM-yyyy')
                          .format(DateTime.now())
                          .toString()),
                  SizedBox(
                    height: width * 0.04,
                  ),
                  Text(
                    "Debit",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: width * 0.06, fontWeight: FontWeight.bold),
                  ),
                  //DailyReportTextField(controller: debit, hintText: "Ex. 5000"),
      TextField(
        keyboardType: TextInputType.number,
        controller: debit,
        onChanged: (value){
          setState(() {
            debitValue=double.parse(value);
          });
        },
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: new BorderSide(color: appMainColor)),
            disabledBorder: UnderlineInputBorder(
                borderSide: new BorderSide(color: appMainColor)),
            border: UnderlineInputBorder(
                borderSide: new BorderSide(color: appMainColor)),
            hintText: "Ex. 5000"),
      ),
                  SizedBox(
                    height: width * 0.04,
                  ),
                  Text(
                    "Credit",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: width * 0.06, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: credit,
                    onChanged: (value){
                      setState(() {
                        creditValue=double.parse(value);
                      });
                    },
                    decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: appMainColor)),
                        disabledBorder: UnderlineInputBorder(
                            borderSide: new BorderSide(color: appMainColor)),
                        border: UnderlineInputBorder(
                            borderSide: new BorderSide(color: appMainColor)),
                        hintText: "Ex. 3000"),
                  ),
                  // DailyReportTextField(
                  //     controller: credit, hintText: "Ex. 3000"),
                  SizedBox(
                    height: width * 0.04,
                  ),
                  Text(
                    "Remaining ",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: width * 0.06, fontWeight: FontWeight.bold),
                  ),
                  DailyReportTextField(
                    enable: false,
                      controller: TextEditingController(text: (debitValue - creditValue).toString()), hintText: "Ex. 2000"),
                  SizedBox(
                    height: width * 0.08,
                  ),
                  Container(
                    //color: Colors.white,
                    padding: EdgeInsets.symmetric(
                        horizontal: width * 0.04, vertical: width * 0.04),
                    child: ElevatedButton(
                      onPressed: () {
                        if (dropdownvalue.salesmanName != "Select Salesman") {
                          if (debit.text.isNotEmpty) {
                            if (credit.text.isNotEmpty) {
                              // if (remaining.text.isNotEmpty) {
                                altogic.db.model("users.salesman.report").append({
                                  "timestamp":
                                      DateTime.now().millisecondsSinceEpoch,
                                  "credit": credit.text,
                                  "debit": debit.text,
                                  "remaining": (debitValue - creditValue).toString(),
                                  "date": DateFormat('dd-MM-yyyy')
                                      .format(
                                        DateTime.now(),
                                      )
                                      .toString(),
                                }, dropdownvalue.id).then(
                                  (value) {
                                    if (value.errors == null) {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.info,
                                        animType: AnimType.rightSlide,
                                        title: 'Congratulation',
                                        desc: 'Your data successfully save',
                                        btnOkColor: appMainColor,
                                        btnOkOnPress: () {
                                          Navigator.of(context)..pop();
                                        },
                                      )..show();
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Error: " +
                                              value.errors!.statusText);
                                    }
                                  },
                                );
                              // } else {
                              //   Fluttertoast.showToast(
                              //       msg: "Your remaining is empty");
                              // }
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Your credit is empty");
                            }
                          } else {
                            Fluttertoast.showToast(msg: "Your Debit is empty");
                          }
                        }
                      },
                      child: Text("Save"),
                    ),
                  ),
                ],
              ),
            ),
          ),
          isLoading ? LoadingIndicator() : Container()
        ],
      ),
    );
  }
}
