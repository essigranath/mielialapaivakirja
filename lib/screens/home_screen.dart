import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive/hive.dart';
import '../models/mood_entry.dart';
import 'entry_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<MoodEntry> _entriesForSelectedDay = [];

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEntriesForDay(_selectedDay!);
  }

  void _loadEntriesForDay(DateTime day) {
    final box = Hive.box<MoodEntry>('moods');
    final allEntries = box.values.toList();
    final entries = allEntries
        .where(
          (entry) =>
              entry.date.year == day.year &&
              entry.date.month == day.month &&
              entry.date.day == day.day,
        )
        .toList();

    setState(() {
      _entriesForSelectedDay = entries;
    });
  }

  void _onDaySelected(DateTime selected, DateTime focused) {
    setState(() {
      _selectedDay = selected;
      _focusedDay = focused;
    });
    _loadEntriesForDay(selected);
  }

  void _confirmDelete(BuildContext context, MoodEntry entry) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDarkMode
                ? const ColorScheme.dark(
                    primary: Color.fromARGB(255, 157, 79, 130),
                    onPrimary: Colors.white,
                    surface: Color.fromARGB(255, 63, 35, 50),
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: Color.fromARGB(255, 157, 79, 130),
                    onPrimary: Colors.white,
                    surface: Color.fromARGB(255, 255, 231, 239),
                    onSurface: Colors.black,
                  ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: isDarkMode
                    ? Colors.white
                    : const Color(0xFF000000),
              ),
            ),
          ),
          child: AlertDialog(
            title: const Text('Poista merkintä'),
            content: const Text('Haluatko varmasti poistaa tämän merkinnän?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('Peruuta'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await entry.delete();
                  Navigator.of(ctx).pop();
                  _loadEntriesForDay(_selectedDay!);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? const Color.fromARGB(255, 83, 37, 60)
                      : const Color.fromARGB(255, 230, 115, 173),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Poista'),
              ),
            ],
          ),
        );
      },
    );
  }

  static const moodEmojis = ['😢', '🙁', '😐', '😊', '😄'];

  String _getEmojiForMood(int mood) {
    return moodEmojis[mood - 1];
  }

  static const moodLabels = [
    'Erittäin huono',
    'Huono',
    'Neutraali',
    'Hyvä',
    'Erinomainen',
  ];

  String _getMoodLabel(int mood) {
    return moodLabels[mood - 1];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = isDark
        ? const Color.fromARGB(255, 190, 95, 139)
        : const Color.fromARGB(255, 182, 62, 116);

    final secondaryColor = isDark
        ? const Color.fromARGB(255, 85, 48, 67)
        : const Color.fromARGB(255, 239, 157, 198);

    final thirdColor = isDark
        ? const Color.fromARGB(255, 161, 96, 118)
        : const Color.fromARGB(255, 230, 94, 168);

    final fourthColor = isDark
        ? const Color.fromARGB(255, 76, 40, 57)
        : const Color.fromARGB(255, 241, 176, 209);

    final fifthColor = isDark
        ? const Color.fromARGB(255, 159, 90, 116)
        : const Color.fromARGB(255, 236, 125, 186);

    return Scaffold(
      appBar: AppBar(title: const Text('Mielialapäiväkirja')),
      body: Column(
        children: [
          TableCalendar(
            calendarFormat: CalendarFormat.month,
            availableCalendarFormats: const {CalendarFormat.month: 'Kuukausi'},
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) =>
                _selectedDay != null &&
                day.year == _selectedDay!.year &&
                day.month == _selectedDay!.month &&
                day.day == _selectedDay!.day,
            onDaySelected: _onDaySelected,

            calendarStyle: CalendarStyle(
              defaultDecoration: BoxDecoration(
                color: secondaryColor,
                shape: BoxShape.circle,
              ),
              weekendDecoration: BoxDecoration(
                color: fourthColor,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: secondaryColor,
                shape: BoxShape.circle,
                border: Border.all(color: thirdColor, width: 2),
              ),
              selectedDecoration: BoxDecoration(
                color: fifthColor,
                shape: BoxShape.circle,
              ),
              defaultTextStyle: TextStyle(color: primaryColor),
              weekendTextStyle: TextStyle(color: thirdColor),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
              weekendStyle: TextStyle(color: primaryColor),
            ),
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              titleTextStyle: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _entriesForSelectedDay.isEmpty
                ? const Center(child: Text('Ei merkintöjä tälle päivälle'))
                : ListView.builder(
                    itemCount: _entriesForSelectedDay.length,
                    itemBuilder: (context, index) {
                      final entry = _entriesForSelectedDay[index];
                      return ListTile(
                        leading: Text(
                          _getEmojiForMood(entry.mood),
                          style: const TextStyle(fontSize: 28),
                        ),
                        title: Text(
                          'Päivän fiilis: ${_getMoodLabel(entry.mood)}',
                        ),
                        subtitle: Text(entry.note),
                        trailing: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: isDark
                                ? const Color.fromARGB(255, 100, 49, 73)
                                : const Color.fromARGB(255, 224, 127, 172),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            'Poista',
                            style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                          onPressed: () => _confirmDelete(context, entry),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      EntryScreen(selectedDate: _selectedDay ?? DateTime.now()),
                ),
              ).then((_) => _loadEntriesForDay(_selectedDay!));
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'stats',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const StatsScreen()),
              );
            },
            child: const Icon(Icons.bar_chart),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            heroTag: 'settings',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            child: const Icon(Icons.settings),
          ),
        ],
      ),
    );
  }
}
