part of 'widget.dart';

class ViewRange {
  const ViewRange(this.firstDay, this.dates);

  /// Month view index.
  final DateTime firstDay;

  /// Month view dates.
  final List<DateTime> dates;
}
