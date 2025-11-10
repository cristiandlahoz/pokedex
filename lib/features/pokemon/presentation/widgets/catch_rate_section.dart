import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/pokemon_type_colors.dart';
import '../../domain/entities/pokemon.dart';
import '../../domain/entities/pokemon_stat.dart';

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
    final numerator = (3 * maxHP - 2 * effectiveCurrentHP) * captureRate * ballModifier * statusModifier;
    final denominator = 3 * maxHP;
    final rate = (numerator / denominator) * 100;
    return math.min(rate, 100.0);
  }

  Color _getPrimaryTypeColor() {
    final primaryType = pokemon.types.isNotEmpty
        ? pokemon.types.first.name
        : 'normal';
    return PokemonTypeColors.getColor(primaryType);
  }


  @override
  Widget build(BuildContext context) {
    if (pokemon.captureRate == null) return const SizedBox.shrink();

    final maxHP = _getMaxHP();
    const double statusModifier = 1.0;

    final pokeBallRate = _calculateCatchRate(
      pokemon.captureRate!,
      1.0,
      maxHP,
      statusModifier: statusModifier,
    );
    final greatBallRate = _calculateCatchRate(
      pokemon.captureRate!,
      1.5,
      maxHP,
      statusModifier: statusModifier,
    );
    final ultraBallRate = _calculateCatchRate(
      pokemon.captureRate!,
      2.0,
      maxHP,
      statusModifier: statusModifier,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.defaultPadding),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getPrimaryTypeColor().withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _getPrimaryTypeColor(),
                width: 1.5,
              ),
            ),
            child: Text(
              'Catch rate',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: _getPrimaryTypeColor(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'When a Poké Ball is thrown at a wild Pokémon, the game uses that Pokémon\'s catch rate in a formula to determine the chances of catching that Pokémon. The catch rate can change according to the health of the Pokémon, the type of Poké Ball, the status condition, and active special powers.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: Colors.black54,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPokeBallRate(
                rate: pokeBallRate,
                color: Colors.red,
                label: 'Poké Ball',
              ),
              _buildPokeBallRate(
                rate: greatBallRate,
                color: Colors.blue,
                label: 'Great Ball',
              ),
              _buildPokeBallRate(
                rate: ultraBallRate,
                color: Colors.yellow[700]!,
                label: 'Ultra Ball',
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Sample rates for this Pokémon when on full HP and no status problems',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPokeBallRate({
    required double rate,
    required Color color,
    required String label,
  }) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: 70,
              height: 70,
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
                  width: 2,
                ),
              ),
              child: Center(
                child: Container(
                  width: 30,
                  height: 2,
                  color: Colors.black87,
                ),
              ),
            ),
            Positioned(
              top: 33,
              child: Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.black87,
                    width: 2,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.black87,
                    width: 1,
                  ),
                ),
                child: Text(
                  '${rate.toStringAsFixed(1)}%',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
