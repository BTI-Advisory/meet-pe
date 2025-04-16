class CountdownTimer {
  final Duration duration;
  DateTime _startTime = DateTime.fromMillisecondsSinceEpoch(0);

  /// Create a new CountdownTimer. IsElapsed is true.
  CountdownTimer(this.duration);

  CountdownTimer.start(this.duration) {
    restart();
  }

  void restart() {
    _startTime = DateTime.now();
  }

  bool get isElapsed => DateTime.now().difference(_startTime) >= duration;
}