import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/utils/assets.dart';

class BuyerHomeAppBar extends StatelessWidget {
  const BuyerHomeAppBar({
    super.key,
    required this.deliveryLocation,
    this.onLocationTap,
    this.onNotificationsTap,
    this.onCartTap,
  });

  final String deliveryLocation;
  final VoidCallback? onLocationTap;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onCartTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onLocationTap,
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      Assets.buyerHomeLocation,
                      width: 22,
                      height: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Deliver to',
                            style: context.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            deliveryLocation,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.titleLarge?.copyWith(
                              fontSize: 18,
                              height: 22 / 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            _HomeIconButton(
              asset: Assets.buyerHomeBell,
              semanticLabel: 'Notifications',
              onTap: onNotificationsTap,
            ),
            const SizedBox(width: 10),
            _HomeIconButton(
              asset: Assets.buyerHomeCart,
              semanticLabel: 'Cart',
              onTap: onCartTap,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeIconButton extends StatelessWidget {
  const _HomeIconButton({
    required this.asset,
    required this.semanticLabel,
    this.onTap,
  });

  final String asset;
  final String semanticLabel;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      button: true,
      child: Material(
        color: context.colorTheme.surfaceContainerLow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: context.colorTheme.outlineVariant),
        ),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: SizedBox.square(
            dimension: 40,
            child: Center(
              child: SvgPicture.asset(asset, width: 20, height: 20),
            ),
          ),
        ),
      ),
    );
  }
}
