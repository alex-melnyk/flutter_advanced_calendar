part of 'widget.dart';

extension DateTimeUtil on DateTime {
  /// Generate a new DateTime instance with a zero time.
  DateTime toZeroTime() => DateTime(this.year, this.month, this.day);
}
