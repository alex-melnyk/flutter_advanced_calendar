part of 'widget.dart';

class MonthView extends StatelessWidget {
  const MonthView({
    Key? key,
    required this.monthView,
    required this.todayDate,
    required this.selectedDate,
    required this.weekLineHeight,
    required this.weeksAmount,
    this.onChanged,
  }) : super(key: key);

  final ViewRange monthView;
  final DateTime? todayDate;
  final DateTime selectedDate;
  final double weekLineHeight;
  final int weeksAmount;
  final ValueChanged<DateTime>? onChanged;

  @override
  Widget build(BuildContext context) {
    final index = selectedDate.findWeekIndex(monthView.dates);
    final offset = index / (weeksAmount - 1) * 2 - 1.0;

    return OverflowBox(
      alignment: Alignment(0, offset),
      minHeight: weekLineHeight,
      maxHeight: weekLineHeight * weeksAmount,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
          6,
          (weekIndex) {
            final weekStart = weekIndex * 7;

            return WeekView(
              dates: monthView.dates.sublist(weekStart, weekStart + 7),
              selectedDate: selectedDate,
              highlightMonth: monthView.firstDay.month,
              lineHeight: weekLineHeight,
              onChanged: onChanged,
            );
          },
          growable: false,
        ),
      ),
    );
  }
}
