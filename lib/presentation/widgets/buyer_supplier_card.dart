import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/extensions/theme_extension.dart';
import '../../core/utils/assets.dart';
import '../view_data/buyer_catalog_view_data.dart';

enum BuyerSupplierCardLayout { compact, detailed }

class BuyerSupplierCard extends StatelessWidget {
  const BuyerSupplierCard({
    super.key,
    required this.supplier,
    this.layout = BuyerSupplierCardLayout.compact,
    this.onTap,
  });

  final BuyerSupplierViewData supplier;
  final BuyerSupplierCardLayout layout;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final detailed = layout == BuyerSupplierCardLayout.detailed;
    return Material(
      color: context.colorTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.colorTheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: detailed ? 126 : 88,
          child: Padding(
            padding: detailed
                ? const EdgeInsets.fromLTRB(14, 14, 14, 9)
                : const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: detailed
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                Container(
                  width: detailed ? 58 : 52,
                  height: detailed ? 58 : 52,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: context.colorTheme.primaryContainer,
                    borderRadius: BorderRadius.circular(detailed ? 16 : 14),
                  ),
                  child: SvgPicture.asset(
                    Assets.buyerHomeSupplierStore,
                    width: 22,
                    height: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: detailed
                      ? _DetailedSupplierCopy(supplier: supplier)
                      : _CompactSupplierCopy(supplier: supplier),
                ),
                const SizedBox(width: 8),
                SvgPicture.asset(
                  Assets.buyerHomeChevron,
                  width: detailed ? 16 : 18,
                  height: detailed ? 16 : 18,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompactSupplierCopy extends StatelessWidget {
  const _CompactSupplierCopy({required this.supplier});
  final BuyerSupplierViewData supplier;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        supplier.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        'Verified supplier',
        style: context.textTheme.labelSmall?.copyWith(
          color: context.ordaraColors.success,
        ),
      ),
      const SizedBox(height: 2),
      Text(
        supplier.serviceArea,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w400,
        ),
      ),
    ],
  );
}

class _DetailedSupplierCopy extends StatelessWidget {
  const _DetailedSupplierCopy({required this.supplier});
  final BuyerSupplierViewData supplier;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Expanded(
            child: Text(
              supplier.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                height: 22 / 16,
              ),
            ),
          ),
          const SizedBox(width: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
            decoration: BoxDecoration(
              color: context.ordaraColors.successContainer,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  Assets.buyerSearchCheck,
                  width: 10,
                  height: 10,
                ),
                const SizedBox(width: 3),
                Text(
                  'Verified',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.ordaraColors.success,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 4),
      _Metadata(asset: Assets.buyerHomeLocation, text: supplier.serviceArea),
      const SizedBox(height: 4),
      _Metadata(asset: Assets.buyerSearchTruck, text: supplier.deliveryDetails),
      const SizedBox(height: 4),
      Text(
        supplier.catalogSummary,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: context.textTheme.labelSmall?.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

class _Metadata extends StatelessWidget {
  const _Metadata({required this.asset, required this.text});
  final String asset;
  final String text;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      SvgPicture.asset(asset, width: 12, height: 12),
      const SizedBox(width: 4),
      Expanded(
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    ],
  );
}
