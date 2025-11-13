import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../domain/entities/pokemon_details.dart';
import '../../../domain/entities/pokemon_stat.dart';
import '../../../domain/services/catch_rate_calculator.dart';
import '../../utils/pokemon_type_helper.dart';
import '../shared/section_title_badge.dart';

class _CatchRateConstants {
  static const double pokeBallSize = 70.0;
  static const double rateTagTopOffset = 6.0;
  static const String explanationText =
      'When a Poké Ball is thrown at a wild Pokémon, the game uses that Pokémon\'s catch rate in a formula to determine the chances of catching that Pokémon. The catch rate can change according to the health of the Pokémon, the type of Poké Ball, the status condition, and active special powers.';
  static const String disclaimerText =
      'Sample rates for this Pokémon when on full HP and no status problems';
}

class _BallRate {
  final double rate;
  final String assetPath;
  final String label;

  const _BallRate({
    required this.rate,
    required this.assetPath,
    required this.label,
  });
}

class _PokeBallVisual extends StatelessWidget {
  final String assetPath;

  const _PokeBallVisual({required this.assetPath});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      assetPath,
      width: _CatchRateConstants.pokeBallSize,
      height: _CatchRateConstants.pokeBallSize,
    );
  }
}

class _RateTag extends StatelessWidget {
  final double rate;

  const _RateTag({required this.rate});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _CatchRateConstants.rateTagTopOffset,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.smallPadding / 1.5,
          vertical: AppConstants.smallPadding / 6,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.smallPadding - 2),
          border: Border.all(
            color: Colors.black87,
            width: 1,
          ),
        ),
        child: Text(
          '${rate.toStringAsFixed(1)}%',
          style: const TextStyle(
            fontSize: AppConstants.fontSizeSmall - 1,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

class _PokeBallRateCard extends StatelessWidget {
  final _BallRate ballRate;

  const _PokeBallRateCard({required this.ballRate});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            _PokeBallVisual(assetPath: ballRate.assetPath),
            _RateTag(rate: ballRate.rate),
          ],
        ),
        const SizedBox(height: AppConstants.smallPadding / 1.5),
        Text(
          ballRate.label,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeSmall - 1,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}

class CatchRateSection extends StatelessWidget {
  final PokemonDetails pokemon;

  const CatchRateSection({
    super.key,
    required this.pokemon,
  });

  int _getMaxHP() {
    if (pokemon.stats.isEmpty) return 100;

    final hpStat = pokemon.stats.firstWhere(
      (stat) => stat.name.toLowerCase() == 'hp',
      orElse: () => const PokemonStat(name: 'hp', baseStat: 100),
    );

    return hpStat.baseStat;
  }

  List<_BallRate> _getBallRates() {
    final maxHP = _getMaxHP();

    return [
      _BallRate(
        rate: CatchRateCalculator.calculate(
              captureRate: pokemon.captureRate!,
              ballModifier: CatchRateCalculator.pokeBallModifier,
              maxHP: maxHP,
            ) *
            100,
        assetPath: 'assets/icons/pokeballs/poke_ball.svg',
        label: 'Poké Ball',
      ),
      _BallRate(
        rate: CatchRateCalculator.calculate(
              captureRate: pokemon.captureRate!,
              ballModifier: CatchRateCalculator.greatBallModifier,
              maxHP: maxHP,
            ) *
            100,
        assetPath: 'assets/icons/pokeballs/great_ball.svg',
        label: 'Great Ball',
      ),
      _BallRate(
        rate: CatchRateCalculator.calculate(
              captureRate: pokemon.captureRate!,
              ballModifier: CatchRateCalculator.ultraBallModifier,
              maxHP: maxHP,
            ) *
            100,
        assetPath: 'assets/icons/pokeballs/ultra_ball.svg',
        label: 'Ultra Ball',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    if (pokemon.captureRate == null) return const SizedBox.shrink();

    final ballRates = _getBallRates();

    return Container(
      margin: const EdgeInsets.only(
        top: AppConstants.mediumPadding,
        bottom: AppConstants.defaultPadding,
      ),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(AppConstants.defaultBorderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SectionTitleBadge(
            title: 'Catch rate',
            color: PokemonTypeHelper.getPrimaryTypeColorFromDetails(pokemon),
          ),
          const SizedBox(height: AppConstants.mediumPadding),
          const Text(
            _CatchRateConstants.explanationText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: ballRates
                .map((ballRate) => _PokeBallRateCard(ballRate: ballRate))
                .toList(),
          ),
          const SizedBox(height: AppConstants.mediumPadding),
          const Text(
            _CatchRateConstants.disclaimerText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppConstants.fontSizeSmall,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }
}
