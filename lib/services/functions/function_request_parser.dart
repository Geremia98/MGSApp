int parseDateTimeToSerializable(DateTime date) =>
    date.toUtc().millisecondsSinceEpoch;

DateTime parseRequestDateIntoDateTime(Map<Object?, Object?> date) {
  return DateTime.fromMillisecondsSinceEpoch(
    int.parse(date['_seconds'].toString()) * 1000 +
        int.parse(date['_nanoseconds'].toString()) ~/ 1000000,
  );
}
