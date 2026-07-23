import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../core/extensions/theme_extension.dart';

class AppSkeleton extends StatelessWidget {
  const AppSkeleton({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Skeletonizer.zone(
        effect: SolidColorEffect(
          color: context.colorTheme.onSurface.withValues(alpha: 0.09),
        ),
        enableSwitchAnimation: false,
        child: ExcludeSemantics(child: child),
      ),
    );
  }
}

class AppSkeletonBox extends StatelessWidget {
  const AppSkeletonBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  final double? width;
  final double? height;
  final BorderRadiusGeometry borderRadius;

  @override
  Widget build(BuildContext context) {
    return AppSkeleton(
      child: Bone(width: width, height: height, borderRadius: borderRadius),
    );
  }
}

class ProductCardSkeleton extends StatelessWidget {
  const ProductCardSkeleton({super.key, this.detailed = false});

  final bool detailed;

  @override
  Widget build(BuildContext context) {
    return detailed
        ? const _DetailedProductSkeleton()
        : const _ProductSkeleton();
  }
}

class SupplierCardSkeleton extends StatelessWidget {
  const SupplierCardSkeleton({super.key, this.detailed = false});

  final bool detailed;

  @override
  Widget build(BuildContext context) {
    return _SkeletonCard(
      width: double.infinity,
      height: detailed ? 126 : 88,
      child: Row(
        children: [
          Bone.square(size: detailed ? 58 : 52, uniRadius: detailed ? 16 : 14),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Bone(width: 150, height: 15, uniRadius: 5),
                const SizedBox(height: 8),
                const Bone(width: 92, height: 11, uniRadius: 4),
                const SizedBox(height: 7),
                Bone(width: detailed ? 190 : 145, height: 10, uniRadius: 4),
                if (detailed) ...[
                  const SizedBox(height: 7),
                  const Bone(width: 130, height: 10, uniRadius: 4),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductSkeleton extends StatelessWidget {
  const _ProductSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      width: 171,
      height: 252,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone(width: 151, height: 88, uniRadius: 12),
          SizedBox(height: 9),
          Bone(width: 64, height: 20, uniRadius: 10),
          SizedBox(height: 9),
          Bone(width: 132, height: 14, uniRadius: 5),
          SizedBox(height: 7),
          Bone(width: 108, height: 14, uniRadius: 5),
          Spacer(),
          Bone(width: 124, height: 10, uniRadius: 4),
          SizedBox(height: 7),
          Bone(width: 94, height: 10, uniRadius: 4),
          SizedBox(height: 9),
          Bone(width: 142, height: 16, uniRadius: 5),
        ],
      ),
    );
  }
}

class _DetailedProductSkeleton extends StatelessWidget {
  const _DetailedProductSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _SkeletonCard(
      width: double.infinity,
      height: 140,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Bone(width: 112, height: 120, uniRadius: 12),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Bone(width: 68, height: 20, uniRadius: 10),
                SizedBox(height: 8),
                Bone(width: 150, height: 15, uniRadius: 5),
                SizedBox(height: 8),
                Bone(width: 125, height: 11, uniRadius: 4),
                SizedBox(height: 8),
                Bone(width: 105, height: 11, uniRadius: 4),
                Spacer(),
                Bone(width: 145, height: 17, uniRadius: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  const _SkeletonCard({
    required this.width,
    required this.height,
    required this.child,
  });

  final double width;
  final double height;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: context.colorTheme.surface,
        border: Border.all(color: context.colorTheme.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}
