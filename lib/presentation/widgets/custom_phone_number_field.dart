import 'package:flutter/material.dart';
import 'package:phone_form_field/phone_form_field.dart';

import '../../core/extensions/theme_extension.dart';
import '../../core/utils/constants.dart';
import '../../services/ip/ip_service.dart';

class CustomPhoneNumberField extends StatefulWidget {
  const CustomPhoneNumberField({
    super.key,
    required this.onChange,
    this.hint = '',
    this.label = '',
    this.asFormField = false,
    this.isDisabled = false,
    this.bottomPadding,
    this.initialCountryCode = '',
    this.initialPhoneNumber = '',
  });

  final String hint;
  final String label;
  final bool asFormField;
  final bool isDisabled;
  final double? bottomPadding;
  final String initialCountryCode;
  final String initialPhoneNumber;
  final void Function(String countryCode, String phoneNumber, bool isValid)
  onChange;

  @override
  State<CustomPhoneNumberField> createState() => _CustomPhoneNumberFieldState();
}

class _CustomPhoneNumberFieldState extends State<CustomPhoneNumberField> {
  late final FocusNode _focusNode;
  late final PhoneNumber _initialValue;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _initialValue = _resolveInitialValue();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _notify(_initialValue);
    });
  }

  PhoneNumber _resolveInitialValue() {
    if (widget.initialPhoneNumber.trim().isNotEmpty) {
      try {
        return PhoneNumber.parse(widget.initialPhoneNumber.trim());
      } catch (_) {
        // Let the package validate the supplied number against its country.
      }
    }

    final requestedCode = widget.initialCountryCode.trim().isNotEmpty
        ? widget.initialCountryCode.trim()
        : kDefaultCountryCode.trim();
    final isoCode = IsoCode.values.firstWhere(
      (code) => code.name == requestedCode.toUpperCase(),
      orElse: () => IsoCode.AU,
    );
    return PhoneNumber(isoCode: isoCode, nsn: '');
  }

  void _notify(PhoneNumber phoneNumber) {
    widget.onChange(
      phoneNumber.countryCode,
      phoneNumber.nsn,
      phoneNumber.isValid(type: PhoneNumberType.mobile),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = widget.asFormField;
    final textStyle = compact
        ? context.textTheme.bodyMedium?.copyWith(
            color: context.colorTheme.onSurface,
          )
        : context.textTheme.headlineLarge;

    return TapRegion(
      onTapOutside: (_) => _focusNode.unfocus(),
      child: Padding(
        padding: EdgeInsets.only(
          bottom: widget.bottomPadding ?? kTextFieldBottomPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label.isNotEmpty) ...[
              Text(
                widget.label,
                style: context.textTheme.labelMedium?.copyWith(
                  color: context.colorTheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 6),
            ],
            PhoneFormField(
              initialValue: _initialValue,
              focusNode: _focusNode,
              enabled: !widget.isDisabled,
              readOnly: widget.isDisabled,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.telephoneNumber],
              countrySelectorNavigator:
                  const CountrySelectorNavigator.modalBottomSheet(),
              countryButtonStyle: CountryButtonStyle(
                showFlag: true,
                flagSize: 18,
                showDialCode: true,
                showIsoCode: false,
                showDropdownIcon: true,
                dropdownIconColor: context.colorTheme.onSurfaceVariant,
                textStyle: textStyle,
                padding: const EdgeInsets.only(left: 12, right: 8),
              ),
              style: textStyle,
              validator: PhoneValidator.compose([
                PhoneValidator.required(context),
                PhoneValidator.validMobile(context),
              ]),
              onChanged: _notify,
              onSubmitted: _notify,
              onTapOutside: (_) => _focusNode.unfocus(),
              decoration: InputDecoration(
                hintText: widget.hint.isEmpty ? '412 345 678' : widget.hint,
                hintStyle: context.textTheme.bodyMedium?.copyWith(
                  color: context.ordaraColors.textTertiary,
                ),
                isDense: true,
                constraints: compact
                    ? const BoxConstraints(minHeight: 48)
                    : null,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: compact ? 12 : 16,
                  vertical: compact ? 13 : 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(compact ? 10 : 12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(compact ? 10 : 12),
                  borderSide: BorderSide(color: context.colorTheme.outline),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(compact ? 10 : 12),
                  borderSide: BorderSide(
                    color: context.colorTheme.primary,
                    width: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
