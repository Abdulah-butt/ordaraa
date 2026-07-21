import 'package:flutter/material.dart';
import '../../../core/extensions/theme_extension.dart';
import '../../../core/utils/constants.dart';
import '../../core/utils/style.dart';
import 'anchored_dropdown.dart';

class CustomDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String hintText;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemLabelBuilder;
  final bool disable;
  final Color? fillColor;
  final double borderRadius;
  final double? width;
  final double? height;
  final Widget Function(T option)? leadingBuilder;
  final Widget Function(T option)? selectedLeadingBuilder;
  final bool Function(T option, T? selected)? isSelected;
  final bool matchAnchorWidth;
  final double? extraWidth;
  final double? minWidth;
  final String label;
  final TextStyle? labelStyle;
  final double labelSpacing;
  final double bottomPadding;
  final Color? borderColor;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    required this.itemLabelBuilder,
    this.hintText = "Please select",
    this.disable = false,
    this.fillColor,
    this.borderRadius = 8.0,
    this.width,
    this.height,
    this.leadingBuilder,
    this.selectedLeadingBuilder,
    this.isSelected,
    this.matchAnchorWidth = true,
    this.extraWidth,
    this.minWidth,
    this.label = '',
    this.labelStyle,
    this.labelSpacing = 8,
    this.bottomPadding = 0,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return _buildMaterial(context);
  }

  Widget _buildMaterial(BuildContext context) {
    final textStyle = AppStyle.textFieldTextStyle(
      context,
    ).copyWith(fontSize: 14);
    final hintStyle = AppStyle.textFieldHintStyle(
      context,
    ).copyWith(fontSize: 12);

    final effectiveHeight = height ?? kTextFieldHeight;
    final contentPadding = AppStyle.centeredContentPadding(
      height: effectiveHeight,
      textStyle: textStyle,
    );
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty) ...[
            Text(label, style: labelStyle ?? AppStyle.labelStyle(context)),
            SizedBox(height: labelSpacing),
          ],
          Builder(
            builder: (anchorContext) {
              return SizedBox(
                width: width ?? double.infinity,
                height: effectiveHeight,
                child: GestureDetector(
                  onTap: disable
                      ? null
                      : () async {
                          final selected = await showAnchoredDropdown<T>(
                            context,
                            anchorContext: anchorContext,
                            items: items,
                            selected: value,
                            itemLabelBuilder: itemLabelBuilder,
                            leadingBuilder: leadingBuilder,
                            isSelected: isSelected,
                            matchAnchorWidth: matchAnchorWidth,
                            extraWidth: extraWidth ?? 0,
                            minWidth: minWidth ?? 220,
                          );
                          if (selected != null && selected != value) {
                            onChanged(selected);
                          }
                        },
                  child: InputDecorator(
                    isEmpty: value == null,
                    decoration: AppStyle.textFieldDecoration(
                      context,
                      hint: '',
                      contentPadding: contentPadding,
                      radius: borderRadius,
                      borderColor: borderColor ?? context.colorTheme.outline,
                      borderWidth: 1,
                      fillColor: disable
                          ? context.themeData.dividerColor
                          : fillColor ?? context.colorTheme.surface,
                      dense: true,
                    ),
                    child: Row(
                      children: [
                        if (value != null &&
                            (selectedLeadingBuilder ?? leadingBuilder) !=
                                null) ...[
                          (selectedLeadingBuilder ?? leadingBuilder)!(
                            value as T,
                          ),
                          const SizedBox(width: 8),
                        ],
                        Expanded(
                          child: Text(
                            value != null
                                ? itemLabelBuilder(value as T)
                                : hintText,
                            style: value != null ? textStyle : hintStyle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: context.colorTheme.tertiary,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
