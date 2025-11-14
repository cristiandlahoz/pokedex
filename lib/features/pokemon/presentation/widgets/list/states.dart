import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../constants/list.dart';
import '../../../../../core/exceptions/failures.dart';

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) => const Center(
        child: Padding(
          padding: EdgeInsets.all(ListConstants.loadingIndicatorPadding),
          child: LinearProgressIndicator(color: Colors.deepOrange),
        ),
      );
}

class ErrorState extends StatefulWidget {
  final Failure failure;
  final VoidCallback onRetry;

  const ErrorState({
    super.key,
    required this.failure,
    required this.onRetry,
  });

  @override
  State<ErrorState> createState() => _ErrorStateState();
}

class _ErrorStateState extends State<ErrorState> {
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
                size: ListConstants.errorIconSize,
                color: Colors.red,
              ),
              const SizedBox(height: ListConstants.errorSpacing),
              Text(
                'Error: ${widget.failure.message}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: ListConstants.errorTextSize,
                ),
              ),
              if (kDebugMode) ...[
                const SizedBox(height: ListConstants.errorSpacing),
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
              const SizedBox(height: ListConstants.errorSpacing),
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

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) => const Center(
        child: Text(
          'No Pokémon found',
          style: TextStyle(fontSize: ListConstants.emptyStateTextSize),
        ),
      );
}
