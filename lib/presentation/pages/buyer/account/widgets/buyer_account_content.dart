import 'package:flutter/material.dart';

import '../../../../../core/extensions/theme_extension.dart';
import '../buyer_account_state.dart';
import 'buyer_account_profile_card.dart';
import 'buyer_account_section.dart';

class BuyerAccountContent extends StatelessWidget {
  const BuyerAccountContent({
    super.key,
    required this.state,
    required this.onLogout,
    required this.onDeleteAccount,
  });

  final BuyerAccountState state;
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Account',
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontSize: 22,
                      height: 29 / 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    state.organizationName,
                    style: context.textTheme.labelSmall?.copyWith(
                      color: context.colorTheme.onSurfaceVariant,
                      height: 18 / 11,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            sliver: SliverList.list(
              children: [
                BuyerAccountProfileCard(
                  displayName: state.displayName,
                  initials: state.initials,
                  roleLabel: state.roleLabel,
                ),
                const SizedBox(height: 12),
                const BuyerAccountSection(
                  title: 'Organization',
                  items: [
                    BuyerAccountItem(label: 'Organization profile'),
                    BuyerAccountItem(
                      label: 'Members · Coming Later',
                      enabled: false,
                    ),
                    BuyerAccountItem(label: 'Saved addresses'),
                    BuyerAccountItem(label: 'Billing details'),
                  ],
                ),
                const SizedBox(height: 12),
                const BuyerAccountSection(
                  title: 'Support & legal',
                  items: [
                    BuyerAccountItem(label: 'Support'),
                    BuyerAccountItem(label: 'Terms'),
                    BuyerAccountItem(label: 'Privacy'),
                  ],
                ),
                const SizedBox(height: 12),
                const BuyerAccountSection(
                  title: 'Marketplace',
                  items: [BuyerAccountItem(label: 'Sell on Ordara')],
                ),
                const SizedBox(height: 12),
                BuyerAccountSection(
                  title: 'Account actions',
                  items: [
                    BuyerAccountItem(
                      label: state.isLoggingOut ? 'Logging out…' : 'Log out',
                      destructive: true,
                      enabled: !state.isLoggingOut,
                      onTap: onLogout,
                    ),
                    BuyerAccountItem(
                      label: 'Delete account',
                      destructive: true,
                      enabled: !state.isLoggingOut,
                      onTap: onDeleteAccount,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
