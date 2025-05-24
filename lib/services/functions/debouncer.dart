import 'dart:async';

class Debouncer {

  final Duration _duration;
  final void Function(dynamic) _trigger;
  Timer? _timer;

  Debouncer(this._trigger, this._duration);

  void runFunction() {

    if (_timer != null) _timer!.cancel();

    _timer = Timer(_duration, () async => _trigger);
  }
}