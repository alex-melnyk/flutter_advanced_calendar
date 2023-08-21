part of 'widget.dart';

/// Week day names line.
class WeekDays extends StatelessWidget {
  const WeekDays({
    Key? key,
    required this.weekNames,
    this.style,
  })  : assert(weekNames.length == 7, '`weekNames` must have length 7'),
        super(key: key);

  /// Week day names.
  final List<String> weekNames;

  /// Text style.
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: style!,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(weekNames.length, (index) {
          return DateBox(
            child: Text(weekNames[index]),
          );
        }),
      ),
    );
  }
}
