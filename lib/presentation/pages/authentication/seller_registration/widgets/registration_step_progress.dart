import 'package:flutter/widgets.dart';

import '../../../../../core/extensions/theme_extension.dart';

class RegistrationStepProgress extends StatelessWidget {
  const RegistrationStepProgress({super.key, required this.activeStep});

  final int activeStep;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(4, (index) {
        final step = index + 1;
        return Padding(
          padding: EdgeInsets.only(right: index == 3 ? 0 : 4),
          child: Container(
            width: step == activeStep ? 30 : 20,
            height: 4,
            decoration: BoxDecoration(
              color: step == activeStep
                  ? context.colorTheme.primary
                  : context.colorTheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
