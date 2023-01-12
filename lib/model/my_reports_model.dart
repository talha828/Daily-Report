class MyReportModel{
  String? id;
  String? parentId;
  String? createAt;
  String? updateAt;
  String? shopName;
  String? shopId;
  String? employeeId;
  String? employeeName;
  String? ownerName;
  String? date;
  List<MyReportItem>? items=[];
  MyReportModel({this.id,this.parentId,this.createAt,this.updateAt, this.shopName, this.shopId, this.employeeName, this.ownerName, this.date, this.items, this.employeeId});

  MyReportModel.fromJson(Map<String,dynamic> json){
   id=json['_id'];
   parentId=json['_parent'];
   createAt=json['createdAt'];
   updateAt=json['updatedAt'];
   shopName=json['shopName'];
   shopId=json['shopId'];
   employeeId=json['employeeId'];
   employeeName=json['employeeName'];
   ownerName=json['ownerName'];
   date=json['date'];
   if(json['report'] != null){
     json['report'].forEach((value){
       items!.add(MyReportItem(id: value["_id"], parent: value['_parent'], productName: value['myproduct'], credit: value['mycredit'], debit: value['mydebit'], differ: value['mydiffer']));
     });}
  }

}


class MyReportItem{
  String? id;
  String? parent;
  List? productName;
  List? credit;
  List? debit;
  List? differ;
  MyReportItem({required this.id,required this.parent,required this.productName,required this.credit,required this.debit,required this.differ});
}