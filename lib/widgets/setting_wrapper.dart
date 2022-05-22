import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:jenkins_board/utils/extensions.dart';

class SettingWrapper extends StatelessWidget {
  final Widget child;
  final bool showNavBar;
  final VoidCallback? onPre;
  final VoidCallback? onNext;

  const SettingWrapper(
      {required this.child,
      this.showNavBar = false,
      this.onNext,
      this.onPre,
      Key? key})
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (showNavBar)
                    InkWell(
                      onTap: onNext,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: context.accentColor,
                        child: const Icon(Icons.keyboard_arrow_left),
                      ),
                    ),
                  InkWell(
                    onTap: () => context.go('/'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: context.accentColor,
                        child: const Icon(Icons.close),
                      ),
                    ),
                  ),
                  if (showNavBar)
                    InkWell(
                      onTap: onPre,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: context.accentColor,
                        child: const Icon(
                          Icons.keyboard_arrow_right,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
