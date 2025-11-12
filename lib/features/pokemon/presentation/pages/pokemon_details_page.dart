import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/exceptions/failures.dart';
import '../utils/pokemon_type_colors.dart';
import '../../domain/entities/pokemon.dart';
import '../bloc/pokemon_details_bloc.dart';
import '../bloc/pokemon_details_event.dart';
import '../bloc/pokemon_details_state.dart';
import '../widgets/sections/abilities_section.dart';
import '../widgets/sections/base_stats_section.dart';
import '../widgets/sections/breeding_section.dart';
import '../widgets/sections/catch_rate_section.dart';
import '../widgets/sections/evolution_section.dart';
import '../widgets/sections/moves_section.dart';
import '../widgets/sections/physical_stats_section.dart';
import '../widgets/detail/pokemon_detail_app_bar.dart';
import '../widgets/detail/pokemon_detail_header.dart';
import '../widgets/sections/species_section.dart';
import '../widgets/sections/training_section.dart';

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
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;
  bool _showErrorDetails = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
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
              return _buildErrorState(state.failure);
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

  Widget _buildErrorState(Failure failure) {
    return Container(
      color: _getPrimaryTypeColor(widget.pokemon),
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                failure.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              if (kDebugMode) ...[
                const SizedBox(height: 16),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showErrorDetails = !_showErrorDetails;
                    });
                  },
                  icon: Icon(
                    _showErrorDetails ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.white,
                  ),
                  label: Text(
                    _showErrorDetails ? 'Hide Details' : 'Show Details',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                if (_showErrorDetails) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      failure.toDetailedString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
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
      ),
    );
  }

  Widget _buildLoadedState(Pokemon pokemon) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          PokemonDetailAppBar(
            pokemon: pokemon,
            backgroundColor: _getPrimaryTypeColor(pokemon),
          ),
        ];
      },
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _buildContentContainer(pokemon),
      ),
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
          _buildTabBar(pokemon),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildAboutTab(pokemon),
                _buildStatsTab(pokemon),
                _buildMovesTab(pokemon),
                _buildOtherTab(pokemon),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar(Pokemon pokemon) {
    return TabBar(
      controller: _tabController,
      labelColor: _getPrimaryTypeColor(pokemon),
      unselectedLabelColor: Colors.grey,
      indicatorColor: _getPrimaryTypeColor(pokemon),
      indicatorWeight: 3,
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      tabs: const [
        Tab(text: 'About'),
        Tab(text: 'Stats'),
        Tab(text: 'Moves'),
        Tab(text: 'Other'),
      ],
    );
  }

  Widget _buildAboutTab(Pokemon pokemon) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      children: [
        if (pokemon.genus != null || pokemon.flavorText != null)
          SpeciesSection(pokemon: pokemon),
        PhysicalStatsSection(pokemon: pokemon),
        CatchRateSection(pokemon: pokemon),
        TrainingSection(pokemon: pokemon),
        BreedingSection(pokemon: pokemon),
        const SizedBox(height: AppConstants.largePadding),
      ],
    );
  }

  Widget _buildStatsTab(Pokemon pokemon) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      children: [
        if (pokemon.stats != null && pokemon.stats!.isNotEmpty)
          BaseStatsSection(stats: pokemon.stats!)
        else
          BaseStatsSection.withSampleData(),
        const SizedBox(height: AppConstants.largePadding),
      ],
    );
  }

  Widget _buildMovesTab(Pokemon pokemon) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      children: [
        if (pokemon.moves != null && pokemon.moves!.isNotEmpty)
          MovesSection(moves: pokemon.moves!)
        else
          MovesSection.withSampleData(),
        const SizedBox(height: AppConstants.largePadding),
      ],
    );
  }

  Widget _buildOtherTab(Pokemon pokemon) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      children: [
        AbilitiesSection(abilities: pokemon.abilities ?? []),
        const EvolutionSection(),
        const SizedBox(height: AppConstants.largePadding),
      ],
    );
  }

}
