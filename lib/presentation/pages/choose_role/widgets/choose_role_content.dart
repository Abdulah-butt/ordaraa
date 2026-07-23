import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/enums/user_role.dart';
import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/assets.dart';
import '../../../../core/utils/constants.dart';
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
              width: 140,
              height: 38,
              fit: BoxFit.contain,
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 358),
                    child: Column(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: context.colorTheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.storefront_rounded,
                            size: 30,
                            color: context.colorTheme.primary,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'How will you use $kAppName?',
                          textAlign: TextAlign.center,
                          style: context.textTheme.headlineLarge?.copyWith(
                            fontSize: 28,
                            height: 36 / 28,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Choose the option that best describes you.',
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: context.colorTheme.onSurfaceVariant,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        RoleOptionCard(
                          label: 'I want to buy',
                          description:
                              'Source quality seafood from trusted suppliers.',
                          iconAsset: Assets.roleBuyer,
                          selected: state.selectedRole == UserRole.buyer,
                          onTap: () => onRoleSelected(UserRole.buyer),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        RoleOptionCard(
                          label: 'I want to sell',
                          description:
                              'Supply seafood and receive wholesale orders.',
                          iconAsset: Assets.roleSeller,
                          selected: state.selectedRole == UserRole.seller,
                          onTap: () => onRoleSelected(UserRole.seller),
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.lock_outline_rounded,
                              size: 18,
                              color: context.colorTheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Flexible(
                              child: Text(
                                'Next, you’ll sign in securely with your phone.',
                                textAlign: TextAlign.center,
                                style: context.textTheme.bodySmall?.copyWith(
                                  color: context.colorTheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
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
