import 'package:daily_report/components/constant/contant.dart';
import 'package:daily_report/main.dart';
import 'package:daily_report/model/salesmanReportModel.dart';
import 'package:daily_report/view/employee_view/salesman_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ViewSalesmanReportScreen extends StatefulWidget {
  final String id;
  final String salesmanName;
  const ViewSalesmanReportScreen({required this.id,required this.salesmanName,Key? key}) : super(key: key);

  @override
  State<ViewSalesmanReportScreen> createState() => _ViewSalesmanReportScreenState();
}

class _ViewSalesmanReportScreenState extends State<ViewSalesmanReportScreen> {
  List<SalesmanReportModel>list=[];

  getData()async{
    altogic.db.model("users.salesman.report").filter('_parent == "${widget.id}"').get().then((value){
      if(value.errors == null){
        value.data.forEach((i){
          list.add(SalesmanReportModel(timestamp:i['timestamp'] , debit: i['debit'], id: i['_id'], remaining: i['remaining'], credit: i["credit"], date: i['date']));
          setState(() {});
        });
      }else{
        Fluttertoast.showToast(msg: "Error: "+value.errors!.statusText);
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
    var width=MediaQuery.of(context).size.width;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: appMainColor,
        child:Icon(Icons.add) ,onPressed: ()async{
        if(list.isNotEmpty){
            Get.to(SalesmanScreen(
              salesman: widget.salesmanName,
              remaining: list.last.remaining,
            ));
          }else{
          Get.to(SalesmanScreen(
            salesman: widget.salesmanName,
            remaining:"0",
          ));
        }
        },),
     appBar: AppBar(
       title: Text(widget.salesmanName),
     ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DataTable(
            // checkboxHorizontalMargin: 2,
            columnSpacing: width * 0.05,
            showBottomBorder: true,
            columns: [
              DataColumn(
                label: Text('Date'),
              ),
              DataColumn(
                label: Text('Debit'),
              ),
              DataColumn(
                label: Text('Credit'),
              ),
              DataColumn(
                label: Text('Remaining'),
              ),
            ],
            rows: list
                .map((element) =>
                DataRow(cells: [
                  DataCell(Text(element.date,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  )),
                  DataCell(Text(element.debit.toString())),
                  DataCell(Text(element.credit.toString())),
                  DataCell(Text(element.remaining.toString())),
                ]))
                .toList(),
          )
        ],
      ),
    );
  }
}
