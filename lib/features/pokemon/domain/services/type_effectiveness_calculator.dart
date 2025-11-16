import 'package:injectable/injectable.dart';
import '../../../../core/constants/app.dart';
import '../entities/pokemon_types.dart';
import '../entities/type_defense_info.dart';

@injectable
class TypeEffectivenessCalculator {
  List<TypeDefenseInfo> calculateDefensiveEffectiveness({
    required List<PokemonTypes> pokemonTypes,
    required Map<String, dynamic> pokemonTypesData,
  }) {
    try {
      if (pokemonTypes.isEmpty || pokemonTypesData.isEmpty) {
        return [];
      }

      final Map<PokemonTypes, double> effectivenessMap = {};
      final typeEfficacyByDefendingType = _extractEfficacyData(pokemonTypesData);
      final typeToIdMap = _buildTypeIdMap(pokemonTypesData);

      for (final attackingType in PokemonTypes.values) {
        if (_isIgnoredType(attackingType)) continue;

        double totalMultiplier = 1.0;

        for (final defendingType in pokemonTypes) {
          if (_isIgnoredType(defendingType)) continue;

          final defendingTypeId = typeToIdMap[defendingType];
          if (defendingTypeId == null) continue;

          final efficacies = typeEfficacyByDefendingType[defendingTypeId];
          if (efficacies != null) {
            final multiplier = _findMultiplierForAttackingType(
              efficacies,
              attackingType,
            );
            totalMultiplier *= multiplier;
          }
        }

        effectivenessMap[attackingType] = totalMultiplier;
      }

      return effectivenessMap.entries
          .map((entry) => TypeDefenseInfo(
                type: entry.key,
                damageMultiplier: entry.value,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  List<TypeDefenseInfo> calculateOffensiveEffectiveness({
    required List<PokemonTypes> pokemonTypes,
    required Map<String, dynamic> pokemonTypesData,
  }) {
    try {
      if (pokemonTypes.isEmpty || pokemonTypesData.isEmpty) {
        return [];
      }

      final Map<PokemonTypes, double> effectivenessMap = {};
      final typesData = pokemonTypesData['pokemontypes'] as List?;

      if (typesData == null || typesData.isEmpty) {
        return [];
      }

      for (final pokemonTypeData in typesData) {
        final typeData = pokemonTypeData['type'] as Map<String, dynamic>?;
        if (typeData == null) continue;

        final efficacies = typeData['typeefficacies'] as List?;
        if (efficacies == null) continue;

        for (final efficacy in efficacies) {
          final targetTypeData =
              efficacy['TypeByTargetTypeId'] as Map<String, dynamic>?;
          if (targetTypeData == null) continue;

          final targetTypeName = targetTypeData['name'] as String?;
          if (targetTypeName == null) continue;

          final defendingType = _parseTypeName(targetTypeName);
          if (_isIgnoredType(defendingType)) continue;

          final damageFactor = efficacy['damage_factor'] as int?;
          if (damageFactor == null) continue;

          final currentMultiplier = effectivenessMap[defendingType] ?? 1.0;
          effectivenessMap[defendingType] =
              currentMultiplier * (damageFactor / AppConstants.damageFactorDivisor);
        }
      }

      return effectivenessMap.entries
          .map((entry) => TypeDefenseInfo(
                type: entry.key,
                damageMultiplier: entry.value,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  bool _isIgnoredType(PokemonTypes type) =>
      type == PokemonTypes.unknown ||
      type == PokemonTypes.monster ||
      type == PokemonTypes.shadow;

  Map<int, List<Map<String, dynamic>>> _extractEfficacyData(
    Map<String, dynamic> json,
  ) {
    final Map<int, List<Map<String, dynamic>>> efficacyMap = {};
    final pokemonTypesData = json['pokemontypes'] as List?;

    if (pokemonTypesData == null) return efficacyMap;

    for (final pokemonTypeData in pokemonTypesData) {
      final typeData = pokemonTypeData['type'] as Map<String, dynamic>?;
      if (typeData == null) continue;

      final targetTypeId = typeData['id'] as int?;
      if (targetTypeId == null) continue;

      final efficacies = typeData['TypeefficaciesByTargetTypeId'] as List?;
      if (efficacies != null) {
        efficacyMap[targetTypeId] = efficacies.cast<Map<String, dynamic>>();
      }
    }

    return efficacyMap;
  }

  Map<PokemonTypes, int> _buildTypeIdMap(Map<String, dynamic> json) {
    final Map<PokemonTypes, int> typeIdMap = {};
    final pokemonTypesData = json['pokemontypes'] as List?;

    if (pokemonTypesData == null) return typeIdMap;

    for (final pokemonTypeData in pokemonTypesData) {
      final typeData = pokemonTypeData['type'] as Map<String, dynamic>?;
      if (typeData == null) continue;

      final typeId = typeData['id'] as int?;
      final typeName = typeData['name'] as String?;
      if (typeId == null || typeName == null) continue;

      final pokemonType = _parseTypeName(typeName);
      typeIdMap[pokemonType] = typeId;
    }

    return typeIdMap;
  }

  double _findMultiplierForAttackingType(
    List<Map<String, dynamic>> efficacies,
    PokemonTypes attackingType,
  ) {
    for (final efficacy in efficacies) {
      final attackingTypeData = efficacy['type'] as Map<String, dynamic>?;
      if (attackingTypeData == null) continue;

      final attackingTypeName = attackingTypeData['name'] as String?;
      if (attackingTypeName == null) continue;

      final matchingType = _parseTypeName(attackingTypeName);
      if (matchingType == attackingType) {
        final damageFactor = efficacy['damage_factor'] as int?;
        if (damageFactor != null) {
          return damageFactor / AppConstants.damageFactorDivisor;
        }
      }
    }

    return 1.0;
  }

  PokemonTypes _parseTypeName(String name) {
    switch (name.toLowerCase()) {
      case 'normal':
        return PokemonTypes.normal;
      case 'fighting':
        return PokemonTypes.fighting;
      case 'flying':
        return PokemonTypes.flying;
      case 'poison':
        return PokemonTypes.poison;
      case 'ground':
        return PokemonTypes.ground;
      case 'rock':
        return PokemonTypes.rock;
      case 'bug':
        return PokemonTypes.bug;
      case 'ghost':
        return PokemonTypes.ghost;
      case 'steel':
        return PokemonTypes.steel;
      case 'fire':
        return PokemonTypes.fire;
      case 'water':
        return PokemonTypes.water;
      case 'grass':
        return PokemonTypes.grass;
      case 'electric':
        return PokemonTypes.electric;
      case 'psychic':
        return PokemonTypes.psychic;
      case 'ice':
        return PokemonTypes.ice;
      case 'dragon':
        return PokemonTypes.dragon;
      case 'dark':
        return PokemonTypes.dark;
      case 'fairy':
        return PokemonTypes.fairy;
      default:
        return PokemonTypes.unknown;
    }
  }
}
