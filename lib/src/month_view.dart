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
    final theme = Theme.of(context);

    final index = monthView.dates.indexWhere((day) => day == selectedDate) ~/ 7;
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
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List<Widget>.generate(
                  7,
                  (dayIndex) {
                    final day = monthView.dates[dayIndex + (weekIndex * 7)];

                    final isToday = day.isAtSameMomentAs(todayDate);
                    final isSelected = day.isAtSameMomentAs(selectedDate);
                    final isHighlight = day.month == monthView.firstDay.month;

                    return DateBox(
                      onPressed: () => onChanged(day),
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: isSelected || isToday
                              ? Colors.white
                              : isHighlight
                                  ? null
                                  : theme.hintColor,
                        ),
                      ),
                      color: isSelected
                          ? theme.primaryColor
                          : isToday
                              ? Colors.orangeAccent
                              : null,
                    );
                  },
                  growable: false,
                ),
              ),
            );
          },
          growable: false,
        ),
      ),
    );
  }
}
