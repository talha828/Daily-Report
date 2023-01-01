import 'package:daily_report/model/my_reports_model.dart';
import 'package:get/get.dart';

class ItemController extends GetxController{
  Rx<MyReportModel>items=MyReportModel().obs;
}