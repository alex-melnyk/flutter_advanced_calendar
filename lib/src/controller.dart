import 'package:flutter/widgets.dart';

/// Advanced Calendar controller that manage selection date state.
class AdvancedCalendarController extends ValueNotifier<DateTime> {
  AdvancedCalendarController._(DateTime value) : super(value);

  /// Generates controller with today date selected.
  AdvancedCalendarController.today()
      : this._(_dateTimeToDayStart(DateTime.now()));

  /// Generates controller with custom date selected.
  AdvancedCalendarController.custom(DateTime dateTime)
      : this._(_dateTimeToDayStart(dateTime));

  static DateTime _dateTimeToDayStart(DateTime dateTime) => DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
      );

  @override
  set value(DateTime newValue) {
    super.value = _dateTimeToDayStart(newValue);
  }
}
