class SalesmanReportModel {
  int timestamp;
  String credit;
  String debit;
  String remaining;
  String date;
  String id;
  SalesmanReportModel(
      {required this.timestamp,
      required this.debit,
      required this.id,
      required this.remaining,
      required this.credit,
      required this.date});
}
