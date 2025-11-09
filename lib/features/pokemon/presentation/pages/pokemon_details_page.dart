import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/theme/pokemon_type_colors.dart';
import '../../domain/entities/pokemon.dart';
import '../bloc/pokemon_details_bloc.dart';
import '../bloc/pokemon_details_event.dart';
import '../bloc/pokemon_details_state.dart';
import '../widgets/abilities_section.dart';
import '../widgets/base_stats_section.dart';
import '../widgets/evolution_section.dart';
import '../widgets/moves_section.dart';
import '../widgets/physical_stats_section.dart';
import '../widgets/pokemon_detail_app_bar.dart';
import '../widgets/pokemon_detail_header.dart';

class PokemonDetailsPage extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonDetailsPage({
    super.key,
    required this.pokemon,
  });

  @override
  State<PokemonDetailsPage> createState() => _PokemonDetailsPageState();
}

class _PokemonDetailsPageState extends State<PokemonDetailsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: AppConstants.animationDurationMs),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  Color _getPrimaryTypeColor(Pokemon pokemon) {
    final primaryType = pokemon.types.isNotEmpty
        ? pokemon.types.first.name
        : 'normal';
    return PokemonTypeColors.getColor(primaryType);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<PokemonDetailsBloc>()
        ..add(LoadPokemonDetails(widget.pokemon.id)),
      child: Scaffold(
        body: BlocBuilder<PokemonDetailsBloc, PokemonDetailsState>(
          builder: (context, state) {
            if (state is PokemonDetailsLoading) {
              return _buildLoadingState();
            }
            
            if (state is PokemonDetailsError) {
              return _buildErrorState(state.message);
            }
            
            if (state is PokemonDetailsLoaded) {
              return _buildLoadedState(state.pokemon);
            }
            
            return _buildLoadedState(widget.pokemon);
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      color: _getPrimaryTypeColor(widget.pokemon),
      child: const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Container(
      color: _getPrimaryTypeColor(widget.pokemon),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.white,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                context.read<PokemonDetailsBloc>().add(
                      LoadPokemonDetails(widget.pokemon.id),
                    );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadedState(Pokemon pokemon) {
    return CustomScrollView(
      slivers: [
        PokemonDetailAppBar(
          pokemon: pokemon,
          backgroundColor: _getPrimaryTypeColor(pokemon),
        ),
        SliverToBoxAdapter(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: _buildContentContainer(pokemon),
          ),
        ),
      ],
    );
  }

  Widget _buildContentContainer(Pokemon pokemon) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppConstants.detailsTopBorderRadius),
          topRight: Radius.circular(AppConstants.detailsTopBorderRadius),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PokemonDetailHeader(pokemon: pokemon),
          PhysicalStatsSection(pokemon: pokemon),
          if (pokemon.stats != null && pokemon.stats!.isNotEmpty)
            BaseStatsSection(stats: pokemon.stats!)
          else
            BaseStatsSection.withSampleData(),
          AbilitiesSection(abilities: pokemon.abilities ?? []),
          const EvolutionSection(),
          if (pokemon.moves != null && pokemon.moves!.isNotEmpty)
            MovesSection(moves: pokemon.moves!)
          else
            MovesSection.withSampleData(),
          const SizedBox(height: AppConstants.largePadding),
        ],
      ),
    );
  }
}
