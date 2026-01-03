import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../logging/logger.dart';
import 'injection_container.config.dart';

final getIt = GetIt.instance;

@module
abstract class LoggingModule {
  @lazySingleton
  Logger provideLogger() => CanonicalLogger();
}

@InjectableInit()
void configureDependencies() => getIt.init();
