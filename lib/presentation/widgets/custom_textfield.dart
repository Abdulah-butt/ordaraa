import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../../../core/extensions/theme_extension.dart';
import '../../../core/utils/style.dart';

import '../../core/utils/constants.dart';
import '../../services/date_time/date_time_picker_service.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final String description;

  final Function(String)? onChange;
  final Function(String)? onSubmit;
  final Function(String)? onGoesOutside;

  final VoidCallback? onTap;

  // Add these new properties
  final bool showDateTimePicker;
  final bool showDateOnlyPicker;

  final bool dealAsTime;
  final bool whenTypingEnds;

  final bool? hide;
  final bool? readOnly;
  final bool disable;

  final String? suffixPath;
  final String? prefixPath;
  final bool? countryPicker;
  final bool? genderPicker;
  final double? bottomPadding;
  final String? initialValue;
  final bool isDetail;
  final double? height;
  final bool autoFocus;

  final double? width;

  final double? prefixHeight;
  final double? suffixHeight;
  final Color? suffixColor;
  final bool showCurrentCharacters;
  final TextInputType? keyboard;
  final TextInputAction? action;

  final List<TextInputFormatter>? inputFormatters;
  final VoidCallback? suffixAction;
  final double? borderRadius;
  final Color? fillColor;
  final Color? borderColor;
  final double? borderWidth;

  final TextAlign? textAlign;
  final TextStyle? labelStyle;
  final Widget? suffix;
  final double labelSpacing;

  const CustomTextField({
    super.key,
    required this.controller,
    this.label = "",
    this.hint = "",
    this.description = "",
    this.onChange,
    this.onSubmit,
    this.onGoesOutside,
    this.onTap,
    this.height,
    this.width,
    this.initialValue,
    this.prefixPath,
    this.readOnly,
    this.bottomPadding,
    this.dealAsTime = false,
    this.inputFormatters,
    this.showCurrentCharacters = false,
    this.autoFocus = false,
    this.whenTypingEnds = false,
    this.disable = false,
    this.isDetail = false,
    this.keyboard,
    this.action,
    this.countryPicker,
    this.genderPicker,
    this.hide,
    this.prefixHeight,
    this.suffixHeight,
    this.suffixColor,
    this.suffixAction,
    this.suffixPath,
    this.showDateTimePicker = false,
    this.showDateOnlyPicker = false,
    this.borderRadius,
    this.fillColor,
    this.borderColor,
    this.borderWidth,
    this.textAlign,
    this.labelStyle,
    this.suffix,
    this.labelSpacing = 8,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = AppStyle.textFieldTextStyle(context, isDisabled: disable);
    final effectiveHeight = height ?? (isDetail ? 85 : kTextFieldHeight);
    final contentPadding = isDetail
        ? const EdgeInsets.symmetric(vertical: 12, horizontal: 12)
        : AppStyle.centeredContentPadding(
            height: effectiveHeight,
            textStyle: textStyle,
          );
    final suffixIconWidget = suffix != null
        ? Center(
            child: GestureDetector(onTap: suffixAction, child: suffix),
          )
        : (suffixPath == null
              ? null
              : GestureDetector(
                  onTap: suffixAction,
                  child: Center(
                    child: SvgPicture.asset(
                      suffixPath!,
                      colorFilter: ColorFilter.mode(
                        context.colorTheme.tertiary,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ));
    final prefixIconWidget = prefixPath == null
        ? null
        : Center(
            child: SvgPicture.asset(
              prefixPath!,
              colorFilter: ColorFilter.mode(
                context.colorTheme.tertiary,
                BlendMode.srcIn,
              ),
            ),
          );

    return Padding(
      padding: EdgeInsets.only(
        bottom: bottomPadding ?? kTextFieldBottomPadding,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          label.isEmpty
              ? const SizedBox.shrink()
              : Text(label, style: labelStyle ?? AppStyle.labelStyle(context)),
          label.isEmpty
              ? const SizedBox.shrink()
              : SizedBox(height: labelSpacing),
          SizedBox(
            width: width ?? double.maxFinite,
            height: effectiveHeight,
            child: TextFormField(
              controller: controller,
              initialValue: initialValue,
              onTapOutside: (event) {
                onGoesOutside?.call(controller.text.trim());
                FocusManager.instance.primaryFocus?.unfocus();
              },
              textAlignVertical: isDetail
                  ? TextAlignVertical.top
                  : TextAlignVertical.center,
              expands: isDetail,
              onChanged: onChange,
              textAlign: textAlign ?? TextAlign.start,
              onFieldSubmitted: onSubmit,
              autofocus: autoFocus,
              inputFormatters: inputFormatters,
              style: textStyle,
              onTap: () {
                if (dealAsTime) {
                  _selectTime(context);
                } else if (showDateTimePicker) {
                  _selectDateTime(context);
                } else if (showDateOnlyPicker) {
                  _selectDate(context);
                } else if (onTap != null) {
                  onTap!();
                }
              },
              textInputAction:
                  action ??
                  (isDetail ? TextInputAction.newline : TextInputAction.done),
              keyboardType:
                  keyboard ??
                  (isDetail ? TextInputType.multiline : TextInputType.text),
              maxLines: isDetail ? null : 1,
              readOnly:
                  disable ||
                  dealAsTime ||
                  showDateTimePicker ||
                  showDateOnlyPicker ||
                  (countryPicker ?? genderPicker ?? readOnly ?? false),
              obscureText: hide ?? false,
              cursorColor: context.colorTheme.primary,
              decoration: AppStyle.textFieldDecoration(
                context,
                hint: hint,
                hintFadeDuration: const Duration(milliseconds: 500),
                contentPadding: contentPadding,
                borderColor: borderColor,
                borderWidth: borderWidth ?? 1,
                radius: borderRadius ?? 12,
                fillColor: fillColor,
                prefixIcon: prefixIconWidget,
                suffixIcon: suffixIconWidget,
                prefixIconConstraints: const BoxConstraints(
                  maxWidth: 45,
                  maxHeight: 45,
                ),
                suffixIconConstraints: const BoxConstraints(
                  maxWidth: 45,
                  maxHeight: 45,
                ),
              ),
            ),
          ),
          description.isEmpty
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(description, style: context.textTheme.bodySmall),
                ),
        ],
      ),
    );
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final service = DateTimePickerFactory.getPickerService(context);
    // First pick the date
    final DateTime? pickedDate = await service.pickDateTime(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Format as "25/03/2025, 10:00 AM"
      final formattedDateTime = DateFormat(
        'dd/MM/yyyy, hh:mm a',
      ).format(pickedDate).trim();
      controller.text = formattedDateTime;
      onSubmit?.call(formattedDateTime);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final service = DateTimePickerFactory.getPickerService(context);
    final DateTime? pickedDate = await service.pickDate(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      // Format as "25/03/2025"
      final formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate).trim();
      controller.text = formattedDate;
      onSubmit?.call(formattedDate);
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final service = DateTimePickerFactory.getPickerService(context);
    final TimeOfDay? pickedTime = await service.pickTime(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      final formattedTime = _formatTime(pickedTime).trim();
      controller.text = formattedTime;
      onSubmit?.call(formattedTime);
    }
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('hh:mm a').format(dt); // Fixed format to show AM/PM
  }
}
