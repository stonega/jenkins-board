import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jenkins_board/utils/extensions.dart';

class SettingWrapper extends StatelessWidget {
  final Widget child;
  final VoidCallback onClose;
  const SettingWrapper({required this.child, required this.onClose, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            color: Colors.grey.shade200.withOpacity(0.5),
            padding: const EdgeInsets.only(top: 50),
            child: child,
          ),
          Positioned(
            bottom: 0,
            child: Container(
              height: 80,
              width: context.width,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[Colors.white10, Colors.white],
                  tileMode: TileMode.repeated,
                ),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: onClose,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: context.accentColor,
                    child: const Icon(Icons.close),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
