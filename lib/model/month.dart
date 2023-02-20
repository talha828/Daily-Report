import 'my_reports_model.dart';

class MonthName {
  String name;
  List<MyReportModel> reports;
  double debit;
  double credit;
  double differ;
  MonthName({required this.reports,required this.name,required this.debit,required this.credit,required this.differ});
}