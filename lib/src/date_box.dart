part of 'widget.dart';

class DateBox extends StatelessWidget {
  const DateBox({
    Key key,
    @required this.child,
    this.color,
    this.onPressed,
  }) : super(key: key);

  final Widget child;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    const borderRadius = const BorderRadius.all(Radius.circular(8.0));

    return UnconstrainedBox(
      alignment: Alignment.center,
      child: InkResponse(
        onTap: onPressed,
        radius: 16.0,
        borderRadius: borderRadius,
        highlightShape: BoxShape.rectangle,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 150),
          width: 24.0,
          height: 24.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: color,
            borderRadius: borderRadius,
          ),
          child: child,
        ),
      ),
    );
  }
}
