import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  final Color? color;

  const CustomLoader({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      width: 25,
      child: CircularProgressIndicator(strokeWidth: 2, backgroundColor: color),
    );
  }
}
