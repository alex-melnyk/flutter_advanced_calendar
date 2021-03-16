part of 'widget.dart';

class MonthView extends StatelessWidget {
  const MonthView({
    Key key,
    @required this.monthView,
    @required this.todayDate,
    @required this.selectedDate,
    @required this.onChanged,
    this.highlightMonth,
  }) : super(key: key);

  final MonthViewBean monthView;
  final DateTime todayDate;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onChanged;
  final int highlightMonth;

  @override
  Widget build(BuildContext context) {
    final index = selectedDate.findWeekIndex(monthView.dates);
    final offset = (index / 5) * 2;

    return OverflowBox(
      alignment: Alignment(0, offset - 1.0),
      minHeight: monthViewWeekHeight,
      maxHeight: monthViewWeekHeight * 6.0,
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
              onChanged: onChanged,
            );
          },
          growable: false,
        ),
      ),
    );
  }
}
