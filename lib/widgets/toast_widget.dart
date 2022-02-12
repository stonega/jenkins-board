import 'package:flutter/material.dart';
import 'package:jenkins_board/utils/extensions.dart';

class ToastWidget extends StatelessWidget {
  final String text;
  final IconData? icon;
  const ToastWidget(this.text, {this.icon, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                offset: const Offset(2, 2),
                color: Colors.black.withOpacity(0.05),
                blurRadius: 5,
                spreadRadius: 5)
          ],
          color: Colors.greenAccent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null)
              Icon(
                icon!,
                size: 20,
              ),
            if (icon != null)
              const SizedBox(
                width: 8.0,
              ),
            Text(
              text,
              style: context.bodyText1
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
      tween: Tween<double>(begin: 1.0, end: 0),
      builder: (context, fraction, child) {
        return Transform.translate(
          offset: const Offset(0, 100) * fraction,
          child: Opacity(opacity: 1 - fraction, child: child),
        );
      },
      duration: const Duration(milliseconds: 500),
    );
  }
}
