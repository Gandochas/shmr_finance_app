String formatDate({required DateTime date, bool withYear = true}) {
  final day = date.day < 10 ? '0${date.day}' : '${date.day}';
  final month = date.month < 10 ? '0${date.month}' : '${date.month}';
  final year = date.year;
  return withYear ? '$day.$month.$year' : '$day.$month';
}
