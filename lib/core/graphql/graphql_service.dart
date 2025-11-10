import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:injectable/injectable.dart';
import 'graphql_config.dart';

@lazySingleton
class GraphQLService {
  late GraphQLClient client;

  GraphQLService(GraphQLConfig config) {
    final httpLink = HttpLink(config.endpoint);

    client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: HiveStore()),
      defaultPolicies: DefaultPolicies(
        query: Policies(
          fetch: FetchPolicy.cacheAndNetwork,
          error: ErrorPolicy.all,
        ),
        mutate: Policies(fetch: FetchPolicy.noCache, error: ErrorPolicy.all),
      ),
    );
  }

  Future<QueryResult> query(QueryOptions options) async {
    return await client.query(options);
  }
}
