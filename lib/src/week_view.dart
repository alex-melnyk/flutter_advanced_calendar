part of 'widget.dart';

class WeekView extends StatelessWidget {
  WeekView({
    Key? key,
    required this.dates,
    required this.selectedDate,
    required this.lineHeight,
    this.highlightMonth,
    this.onChanged,
    required this.event,
  }) : super(key: key);

  final DateTime todayDate = DateTime.now().toZeroTime();
  final List<DateTime> dates;
  final double lineHeight;
  final int? highlightMonth;
  final DateTime selectedDate;
  final ValueChanged<DateTime>? onChanged;
  final List<DateTime>? event;
  // final List<DateTime> eventt = [
  //   DateTime.utc(2021, 08, 10, 12),
  //   DateTime.utc(2021, 08, 11, 12)
  // ];
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

            return Column(
              children: [
                DateBox(
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
                ),
                for (var list in event ?? [])
                  list == date
                      ? Container(
                          height: 6,
                          width: 6,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: theme.primaryColor))
                      : SizedBox(),
              ],
            );
          },
          growable: false,
        ),
      ),
    );
  }
}
