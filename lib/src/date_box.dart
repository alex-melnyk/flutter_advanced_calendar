part of 'widget.dart';

/// Unit of calendar.
class DateBox extends StatelessWidget {
  const DateBox({
    Key? key,
    required this.child,
    this.color,
    this.width = 24.0,
    this.height = 24.0,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.onPressed,
    this.showDot = false,
    this.isSelected = false,
    this.isToday = false,
    this.hasEvent = false,
  }) : super(key: key);

  /// Child widget.
  final Widget child;

  /// Background color.
  final Color? color;

  /// Widget width.
  final double width;

  /// Widget height.
  final double height;

  /// Container border radius.
  final BorderRadius borderRadius;

  /// Pressed callback function.
  final VoidCallback? onPressed;

  /// Show DateBox event in container.
  final bool showDot;

  /// DateBox is today.
  final bool isToday;

  /// DateBox selection.
  final bool isSelected;

  /// Show event in DateBox.
  final bool hasEvent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return UnconstrainedBox(
      alignment: Alignment.center,
      child: InkResponse(
        onTap: onPressed,
        radius: 16.0,
        borderRadius: borderRadius,
        highlightShape: BoxShape.rectangle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: width,
          height: height,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? theme.primaryColor
                : isToday
                    ? theme.highlightColor
                    : null,
            borderRadius: borderRadius,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              child,
              if (showDot && hasEvent)
                Container(
                  margin: const EdgeInsets.all(2.0),
                  height: 4,
                  width: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.secondary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
