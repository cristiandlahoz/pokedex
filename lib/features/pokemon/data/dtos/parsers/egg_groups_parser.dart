class EggGroupsParser {
  static List<String> parse(Map<String, dynamic>? speciesJson) {
    if (speciesJson == null) return [];

    final eggGroups = <String>[];
    final eggGroupsData = speciesJson['pokemonegggroups'];

    if (eggGroupsData != null && eggGroupsData is List) {
      for (final eggGroupData in eggGroupsData) {
        if (eggGroupData is! Map) continue;
        if (eggGroupData['egggroup'] == null) continue;
        if (eggGroupData['egggroup']['name'] == null) continue;

        eggGroups.add(eggGroupData['egggroup']['name'] as String);
      }
    }

    return eggGroups;
  }
}
