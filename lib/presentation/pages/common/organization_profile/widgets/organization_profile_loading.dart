import 'package:flutter/material.dart';

import '../../../../widgets/app_skeleton.dart';

class OrganizationProfileLoading extends StatelessWidget {
  const OrganizationProfileLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        AppSkeletonBox(height: 82),
        SizedBox(height: 16),
        AppSkeletonBox(height: 190),
        SizedBox(height: 16),
        AppSkeletonBox(height: 250),
        SizedBox(height: 16),
        AppSkeletonBox(height: 190),
        SizedBox(height: 16),
        AppSkeletonBox(height: 130),
      ],
    );
  }
}
