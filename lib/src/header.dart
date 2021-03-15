part of 'widget.dart';

class Header extends StatelessWidget {
  const Header({
    Key key,
    this.monthDate,
    this.margin = const EdgeInsets.only(
      left: 16.0,
      right: 8.0,
      top: 4.0,
      bottom: 4.0,
    ),
    this.onPressed,
  }) : super(key: key);

  static final _dateFormatter = DateFormat().add_yMMMM();
  final DateTime monthDate;
  final EdgeInsetsGeometry margin;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: margin,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _dateFormatter.format(monthDate),
            style: TextStyle(
              color: theme.primaryColor,
            ),
          ),
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
                style: TextStyle(
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
