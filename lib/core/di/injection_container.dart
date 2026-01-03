import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import '../logging/logger.dart';
import 'injection_container.config.dart';

final getIt = GetIt.instance;

@module
abstract class LoggingModule {
  @lazySingleton
  Logger provideLogger() => CanonicalLogger();
}

@module
abstract class HttpModule {
  @lazySingleton
  http.Client provideHttpClient() => http.Client();
}

@InjectableInit()
void configureDependencies() => getIt.init();
