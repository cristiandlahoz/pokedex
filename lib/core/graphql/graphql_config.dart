import 'package:injectable/injectable.dart';

@injectable
class GraphQLConfig {
  final String endpoint = 'https://graphql.pokeapi.co/v1beta2';
  String? authToken;
  
  GraphQLConfig();
}
