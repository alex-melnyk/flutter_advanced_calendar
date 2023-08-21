part of 'widget.dart';

class Header extends StatelessWidget {
  Header({
    Key? key,
    required this.monthDate,
    this.margin = const EdgeInsets.only(
      left: 16.0,
      right: 8.0,
      top: 4.0,
      bottom: 4.0,
    ),
    this.dateStyle,
    this.todayStyle,
    this.child,
    this.onPressed,
    this.localeID = 'en_US',
  })  : _dateFormatter = DateFormat.yMMMM(localeID),
        super(key: key);

  /// The date formatter to use for the header.
  late final DateFormat _dateFormatter;

  /// The locale to use for the header.
  final String localeID;

  /// The date to display in the header.
  final DateTime monthDate;

  /// The margin to use for the header.
  final EdgeInsetsGeometry margin;

  /// The style to use for the date.
  final TextStyle? dateStyle;

  /// The style to use for the today button.
  final TextStyle? todayStyle;

  /// The child to display in the header.
  final Widget? child;

  /// The callback that is called when the today button is pressed.
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin,
      child: Row(
        children: [
          Text(
            _dateFormatter.format(monthDate),
            style: dateStyle ?? theme.textTheme.subtitle1!,
          ),
          if (child != null) child!,
          const Spacer(),
          InkWell(
            onTap: onPressed,
            borderRadius: const BorderRadius.all(
              Radius.circular(4.0),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 4.0,
              ),
              child: Text(
                'Today',
                style: todayStyle ?? theme.textTheme.subtitle1!,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
