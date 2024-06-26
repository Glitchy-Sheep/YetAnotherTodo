import 'package:intl/intl.dart';

String formatDate(DateTime date, String locale) {
  return DateFormat(
    'dd MMMM yyyy',
    locale,
  ).format(date);
}
