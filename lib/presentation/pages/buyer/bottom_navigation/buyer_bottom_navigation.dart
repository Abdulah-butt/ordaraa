import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/extensions/theme_extension.dart';
import '../../../../core/utils/assets.dart';
import '../account/buyer_account_page.dart';
import '../home/buyer_home_page.dart';
import '../orders/buyer_orders_page.dart';
import '../search/buyer_search_page.dart';
import 'widgets/buyer_bottom_navigation_item.dart';

class BuyerBottomNavigation extends StatelessWidget {
  const BuyerBottomNavigation({super.key, required this.child});

  final Widget child;

  static const _items = <({String asset, String label, String path})>[
    (asset: Assets.buyerNavHome, label: 'Home', path: BuyerHomePage.path),
    (asset: Assets.buyerNavSearch, label: 'Search', path: BuyerSearchPage.path),
    (asset: Assets.buyerNavOrders, label: 'Orders', path: BuyerOrdersPage.path),
    (
      asset: Assets.buyerNavAccount,
      label: 'Account',
      path: BuyerAccountPage.path,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _selectedIndex(context);

    return Scaffold(
      backgroundColor: context.colorTheme.surface,
      body: child,
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colorTheme.surface,
          border: Border(
            top: BorderSide(color: context.colorTheme.outlineVariant),
          ),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 76,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (var index = 0; index < _items.length; index++)
                    BuyerBottomNavigationItem(
                      asset: _items[index].asset,
                      label: _items[index].label,
                      isSelected: selectedIndex == index,
                      onTap: () => context.go(_items[index].path),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  int _selectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _items.indexWhere((item) => location.startsWith(item.path));
    return index < 0 ? 0 : index;
  }
}
