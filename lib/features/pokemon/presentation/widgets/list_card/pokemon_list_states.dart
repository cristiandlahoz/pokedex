import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/ui_constants.dart';
import '../../../../../core/exceptions/failures.dart';

class PokemonLoadingState extends StatelessWidget {
  const PokemonLoadingState({super.key});

  @override
  Widget build(BuildContext context) => const Center(
        child: Padding(
          padding: EdgeInsets.all(PokemonListPageConstants.loadingIndicatorPadding),
          child: LinearProgressIndicator(color: Colors.deepOrange),
        ),
      );
}

class PokemonErrorState extends StatefulWidget {
  final Failure failure;
  final VoidCallback onRetry;

  const PokemonErrorState({
    super.key,
    required this.failure,
    required this.onRetry,
  });

  @override
  State<PokemonErrorState> createState() => _PokemonErrorStateState();
}

class _PokemonErrorStateState extends State<PokemonErrorState> {
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: PokemonListPageConstants.errorIconSize,
                color: Colors.red,
              ),
              const SizedBox(height: PokemonListPageConstants.errorSpacing),
              Text(
                'Error: ${widget.failure.message}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: PokemonListPageConstants.errorTextSize,
                ),
              ),
              if (kDebugMode) ...[
                const SizedBox(height: PokemonListPageConstants.errorSpacing),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _showDetails = !_showDetails;
                    });
                  },
                  icon: Icon(
                    _showDetails ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  ),
                  label: Text(_showDetails ? 'Hide Details' : 'Show Details'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.grey,
                  ),
                ),
                if (_showDetails) ...[
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(
                      widget.failure.toDetailedString(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                ],
              ],
              const SizedBox(height: PokemonListPageConstants.errorSpacing),
              ElevatedButton.icon(
                onPressed: widget.onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
}

class PokemonEmptyState extends StatelessWidget {
  const PokemonEmptyState({super.key});

  @override
  Widget build(BuildContext context) => const Center(
        child: Text(
          'No Pokémon found',
          style: TextStyle(fontSize: PokemonListPageConstants.emptyStateTextSize),
        ),
      );
}
