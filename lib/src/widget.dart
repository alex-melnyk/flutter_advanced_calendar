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

  MonthViewBean _generateMonthViewDate(DateTime baseDate, int month) {
    final firstMonthDate = DateTime(baseDate.year, month, 1);
    final firstViewDate = firstMonthDate.subtract(Duration(
      days: firstMonthDate.weekday,
    ));

    return MonthViewBean(
      firstMonthDate,
      List.generate(
        42,
        (index) => firstViewDate.add(Duration(days: index)).toZeroTime(),
        growable: false,
      ),
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
          },
          onVerticalDragUpdate: (details) {
            final moveOffset = details.globalPosition;

            final diff = moveOffset - _captureOffset;

            _animationController.value = _animationValue + diff.dy / 200;
          },
          onVerticalDragEnd: (details) => _handleFinishDrag(),
          onVerticalDragCancel: () => _handleFinishDrag(),
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
                builder: (context, child) {
                  final height = Tween<double>(
                    begin: monthViewWeekHeight,
                    end: monthViewWeekHeight * 6.0,
                  ).transform(_animationController.value);

                  return SizedBox(
                    height: height,
                    child: PageView.builder(
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
                        return ValueListenableBuilder<DateTime>(
                          valueListenable: _controller,
                          builder: (_, selectedDate, __) {
                            return MonthView(
                              monthView: _monthViews[pageIndex],
                              todayDate: _todayDate,
                              selectedDate: selectedDate,
                              onChanged: (date) {
                                _controller.value = date;
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
    );
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
  }

  void _handleTodayPressed() {
    _controller.value = _todayDate;
    _pageController.jumpToPage(6);
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
