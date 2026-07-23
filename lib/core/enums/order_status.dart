import 'package:flutter/material.dart';

import '../extensions/theme_extension.dart';

enum OrderStatus {
  pending('PENDING'),
  confirmed('CONFIRMED'),
  preparing('PREPARING'),
  readyForDispatch('READY_FOR_DISPATCH'),
  outForDelivery('OUT_FOR_DELIVERY'),
  rejected('REJECTED'),
  delivered('DELIVERED'),
  cancelled('CANCELLED');

  const OrderStatus(this.apiValue);

  final String apiValue;

  static OrderStatus fromApiValue(String value) {
    return OrderStatus.values.firstWhere(
      (status) => status.apiValue == value,
      orElse: () => throw FormatException('Unknown order status: $value'),
    );
  }

  String get displayText => switch (this) {
    pending => 'Pending supplier confirmation',
    confirmed => 'Confirmed',
    preparing => 'Preparing',
    readyForDispatch => 'Ready for dispatch',
    outForDelivery => 'Out for delivery',
    rejected => 'Rejected',
    delivered => 'Delivered',
    cancelled => 'Cancelled',
  };

  Color foregroundColor(BuildContext context) => switch (this) {
    delivered || confirmed => context.ordaraColors.success,
    cancelled || rejected => context.colorTheme.error,
    readyForDispatch || outForDelivery => context.ordaraColors.info,
    pending || preparing => context.ordaraColors.warning,
  };

  Color backgroundColor(BuildContext context) => switch (this) {
    delivered || confirmed => context.ordaraColors.successContainer,
    cancelled || rejected => context.colorTheme.errorContainer,
    readyForDispatch || outForDelivery => context.ordaraColors.infoContainer,
    pending || preparing => context.ordaraColors.warningContainer,
  };
}
