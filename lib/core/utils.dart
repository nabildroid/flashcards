List<DateTime> uniqueDates(List<DateTime> dates) {
  final s = Map<String, DateTime>();

  dates.forEach((date) {
    final str = "${date.day}-${date.month}-${date.year}";
    s.putIfAbsent(str, () => date);
  });

  return s.values.toList();
}

int dateInDays(DateTime date) {
  // todo some month have 31 days :o
  return date.day + date.month * 30 + date.year * 365;
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
