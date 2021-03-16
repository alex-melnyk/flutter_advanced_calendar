import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'controller.dart';

part 'date_box.dart';

part 'datetime_util.dart';

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
  final _pageController = PageController(initialPage: 6);
  final _currentPage = ValueNotifier<int>(6);
  final _weekView = ValueNotifier<bool>(false);
  AnimationController _animationController;
  AdvancedCalendarController _controller;

  Offset _captureOffset;
  double _animationValue;

  DateTime _todayDate;
  List<MonthViewBean> _monthViews;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
      value: 1.0,
    );

    _animationValue = _animationController.value;

    _todayDate = DateTime.now().toZeroTime();

    _controller = widget.controller ?? AdvancedCalendarController.today();

    _monthViews = List.generate(13, (index) {
      final offset = index - 6;

      return _generateMonthViewDate(_todayDate, _todayDate.month + offset);
    });
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
                      monthDate: _monthViews[_currentPage.value].firstDay,
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
                                    final monthView = _monthViews[pageIndex];

                                    final weekIndex = selectedDate
                                        .findWeekIndex(monthView.dates);

                                    final startIndex = weekIndex * 7;

                                    final selectedWeek = monthView.dates
                                        .sublist(startIndex, startIndex + 7);

                                    return WeekView(
                                      dates: selectedWeek,
                                      selectedDate: selectedDate,
                                      highlightMonth: monthView.firstDay.month,
                                      onChanged: _handleDateSelected,
                                    );
                                  },
                                );
                              }

                              return PageView.builder(
                                controller: _pageController,
                                physics: _animationController.value == 1.0
                                    ? AlwaysScrollableScrollPhysics()
                                    : NeverScrollableScrollPhysics(),
                                pageSnapping: true,
                                onPageChanged: (pageIndex) {
                                  _currentPage.value = pageIndex;
                                },
                                itemCount: _monthViews.length,
                                itemBuilder: (_, pageIndex) {
                                  return MonthView(
                                    monthView: _monthViews[pageIndex],
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

  MonthViewBean _generateMonthViewDate(
    DateTime baseDate,
    int month, [
    int weeksAmount = 6,
  ]) {
    final firstMonthDate = DateTime(baseDate.year, month, 1);
    final firstViewDate = firstMonthDate.subtract(Duration(
      days: firstMonthDate.weekday,
    ));

    return MonthViewBean(
      firstMonthDate,
      List.generate(
        weeksAmount * 7,
        (index) => firstViewDate.add(Duration(days: index)).toZeroTime(),
        growable: false,
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
      _pageController.jumpToPage(6);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();

    if (widget.controller == null) {
      _controller.dispose();
    }

    super.dispose();
  }
}
