class SpeciesParser {
  static SpeciesInfo parse(Map<String, dynamic>? speciesJson) {
    if (speciesJson == null) return SpeciesInfo.empty();

    String? genus;
    final genera = speciesJson['pokemonspeciesnames'] as List?;
    if (genera != null && genera.isNotEmpty) {
      genus = genera[0]['genus'] as String?;
    }

    String? description;
    final descriptions = speciesJson['pokemonspeciesflavortexts'] as List?;
    if (descriptions != null && descriptions.isNotEmpty) {
      description = (descriptions[0]['flavor_text'] as String?)
          ?.replaceAll('\n', ' ')
          .replaceAll('\f', ' ');
    }

    return SpeciesInfo(
      genus: genus,
      description: description,
      captureRate: speciesJson['capture_rate'] as int?,
      baseHappiness: speciesJson['base_happiness'] as int?,
      growthRate: speciesJson['growthrate']?['name'] as String?,
      genderRatio: speciesJson['gender_rate'] as int?,
    );
  }
}

class SpeciesInfo {
  final String? genus;
  final String? description;
  final int? captureRate;
  final int? baseHappiness;
  final String? growthRate;
  final int? genderRatio;

  const SpeciesInfo({
    this.genus,
    this.description,
    this.captureRate,
    this.baseHappiness,
    this.growthRate,
    this.genderRatio,
  });

  static SpeciesInfo empty() => const SpeciesInfo();
}
