import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

import '../../../../../core/extensions/theme_extension.dart';

class OtpCodeField extends StatelessWidget {
  const OtpCodeField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onCompleted,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cellWidth = ((constraints.maxWidth - 40) / 6).clamp(38.0, 53.0);
        final pinTheme = PinTheme(
          width: cellWidth,
          height: 58,
          textStyle: context.textTheme.titleLarge,
          decoration: BoxDecoration(
            color: context.colorTheme.surface,
            border: Border.all(color: context.colorTheme.outline),
            borderRadius: BorderRadius.circular(12),
          ),
        );

        return Pinput(
          length: 6,
          controller: controller,
          defaultPinTheme: pinTheme,
          focusedPinTheme: pinTheme.copyWith(
            decoration: pinTheme.decoration?.copyWith(
              border: Border.all(color: context.colorTheme.primary, width: 2),
            ),
          ),
          separatorBuilder: (_) => const SizedBox(width: 8),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: onChanged,
          onCompleted: onCompleted,
        );
      },
    );
  }
}
