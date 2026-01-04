import '../../domain/entities/pokemon_variety.dart';

class VarietyClassifier {
  VarietyClassifier._();

  static const List<String> _specialEvolutionKeywords = [
    'mega',
    'gmax',
    'gigantamax',
    'primal',
    'ultra',
  ];

  static const List<String> _alternativeFormKeywords = [
    'alola',
    'galar',
    'hisui',
    'paldea',
  ];

  static bool isSpecialEvolution(PokemonVariety variety) {
    if (variety.isDefault) return false;
    final lowerName = variety.name.toLowerCase();
    return _specialEvolutionKeywords
        .any((keyword) => lowerName.contains(keyword));
  }

  static bool isAlternativeForm(PokemonVariety variety) {
    if (variety.isDefault) return false;
    final lowerName = variety.name.toLowerCase();
    return _alternativeFormKeywords
        .any((keyword) => lowerName.contains(keyword));
  }

  static List<PokemonVariety> getSpecialEvolutions(
      List<PokemonVariety> varieties) {
    return varieties.where(isSpecialEvolution).toList();
  }

  static List<PokemonVariety> getAlternativeForms(
      List<PokemonVariety> varieties) {
    return varieties.where(isAlternativeForm).toList();
  }
}
