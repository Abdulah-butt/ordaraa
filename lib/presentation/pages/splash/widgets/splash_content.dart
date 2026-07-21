import 'package:flutter/widgets.dart';

import '../../../../core/extensions/theme_extension.dart';
import 'splash_brand.dart';
import 'splash_loading_indicator.dart';

class SplashContent extends StatelessWidget {
  const SplashContent({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        double top(double designY) => height * designY / 844;

        return Stack(
          alignment: Alignment.topCenter,
          children: [
            Positioned(top: top(284), child: const SplashBrand()),
            Positioned(
              top: top(418),
              left: 16,
              right: 16,
              child: Text(
                'Wholesale ordering made simple.',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyLarge?.copyWith(
                  fontSize: 18,
                  height: 22 / 18,
                  color: context.colorTheme.onSurfaceVariant,
                ),
              ),
            ),
            Positioned(
              top: top(458),
              left: 24,
              right: 24,
              child: Text(
                'Order from trusted suppliers across Australia.',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  fontSize: 13,
                  height: 22 / 13,
                ),
              ),
            ),
            Positioned(
              top: top(720),
              left: 16,
              right: 16,
              child: Text(
                'Preparing your marketplace',
                textAlign: TextAlign.center,
                style: context.textTheme.bodySmall?.copyWith(
                  height: 22 / 12,
                  color: context.colorTheme.onSurfaceVariant,
                ),
              ),
            ),
            Positioned(top: top(752), child: const SplashLoadingIndicator()),
          ],
        );
      },
    );
  }
}
