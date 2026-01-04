class LocationNameNormalizer {
  static String normalize(String apiLocationName) {
    return apiLocationName
        .replaceAll(
          RegExp(
            r'^(kanto|johto|hoenn|sinnoh|unova|kalos|alola|galar|paldea|hisui)-',
          ),
          '',
        )
        .replaceAll(RegExp(r'-(area|zone|main)$'), '');
  }

  static String? findMatchInCoordinates(
    String apiLocationName,
    List<String> availableCoordinateNames,
  ) {
    final normalized = normalize(apiLocationName);

    for (final coordName in availableCoordinateNames) {
      if (coordName == normalized) {
        return coordName;
      }
    }

    final variations = _generateVariations(apiLocationName);
    for (final variation in variations) {
      for (final coordName in availableCoordinateNames) {
        if (coordName == variation) {
          return coordName;
        }
      }
    }

    return null;
  }

  static List<String> _generateVariations(String apiLocationName) {
    final variations = <String>[];

    variations.add(normalize(apiLocationName));

    // Try without directional suffixes
    final withoutDirection = apiLocationName.replaceAll(
      RegExp(r'-(south|north|east|west|ne|nw|se|sw)(-[^-]+)?$'),
      '',
    );
    if (withoutDirection != apiLocationName) {
      variations.add(normalize(withoutDirection));
    }

    // Try without floor/level suffixes
    final withoutFloor = apiLocationName.replaceAll(
      RegExp(r'-(b\d+f|f\d+|1f|2f|3f)(-[^-]+)?$'),
      '',
    );
    if (withoutFloor != apiLocationName) {
      variations.add(normalize(withoutFloor));
    }

    // Try trimming to parent location for deeply nested areas
    if (apiLocationName.split('-').length > 4) {
      final parts = apiLocationName.split('-');
      for (int i = parts.length - 1; i >= 3; i--) {
        final trimmed = parts.take(i).join('-');
        variations.add(normalize(trimmed));
      }
    }

    return variations.toSet().toList();
  }
}
