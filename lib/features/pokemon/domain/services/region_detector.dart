import 'location_name_normalizer.dart';

class RegionDetector {
  static const _locationRegionMap = {
    'kanto': [
      'pallet-town',
      'viridian-city',
      'viridian-forest',
      'pewter-city',
      'mt-moon',
      'cerulean-city',
      'rock-tunnel',
      'power-plant',
      'lavender-town',
      'pokemon-tower',
      'saffron-city',
      'celadon-city',
      'vermilion-city',
      'digletts-cave',
      'fuchsia-city',
      'seafoam-islands',
      'cinnabar-island',
      'victory-road',
      'indigo-plateau',
      'tohjo-falls',
    ],
    'johto': [
      'new-bark-town',
      'cherrygrove-city',
      'violet-city',
      'dark-cave',
      'ruins-of-alph',
      'union-cave',
      'azalea-town',
      'ilex-forest',
      'goldenrod-city',
      'national-park',
      'ecruteak-city',
      'burned-tower',
      'bell-tower',
      'tin-tower',
      'olivine-city',
      'mahogany-town',
      'lake-of-rage',
      'ice-path',
      'blackthorn-city',
      'dragons-den',
      'cianwood-city',
      'whirl-islands',
      'mt-mortar',
      'mt-silver',
    ],
    'hoenn': [
      'littleroot-town',
      'oldale-town',
      'petalburg-city',
      'rustboro-city',
      'dewford-town',
      'slateport-city',
      'mauville-city',
      'verdanturf-town',
      'fallarbor-town',
      'lavaridge-town',
      'fortree-city',
      'lilycove-city',
      'mossdeep-city',
      'sootopolis-city',
      'pacifidlog-town',
      'ever-grande-city',
      'meteor-falls',
      'mt-chimney',
      'jagged-pass',
      'fiery-path',
      'mt-pyre',
      'shoal-cave',
      'cave-of-origin',
      'sky-pillar',
    ],
    'sinnoh': [
      'twinleaf-town',
      'lake-verity',
      'sandgem-town',
      'jubilife-city',
      'canalave-city',
      'iron-island',
      'floaroma-town',
      'eterna-city',
      'hearthome-city',
      'solaceon-town',
      'veilstone-city',
      'pastoria-city',
      'great-marsh',
      'celestic-town',
      'mt-coronet',
      'snowpoint-city',
      'lake-acuity',
      'sunyshore-city',
      'pokemon-league',
      'oreburgh-city',
      'oreburgh-mine',
      'ravaged-path',
      'valley-windworks',
      'eterna-forest',
    ],
    'unova': [
      'nuvema-town',
      'accumula-town',
      'striaton-city',
      'nacrene-city',
      'castelia-city',
      'nimbasa-city',
      'driftveil-city',
      'mistralton-city',
      'icirrus-city',
      'opelucid-city',
      'lacunosa-town',
      'undella-town',
      'black-city',
      'white-forest',
      'aspertia-city',
      'virbank-city',
      'humilau-city',
      'lentimas-town',
      'reversal-mountain',
      'twist-mountain',
      'chargestone-cave',
      'wellspring-cave',
      'celestial-tower',
      'dragonspiral-tower',
    ],
    'kalos': [
      'vaniville-town',
      'aquacorde-town',
      'santalune-city',
      'lumiose-city',
      'camphrier-town',
      'cyllage-city',
      'ambrette-town',
      'geosenge-town',
      'shalour-city',
      'coumarine-city',
      'laverre-city',
      'dendemille-town',
      'anistar-city',
      'couriway-town',
      'snowbelle-city',
      'terminus-cave',
      'reflecting-cave',
      'connecting-cave',
      'glittering-cave',
      'frost-cavern',
    ],
  };

  static List<String> detectRegionsForLocations(List<String> locationNames) {
    final detectedRegions = <String>{};

    for (final locationName in locationNames) {
      final region = detectRegion(locationName);
      if (region != null) {
        detectedRegions.add(region);
      }
    }

    return detectedRegions.toList();
  }

  static String? detectRegion(String locationName) {
    final normalizedName = LocationNameNormalizer.normalize(locationName);

    for (final entry in _locationRegionMap.entries) {
      for (final location in entry.value) {
        if (normalizedName.contains(location) ||
            location.contains(normalizedName)) {
          return entry.key;
        }
      }
    }

    final routeMatch = RegExp(r'route-(\d+)').firstMatch(normalizedName);
    if (routeMatch != null) {
      final routeNumber = int.tryParse(routeMatch.group(1) ?? '');
      if (routeNumber != null) {
        return _detectRegionFromRoute(routeNumber);
      }
    }

    return null;
  }

  static String? _detectRegionFromRoute(int routeNumber) {
    if (routeNumber >= 101 && routeNumber <= 134) return 'hoenn';
    if (routeNumber >= 201 && routeNumber <= 230) return 'sinnoh';
    if (routeNumber >= 29 && routeNumber <= 48) return 'johto';
    if (routeNumber >= 1 && routeNumber <= 28) return 'kanto';
    return null;
  }
}
