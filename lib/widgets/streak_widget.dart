import 'package:flutter/material.dart';
import 'package:learning_app/models/streak_modal.dart';

class StreakWidget extends StatelessWidget {
  final List<StreakDay> streakData;

  const StreakWidget({super.key, required this.streakData});

  @override
  Widget build(BuildContext context) {
    final Map<String, StreakDay> streakMap = {
      for (var day in streakData) _formatDate(day.date): day,
    };

    final today = DateTime.now();
    final daysInMonth = DateTime(today.year, today.month + 1, 0).day;

    final int totalWeeks = (daysInMonth / 7).ceil();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "    Streak",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),

        Row(
          children: [
            const SizedBox(width: 50),
            Expanded(
              child: GridView.count(
                crossAxisCount: 7,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  Center(child: Text("S")),
                  Center(child: Text("M")),
                  Center(child: Text("T")),
                  Center(child: Text("W")),
                  Center(child: Text("T")),
                  Center(child: Text("F")),
                  Center(child: Text("S")),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),
        ...List.generate(totalWeeks, (weekIndex) {
          final startDay = weekIndex * 7 + 1;
          final endDay = (startDay + 6 > daysInMonth)
              ? daysInMonth
              : startDay + 6;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                  child: Text(
                    "$startDay-$endDay",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          crossAxisSpacing: 9,
                          mainAxisSpacing: 2,
                        ),
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      final dayNumber = startDay + index;
                      if (dayNumber > daysInMonth) {
                        return const SizedBox();
                      }
                      final date = DateTime(today.year, today.month, dayNumber);
                      final key = _formatDate(date);
                      final isCompleted = streakMap[key]?.isCompleted ?? false;
                      return Center(
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isCompleted
                                ? Colors.orange
                                : Colors.grey.shade300,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  String _getDayLetter(DateTime date) {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    return days[date.weekday % 7];
  }
}
