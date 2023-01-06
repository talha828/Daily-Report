import 'package:daily_report/components/constant/contant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../getx_controller/report_view_controller.dart';
import '../../model/controllerModel.dart';
import '../../model/reportModel.dart';
import 'ViewReportScreen.dart';

class NewReportScreen extends StatefulWidget {
  const NewReportScreen({Key? key}) : super(key: key);

  @override
  State<NewReportScreen> createState() => _NewReportScreenState();
}

class _NewReportScreenState extends State<NewReportScreen> {
  final controller = Get.put(ReportViewController());
  TextEditingController title = TextEditingController();
  TextEditingController credit = TextEditingController();
  TextEditingController debit = TextEditingController();

  List<ControllerModel> controllers = [];
  List<Widget> widgetList = [];
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.04, vertical: width * 0.04),
        child: ElevatedButton(
          onPressed: () async {
            controller.controller.clear();
            double creditTotal = 00.0;
            double debitTotal = 00.0;
            double rammingTotal = 00.0;
            controllers.forEach((element) {
              controller.controller.add(ReportModel(
                  product: element.product!.text.toString(),
                  credit: element.credit!.text.toString(),
                  debit: element.debit!.text.toString(),
                  ramming: (int.parse(element.credit!.text.toString()) -
                          int.parse(element.debit!.text.toString()))
                      .toString()));
              creditTotal =
                  creditTotal + double.parse(element.credit!.text.toString());
              debitTotal =
                  debitTotal + double.parse(element.debit!.text.toString());
              rammingTotal = rammingTotal +
                  double.parse((int.parse(element.credit!.text.toString()) -
                          int.parse(element.debit!.text.toString()))
                      .toString());
            });
            controller.controller.add(ReportModel(
                product: "Total",
                credit: creditTotal.toStringAsFixed(0),
                debit: debitTotal.toStringAsFixed(0),
                ramming: rammingTotal.toStringAsFixed(0)));
            Get.to(ViewReportScreen());
          },
          child: Text("View Report"),
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "1",
            onPressed: () {
              setState(() {
                widgetList.removeLast();
                controllers.removeLast();
              });
            },
            child: Icon(Icons.remove),
            backgroundColor: Colors.red,
          ),
          SizedBox(
            height: width * 0.04,
          ),
          FloatingActionButton(
            heroTag: "2",
            onPressed: () {
              controllers.add(ControllerModel(
                product: TextEditingController(),
                credit: TextEditingController(),
                debit: TextEditingController(),
              ));

              widgetList.add(
                ReporterTextField(
                  width: width,
                  title: controllers.last.product!,
                  credit: controllers.last.credit!,
                  debit: controllers.last.debit!,
                ),
              );
              setState(() {});
            },
            child: Icon(Icons.add),
            backgroundColor: Colors.green,
          ),
        ],
      ),
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios)),
        title: Text("New Report"),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: width * 0.04, vertical: width * 0.04),
          child: Column(
            children: [
              ListView.separated(
                physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return widgetList[index];
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(
                      height: width * 0.04,
                    );
                  },
                  itemCount: widgetList.length),
              SizedBox(
                height: width * 0.04,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ReporterTextField extends StatefulWidget {
  const ReporterTextField({
    Key? key,
    required this.width,
    required this.title,
    required this.credit,
    required this.debit,
  }) : super(key: key);

  final double width;
  final TextEditingController title;
  final TextEditingController credit;
  final TextEditingController debit;

  @override
  State<ReporterTextField> createState() => _ReporterTextFieldState();
}

class _ReporterTextFieldState extends State<ReporterTextField> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: widget.width * 0.3,
          child: TextField(
            //style: TextStyle(fontSize: widget.width * 0.035),
            controller: widget.title,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: widget.width * 0.03,
                  vertical: widget.width * 0.01),
              labelText: "Product",
            ),
          ),
        ),
        Container(
          width: widget.width * 0.235,
          child: TextField(
            //style: TextStyle(fontSize: widget.width * 0.035),
            controller: widget.credit,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: widget.width * 0.03,
                  vertical: widget.width * 0.01),
              labelText: "Credit",
            ),
          ),
        ),
        Container(
          width: widget.width * 0.235,
          child: TextField(
            //style: TextStyle(fontSize: widget.width * 0.035),
            controller: widget.debit,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(
                  horizontal: widget.width * 0.03,
                  vertical: widget.width * 0.01),
              labelText: "Debit",
            ),
          ),
        ),
      ],
    );
  }
}
