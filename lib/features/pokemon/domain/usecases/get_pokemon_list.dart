import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/exceptions/failures.dart';
import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';

@lazySingleton
class GetPokemonList {
  final PokemonRepository repository;
  
  GetPokemonList(this.repository);
  
  Future<Either<Failure, List<Pokemon>>> call({int page = 0, int limit = 20}) async {
    return await repository.getPokemonList(page: page, limit: limit);
  }
}
