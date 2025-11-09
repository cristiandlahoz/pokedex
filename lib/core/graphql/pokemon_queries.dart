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
    pokemontypes {
      type {
        id
        name
      }
    }
    pokemonabilities {
      ability {
        id
        name
      }
      is_hidden
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
