import 'package:flutter/material.dart';

class ToastWidget extends StatelessWidget {
  final String text;
  final IconData? icon;
  const ToastWidget(this.text, {this.icon, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.greenAccent,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon!),
          if (icon != null)
            const SizedBox(
              width: 12.0,
            ),
          Text(text),
        ],
      ),
    );
  }
}
