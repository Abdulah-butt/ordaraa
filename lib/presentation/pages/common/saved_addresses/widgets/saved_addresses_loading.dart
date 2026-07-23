import 'package:flutter/material.dart';

import '../../../../widgets/app_skeleton.dart';

class SavedAddressesLoading extends StatelessWidget {
  const SavedAddressesLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AppSkeletonBox(height: 142),
        SizedBox(height: 12),
        AppSkeletonBox(height: 142),
        SizedBox(height: 12),
        AppSkeletonBox(height: 142),
      ],
    );
  }
}
