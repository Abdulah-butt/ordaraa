import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../domain/entities/category.dart';
import '../../../../widgets/app_skeleton.dart';
import '../../../../widgets/custom_cache_image.dart';

class BuyerCategoryShortcuts extends StatelessWidget {
  const BuyerCategoryShortcuts({
    super.key,
    required this.categories,
    required this.loading,
    required this.onViewAll,
    this.onSelected,
  });

  final List<Category> categories;
  final bool loading;
  final VoidCallback onViewAll;
  final ValueChanged<Category>? onSelected;

  @override
  Widget build(BuildContext context) {
    if (loading && categories.isEmpty) {
      return const AppSkeleton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Bone.square(
              size: 72,
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            Bone.square(
              size: 72,
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            Bone.square(
              size: 72,
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
            Bone.square(
              size: 72,
              borderRadius: BorderRadius.all(Radius.circular(14)),
            ),
          ],
        ),
      );
    }
    return SizedBox(
      height: 72,
      child: Row(
        children: [
          for (final category in categories.take(3)) ...[
            Expanded(
              child: _CategoryShortcut(
                category: category,
                onTap: onSelected == null ? null : () => onSelected!(category),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(child: _ViewAllShortcut(onTap: onViewAll)),
        ],
      ),
    );
  }
}

class _CategoryShortcut extends StatelessWidget {
  const _CategoryShortcut({required this.category, this.onTap});

  final Category category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final selected = category.slug == 'all-products';
    final selectedBackground = context.isDarkMode
        ? context.colorTheme.primaryContainer
        : const Color(0xFFE7F3FC);
    final selectedBorder = context.isDarkMode
        ? context.colorTheme.primary
        : const Color(0xFFB8D9F2);

    return Material(
      color: selected
          ? selectedBackground
          : context.colorTheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(
          color: selected ? selectedBorder : context.colorTheme.outlineVariant,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: double.infinity,
          height: 72,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 4,
            children: [
              Container(
                width: 34,
                height: 40,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.brand100
                      : context.colorTheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: _CategoryImage(category: category),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  selected ? 'All' : category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colorTheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ViewAllShortcut extends StatelessWidget {
  const _ViewAllShortcut({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final background = context.isDarkMode
        ? context.colorTheme.primaryContainer
        : const Color(0xFFE7F3FC);
    final border = context.isDarkMode
        ? context.colorTheme.primary
        : const Color(0xFFB8D9F2);

    return Material(
      color: background,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: double.infinity,
          height: 72,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: const BoxDecoration(
                  color: AppColors.brand100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.grid_view_rounded,
                  size: 18,
                  color: context.colorTheme.primary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'View all',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.textTheme.labelSmall?.copyWith(
                  color: context.colorTheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CategoryImage extends StatelessWidget {
  const _CategoryImage({required this.category});

  final Category category;

  @override
  Widget build(BuildContext context) {
    final image = category.image;
    final imageUrl = image?.thumbnailUrl ?? image?.url;
    if (imageUrl == null || imageUrl.isEmpty) {
      return Icon(
        Icons.category_outlined,
        size: 20,
        color: context.colorTheme.primary,
      );
    }
    return CustomCacheImage(
      imgUrl: imageUrl,
      width: 34,
      height: 34,
      fit: BoxFit.cover,
    );
  }
}
