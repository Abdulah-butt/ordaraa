import 'dart:math';
import 'package:flutter/material.dart';

import '../../core/extensions/theme_extension.dart';

Future<T?> showAnchoredDropdown<T>(
  BuildContext context, {
  required BuildContext anchorContext,
  required List<T> items,
  required T? selected,
  required String Function(T) itemLabelBuilder,
  Widget Function(T option)? leadingBuilder,
  bool Function(T option, T? selected)? isSelected,
  double minWidth = 220,
  double extraWidth = 0,
  double maxHeight = 360,
  bool matchAnchorWidth = true,
}) async {
  final overlay = Overlay.of(context).context.findRenderObject() as RenderBox?;
  final anchorBox = anchorContext.findRenderObject() as RenderBox?;
  if (overlay == null || anchorBox == null) {
    return null;
  }

  final anchorTopLeft = anchorBox.localToGlobal(Offset.zero, ancestor: overlay);
  final anchorBottomLeft = anchorBox.localToGlobal(
    Offset(0, anchorBox.size.height),
    ancestor: overlay,
  );

  final screenWidth = overlay.size.width;
  final screenHeight = overlay.size.height;
  final maxWidth = screenWidth - 32;
  final anchorWidth = anchorBox.size.width;
  final computedWidth = matchAnchorWidth
      ? anchorWidth
      : (anchorWidth + extraWidth).clamp(minWidth, maxWidth);
  final desiredHeight = min(maxHeight, 16 + items.length * 52.0);
  final spaceBelow = screenHeight - anchorBottomLeft.dy - 16;
  final spaceAbove = anchorTopLeft.dy - 16;
  final showAbove = spaceBelow < 160 && spaceAbove > spaceBelow;
  final panelHeight = min(desiredHeight, showAbove ? spaceAbove : spaceBelow);

  double left = anchorTopLeft.dx;
  if (left + computedWidth > screenWidth - 16) {
    left = screenWidth - computedWidth - 16;
  }
  if (left < 16) {
    left = 16;
  }

  final top = showAbove
      ? (anchorTopLeft.dy - panelHeight - 8)
      : anchorBottomLeft.dy + 8;

  final value = await showGeneralDialog<T>(
    context: context,
    barrierLabel: 'dropdown',
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.05),
    transitionDuration: const Duration(milliseconds: 150),
    pageBuilder: (context, _, __) {
      return Stack(
        children: [
          Positioned(
            left: left,
            top: top,
            width: computedWidth,
            child: _DropdownPanel<T>(
              items: items,
              selected: selected,
              itemLabelBuilder: itemLabelBuilder,
              leadingBuilder: leadingBuilder,
              isSelected: isSelected,
              maxHeight: panelHeight,
            ),
          ),
        ],
      );
    },
    transitionBuilder: (context, animation, _, child) {
      final curve = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return FadeTransition(
        opacity: curve,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.98, end: 1).animate(curve),
          child: child,
        ),
      );
    },
  );

  return value;
}

class _DropdownPanel<T> extends StatelessWidget {
  final List<T> items;
  final T? selected;
  final String Function(T) itemLabelBuilder;
  final Widget Function(T option)? leadingBuilder;
  final bool Function(T option, T? selected)? isSelected;
  final double maxHeight;

  const _DropdownPanel({
    required this.items,
    required this.selected,
    required this.itemLabelBuilder,
    required this.maxHeight,
    this.leadingBuilder,
    this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorTheme;
    return Material(
      color: colorScheme.surface,
      elevation: 6,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            shrinkWrap: true,
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 4),
            itemBuilder: (context, index) {
              final option = items[index];
              final selectedCheck =
                  isSelected?.call(option, selected) ?? option == selected;
              final leading = leadingBuilder?.call(option);
              return _DropdownOptionTile(
                label: itemLabelBuilder(option),
                isSelected: selectedCheck,
                leading: leading,
                onTap: () => Navigator.of(context).pop(option),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DropdownOptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Widget? leading;
  final VoidCallback onTap;

  const _DropdownOptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorTheme;
    final textTheme = context.textTheme;
    final selectedColor = colorScheme.secondaryContainer;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: isSelected
                  ? Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: colorScheme.onSecondaryContainer,
                    )
                  : const SizedBox.shrink(),
            ),
            if (leading != null) ...[const SizedBox(width: 8), leading!],
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected
                      ? colorScheme.onSecondaryContainer
                      : colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
