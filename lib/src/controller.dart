import 'package:flutter/widgets.dart';

import 'datetime_util.dart';

/// Advanced Calendar controller that manage selection date state.
class AdvancedCalendarController extends ValueNotifier<DateTime> {
  AdvancedCalendarController._(DateTime value) : super(value);

  /// Generates controller with today date selected.
  AdvancedCalendarController.today() : this._(DateTime.now().toZeroTime());

  /// Generates controller with custom date selected.
  AdvancedCalendarController.custom(DateTime dateTime)
      : this._(dateTime.toZeroTime());

  @override
  set value(DateTime newValue) {
    super.value = newValue.toZeroTime();
  }
}
