import 'package:flutter/material.dart';

class MoodSelector extends StatelessWidget {
  final int selectedMood;
  final ValueChanged<int> onMoodSelected;

  const MoodSelector({
    Key? key,
    required this.selectedMood,
    required this.onMoodSelected,
  }) : super(key: key);

  static const moodEmojis = ['😢', '😐', '🙂', '😊', '😄'];

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(moodEmojis.length, (index) {
        final mood = index + 1;
        final isSelected = selectedMood == mood;

        final backgroundColor = isSelected
            ? (isDarkMode
                  ? const Color.fromARGB(255, 113, 50, 79)
                  : const Color.fromARGB(255, 255, 224, 239))
            : Colors.transparent;

        final emojiColor = isSelected
            ? (isDarkMode ? Colors.white : Colors.orange)
            : (isDarkMode ? Colors.white70 : Colors.black);

        return GestureDetector(
          onTap: () => onMoodSelected(mood),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: backgroundColor,
              shape: BoxShape.circle,
            ),
            child: Text(
              moodEmojis[index],
              style: TextStyle(fontSize: 28, color: emojiColor),
            ),
          ),
        );
      }),
    );
  }
}
