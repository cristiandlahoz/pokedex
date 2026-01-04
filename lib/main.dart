import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/connectivity/connectivity_bloc.dart';
import 'core/di/injection_container.dart';
import 'core/logging/bloc_observer.dart';
import 'core/logging/logger.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/offline_banner.dart';
import 'features/pokemon/bloc/favorites_bloc.dart';
import 'features/pokemon/bloc/favorites_event.dart';
import 'features/pokemon/bloc/favorites_state.dart';
import 'features/pokemon/bloc/home_bloc.dart';
import 'features/pokemon/bloc/home_event.dart';
import 'features/pokemon/data/models/evolution_chain_hive_model.dart';
import 'features/pokemon/data/models/evolution_requirement_hive_model.dart';
import 'features/pokemon/data/models/evolution_species_hive_model.dart';
import 'features/pokemon/data/models/pokemon_ability_hive_model.dart';
import 'features/pokemon/data/models/pokemon_details_hive_model.dart';
import 'features/pokemon/data/models/pokemon_move_hive_model.dart';
import 'features/pokemon/data/models/pokemon_stat_hive_model.dart';
import 'features/pokemon/data/models/type_defense_info_hive_model.dart';
import 'features/pokemon/domain/repositories/favorites_repository.dart';
import 'features/pokemon/domain/repositories/pokemon_repository.dart';
import 'features/pokemon/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await initHiveForFlutter();

  // await Hive.deleteBoxFromDisk('favorites');

  // Register all 8 new Hive adapters
  Hive.registerAdapter(PokemonDetailsHiveModelAdapter()); // typeId: 1
  Hive.registerAdapter(PokemonAbilityHiveModelAdapter()); // typeId: 2
  Hive.registerAdapter(PokemonStatHiveModelAdapter()); // typeId: 3
  Hive.registerAdapter(PokemonMoveHiveModelAdapter()); // typeId: 4
  Hive.registerAdapter(TypeDefenseInfoHiveModelAdapter()); // typeId: 5
  Hive.registerAdapter(EvolutionChainHiveModelAdapter()); // typeId: 6
  Hive.registerAdapter(EvolutionSpeciesHiveModelAdapter()); // typeId: 7
  Hive.registerAdapter(EvolutionRequirementHiveModelAdapter()); // typeId: 8

  await Hive.openBox<PokemonDetailsHiveModel>('favorites');

  configureDependencies();

  Bloc.observer = CanonicalBlocObserver(getIt<Logger>());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<FavoritesBloc>()..add(const FavoritesLoadRequested()),
        ),
        BlocProvider(
          create: (_) =>
              getIt<ConnectivityBloc>()..add(ConnectivityCheckRequested()),
        ),
      ],
      child: MaterialApp(
        title: 'Pokédex',
        theme: AppTheme.lightTheme,
        home: const MainNavigationPage(),
      ),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  const MainNavigationPage({super.key});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;
  late final ListBloc _pokemonBloc;
  late final ListBloc _favoritesBloc;
  Timer? _autoSwitchTimer;

  @override
  void initState() {
    super.initState();
    // Create two ListBloc instances with different repositories
    _pokemonBloc = ListBloc(repository: getIt<PokemonRepository>())
      ..add(const ListLoadRequested());
    // FavoritesRepository implements PokemonRepository, so we can cast it
    _favoritesBloc = ListBloc(
      repository: getIt<FavoritesRepository>() as PokemonRepository,
    )..add(const ListLoadRequested());
  }

  @override
  void dispose() {
    _autoSwitchTimer?.cancel();
    _pokemonBloc.close();
    _favoritesBloc.close();
    super.dispose();
  }

  void _scheduleTabSwitch(int targetIndex) {
    _autoSwitchTimer?.cancel();
    _autoSwitchTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() => _currentIndex = targetIndex);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final int pokedexTab = 0;
    final int favoritesTab = 1;

    return BlocConsumer<ConnectivityBloc, ConnectivityState>(
      listener: (context, connectivityState) {
        // Auto-switch tabs based on connectivity
        if (connectivityState is ConnectivityOffline) {
          _scheduleTabSwitch(favoritesTab);
        } else if (connectivityState is ConnectivityOnline) {
          _scheduleTabSwitch(pokedexTab);
        }
      },
      builder: (context, connectivityState) {
        final isOffline = connectivityState is ConnectivityOffline;

        return BlocListener<FavoritesBloc, FavoritesState>(
          listener: (context, state) {
            if (state is FavoritesLoaded && _currentIndex == favoritesTab) {
              _favoritesBloc.add(const ListLoadRequested());
            }
          },
          child: Scaffold(
            body: Column(
              children: [
                if (isOffline) const OfflineBanner(),
                Expanded(
                  child: IndexedStack(
                    index: _currentIndex,
                    children: [
                      BlocProvider.value(
                        value: _pokemonBloc,
                        child: PokemonListPage(
                          bloc: _pokemonBloc,
                          title: 'Pokédex',
                        ),
                      ),
                      BlocProvider.value(
                        value: _favoritesBloc,
                        child: PokemonListPage(
                          bloc: _favoritesBloc,
                          title: 'Favorites',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: isOffline
                ? null
                : BottomNavigationBar(
                    currentIndex: _currentIndex,
                    onTap: (index) {
                      setState(() => _currentIndex = index);
                      if (index == favoritesTab) {
                        _favoritesBloc.add(const ListLoadRequested());
                      }
                    },
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.catching_pokemon),
                        label: 'Pokédex',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        label: 'Favorites',
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
