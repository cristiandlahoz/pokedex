import '../../../domain/entities/pokemon_ability.dart';

class AbilitiesParser {
  static List<PokemonAbility> parse(dynamic abilitiesData) {
    if (abilitiesData == null || abilitiesData is! List) return [];

    final abilities = <PokemonAbility>[];

    for (final abilityData in abilitiesData) {
      if (abilityData is! Map) continue;
      if (abilityData['ability'] == null) continue;
      if (abilityData['ability']['name'] == null) continue;

      String? effect;
      final flavorTexts = abilityData['ability']['abilityflavortexts'] as List?;
      if (flavorTexts != null && flavorTexts.isNotEmpty) {
        effect = (flavorTexts[0]['flavor_text'] as String?)
            ?.replaceAll('\n', ' ')
            .replaceAll('\f', ' ');
      }

      abilities.add(
        PokemonAbility(
          id: abilityData['ability']['id'] as int,
          name: abilityData['ability']['name'] as String,
          isHidden: abilityData['is_hidden'] as bool? ?? false,
          effect: effect,
        ),
      );
    }

    return abilities;
  }
}
