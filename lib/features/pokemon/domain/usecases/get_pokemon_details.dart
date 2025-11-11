import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/exceptions/failures.dart';
import '../entities/pokemon_details.dart';
import '../repositories/pokemon_repository.dart';

@lazySingleton
class GetPokemonDetails {
  final PokemonRepository repository;
  
  GetPokemonDetails(this.repository);
  
  Future<Either<Failure, PokemonDetails>> call(int id) async {
    return await repository.getPokemonDetails(id);
  }
}
