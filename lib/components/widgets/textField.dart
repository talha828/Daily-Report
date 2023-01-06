import 'package:flutter/material.dart';

import '../constant/contant.dart';

class DailyReportTextField extends StatelessWidget {
  const DailyReportTextField({
    Key? key,
    required TextEditingController controller,
    required this.hintText,
  })  : _controller = controller,
        super(key: key);

  final TextEditingController _controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
              borderSide: new BorderSide(color: appMainColor)),
          disabledBorder: UnderlineInputBorder(
              borderSide: new BorderSide(color: appMainColor)),
          border: UnderlineInputBorder(
              borderSide: new BorderSide(color: appMainColor)),
          hintText: hintText),
    );
  }
}
