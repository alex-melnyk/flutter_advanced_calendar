part of 'widget.dart';


class WeekView extends StatelessWidget {
  WeekView({
    Key? key,
    required this.dates,
    required this.selectedDate,
    required this.lineHeight,
    this.highlightMonth,
    this.onChanged,
    this.events,
    this.selectedDayColor,
    this.todayColor
  }) : super(key: key);

  final DateTime todayDate = DateTime.now().toZeroTime();
  final List<DateTime> dates;
  final double lineHeight;
  final int? highlightMonth;
  final DateTime selectedDate;
  final ValueChanged<DateTime>? onChanged;
  final List<DateTime>? events;
  final Color? selectedDayColor;
  final Color? todayColor;


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DateBox(
                  onPressed: (){
                    if(isHighlight && onChanged != null){
                      return onChanged!(date);
                    }
                  },
                  color: isSelected
                      ?  selectedDayColor ?? theme.primaryColor
                      : isToday
                          ? todayColor ?? theme.highlightColor
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
                Column(
                  children: List<Widget>.generate(
                      events != null ? events!.length : 0,
                      (index) => events![index].isSameDate(date)
                          ? Container(
                              height: 6,
                              width: 6,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Theme.of(context).primaryColor))
                          : const SizedBox()),
                )
              ],
            );
          },
          growable: false,
        ),
      ),
    );
  }
}
