import 'dart:math' as math;

/// Domain service for calculating Pokemon catch rates
/// Implements the Gen III+ catch rate formula
/// https://bulbapedia.bulbagarden.net/wiki/Catch_rate
class CatchRateCalculator {
  CatchRateCalculator._();

  /// Calculates the catch probability for a Pokemon
  ///
  /// Parameters:
  /// - [captureRate]: The species' base capture rate (0-255)
  /// - [ballModifier]: The Poke Ball's catch rate modifier (e.g., 1.0 for standard, 1.5 for Great Ball)
  /// - [maxHP]: The Pokemon's maximum HP stat
  /// - [currentHP]: The Pokemon's current HP (defaults to maxHP if null)
  /// - [statusModifier]: Status condition modifier (1.0 = none, 1.5 = poisoned/burned/paralyzed, 2.5 = asleep/frozen)
  ///
  /// Returns: Probability of capture as a decimal between 0.0 and 1.0
  static double calculate({
    required int captureRate,
    required double ballModifier,
    required int maxHP,
    int? currentHP,
    double statusModifier = 1.0,
  }) {
    final effectiveCurrentHP = currentHP ?? maxHP;

    // HP Factor: how much HP the Pokemon has lost
    final double hpFactor =
        (3 * maxHP - 2 * effectiveCurrentHP) / (3 * maxHP);

    // Modified catch rate
    final double a = hpFactor * captureRate * ballModifier * statusModifier;

    // Guaranteed catch if modified rate >= 255
    if (a >= 255) return 1.0;

    // Calculate shake probability (b value)
    final double b = 1048560 / math.pow(16711680 / a, 0.25);

    // Calculate individual shake chance
    final double shakeChance = math.min(b / 65535, 1.0);

    // Overall capture chance (4 shakes must succeed)
    final double captureChance = math.pow(shakeChance, 4).toDouble();

    return captureChance.clamp(0.0, 1.0);
  }

  /// Common Poke Ball modifiers
  static const double pokeBallModifier = 1.0;
  static const double greatBallModifier = 1.5;
  static const double ultraBallModifier = 2.0;
  static const double masterBallModifier = 255.0;
  static const double netBallModifier = 3.5; // For Bug/Water types
  static const double diveBallModifier = 3.5; // Underwater
  static const double nestBallModifier = 1.0; // Varies by level
  static const double repeatBallModifier = 3.5; // If already caught
  static const double timerBallModifier = 1.0; // Increases with turns
  static const double luxuryBallModifier = 1.0;
  static const double premierBallModifier = 1.0;
  static const double duskBallModifier = 3.5; // At night or in caves
  static const double healBallModifier = 1.0;
  static const double quickBallModifier = 5.0; // First turn only
  static const double cherishBallModifier = 1.0;
  static const double parkBallModifier = 1.5;
  static const double dreamBallModifier = 1.0;

  /// Common status condition modifiers
  static const double noStatusModifier = 1.0;
  static const double poisonedModifier = 1.5;
  static const double burnedModifier = 1.5;
  static const double paralyzedModifier = 1.5;
  static const double asleepModifier = 2.5;
  static const double frozenModifier = 2.5;
}
