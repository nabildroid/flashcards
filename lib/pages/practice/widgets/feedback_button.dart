import 'package:flutter/material.dart';

class FeedbackButton extends StatelessWidget {
  final Function onPressed;
  final List<Color> colors;
  final String label;
  final bool enabled;
  const FeedbackButton({
    Key? key,
    required this.onPressed,
    required this.colors,
    required this.label,
    required this.enabled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: enabled ? 0.0 : 1.0, end: !enabled ? 1.0 : 0.0),
      duration: Duration(milliseconds: 350),
      builder: (ctx, value, child) => Container(
        width: 70,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 3,
              offset: const Offset(1, 2),
              spreadRadius: 1,
            )
          ],
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              ColorTween(begin: colors[0], end: Color(0xFF5D7D9A)).lerp(value)!,
              ColorTween(begin: colors[1], end: Color(0xFF5D7D9A)).lerp(value)!
            ],
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: SizedBox.expand(
          child: Material(
            color: Colors.transparent,
            child: IgnorePointer(
              ignoring: value == 1,
              child: InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () => onPressed(),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                  child: Center(
                    child: Text(
                      label,
                      style: Theme.of(context).textTheme.button?.copyWith(
                            color: Colors.white,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
