import 'package:injectable/injectable.dart';

@lazySingleton
class GraphQLConfig {
  final String endpoint = 'https://graphql.pokeapi.co/v1beta2';

  GraphQLConfig();
}
