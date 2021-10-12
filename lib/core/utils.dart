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
