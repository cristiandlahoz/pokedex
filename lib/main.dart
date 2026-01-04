import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/connectivity/connectivity_bloc.dart';
import 'core/di/injection_container.dart';
import 'core/i18n/arb/app_localizations.dart';
import 'core/logging/bloc_observer.dart';
import 'core/logging/logger.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/offline_banner.dart';
import 'features/pokemon/bloc/favorites_bloc.dart';
import 'features/pokemon/bloc/favorites_event.dart';
import 'features/pokemon/bloc/favorites_state.dart';
import 'features/pokemon/bloc/home_bloc.dart';
import 'features/pokemon/bloc/home_event.dart';
import 'features/pokemon/bloc/trivia_bloc.dart';
import 'features/pokemon/data/models/evolution_chain_hive_model.dart';
import 'features/pokemon/data/models/evolution_requirement_hive_model.dart';
import 'features/pokemon/data/models/evolution_species_hive_model.dart';
import 'features/pokemon/data/models/pokemon_ability_hive_model.dart';
import 'features/pokemon/data/models/pokemon_details_hive_model.dart';
import 'features/pokemon/data/models/pokemon_move_hive_model.dart';
import 'features/pokemon/data/models/pokemon_stat_hive_model.dart';
import 'features/pokemon/data/models/trivia_level_stats_hive_model.dart';
import 'features/pokemon/data/models/trivia_player_hive_model.dart';
import 'features/pokemon/data/models/type_defense_info_hive_model.dart';
import 'features/pokemon/domain/repositories/favorites_repository.dart';
import 'features/pokemon/domain/repositories/pokemon_repository.dart';
import 'features/pokemon/presentation/pages/home_page.dart';
import 'features/pokemon/presentation/pages/trivia_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await initHiveForFlutter();

  Hive.registerAdapter(PokemonDetailsHiveModelAdapter());
  Hive.registerAdapter(PokemonAbilityHiveModelAdapter());
  Hive.registerAdapter(PokemonStatHiveModelAdapter());
  Hive.registerAdapter(PokemonMoveHiveModelAdapter());
  Hive.registerAdapter(TypeDefenseInfoHiveModelAdapter());
  Hive.registerAdapter(EvolutionChainHiveModelAdapter());
  Hive.registerAdapter(EvolutionSpeciesHiveModelAdapter());
  Hive.registerAdapter(EvolutionRequirementHiveModelAdapter());
  Hive.registerAdapter(TriviaPlayerHiveModelAdapter());
  Hive.registerAdapter(TriviaLevelStatsHiveModelAdapter());

  await Hive.openBox<PokemonDetailsHiveModel>('favorites');
  await Hive.openBox<TriviaPlayerHiveModel>('trivia_players');

  configureDependencies();

  Bloc.observer = CanonicalBlocObserver(getIt<Logger>());

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
  }

  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('language_code') ?? 'en';
    if (mounted) {
      setState(() => _locale = Locale(savedLanguage));
    }
  }

  Future<void> _changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', languageCode);
    if (mounted) {
      setState(() => _locale = Locale(languageCode));
    }
  }

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
        locale: _locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [Locale('en'), Locale('es')],
        home: MainNavigationPage(onLanguageChange: _changeLanguage),
      ),
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  final Function(String) onLanguageChange;

  const MainNavigationPage({super.key, required this.onLanguageChange});

  @override
  State<MainNavigationPage> createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _currentIndex = 0;
  late final ListBloc _pokemonBloc;
  late final ListBloc _favoritesBloc;
  late final TriviaBloc _triviaBloc;
  Timer? _autoSwitchTimer;

  @override
  void initState() {
    super.initState();
    _pokemonBloc = ListBloc(repository: getIt<PokemonRepository>())
      ..add(const ListLoadRequested());
    _favoritesBloc = ListBloc(
      repository: getIt<FavoritesRepository>() as PokemonRepository,
    )..add(const ListLoadRequested());
    _triviaBloc = getIt<TriviaBloc>();
  }

  @override
  void dispose() {
    _autoSwitchTimer?.cancel();
    _pokemonBloc.close();
    _favoritesBloc.close();
    _triviaBloc.close();
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
    final int favoritesTabWhenOffline = 0;
    final int triviaTab = 2;

    return BlocConsumer<ConnectivityBloc, ConnectivityState>(
      listener: (context, connectivityState) {
        if (connectivityState is ConnectivityOffline) {
          if (_currentIndex != triviaTab) {
            setState(() => _currentIndex = favoritesTab);
            _favoritesBloc.add(const ListLoadRequested());
          }
        } else if (connectivityState is ConnectivityOnline) {
          if (_currentIndex == favoritesTab) {
            _scheduleTabSwitch(pokedexTab);
          }
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
                        BlocProvider.value(
                          value: _triviaBloc,
                          child: TriviaPage(
                            onLanguageChange: widget.onLanguageChange,
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
                    items: [
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.catching_pokemon),
                        label: 'Pokédex',
                      ),
                      const BottomNavigationBarItem(
                        icon: Icon(Icons.favorite),
                        label: 'Favorites',
                      ),
                      BottomNavigationBarItem(
                        icon: const Icon(Icons.quiz),
                        label: AppLocalizations.of(context)!.triviaTitle,
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
