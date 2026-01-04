import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:pokedex/features/pokemon/domain/repositories/pokemon_repository.dart';

import '../../features/pokemon/data/repositories/pokemon_repository_impl.dart';
import '../../features/pokemon/domain/repositories/locations_repository.dart';
import '../logging/logger.dart';
import 'injection_container.config.dart';

final getIt = GetIt.instance;

@module
abstract class LoggingModule {
  @lazySingleton
  Logger provideLogger() => CanonicalLogger();
}

@InjectableInit()
void configureDependencies() {
  getIt.init();

  getIt.registerLazySingleton<LocationsRepository>(
    () => getIt<PokemonRepository>() as PokemonRepositoryImpl,
  );
}
