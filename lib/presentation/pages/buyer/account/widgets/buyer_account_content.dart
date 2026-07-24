import 'package:flutter/material.dart';

import '../../../../../core/extensions/theme_extension.dart';
import '../../../../../core/utils/constants.dart';
import '../buyer_account_state.dart';
import 'buyer_account_profile_card.dart';
import 'buyer_account_section.dart';

class BuyerAccountContent extends StatelessWidget {
  const BuyerAccountContent({
    super.key,
    required this.state,
    required this.onLogout,
    required this.onDeleteAccount,
    required this.onOrganizationProfile,
    required this.onSavedAddresses,
  });

  final BuyerAccountState state;
  final VoidCallback onLogout;
  final VoidCallback onDeleteAccount;
  final VoidCallback onOrganizationProfile;
  final VoidCallback onSavedAddresses;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 12),
            sliver: SliverToBoxAdapter(
              child: Text(
                'Account',
                style: context.textTheme.headlineSmall?.copyWith(
                  fontSize: 22,
                  height: 29 / 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            sliver: SliverList.list(
              children: [
                BuyerAccountProfileCard(
                  businessName: state.organizationName,
                  initials: state.initials,
                  businessSubtitle: state.organizationSubtitle,
                  verified: state.organizationVerified,
                ),
                const SizedBox(height: 12),
                BuyerAccountSection(
                  title: 'Organization',
                  items: [
                    BuyerAccountItem(
                      label: 'Organization profile',
                      onTap: onOrganizationProfile,
                    ),
                    BuyerAccountItem(
                      label: 'Saved addresses',
                      onTap: onSavedAddresses,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const BuyerAccountSection(
                  title: 'Support & legal',
                  items: [
                    BuyerAccountItem(label: 'Support'),
                    BuyerAccountItem(label: 'Terms & Privacy'),
                  ],
                ),
                const SizedBox(height: 12),
                const BuyerAccountSection(
                  title: 'Marketplace',
                  items: [BuyerAccountItem(label: 'Sell on $kAppName')],
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
