part of 'widget.dart';

class HandleBar extends StatelessWidget {
  const HandleBar({
    Key? key,
    this.decoration,
    this.margin = const EdgeInsets.only(
      top: 8.0,
    ),
    this.onPressed,
  }) : super(key: key);

  final BoxDecoration? decoration;
  final EdgeInsetsGeometry margin;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.translucent,
      child: Container(
        margin: margin,
        alignment: Alignment.center,
        child: FractionallySizedBox(
          widthFactor: 0.1,
          child: Container(
            height: 4.0,
            decoration: decoration ??
                BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2.0),
                ),
          ),
        ),
      ),
    );
  }
}
