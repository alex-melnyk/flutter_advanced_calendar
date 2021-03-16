import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'controller.dart';
import 'datetime_util.dart';

part 'date_box.dart';

part 'handlebar.dart';

part 'header.dart';

part 'month_view.dart';

part 'month_view_bean.dart';

part 'week_days.dart';

part 'week_view.dart';

const monthViewWeekHeight = 32.0;

/// Advanced Calendar widget.
class AdvancedCalendar extends StatefulWidget {
  const AdvancedCalendar({
    Key key,
    this.controller,
  }) : super(key: key);

  /// Calendar selection date controller.
  final AdvancedCalendarController controller;

  @override
  _AdvancedCalendarState createState() => _AdvancedCalendarState();
}

class _AdvancedCalendarState extends State<AdvancedCalendar>
    with SingleTickerProviderStateMixin {
  static const _preloadMonthAmount = 13;
  static const _preloadWeeksAmount = 21;

  final _monthPageController = PageController(
    initialPage: _preloadMonthAmount ~/ 2,
  );
  final _weekPageController = PageController(
    initialPage: _preloadWeeksAmount ~/ 2,
  );
  final _currentPage = ValueNotifier<int>(6);
  final _weekView = ValueNotifier<bool>(true);
  AnimationController _animationController;
  AdvancedCalendarController _controller;

  Offset _captureOffset;
  double _animationValue;

  DateTime _todayDate;
  List<ViewRange> _monthRangeList;
  List<List<DateTime>> _weekRangeList;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: 0,
    );

    _animationValue = _animationController.value;

    _todayDate = DateTime.now().toZeroTime();

    _controller = widget.controller ?? AdvancedCalendarController.today();

    _monthRangeList = List.generate(
      _preloadMonthAmount,
      (index) => _generateMonthViewDate(
        _todayDate,
        _todayDate.month + (index - _monthPageController.initialPage),
      ),
    );

    _weekRangeList = _generateWeeks(_controller.value, _preloadWeeksAmount);

    _weekView.addListener(() {
      _weekRangeList = _generateWeeks(_controller.value);
    });
  }

  ViewRange _generateMonthViewDate(
    DateTime date,
    int month, [
    int weeksAmount = 6,
  ]) {
    final firstMonthDate = DateTime.utc(date.year, month, 1);
    final firstViewDate = firstMonthDate.firstDayOfWeek();

    return ViewRange(
      firstMonthDate,
      List.generate(
        weeksAmount * 7,
        (index) => firstViewDate.add(Duration(days: index)),
        growable: false,
      ),
    );
  }

  List<List<DateTime>> _generateWeeks(
    DateTime date, [
    int weeksAmount = 21,
  ]) {
    final firstViewDate = date.firstDayOfWeek().subtract(Duration(
          days: (weeksAmount ~/ 2) * 7,
        ));

    return List.generate(
      weeksAmount,
      (weekIndex) {
        final firstDateOfNextWeek = firstViewDate.add(Duration(
          days: weekIndex * 7,
        ));

        final weekDays = firstDateOfNextWeek.weekDates();

        print(weekDays);

        return weekDays;
      },
      growable: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final commonTextStyle = theme.textTheme.bodyText1.copyWith(
      fontSize: 14.0,
    );

    return Material(
      color: Colors.transparent,
      child: DefaultTextStyle(
        style: commonTextStyle,
        child: GestureDetector(
          onVerticalDragStart: (details) {
            _captureOffset = details.globalPosition;

            setState(() {
              _weekView.value = false;
            });
          },
          onVerticalDragUpdate: (details) {
            final moveOffset = details.globalPosition;

            final diffY = moveOffset.dy - _captureOffset.dy;

            _animationController.value =
                _animationValue + diffY / (monthViewWeekHeight * 5);
          },
          onVerticalDragEnd: (details) => _handleFinishDrag(),
          onVerticalDragCancel: () => _handleFinishDrag(),
          child: Container(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ValueListenableBuilder(
                  valueListenable: _currentPage,
                  builder: (_, value, __) {
                    return Header(
                      monthDate: _monthRangeList[_currentPage.value].firstDay,
                      onPressed: _handleTodayPressed,
                    );
                  },
                ),
                WeekDays(
                  style: commonTextStyle.copyWith(
                    color: theme.hintColor,
                  ),
                ),
                AnimatedBuilder(
                  animation: _animationController,
                  builder: (_, __) {
                    final height = Tween<double>(
                      begin: monthViewWeekHeight,
                      end: monthViewWeekHeight * 6.0,
                    ).transform(_animationController.value);

                    return SizedBox(
                      height: height,
                      child: ValueListenableBuilder<DateTime>(
                        valueListenable: _controller,
                        builder: (_, selectedDate, __) {
                          return ValueListenableBuilder<bool>(
                            valueListenable: _weekView,
                            builder: (_, value, __) {
                              if (value) {
                                return ValueListenableBuilder<int>(
                                  valueListenable: _currentPage,
                                  builder: (_, pageIndex, __) {
                                    return PageView.builder(
                                      controller: _weekPageController,
                                      itemCount: _weekRangeList.length,
                                      itemBuilder: (context, index) {
                                        return WeekView(
                                          dates: _weekRangeList[index],
                                          selectedDate: selectedDate,
                                          onChanged: _handleDateSelected,
                                        );
                                      },
                                    );
                                  },
                                );
                              }

                              return PageView.builder(
                                onPageChanged: (pageIndex) {
                                  _currentPage.value = pageIndex;
                                },
                                controller: _monthPageController,
                                physics: _animationController.value == 1.0
                                    ? AlwaysScrollableScrollPhysics()
                                    : NeverScrollableScrollPhysics(),
                                itemCount: _monthRangeList.length,
                                itemBuilder: (_, pageIndex) {
                                  return MonthView(
                                    monthView: _monthRangeList[pageIndex],
                                    todayDate: _todayDate,
                                    selectedDate: selectedDate,
                                    onChanged: _handleDateSelected,
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
                HandleBar(
                  onPressed: () async {
                    await _animationController.forward();
                    _animationValue = 1.0;
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleDateSelected(DateTime date) {
    _controller.value = date;
  }

  void _handleFinishDrag() async {
    _captureOffset = null;

    if (_animationController.value > 0.5) {
      await _animationController.forward();
      _animationValue = 1.0;
    } else {
      await _animationController.reverse();
      _animationValue = 0.0;
    }

    setState(() {
      _weekView.value = _animationValue < 1.0;
    });
  }

  void _handleTodayPressed() {
    _controller.value = _todayDate;

    if (!_weekView.value) {
      _monthPageController.jumpToPage(6);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _monthPageController.dispose();

    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }
}
