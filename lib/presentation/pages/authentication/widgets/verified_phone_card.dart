import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/utils/assets.dart';

class VerifiedPhoneCard extends StatelessWidget {
  const VerifiedPhoneCard({
    super.key,
    required this.phoneNumber,
    required this.description,
    this.height = 70,
  });

  final String phoneNumber;
  final String description;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.ordaraColors.supplierContainer.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.colorTheme.surface,
              shape: BoxShape.circle,
            ),
            child: SvgPicture.asset(Assets.check, width: 18, height: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(phoneNumber, style: context.textTheme.labelLarge),
                const SizedBox(height: 1),
                Text(
                  description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: context.ordaraColors.success,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
