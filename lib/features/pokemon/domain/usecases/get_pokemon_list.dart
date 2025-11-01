import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';

@injectable
class GetPokemonList {
  final PokemonRepository repository;
  
  GetPokemonList(this.repository);
  
  Future<Either<Failure, List<Pokemon>>> call({int page = 0, int limit = 20}) async {
    return await repository.getPokemonList(page: page, limit: limit);
  }
}
