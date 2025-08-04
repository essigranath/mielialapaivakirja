import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/mood_entry.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  List<MoodEntry> _filteredEntries = [];
  bool isWeekly = true;

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  void _loadEntries() {
    final box = Hive.box<MoodEntry>('moods');
    final now = DateTime.now();

    final fromDate = isWeekly
        ? now.subtract(const Duration(days: 6))
        : now.subtract(const Duration(days: 29));

    final entries = box.values.where((entry) {
      return entry.date.isAfter(fromDate.subtract(const Duration(days: 1))) &&
          entry.date.isBefore(now.add(const Duration(days: 1)));
    }).toList();

    setState(() {
      _filteredEntries = entries;
    });
  }

  List<BarChartGroupData> _buildBarData() {
    List<BarChartGroupData> data = [];

    final now = DateTime.now();
    final dayCount = isWeekly ? 7 : 30;

    return List.generate(dayCount, (i) {
      final day = now.subtract(Duration(days: dayCount - 1 - i));
      final entriesForDay = _filteredEntries.where(
        (entry) =>
            entry.date.year == day.year &&
            entry.date.month == day.month &&
            entry.date.day == day.day,
      );

      double averageMood = 0;
      if (entriesForDay.isNotEmpty) {
        averageMood =
            entriesForDay.map((e) => e.mood).reduce((a, b) => a + b) /
            entriesForDay.length;
      }

      final isDark = Theme.of(context).brightness == Brightness.dark;

      final primaryColor = isDark
          ? const Color.fromARGB(255, 112, 60, 85)
          : const Color.fromARGB(255, 225, 142, 183);

      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: averageMood,
            width: isWeekly ? 15 : 7,
            borderRadius: BorderRadius.circular(4),
            color: primaryColor,
          ),
        ],
      );
    });
  }

  String _emojiForMood(double value) {
    if (value >= 4.5) return '😄';
    if (value >= 3.5) return '😊';
    if (value >= 2.5) return '😐';
    if (value >= 1.5) return '😟';
    if (value > 0) return '😢';
    return '❓';
  }

  @override
  Widget build(BuildContext context) {
    final moodAvg = _filteredEntries.isEmpty
        ? 0
        : _filteredEntries.map((e) => e.mood).reduce((a, b) => a + b) /
              _filteredEntries.length;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = isDark
        ? const Color.fromARGB(255, 99, 61, 79)
        : const Color.fromARGB(255, 224, 151, 187);

    final secondaryColor = isDark
        ? const Color.fromARGB(255, 235, 197, 215)
        : const Color.fromARGB(255, 255, 236, 245);

    final thirdColor = isDark
        ? const Color.fromARGB(255, 89, 46, 67)
        : const Color.fromARGB(255, 229, 153, 191);

    final fourthColor = isDark
        ? const Color.fromARGB(255, 168, 94, 129)
        : const Color.fromARGB(255, 197, 89, 143);

    final fifthColor = isDark
        ? const Color.fromARGB(255, 124, 64, 86)
        : const Color.fromARGB(255, 216, 116, 171);

    return Scaffold(
      appBar: AppBar(title: const Text('Tilastosi')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ToggleButtons(
              isSelected: [isWeekly, !isWeekly],
              onPressed: (index) {
                setState(() {
                  isWeekly = index == 0;
                  _loadEntries();
                });
              },
              color: fourthColor,
              selectedColor: secondaryColor,
              fillColor: fifthColor,
              borderColor: fifthColor,
              selectedBorderColor: fifthColor,
              constraints: const BoxConstraints(minHeight: 40, minWidth: 80),
              borderRadius: BorderRadius.circular(50),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Viikko'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('Kuukausi'),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: thirdColor,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  'Keskimääräinen mielialasi on ollut ${_emojiForMood(moodAvg.toDouble())}',
                  style: TextStyle(fontSize: 18, color: secondaryColor),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 15),
              child: Text(
                'Merkintöjä yhteensä ${_filteredEntries.length}',
                style: TextStyle(fontSize: 16, color: fourthColor),
              ),
            ),

            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: BarChart(
                BarChartData(
                  maxY: 6,
                  minY: 0,
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    drawHorizontalLine: true,
                    horizontalInterval: 1,
                    verticalInterval: 1,
                    getDrawingHorizontalLine: (value) =>
                        FlLine(color: primaryColor, strokeWidth: 1),
                    getDrawingVerticalLine: (value) =>
                        FlLine(color: primaryColor, strokeWidth: 1),
                  ),
                  borderData: FlBorderData(show: true),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                        getTitlesWidget: (value, meta) {
                          const moodEmojis = {
                            1: '😢',
                            2: '😟',
                            3: '😐',
                            4: '🙂',
                            5: '😄',
                          };
                          if (value % 1 != 0 ||
                              !moodEmojis.containsKey(value.toInt())) {
                            return const SizedBox.shrink();
                          }

                          return Text(
                            moodEmojis[value.toInt()]!,
                            style: const TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          );
                        },
                        interval: 1,
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, _) {
                          final now = DateTime.now();
                          final dayCount = isWeekly ? 7 : 30;
                          final date = now.subtract(
                            Duration(days: dayCount - 1 - value.toInt()),
                          );
                          if (isWeekly || value.toInt() % 3 == 0) {
                            return Text(
                              '${date.day}.${date.month}.',
                              style: const TextStyle(fontSize: 10),
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  barGroups: _buildBarData(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
