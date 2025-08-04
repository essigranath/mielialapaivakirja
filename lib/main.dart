import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'models/mood_entry.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(MoodEntryAdapter());
  await Hive.openBox<MoodEntry>('moods');

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Mielialapäiväkirja',
      themeMode: themeProvider.themeMode,

      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color.fromARGB(255, 246, 200, 225),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 225, 159, 191),
          foregroundColor: const Color.fromARGB(255, 255, 255, 255),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 216, 143, 178),
          foregroundColor: Colors.white,
          elevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            side: BorderSide(
              color: Color.fromARGB(255, 252, 209, 230),
              width: 4,
            ),
          ),
        ),
      ),

      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.pink,
        scaffoldBackgroundColor: const Color.fromARGB(255, 60, 32, 42),
        appBarTheme: AppBarTheme(
          backgroundColor: const Color.fromARGB(255, 50, 27, 36),
          foregroundColor: Colors.white,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color.fromARGB(255, 50, 27, 36),
          foregroundColor: Colors.white,
          elevation: 0,
          hoverElevation: 0,
          highlightElevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            side: BorderSide(color: Color.fromARGB(255, 86, 56, 71), width: 4),
          ),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
