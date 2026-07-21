import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/extensions/theme_extension.dart';
import '../../core/utils/constants.dart';
import '../widgets/custom_button.dart';

class ConfirmationSheet extends StatefulWidget {
  final ConfirmationSheetInitialParams initialParams;

  const ConfirmationSheet({super.key, required this.initialParams});

  @override
  State<ConfirmationSheet> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<ConfirmationSheet> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text(
          widget.initialParams.title,
          style: context.textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        Visibility(
          visible: widget.initialParams.subTitle.isNotEmpty,
          child: Text(widget.initialParams.subTitle),
        ),
        const SizedBox(height: 28),
        CustomButton(
          text: widget.initialParams.secondaryBtnText,
          onTap: () {
            context.pop();
          },
          isSecondary: true,
        ),
        const SizedBox(height: 0),
        CustomButton(
          text: widget.initialParams.primaryBtnText,
          onTap: () {
            context.pop();
            widget.initialParams.btnAction?.call();
          },
        ),
        const SizedBox(height: kScreenPadding),
      ],
    );
  }
}

class ConfirmationSheetInitialParams {
  String title;
  String primaryBtnText;
  String secondaryBtnText;
  VoidCallback? btnAction;
  String subTitle;

  ConfirmationSheetInitialParams({
    required this.title,
    required this.primaryBtnText,
    required this.secondaryBtnText,
    this.btnAction,
    this.subTitle = "",
  });
}
