part of 'widget.dart';

class WeekView extends StatelessWidget {
  WeekView({
    Key key,
    @required this.dates,
    @required this.selectedDate,
    this.highlightMonth,
    this.onChanged,
  }) : super(key: key);

  final DateTime todayDate = DateTime.now().toZeroTime();
  final List<DateTime> dates;
  final int highlightMonth;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 1.0,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List<Widget>.generate(
          7,
          (dayIndex) {
            final date = dates[dayIndex];

            final isToday = date.isAtSameMomentAs(todayDate);
            final isSelected = date.isAtSameMomentAs(selectedDate);
            final isHighlight =
                highlightMonth == null ? true : date.month == highlightMonth;

            return Column(
              children: [
                DateBox(
                  onPressed: onChanged != null ? () => onChanged(date) : null,
                  color: isSelected
                      ? theme.primaryColor
                      : isToday
                          ? Colors.orange
                          : null,
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      color: isSelected || isToday
                          ? theme.colorScheme.onPrimary
                          : isHighlight
                              ? null
                              : theme.disabledColor,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 2.0,
                  ),
                  width: 4.0,
                  height: 4.0,
                  decoration: BoxDecoration(
                    // color: theme.indicatorColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            );
          },
          growable: false,
        ),
      ),
    );
  }
}
