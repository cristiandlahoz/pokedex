import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';

@injectable
class SearchPokemon {
  final PokemonRepository repository;
  
  SearchPokemon(this.repository);
  
  Future<Either<Failure, List<Pokemon>>> call(String query) async {
    return await repository.searchPokemon(query);
  }
}
