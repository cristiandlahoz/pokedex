import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'core/di/injection_container.dart';
import 'features/pokemon/presentation/pages/list_page.dart';

void main() async {
  await initHiveForFlutter();

  configureDependencies();

  runApp(const MaterialApp(home: PokemonListPage()));
}
