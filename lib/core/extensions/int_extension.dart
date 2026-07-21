extension IntExtentions on int {
  String toTimeString() {
    final int minutes = this ~/ 60;
    final int seconds = this % 60;
    final String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    final String secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }
}