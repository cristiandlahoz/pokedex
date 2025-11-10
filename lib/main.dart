import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'core/di/injection_container.dart';
import 'features/pokemon/presentation/pages/pokemon_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await initHiveForFlutter();
  
  await configureDependencies();
  
  runApp(const PokedexApp());
}

class PokedexApp extends StatelessWidget {
  const PokedexApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const PokemonListPage(),
    );
  }
}