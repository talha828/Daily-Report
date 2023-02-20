
import 'package:daily_report/model/salesmanModel.dart';
import 'package:flutter/material.dart';

class DailyReportDropDown extends StatelessWidget {
  const DailyReportDropDown({
    Key? key,
    required this.width,
    required this.dropdownvalue,
    required this.items,
    required this.ontap,
  }) : super(key: key);

  final double width;
  final SalesmanModel dropdownvalue;
  final List<SalesmanModel> items;
  final Null Function(SalesmanModel? val) ontap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: width * 0.05),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
          borderRadius: BorderRadius.circular(7)),
      child: DropdownButtonHideUnderline(
        child: IgnorePointer(
          ignoring: true,
          child: DropdownButton<SalesmanModel>(

            disabledHint: Text("Loading"),
            isExpanded: true,
            value: dropdownvalue,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: items.map((SalesmanModel items) {
              return DropdownMenuItem(
                value: items,
                child: Text(items.salesmanName),
              );
            }).toList(),
            onChanged: ontap,
          ),
        ),
      ),
    );
  }
}
