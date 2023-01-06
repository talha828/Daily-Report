
import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(child: Container(
      color: Colors.white54,
      child: Center(child: CircularProgressIndicator()),));
  }
}
