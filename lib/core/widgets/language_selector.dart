import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final String currentLanguageCode;
  final Function(String) onLanguageChanged;

  const LanguageSelector({
    super.key,
    required this.currentLanguageCode,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.language),
      tooltip: 'Change Language',
      onSelected: onLanguageChanged,
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'en',
          child: Row(
            children: [
              const Text('🇺🇸  English'),
              if (currentLanguageCode == 'en')
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.check, size: 18),
                ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'es',
          child: Row(
            children: [
              const Text('🇪🇸  Español'),
              if (currentLanguageCode == 'es')
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.check, size: 18),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
