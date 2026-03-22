class StreakDay {
  final DateTime date;
  final int minutesStudied;

  StreakDay({required this.date, required this.minutesStudied});

  bool get isCompleted => minutesStudied >= 10;

  factory StreakDay.fromJson(Map<String, dynamic> json) {
    return StreakDay(
      date: DateTime.parse(json['date']),
      minutesStudied: json['minutesStudied'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date.toIso8601String(), 'minutesStudied': minutesStudied};
  }
}
