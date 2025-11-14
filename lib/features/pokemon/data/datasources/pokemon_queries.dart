import '../../../../core/theme/tokens.dart';

// Reusable fragments to eliminate duplication and maintain consistency

/// Basic pokemon information fragment used across list and search queries
const String basicPokemonFragment = '''
fragment BasicPokemonFields on pokemon {
  id
  name
  height
  weight
  base_experience
  pokemontypes {
    type {
      id
      name
    }
  }
  pokemonsprites {
    sprites
  }
}
''';

/// Type information fragment for detailed type data
const String typeFragment = '''
fragment TypeFields on type {
  id
  name
}
''';

/// Type effectiveness fragment for battle calculations
const String typeEffectivenessFragment = '''
fragment TypeEffectivenessFields on type {
  id
  name
  typeefficacies {
    damage_factor
    TypeByTargetTypeId {
      id
      name
    }
  }
  TypeefficaciesByTargetTypeId {
    damage_factor
    type {
      id
      name
    }
  }
}
''';


const String getPokemonListQuery = '''
$basicPokemonFragment

query GetPokemonList(\$limit: Int, \$offset: Int, \$order_by: [pokemon_order_by!], \$where: pokemon_bool_exp) {
  pokemon(limit: \$limit, offset: \$offset, order_by: \$order_by, where: \$where) {
    ...BasicPokemonFields
  }
}
''';

const String getPokemonDetailsQuery = '''
$basicPokemonFragment
$typeEffectivenessFragment

query GetPokemonDetails(\$id: Int!) {
  pokemon(where: {id: {_eq: \$id}}, limit: 1) {
    ...BasicPokemonFields
    pokemonabilities(order_by: {slot: asc}) {
      ability {
        id
        name
        abilityflavortexts(where: {language_id: {_eq: 9}}, limit: 1, order_by: {version_group_id: desc}) {
          flavor_text
        }
      }
      is_hidden
      slot
    }
    pokemonstats {
      base_stat
      effort
      stat {
        name
      }
    }
    pokemonmoves(limit: ${DesignTokens.defaultMovesLimit}) {
      move {
        name
        power
        accuracy
        pp
        type {
          name
        }
      }
    }
    pokemonspecy {
      gender_rate
      capture_rate
      base_happiness
      hatch_counter
      growthrate {
        name
      }
      pokemonegggroups {
        egggroup {
          name
        }
      }
      pokemonspeciesnames(where: {language_id: {_eq: 9}}, limit: 1) {
        genus
      }
      pokemonspeciesflavortexts(where: {language_id: {_eq: 9}}, limit: 1, order_by: {version_id: desc}) {
        flavor_text
      }
    }
  }
  pokemontype(where: {pokemon_id: {_eq: \$id}}) {
    type {
      ...TypeEffectivenessFields
    }
  }
}
''';

const String searchPokemonQuery = '''
$basicPokemonFragment

query SearchPokemon(\$name: String!) {
  pokemon(where: {name: {_ilike: \$name}}) {
    ...BasicPokemonFields
  }
}
''';
