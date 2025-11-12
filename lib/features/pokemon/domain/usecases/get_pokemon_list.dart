import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/exceptions/failures.dart';
import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';
import '../value_objects/filter_criteria.dart';
import '../value_objects/sort_criteria.dart';

@lazySingleton
class GetPokemonList {
  final PokemonRepository repository;
  
  GetPokemonList(this.repository);
  
  Future<Either<Failure, List<Pokemon>>> call({
    int page = 0,
    int limit = 20,
    SortCriteria? sortCriteria,
    FilterCriteria? filterCriteria,
  }) async {
    return await repository.getPokemonList(
      page: page,
      limit: limit,
      sortCriteria: sortCriteria,
      filterCriteria: filterCriteria,
    );
  }
}
