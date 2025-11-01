import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/pokemon.dart';
import '../repositories/pokemon_repository.dart';

@injectable
class GetPokemonDetails {
  final PokemonRepository repository;
  
  GetPokemonDetails(this.repository);
  
  Future<Either<Failure, Pokemon>> call(int id) async {
    return await repository.getPokemonDetails(id);
  }
}
