import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../../core/constants/app_constants.dart';
import '../../utils/pokemon_type_colors.dart';
import '../../../domain/entities/pokemon.dart';
import '../../../domain/entities/pokemon_stat.dart';

class _CatchRateConstants {
  static const double pokeBallSize = 70.0;
  static const double pokeBallBorderWidth = 2.0;
  static const double centerLineWidth = 30.0;
  static const double centerLineHeight = 2.0;
  static const double centerButtonSize = 16.0;
  static const double centerButtonTopOffset = 33.0;
  static const double rateTagTopOffset = 6.0;
  static const double pokeBallModifier = 1.0;
  static const double greatBallModifier = 1.5;
  static const double ultraBallModifier = 2.0;
  static const String explanationText = 
      'When a Poké Ball is thrown at a wild Pokémon, the game uses that Pokémon\'s catch rate in a formula to determine the chances of catching that Pokémon. The catch rate can change according to the health of the Pokémon, the type of Poké Ball, the status condition, and active special powers.';
  static const String disclaimerText = 
      'Sample rates for this Pokémon when on full HP and no status problems';
}

class _BallRate {
  final double rate;
  final Color color;
  final String label;

  const _BallRate({
    required this.rate,
    required this.color,
    required this.label,
  });
}

class _SectionTitleBadge extends StatelessWidget {
  final Color color;

  const _SectionTitleBadge({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.mediumPadding,
        vertical: AppConstants.smallPadding / 2,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: AppConstants.opacityLight * 2),
        borderRadius: BorderRadius.circular(AppConstants.extraLargeBorderRadius),
        border: Border.all(
          color: color,
          width: 1.5,
        ),
      ),
      child: Text(
        'Catch rate',
        style: TextStyle(
          fontSize: AppConstants.fontSizeRegular,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
    );
  }
}

class _PokeBallVisual extends StatelessWidget {
  final Color color;

  const _PokeBallVisual({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _CatchRateConstants.pokeBallSize,
      height: _CatchRateConstants.pokeBallSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withValues(alpha: 0.3),
            color.withValues(alpha: 0.6),
          ],
        ),
        border: Border.all(
          color: Colors.black87,
          width: _CatchRateConstants.pokeBallBorderWidth,
        ),
      ),
      child: Center(
        child: Container(
          width: _CatchRateConstants.centerLineWidth,
          height: _CatchRateConstants.centerLineHeight,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _PokeBallCenterButton extends StatelessWidget {
  const _PokeBallCenterButton();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: _CatchRateConstants.centerButtonTopOffset,
      child: Container(
        width: _CatchRateConstants.centerButtonSize,
        height: _CatchRateConstants.centerButtonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(
            color: Colors.black87,
            width: _CatchRateConstants.pokeBallBorderWidth,
          ),
        ),
      ),
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
            _PokeBallVisual(color: ballRate.color),
            const _PokeBallCenterButton(),
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
  final Pokemon pokemon;

  const CatchRateSection({
    super.key,
    required this.pokemon,
  });

  int _getMaxHP() {
    if (pokemon.stats == null) return 100;
    
    final hpStat = pokemon.stats!.firstWhere(
      (stat) => stat.name.toLowerCase() == 'hp',
      orElse: () => const PokemonStat(name: 'hp', baseStat: 100),
    );
    
    return hpStat.baseStat;
  }

  double _calculateCatchRate(
    int captureRate,
    double ballModifier,
    int maxHP, {
    int? currentHP,
    double statusModifier = 1.0,
  }) {
    final effectiveCurrentHP = currentHP ?? maxHP;
    
    final double hpFactor = (3 * maxHP - 2 * effectiveCurrentHP) / (3 * maxHP);
    final double a = hpFactor * captureRate * ballModifier * statusModifier;
    
    if (a >= 255) return 1.0;
    
    final double b = 1048560 / math.pow(16711680 / a, 0.25);
    
    final double shakeChance = math.min(b / 65535, 1.0);
    final double captureChance = math.pow(shakeChance, 4).toDouble();
    
    return captureChance.clamp(0.0, 1.0);
  }

  Color get _primaryTypeColor {
    final primaryType = pokemon.types.isNotEmpty
        ? pokemon.types.first.name
        : 'normal';
    return PokemonTypeColors.getColor(primaryType);
  }

  List<_BallRate> _getBallRates() {
    final maxHP = _getMaxHP();
    const double statusModifier = 1.0;

    return [
      _BallRate(
        rate: _calculateCatchRate(
          pokemon.captureRate!,
          _CatchRateConstants.pokeBallModifier,
          maxHP,
          statusModifier: statusModifier,
        ) * 100,
        color: Colors.red,
        label: 'Poké Ball',
      ),
      _BallRate(
        rate: _calculateCatchRate(
          pokemon.captureRate!,
          _CatchRateConstants.greatBallModifier,
          maxHP,
          statusModifier: statusModifier,
        ) * 100,
        color: Colors.blue,
        label: 'Great Ball',
      ),
      _BallRate(
        rate: _calculateCatchRate(
          pokemon.captureRate!,
          _CatchRateConstants.ultraBallModifier,
          maxHP,
          statusModifier: statusModifier,
        ) * 100,
        color: Colors.yellow[700]!,
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
          _SectionTitleBadge(color: _primaryTypeColor),
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
            children: ballRates.map((ballRate) => _PokeBallRateCard(ballRate: ballRate)).toList(),
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
