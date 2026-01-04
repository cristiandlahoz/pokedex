import 'package:equatable/equatable.dart';

import '../../../../core/utils/string_utils.dart';

enum GameVersionGroup {
  redBlue(
    name: 'red-blue',
    displayName: 'Red - Blue',
    region: 'Kanto',
  ),
  yellow(
    name: 'yellow',
    displayName: 'Yellow',
    region: 'Kanto',
  ),
  goldSilver(
    name: 'gold-silver',
    displayName: 'Gold - Silver',
    region: 'Johto',
  ),
  crystal(
    name: 'crystal',
    displayName: 'Crystal',
    region: 'Johto',
  ),
  rubySapphire(
    name: 'ruby-sapphire',
    displayName: 'Ruby - Sapphire',
    region: 'Hoenn',
  ),
  emerald(
    name: 'emerald',
    displayName: 'Emerald',
    region: 'Hoenn',
  ),
  fireRedLeafGreen(
    name: 'firered-leafgreen',
    displayName: 'FireRed - LeafGreen',
    region: 'Kanto',
  ),
  diamondPearl(
    name: 'diamond-pearl',
    displayName: 'Diamond - Pearl',
    region: 'Sinnoh',
  ),
  platinum(
    name: 'platinum',
    displayName: 'Platinum',
    region: 'Sinnoh',
  ),
  heartGoldSoulSilver(
    name: 'heartgold-soulsilver',
    displayName: 'HeartGold - SoulSilver',
    region: 'Johto',
  ),
  blackWhite(
    name: 'black-white',
    displayName: 'Black - White',
    region: 'Unova',
  ),
  black2White2(
    name: 'black-2-white-2',
    displayName: 'Black 2 - White 2',
    region: 'Unova',
  ),
  xY(
    name: 'x-y',
    displayName: 'X - Y',
    region: 'Kalos',
  ),
  omegaRubyAlphaSapphire(
    name: 'omega-ruby-alpha-sapphire',
    displayName: 'Omega Ruby - Alpha Sapphire',
    region: 'Hoenn',
  ),
  sunMoon(
    name: 'sun-moon',
    displayName: 'Sun - Moon',
    region: 'Alola',
  ),
  ultraSunUltraMoon(
    name: 'ultra-sun-ultra-moon',
    displayName: 'Ultra Sun - Ultra Moon',
    region: 'Alola',
  ),
  letsGoPikachuLetsGoEevee(
    name: 'lets-go-pikachu-lets-go-eevee',
    displayName: "Let's Go Pikachu - Let's Go Eevee",
    region: 'Kanto',
  ),
  swordShield(
    name: 'sword-shield',
    displayName: 'Sword - Shield',
    region: 'Galar',
  ),
  brilliantDiamondShiningPearl(
    name: 'brilliant-diamond-shining-pearl',
    displayName: 'Brilliant Diamond - Shining Pearl',
    region: 'Sinnoh',
  ),
  legendsArceus(
    name: 'legends-arceus',
    displayName: 'Legends: Arceus',
    region: 'Hisui',
  ),
  scarletViolet(
    name: 'scarlet-violet',
    displayName: 'Scarlet - Violet',
    region: 'Paldea',
  );

  final String name;
  final String displayName;
  final String region;

  const GameVersionGroup({
    required this.name,
    required this.displayName,
    required this.region,
  });

  static GameVersionGroup? fromName(String versionName) {
    for (final group in GameVersionGroup.values) {
      if (group.name == versionName) {
        return group;
      }
    }
    return null;
  }

  GameVersion toGameVersion() {
    return GameVersion(
      name: name,
      displayName: displayName,
    );
  }
}

class GameVersion extends Equatable {
  final String name;
  final String displayName;

  const GameVersion({
    required this.name,
    required this.displayName,
  });

  String get region {
    final group = GameVersionGroup.fromName(name);
    return group?.region ?? 'Unknown';
  }

  GameVersionGroup? get versionGroup => GameVersionGroup.fromName(name);

  static String formatDisplayName(String versionName) {
    return StringUtils.capitalizeWords(versionName);
  }

  static List<GameVersion> get allVersions =>
      GameVersionGroup.values.map((g) => g.toGameVersion()).toList();

  @override
  List<Object?> get props => [name, displayName];
}
