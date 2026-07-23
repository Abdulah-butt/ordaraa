enum OrderListStatus {
  active('ACTIVE', 'Active'),
  completed('COMPLETED', 'Completed'),
  cancelled('CANCELLED', 'Cancelled');

  const OrderListStatus(this.apiValue, this.displayText);

  final String apiValue;
  final String displayText;
}
