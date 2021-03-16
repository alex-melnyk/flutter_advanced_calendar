extension DateTimeUtil on DateTime {
  /// Generate a new DateTime instance with a zero time.
  DateTime toZeroTime() => DateTime.utc(this.year, this.month, this.day, 12);

  int findWeekIndex(List<DateTime> dates) {
    return dates.indexWhere((date) => this.isAtSameMomentAs(date)) ~/ 7;
  }

  /// Calculates first week date (Sunday) from this date.
  DateTime firstDayOfWeek() {
    final utcDate = DateTime.utc(this.year, this.month, this.day, 12);
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
}
