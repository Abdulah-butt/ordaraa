import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/extensions/theme_extension.dart';
import '../../core/utils/assets.dart';

class BuyerDetailAppBar extends StatelessWidget {
  const BuyerDetailAppBar({
    super.key,
    required this.title,
    required this.onBack,
    this.onCart,
  });

  final String title;
  final VoidCallback onBack;
  final VoidCallback? onCart;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            _HeaderButton(
              semanticLabel: 'Back',
              asset: Assets.chevronLeft,
              onTap: onBack,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.titleLarge?.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            if (onCart != null) ...[
              const SizedBox(width: 12),
              _HeaderButton(
                semanticLabel: 'Cart',
                asset: Assets.buyerHomeCart,
                onTap: onCart!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({
    required this.semanticLabel,
    required this.asset,
    required this.onTap,
  });

  final String semanticLabel;
  final String asset;
  final VoidCallback onTap;

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
              child: SvgPicture.asset(asset, width: 18, height: 18),
            ),
          ),
        ),
      ),
    );
  }
}
