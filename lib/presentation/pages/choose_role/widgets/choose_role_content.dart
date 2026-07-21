import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/enums/user_role.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/assets.dart';
import '../choose_role_state.dart';
import 'role_option_card.dart';

class ChooseRoleContent extends StatelessWidget {
  const ChooseRoleContent({
    super.key,
    required this.state,
    required this.onRoleSelected,
  });

  final ChooseRoleState state;
  final ValueChanged<UserRole> onRoleSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
      child: Padding(
        padding: AppSpacing.pageCompact,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              Assets.logoTransparent,
              width: 131,
              height: 35,
              fit: BoxFit.contain,
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 358),
                    child: Column(
                      children: [
                        Text(
                          'What do you want to do?',
                          textAlign: TextAlign.center,
                          style: context.textTheme.headlineLarge?.copyWith(
                            fontSize: 28,
                            height: 36 / 28,
                          ),
                        ),
                        const SizedBox(height: 28),
                        RoleOptionCard(
                          label: 'Buy products',
                          iconAsset: Assets.roleBuyer,
                          selected: state.selectedRole == UserRole.buyer,
                          onTap: () => onRoleSelected(UserRole.buyer),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        RoleOptionCard(
                          label: 'Sell products',
                          iconAsset: Assets.roleSeller,
                          selected: state.selectedRole == UserRole.seller,
                          onTap: () => onRoleSelected(UserRole.seller),
                        ),
                      ],
                    ),
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
