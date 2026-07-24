import 'package:flutter/material.dart';

import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/theme/app_colors.dart';

class BuyerAccountProfileCard extends StatelessWidget {
  const BuyerAccountProfileCard({
    super.key,
    required this.businessName,
    required this.initials,
    required this.businessSubtitle,
    required this.verified,
  });

  final String businessName;
  final String initials;
  final String businessSubtitle;
  final bool verified;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:context.colorTheme.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 52,
            height: 52,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: context.isDarkMode
                  ? context.colorTheme.primary
                  : AppColors.brand600,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              initials,
              style: context.textTheme.titleMedium?.copyWith(
                color: context.colorTheme.onPrimary,
                fontWeight: FontWeight.w700,
                height: 23 / 16,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    businessName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontSize: 15,
                      height: 22 / 15,
                      fontWeight: FontWeight.w700,
                      color: context.colorTheme.onPrimary
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    businessSubtitle,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorTheme.onPrimary,
                      height: 18 / 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (verified) ...[
            const SizedBox(width: 8),
            Tooltip(
              message: 'Verified organization',
              child: Icon(
                Icons.verified_rounded,
                size: 22,
                color: context.colorTheme.primary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
