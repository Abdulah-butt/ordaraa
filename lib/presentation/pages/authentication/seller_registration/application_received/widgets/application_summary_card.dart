import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../../core/extensions/theme_extension.dart';
import '../../../../../../core/utils/assets.dart';

class ApplicationSummaryCard extends StatelessWidget {
  const ApplicationSummaryCard({
    super.key,
    required this.businessName,
    required this.abn,
    required this.phoneNumber,
  });

  final String businessName;
  final String abn;
  final String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 176,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: context.colorTheme.surfaceContainerLow,
        border: Border.all(color: context.colorTheme.outline),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(Assets.roleSeller, width: 24, height: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(businessName, style: context.textTheme.titleMedium),
                    Text('ABN $abn', style: context.textTheme.bodySmall),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: context.colorTheme.outline),
          const SizedBox(height: 12),
          _SummaryRow(label: 'WhatsApp', value: phoneNumber),
          const SizedBox(height: 14),
          const _SummaryRow(label: 'Submitted', value: '19 July 2026'),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: context.textTheme.bodySmall),
        const Spacer(),
        Text(
          value,
          style: context.textTheme.labelMedium?.copyWith(
            color: context.colorTheme.onSurface,
          ),
        ),
      ],
    );
  }
}
