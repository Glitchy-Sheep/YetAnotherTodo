import 'package:intl/intl.dart';

abstract class DateFormatters {
  static String toDayMonthYear(DateTime date, String locale) {
    return DateFormat(
      'dd MMMM yyyy',
      locale,
    ).format(date);
  }
}
