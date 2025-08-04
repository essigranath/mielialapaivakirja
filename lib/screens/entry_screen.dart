import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/mood_entry.dart';
import '../widgets/mood_selector.dart';

class EntryScreen extends StatefulWidget {
  final DateTime selectedDate;
  const EntryScreen({super.key, required this.selectedDate});

  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  int selectedMood = 3;
  late DateTime _entryDate;
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _entryDate = widget.selectedDate;
  }

  Future<void> _selectDate() async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _entryDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: isDarkMode
                ? const ColorScheme.dark(
                    primary: Color.fromARGB(255, 99, 46, 81),
                    onPrimary: Colors.white,
                    surface: Color.fromARGB(255, 60, 28, 41),
                    onSurface: Colors.white,
                  )
                : const ColorScheme.light(
                    primary: Color.fromARGB(255, 199, 97, 146),
                    onPrimary: Colors.white,
                    surface: Color.fromARGB(255, 255, 236, 244),
                    onSurface: Colors.black,
                  ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: isDarkMode
                    ? Colors.white
                    : const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _entryDate) {
      setState(() {
        _entryDate = picked;
      });
    }

    if (picked != null && picked != _entryDate) {
      setState(() {
        _entryDate = picked;
      });
    }
  }

  void _saveEntry() async {
    final mood = MoodEntry(
      date: _entryDate,
      mood: selectedMood,
      note: _noteController.text,
    );

    final box = Hive.box<MoodEntry>('moods');
    await box.add(mood);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = isDark
        ? const Color.fromARGB(255, 100, 49, 73)
        : const Color.fromARGB(255, 235, 139, 183);

    return Scaffold(
      appBar: AppBar(title: const Text('Uusi merkintä')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                const Text('Päivämäärä: ', style: TextStyle(fontSize: 16)),
                TextButton(
                  onPressed: _selectDate,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    color: primaryColor,
                    child: Text(
                      '${_entryDate.toLocal()}'.split(' ')[0],
                      style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Valitse mieliala:', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 8),

            MoodSelector(
              selectedMood: selectedMood,
              onMoodSelected: (value) {
                setState(() {
                  selectedMood = value;
                });
              },
            ),

            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              decoration: const InputDecoration(
                labelText: 'Muistiinpano',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all<Color>(
                  isDark
                      ? const Color.fromARGB(255, 91, 43, 63)
                      : const Color.fromARGB(255, 234, 151, 190),
                ),
              ),
              onPressed: _saveEntry,
              child: const Text(
                'Tallenna',
                style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
