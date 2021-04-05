part of 'widget.dart';

class WeekView extends StatelessWidget {
  WeekView({
    Key? key,
    required this.dates,
    required this.selectedDate,
    required this.lineHeight,
    this.highlightMonth,
    this.onChanged,
  }) : super(key: key);

  final DateTime todayDate = DateTime.now().toZeroTime();
  final List<DateTime> dates;
  final double lineHeight;
  final int? highlightMonth;
  final DateTime selectedDate;
  final ValueChanged<DateTime>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: lineHeight,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List<Widget>.generate(
          7,
          (dayIndex) {
            final date = dates[dayIndex];

            final isToday = date.isAtSameMomentAs(todayDate);
            final isSelected = date.isAtSameMomentAs(selectedDate);
            final isHighlight =
                highlightMonth == null ? true : date.month == highlightMonth;

            return DateBox(
              onPressed: onChanged != null ? () => onChanged!(date) : null,
              color: isSelected
                  ? theme.primaryColor
                  : isToday
                      ? theme.highlightColor
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
            );
          },
          growable: false,
        ),
      ),
    );
  }
}
