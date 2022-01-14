import 'package:flutter/material.dart';

class RunningWidget extends StatefulWidget {
  const RunningWidget({Key? key}) : super(key: key);

  @override
  _RunningWidgetState createState() => _RunningWidgetState();
}

class _RunningWidgetState extends State<RunningWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _tween = Tween<double>(begin: 0.8, end: 1.2);
  late double _scale;

  @override
  void initState() {
    super.initState();
    _scale = 1.0;
    _controller = AnimationController(
        duration: const Duration(milliseconds: 800), vsync: this)
      ..addListener(() {
        setState(() => _scale = _tween.animate(_controller).value);
      });
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _scale,
      child: const CircleAvatar(
        radius: 6,
        backgroundColor: Colors.cyan,
      ),
    );
  }
}
