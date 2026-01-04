import 'package:flutter/material.dart';

class TCGCardAbility extends StatelessWidget {
  final String? abilityName;
  final String? abilityEffect;
  final double scale;

  const TCGCardAbility({
    super.key,
    this.abilityName,
    this.abilityEffect,
    this.scale = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    if (abilityName == null) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.fromLTRB(
        12 * scale,
        8 * scale,
        12 * scale,
        5 * scale,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10 * scale,
                  vertical: 3 * scale,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.red.shade700, Colors.red.shade600],
                  ),
                  borderRadius: BorderRadius.circular(12 * scale),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 0.5 * scale,
                  ),
                ),
                child: Text(
                  'Ability',
                  style: TextStyle(
                    fontSize: 10 * scale,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              SizedBox(width: 10 * scale),
              Expanded(
                child: Text(
                  abilityName!,
                  style: TextStyle(
                    fontSize: 16 * scale,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                    letterSpacing: -0.1,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (abilityEffect != null) ...[
            SizedBox(height: 4 * scale),
            Text(
              abilityEffect!,
              style: TextStyle(
                fontSize: 11 * scale,
                color: Colors.black.withValues(alpha: 0.85),
                height: 1.2,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
