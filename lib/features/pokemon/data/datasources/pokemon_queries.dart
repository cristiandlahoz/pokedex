const String getPokemonListQuery = '''
query GetPokemonList(\$limit: Int, \$offset: Int) {
  pokemon(limit: \$limit, offset: \$offset, order_by: {id: asc}) {
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
}
''';

const String getPokemonDetailsQuery = '''
query GetPokemonDetails(\$id: Int!) {
  pokemon(where: {id: {_eq: \$id}}, limit: 1) {
    id
    name
    height
    weight
    base_experience
    pokemonsprites {
      sprites
    }
    pokemonabilities(order_by: {slot: asc}) {
      ability {
        id
        name
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
    pokemonmoves(limit: 20) {
      move {
        name
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
      id
      name
    }
  }
}
''';

const String getTypeEfficaciesQuery = '''
query GetTypeEfficacies(\$typeIds: [Int!]!) {
  type(where: {id: {_in: \$typeIds}}) {
    id
    name
    TypeefficaciesByTargetTypeId {
      damage_factor
      type {
        id
        name
      }
    }
  }
}
''';

const String searchPokemonQuery = '''
query SearchPokemon(\$name: String!) {
  pokemon(where: {name: {_ilike: \$name}}) {
    id
    name
    height
    weight
    pokemontypes {
      type {
        id
        name
      }
    }
  }
}
''';
