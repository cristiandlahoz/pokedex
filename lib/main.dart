import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'core/di/injection_container.dart';
import 'core/logging/bloc_observer.dart';
import 'core/logging/logger.dart';
import 'features/pokemon/presentation/pages/list_page.dart';

void main() async {
  await initHiveForFlutter();

  configureDependencies();

  Bloc.observer = CanonicalBlocObserver(getIt<Logger>());

  runApp(const MaterialApp(home: PokemonListPage()));
}
