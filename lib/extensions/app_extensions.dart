extension ExInt on int {
  String get formatTwoDigits {
    return this < 10 ? '0$this' : '$this';
  }
}

extension ExDuration on Duration? {
  String get formatDuration {
    if (this == null) {
      return '00:00:00';
    } else {
      return '${this?.inHours.remainder(60).formatTwoDigits}:${this?.inMinutes.remainder(60).formatTwoDigits}:${this?.inSeconds.remainder(60).formatTwoDigits}';
    }
  }
}
