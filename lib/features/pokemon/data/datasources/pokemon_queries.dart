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

/// Evolution chain fragment for species information
const String evolutionSpeciesFragment = '''
fragment EvolutionSpeciesFields on pokemonspecies {
  id
  name
  evolves_from_species_id
  
  pokemons(where: {is_default: {_eq: true}}, limit: 1) {
    id
    name
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
  
  pokemonevolutions {
    evolved_species_id
    min_level
    min_happiness
    min_affection
    time_of_day
    
    evolutiontrigger {
      id
      name
      evolutiontriggernames(where: {language_id: {_eq: 9}}, limit: 1) {
        name
      }
    }
    
    item {
      id
      name
      itemnames(where: {language_id: {_eq: 9}}, limit: 1) {
        name
      }
    }
    
    location {
      id
      locationnames(where: {language_id: {_eq: 9}}, limit: 1) {
        name
      }
    }
  }
}
''';

/// Pokemon forms fragment for variant/form data
const String pokemonFormFragment = '''
fragment PokemonFormFields on pokemonform {
  id
  name
  form_name
  form_order
  is_default
  is_mega
  is_battle_only
  pokemon_id
  pokemonformnames(where: {language_id: {_eq: 9}}, limit: 1) {
    name
    pokemon_name
  }
  pokemonformsprites {
    sprites
  }
}
''';

/// Pokemon varieties fragment for regional variants (Alolan, Galarian, etc.)
const String pokemonVarietyFragment = '''
fragment PokemonVarietyFields on pokemon {
  id
  name
  is_default
  order
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

const String moveFragment = '''
fragment MoveFields on pokemonmove {
  level
  move_learn_method_id
  version_group_id
  versiongroup {
    name
  }
  movelearnmethod {
    name
  }
  move {
    name
    power
    accuracy
    pp
    type {
      name
    }
    machines(where: {version_group_id: {_is_null: false}}, limit: 1) {
      machine_number
      item {
        name
      }
    }
  }
}
''';

const String getPokemonListQuery =
    '''
$basicPokemonFragment

query GetPokemonList(\$limit: Int, \$offset: Int, \$order_by: [pokemon_order_by!], \$where: pokemon_bool_exp) {
  pokemon(limit: \$limit, offset: \$offset, order_by: \$order_by, where: \$where) {
    ...BasicPokemonFields
  }
}
''';

const String getPokemonDetailsQuery =
    '''
$basicPokemonFragment
$typeEffectivenessFragment
$evolutionSpeciesFragment
$pokemonFormFragment
$pokemonVarietyFragment
$moveFragment

query GetPokemonDetails(\$id: Int!) {
  pokemon(where: {id: {_eq: \$id}}, limit: 1) {
    ...BasicPokemonFields
    pokemonforms(order_by: {form_order: asc}) {
      ...PokemonFormFields
    }
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
    pokemonmoves {
      ...MoveFields
    }
    pokemonspecy {
      id
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
      pokemons(order_by: {order: asc}) {
        ...PokemonVarietyFields
      }
      evolution_chain_id
      evolutionchain {
        id
        pokemonspecies(order_by: {id: asc}) {
          ...EvolutionSpeciesFields
        }
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

const String getPokemonFormDetailsQuery = '''
$basicPokemonFragment
$typeEffectivenessFragment
$moveFragment

query GetPokemonFormDetails(\$formId: Int!) {
  pokemonform(where: {id: {_eq: \$formId}}, limit: 1) {
    id
    name
    form_name
    is_default
    is_mega
    pokemon_id
    pokemonformnames(where: {language_id: {_eq: 9}}, limit: 1) {
      name
      pokemon_name
    }
    pokemonformsprites {
      sprites
    }
    pokemon {
      id
      pokemontypes {
        type {
          id
          name
        }
      }
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
      pokemonmoves {
        ...MoveFields
      }
    }
  }
  pokemontype(where: {pokemon_id: {_eq: \$formId}}) {
    type {
      ...TypeEffectivenessFields
    }
  }
}
''';

const String searchPokemonQuery =
    '''
$basicPokemonFragment

query SearchPokemon(\$name: String!) {
  pokemon(where: {name: {_ilike: \$name}}) {
    ...BasicPokemonFields
  }
}
''';

const String getPokemonLocationsQuery = '''
query GetPokemonLocations(\$pokemonId: Int!) {
  encounter(
    where: {pokemon_id: {_eq: \$pokemonId}}
    order_by: {location_area_id: asc}
  ) {
    id
    min_level
    max_level
    location_area_id
    version_id
    locationarea {
      name
      id
      location {
        name
        id
        region {
          name
          id
        }
      }
    }
    version {
      name
      id
      versiongroup {
        name
        id
      }
    }
  }
}
''';
