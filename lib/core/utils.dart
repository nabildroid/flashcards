int dateInDays(DateTime date) {
  return date.difference(DateTime(-1)).inDays;
}

String monthDayFromDate(DateTime date) {
  final month = [
    "jan",
    "fev",
    "mar",
    "apr",
    "mai",
    "jun",
    "jul",
    "aug",
    "sep",
    "oct",
    "nov",
    "dec"
  ][date.month - 1];

  return date.day.toString() + " " + month;
}

String minutesHoursFrom(DateTime start) {
  final now = DateTime.now();
  final diff = start.difference(now).abs();
  const sessionDuration = 60 * 5;
  final seconds = (sessionDuration - diff.inSeconds).abs();
  final s = (seconds < sessionDuration ? seconds : 0) % 60;
  final m = ((seconds < sessionDuration ? seconds : 0) / 60).floor();

  final str = (m > 9 ? m.toString() : "0" + m.toString()) +
      ":" +
      (s > 9 ? s.toString() : "0" + s.toString());
  return str;
}

List<String> mergeUniquely(List<String> a, List<String> b) {
  final s = <String>{};

  s.addAll([...a, ...b]);

  return s.toList();
}
