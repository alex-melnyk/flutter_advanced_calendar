extension DateTimeUtil on DateTime {
  /// Generate a new DateTime instance with a zero time.
  DateTime toZeroTime() => DateTime.utc(this.year, this.month, this.day, 12);

  int findWeekIndex(List<DateTime> dates) {
    return dates.indexWhere((date) => this.isAtSameMomentAs(date)) ~/ 7;
  }

  /// Calculates first week date (Sunday) from this date.
  DateTime firstDayOfWeek({int? startWeekDay}) {
    final utcDate = DateTime.utc(this.year, this.month, this.day, 12);
    if (startWeekDay != null && startWeekDay < 7) {
      return utcDate
          .subtract(new Duration(days: utcDate.weekday - startWeekDay));
    }
    return utcDate.subtract(new Duration(days: utcDate.weekday % 7));
  }

  /// Generates 7 dates according to this date.
  /// (Supposed that this date is result of [firstDayOfWeek])
  List<DateTime> weekDates() {
    return List.generate(
      7,
      (index) => this.add(Duration(days: index)),
      growable: false,
    );
  }

  /// Generates list of list with [DateTime]
  /// according to [date] and [weeksAmount].
  /// gives the beginning of the day of the week [startWeekDay]
  List<List<DateTime>> generateWeeks(int weeksAmount, {int? startWeekDay}) {
    final firstViewDate =
        this.firstDayOfWeek(startWeekDay: startWeekDay).subtract(Duration(
              days: (weeksAmount ~/ 2) * 7,
            ));

    return List.generate(
      weeksAmount,
      (weekIndex) {
        final firstDateOfNextWeek = firstViewDate.add(Duration(
          days: weekIndex * 7,
        ));

        return firstDateOfNextWeek.weekDates();
      },
      growable: false,
    );
  }
}
