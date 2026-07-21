import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/assets.dart';

class AuthWhatsAppNotice extends StatelessWidget {
  const AuthWhatsAppNotice({
    super.key,
    required this.title,
    required this.description,
    this.height = 84,
  });

  final String title;
  final String description;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.ordaraColors.supplierContainer.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.colorTheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgPicture.asset(Assets.message, width: 22, height: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textTheme.labelLarge?.copyWith(
                    color: context.ordaraColors.success,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
