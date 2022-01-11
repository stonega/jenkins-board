import 'package:flutter/material.dart';
import 'package:jenkins_board/utils/extensions.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool loading;
  final Widget? child;
  final Color? backgroundColor;
  const CustomButton(
      {this.onPressed,
      this.child,
      this.loading = false,
      this.backgroundColor,
      key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ButtonStyle(
          enableFeedback: false,
          elevation: MaterialStateProperty.resolveWith<double>((states) {
            return 0;
          }),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 15)),
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          backgroundColor: MaterialStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(MaterialState.disabled)) {
                return const Color(0xffececec);
              } else if (states.contains(MaterialState.pressed)) {
                return backgroundColor?.withOpacity(0.8) ??
                    context.accentColor.withOpacity(0.8);
              }
              return backgroundColor ?? context.accentColor;
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(MaterialState.disabled)) {
                return Colors.black;
              }
              return Colors.white;
            },
          ),
          animationDuration: Duration.zero,
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        onPressed: onPressed,
        clipBehavior: Clip.hardEdge,
        child: child);
  }
}
