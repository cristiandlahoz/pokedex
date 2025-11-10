import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/exceptions/failures.dart';
import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';

@lazySingleton
class SearchPokemon {
  final PokemonRepository repository;
  
  SearchPokemon(this.repository);
  
  Future<Either<Failure, List<Pokemon>>> call(String query) async {
    return await repository.searchPokemon(query);
  }
}
