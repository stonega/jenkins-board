import 'dart:async';

class Throttle {
  final Duration? delay;
  Timer? _timer;

  Throttle({this.delay});

  void call(void Function() action) {
    if (isRunning) return;
    _timer = Timer(delay!, () {});
    action();
  }

  /// Notifies if the delayed call is active.
  bool get isRunning => _timer?.isActive ?? false;

  /// Cancel the current delayed call.
  void cancel() => _timer?.cancel();
}
