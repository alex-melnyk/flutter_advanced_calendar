part of 'widget.dart';

class ViewRange {
  const ViewRange._(this.firstDay, this.dates);

  /// Creates custom filled [ViewRange] instance.
  const ViewRange.custom(
    DateTime firstDay,
    List<DateTime> dates,
  ) : this._(firstDay, dates);

  /// Generates [ViewRange] instance based on [date],
  /// number of [month] and [weeksAmount].
  /// gives the beginning of the day of the week [startWeekDay]
  factory ViewRange.generateDates(
    DateTime date,
    int month,
    int weeksAmount, {
    int? startWeekDay,
  }) {
    final firstMonthDate = DateTime.utc(date.year, month, 1);
    final firstViewDate =
        firstMonthDate.firstDayOfWeek(startWeekDay: startWeekDay);

    return ViewRange._(
      firstMonthDate,
      List.generate(
        weeksAmount * 7,
        (index) => firstViewDate.add(Duration(days: index)),
        growable: false,
      ),
    );
  }

  /// Month view index.
  final DateTime firstDay;

  /// Month view dates.
  final List<DateTime> dates;
}
