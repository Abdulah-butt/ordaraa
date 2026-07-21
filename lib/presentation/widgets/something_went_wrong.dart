import 'package:flutter/material.dart';

class SomethingWentWrong extends StatelessWidget {
  const SomethingWentWrong({super.key});

  @override
  Widget build(BuildContext context) {
    return const Material(
      child: Center(child: Text("Something went wrong"),),
    );
  }
}
