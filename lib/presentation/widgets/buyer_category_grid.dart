import 'package:flutter/material.dart';

import '../../core/extensions/theme_extension.dart';
import '../../domain/entities/category.dart';
import 'app_skeleton.dart';
import 'custom_cache_image.dart';

class BuyerCategoryGridSkeletonSliver extends StatelessWidget {
  const BuyerCategoryGridSkeletonSliver({super.key, this.itemCount = 6});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 16,
        childAspectRatio: 171 / 124,
      ),
      delegate: SliverChildBuilderDelegate(
        (_, _) => const AppSkeletonBox(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        childCount: itemCount,
      ),
    );
  }
}

class BuyerCategoryGridSliver extends StatelessWidget {
  const BuyerCategoryGridSliver({
    super.key,
    required this.categories,
    required this.onCategoryTap,
  });

  final List<Category> categories;
  final ValueChanged<Category> onCategoryTap;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 16,
        childAspectRatio: 171 / 124,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) => BuyerCategoryCard(
          category: categories[index],
          onTap: () => onCategoryTap(categories[index]),
        ),
        childCount: categories.length,
      ),
    );
  }
}

class BuyerCategoryCard extends StatelessWidget {
  const BuyerCategoryCard({
    super.key,
    required this.category,
    required this.onTap,
  });

  final Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colorTheme.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: context.colorTheme.outlineVariant),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _CategoryBackground(category: category),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x12000000),
                  Color(0x42000000),
                  Color(0xC2000000),
                ],
                stops: [0, 0.48, 1],
              ),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 12,
            child: Text(
              category.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.left,
              style: context.textTheme.labelLarge?.copyWith(
                color: Colors.white,
                height: 1.2,
                fontWeight: FontWeight.w700,
                shadows: const [
                  Shadow(
                    color: Color(0x66000000),
                    offset: Offset(0, 1),
                    blurRadius: 3,
                  ),
                ],
              ),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(onTap: onTap),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryBackground extends StatelessWidget {
  const _CategoryBackground({required this.category});
  final Category category;

  @override
  Widget build(BuildContext context) {
    final image = category.image;
    final url = image?.thumbnailUrl ?? image?.url;
    if (url == null || url.isEmpty) {
      return ColoredBox(
        color: context.colorTheme.primaryContainer,
        child: Icon(
          Icons.category_outlined,
          size: 38,
          color: context.colorTheme.primary,
        ),
      );
    }
    return CustomCacheImage(
      imgUrl: url,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    );
  }
}
