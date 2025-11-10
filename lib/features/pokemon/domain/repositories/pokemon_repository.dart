import 'package:dartz/dartz.dart';
import '../../../../core/exceptions/failures.dart';
import '../entities/pokemon.dart';

abstract class PokemonRepository {
  Future<Either<Failure, List<Pokemon>>> getPokemonList({int page = 0, int limit = 20});
  Future<Either<Failure, Pokemon>> getPokemonDetails(int id);
  Future<Either<Failure, List<Pokemon>>> searchPokemon(String query);
}
