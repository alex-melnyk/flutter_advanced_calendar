part of 'widget.dart';

class MonthViewBean {
  const MonthViewBean(this.firstDay, this.dates);

  /// Month view index.
  final DateTime firstDay;

  /// Month view dates.
  final List<DateTime> dates;
}
