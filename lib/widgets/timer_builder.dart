import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jenkins_board/utils/extensions.dart';

class TimerBuilder extends StatefulWidget {
  const TimerBuilder({required this.startTime, Key? key}) : super(key: key);
  final DateTime startTime;

  @override
  _TimerBuilderState createState() => _TimerBuilderState();
}

class _TimerBuilderState extends State<TimerBuilder> {
  late Timer _timer;
  String _sinceString = '';
  @override
  void initState() {
    super.initState();
    _initTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text('Build time:'),
        const SizedBox(
          width: 10,
        ),
        Text(_sinceString),
      ],
    );
  }

  _initTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        final since = DateTime.now().difference(widget.startTime);
        setState(() {
          _sinceString = since.inSeconds.toTime;
        });
      },
    );
  }
}
