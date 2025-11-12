import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/exceptions/failures.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_details.dart';
import '../bloc/pokemon_details_bloc.dart';
import '../bloc/pokemon_details_event.dart';
import '../bloc/pokemon_details_state.dart';
import '../utils/pokemon_type_helper.dart';
import '../widgets/sections/abilities_section.dart';
import '../widgets/sections/base_stats_section.dart';
import '../widgets/sections/breeding_section.dart';
import '../widgets/sections/catch_rate_section.dart';
import '../widgets/sections/species_section.dart';
import '../widgets/sections/evolution_section.dart';
import '../widgets/sections/moves_section.dart';
import '../widgets/sections/physical_stats_section.dart';
import '../widgets/detail/pokemon_detail_app_bar.dart';
import '../widgets/detail/pokemon_detail_header.dart';
import '../widgets/sections/training_section.dart';
import '../widgets/sections/type_effectiveness_section.dart';
import '../widgets/shared/loading_state_widget.dart';
import '../widgets/shared/error_state_widget.dart';

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

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  static const List<String> _tabs = ['About', 'Stats', 'Moves', 'Other'];

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
            
            return _buildLoadingState();
          },
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return LoadingStateWidget(
      backgroundColor: PokemonTypeHelper.getPrimaryTypeColor(widget.pokemon),
    );
  }

  Widget _buildErrorState(Failure failure) {
    return ErrorStateWidget(
      message: failure.message,
      backgroundColor: PokemonTypeHelper.getPrimaryTypeColor(widget.pokemon),
      onRetry: () {
        context.read<PokemonDetailsBloc>().add(
              LoadPokemonDetails(widget.pokemon.id),
            );
      },
    );
  }

  Widget _buildLoadedState(PokemonDetails pokemon) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          PokemonDetailAppBar(
            pokemon: pokemon,
            backgroundColor: PokemonTypeHelper.getPrimaryTypeColor(pokemon),
          ),
        ];
      },
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: _buildContentContainer(pokemon),
      ),
    );
  }

  Widget _buildContentContainer(PokemonDetails pokemon) {
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

  Widget _buildTabBar(PokemonDetails pokemon) {
    final primaryTypeColor = PokemonTypeHelper.getPrimaryTypeColor(pokemon);
    
    return TabBar(
      controller: _tabController,
      labelColor: primaryTypeColor,
      unselectedLabelColor: Colors.grey,
      indicatorColor: primaryTypeColor,
      indicatorWeight: 3,
      labelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      unselectedLabelStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),
      tabs: _tabs.map((tab) => Tab(text: tab)).toList(),
    );
  }

  Widget _buildAboutTab(PokemonDetails pokemon) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      children: [
        if (pokemon.genus != null || pokemon.description != null)
          SpeciesSection(pokemon: pokemon),
        PhysicalStatsSection(pokemon: pokemon),
        CatchRateSection(pokemon: pokemon),
        TrainingSection(pokemon: pokemon),
        BreedingSection(pokemon: pokemon),
        AbilitiesSection(pokemon: pokemon),
        const EvolutionSection(),
        const SizedBox(height: AppConstants.largePadding),
      ],
    );
  }

  Widget _buildStatsTab(PokemonDetails pokemon) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      children: [
        if (pokemon.stats.isNotEmpty)
          BaseStatsSection(
            stats: pokemon.stats,
            primaryType: PokemonTypeHelper.getPrimaryTypeName(pokemon),
          )
        else
          BaseStatsSection.withSampleData(),
        TypeEffectivenessSection(pokemon: pokemon),
        const SizedBox(height: AppConstants.largePadding),
      ],
    );
  }

  Widget _buildMovesTab(PokemonDetails pokemon) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      children: [
        if (pokemon.moves.isNotEmpty)
          MovesSection(moves: pokemon.moves)
        else
          MovesSection.withSampleData(),
        const SizedBox(height: AppConstants.largePadding),
      ],
    );
  }

  Widget _buildOtherTab(PokemonDetails pokemon) {
    return ListView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      children: const [
        SizedBox(height: AppConstants.largePadding),
      ],
    );
  }

}
