import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/core/constants/ui_constants.dart';
import '../../../../core/di/injection_container.dart';
import '../bloc/pokemon_bloc.dart';
import '../bloc/pokemon_event.dart';
import '../bloc/pokemon_state.dart';
import '../widgets/pokemon_card.dart';

class PokemonListPage extends StatefulWidget {
  const PokemonListPage({super.key});

  @override
  State<PokemonListPage> createState() => _PokemonListPageState();
}

class _PokemonListPageState extends State<PokemonListPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<PokemonBloc>().add(const LoadMorePokemon());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PokemonBloc>()
        ..add(const LoadPokemonList()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Pokédex',
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          elevation: App.appBarElevation,
        ),
        body: BlocBuilder<PokemonBloc, PokemonState>(
          builder: (context, state) {
            if (state is PokemonLoading) {
              return const Center(
                child: GlowingOverscrollIndicator(axisDirection: AxisDirection.right, color: Colors.deepOrange),
              );
            }

            if (state is PokemonError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error: ${state.message}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        context.read<PokemonBloc>().add(
                              const LoadPokemonList(isRefresh: true),
                            );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is PokemonLoaded) {
              if (state.pokemons.isEmpty) {
                return const Center(
                  child: Text(
                    'No Pokémon found',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<PokemonBloc>().add(
                        const LoadPokemonList(isRefresh: true),
                      );
                  await Future.delayed(const Duration(milliseconds: 500));
                },
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: state.hasReachedMax
                      ? state.pokemons.length
                      : state.pokemons.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= state.pokemons.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    final pokemon = state.pokemons[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: PokemonCard(
                        pokemon: pokemon,
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Tapped on ${pokemon.displayName}'),
                              duration: const Duration(milliseconds: 500),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
