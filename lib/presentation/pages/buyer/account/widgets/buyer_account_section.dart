import 'package:flutter/material.dart';

import '../../../../../core/extensions/theme_extension.dart';

class BuyerAccountItem {
  const BuyerAccountItem({
    required this.label,
    this.enabled = true,
    this.destructive = false,
    this.onTap,
  });

  final String label;
  final bool enabled;
  final bool destructive;
  final VoidCallback? onTap;
}

class BuyerAccountSection extends StatelessWidget {
  const BuyerAccountSection({
    super.key,
    required this.title,
    required this.items,
  });

  final String title;
  final List<BuyerAccountItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.labelSmall?.copyWith(
            color: context.colorTheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            height: 18 / 11,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: context.colorTheme.surface,
            border: Border.all(color: context.colorTheme.outlineVariant),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              for (var index = 0; index < items.length; index++) ...[
                _AccountMenuRow(item: items[index]),
                if (index != items.length - 1)
                  Divider(
                    height: 1,
                    indent: 14,
                    endIndent: 14,
                    color: context.colorTheme.outlineVariant,
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _AccountMenuRow extends StatelessWidget {
  const _AccountMenuRow({required this.item});

  final BuyerAccountItem item;

  @override
  Widget build(BuildContext context) {
    final color = !item.enabled
        ? context.ordaraColors.textDisabled
        : item.destructive
        ? context.colorTheme.error
        : context.colorTheme.onSurface;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: item.enabled ? item.onTap : null,
        child: SizedBox(
          height: 47,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    item.label,
                    style: context.textTheme.labelMedium?.copyWith(
                      color: color,
                      height: 19 / 12,
                    ),
                  ),
                ),
                if (!item.destructive)
                  Text(
                    '›',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.ordaraColors.textDisabled,
                      fontWeight: FontWeight.w700,
                      height: 23 / 16,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
