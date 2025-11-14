import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/exceptions/failures.dart';
import '../../../../core/theme/tokens.dart';
import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';
import '../value_objects/filters.dart';
import '../value_objects/sorting.dart';

@lazySingleton
class GetPokemonList {
  final PokemonRepository repository;

  GetPokemonList(this.repository);

  Future<Either<Failure, List<Pokemon>>> call({
    int page = 0,
    int limit = DesignTokens.defaultPageSize,
    Sorting? sort,
    Filters? filter,
  }) async {
    return await repository.getPokemonList(
      page: page,
      limit: limit,
      sort: sort,
      filter: filter,
    );
  }
}
