import 'package:intl/intl.dart';

extension IndianNumberFormat on num {
  String toIndianFormat() {
    return NumberFormat("#,##0", "en_IN").format(this);
  }

  String toIndianFormatWithDecimal() {
    return NumberFormat("#,##0.00", "en_IN").format(this);
  }
}


