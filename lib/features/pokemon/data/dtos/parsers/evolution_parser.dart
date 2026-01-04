import '../../../domain/entities/evolution_chain.dart';
import '../../../domain/entities/evolution_requirement.dart';
import '../../../domain/entities/evolution_species.dart';
import '../../../domain/entities/pokemon_types.dart';
import '../list_item_dto.dart';

class EvolutionParser {
  static EvolutionChain? parse(dynamic pokemonSpecyData) {
    if (pokemonSpecyData == null) return null;

    final evolutionChainData = pokemonSpecyData['evolutionchain'];
    if (evolutionChainData == null) return null;

    final chainId = evolutionChainData['id'] as int?;
    if (chainId == null) return null;

    final speciesList = evolutionChainData['pokemonspecies'] as List?;
    if (speciesList == null || speciesList.isEmpty) return null;

    final parsedSpecies = <EvolutionSpecies>[];

    for (final speciesData in speciesList) {
      if (speciesData is! Map<String, dynamic>) continue;
      final parsed = _parseSpecies(speciesData);
      if (parsed != null) {
        parsedSpecies.add(parsed);
      }
    }

    if (parsedSpecies.isEmpty) return null;

    return EvolutionChain(chainId: chainId, species: parsedSpecies);
  }

  static EvolutionSpecies? _parseSpecies(Map<String, dynamic> data) {
    final speciesId = data['id'] as int?;
    final speciesName = data['name'] as String?;

    if (speciesId == null || speciesName == null) return null;

    final pokemonsList = data['pokemons'] as List?;
    final pokemonData = pokemonsList?.isNotEmpty == true
        ? pokemonsList!.first as Map<String, dynamic>?
        : null;

    int? pokemonId;
    String? pokemonName;
    String? imageUrl;
    List<PokemonTypes> types = [];

    if (pokemonData != null) {
      pokemonId = pokemonData['id'] as int?;
      pokemonName = pokemonData['name'] as String?;

      final spritesData = pokemonData['pokemonsprites'];
      if (spritesData != null &&
          spritesData is List &&
          spritesData.isNotEmpty) {
        final sprites = spritesData[0]['sprites'] as Map<String, dynamic>?;
        if (sprites != null) {
          imageUrl = ListItemDto.getSprite(sprites, false);
        }
      }

      final typesData = pokemonData['pokemontypes'] as List?;
      if (typesData != null) {
        for (final typeData in typesData) {
          if (typeData['type'] != null && typeData['type']['name'] != null) {
            final typeName = typeData['type']['name'] as String;
            types.add(PokemonTypeExtension.fromString(typeName));
          }
        }
      }
    }

    final requirements = _parseRequirements(data['pokemonevolutions'] as List?);

    return EvolutionSpecies(
      speciesId: speciesId,
      speciesName: speciesName,
      evolvesFromSpeciesId: data['evolves_from_species_id'] as int?,
      pokemonId: pokemonId,
      pokemonName: pokemonName,
      imageUrl: imageUrl,
      types: types,
      requirements: requirements,
    );
  }

  static List<EvolutionRequirement> _parseRequirements(
    List<dynamic>? evolutionsData,
  ) {
    if (evolutionsData == null || evolutionsData.isEmpty) return [];

    final requirements = <EvolutionRequirement>[];

    for (final evoData in evolutionsData) {
      if (evoData is! Map<String, dynamic>) continue;

      final trigger = evoData['evolutiontrigger'];
      final triggerName =
          trigger?['evolutiontriggernames'] is List &&
              (trigger['evolutiontriggernames'] as List).isNotEmpty
          ? trigger['evolutiontriggernames'][0]['name'] as String?
          : null;

      final item = evoData['item'];
      final itemName =
          item?['itemnames'] is List && (item['itemnames'] as List).isNotEmpty
          ? item['itemnames'][0]['name'] as String?
          : null;

      final location = evoData['location'];
      final locationName =
          location?['locationnames'] is List &&
              (location['locationnames'] as List).isNotEmpty
          ? location['locationnames'][0]['name'] as String?
          : null;

      requirements.add(
        EvolutionRequirement(
          trigger: trigger?['name'] as String? ?? 'unknown',
          triggerName: triggerName,
          minLevel: evoData['min_level'] as int?,
          minHappiness: evoData['min_happiness'] as int?,
          minAffection: evoData['min_affection'] as int?,
          timeOfDay: evoData['time_of_day'] as String?,
          itemName: itemName,
          locationName: locationName,
        ),
      );
    }

    return requirements;
  }

  static String formatRequirementDescription(EvolutionRequirement req) {
    final parts = <String>[];

    if (req.trigger == 'use-item' && req.itemName != null) {
      return 'Using ${req.itemName}';
    }

    if (req.trigger == 'trade') {
      if (req.itemName != null) {
        return 'Trading while holding ${req.itemName}';
      }
      return 'Trading';
    }

    if (req.trigger == 'level-up') {
      if (req.minLevel != null) {
        parts.add('Level ${req.minLevel}');
      } else {
        parts.add('Levelling up');
      }

      if (req.minHappiness != null && req.minHappiness! > 0) {
        parts.add('when happy');
      }

      if (req.minAffection != null && req.minAffection! > 0) {
        parts.add('with affection');
      }

      if (req.timeOfDay != null && req.timeOfDay!.isNotEmpty) {
        parts.add('at ${req.timeOfDay}time');
      }

      if (req.locationName != null) {
        parts.add('near ${req.locationName}');
      }

      return parts.join(' ');
    }

    return req.triggerName ?? 'Unknown method';
  }
}
