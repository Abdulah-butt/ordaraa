import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_button.dart';
import '../../core/extensions/theme_extension.dart';

class InformationSheet extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onDone;
  final TextAlign? align;
  const InformationSheet({
    super.key,
    required this.title,
    required this.description,
    this.align,
    this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: context.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
          textAlign: align??TextAlign.center,
        ),
        Text(
          description,
        ),
        const SizedBox(height: 54,),
        CustomButton(
          text: "Okay",
          onTap: () {
            context.pop();
            onDone?.call();
          },
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
