import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/mood_entry.dart';
import 'package:provider/provider.dart';
import '../theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _resetData(BuildContext context) async {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final confirmed = await showDialog<bool>(
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
            title: const Text('Nollaa kaikki tiedot'),
            content: const Text('Haluatko varmasti poistaa kaikki merkinnät?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Peruuta'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDarkMode
                      ? const Color.fromARGB(255, 83, 37, 60)
                      : const Color.fromARGB(255, 230, 115, 173),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Nollaa'),
              ),
            ],
          ),
        );
      },
    );

    if (confirmed == true) {
      final box = Hive.box<MoodEntry>('moods');
      await box.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kaikki tiedot on poistettu.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Asetukset')),
      body: ListView(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color.fromARGB(255, 86, 42, 61)
                  : const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: const Text('Nollaa kaikki merkinnät'),
              onTap: () => _resetData(context),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
            decoration: BoxDecoration(
              color: isDarkMode
                  ? const Color.fromARGB(255, 86, 42, 61)
                  : const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: const Text('Vaihda teema'),
              trailing: const Icon(Icons.brightness_6),
              onTap: () {
                final themeProvider = Provider.of<ThemeProvider>(
                  context,
                  listen: false,
                );
                final isDark = themeProvider.themeMode == ThemeMode.dark;
                themeProvider.toggleTheme(!isDark);
              },
            ),
          ),
        ],
      ),
    );
  }
}
