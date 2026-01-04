import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/responsive_utils.dart';
import '../../bloc/favorites_bloc.dart';
import '../../bloc/favorites_event.dart';
import '../../bloc/favorites_state.dart';
import '../../domain/entities/pokemon.dart';

class FavoriteToggleButton extends StatefulWidget {
  final Pokemon pokemon;
  final Color? color;
  final double? size;

  const FavoriteToggleButton({
    super.key,
    required this.pokemon,
    this.color,
    this.size,
  });

  @override
  State<FavoriteToggleButton> createState() => _FavoriteToggleButtonState();
}

class _FavoriteToggleButtonState extends State<FavoriteToggleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.3,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPressed(BuildContext context, bool isFavorited) {
    if (_isLoading) return; // Prevent multiple taps while loading

    setState(() => _isLoading = true);

    // Trigger animation only for removing favorites (immediate)
    if (isFavorited) {
      _controller.forward().then((_) => _controller.reverse());
    }

    // Toggle favorite
    context.read<FavoritesBloc>().add(FavoriteToggled(widget.pokemon));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FavoritesBloc, FavoritesState>(
      listener: (context, state) {
        // Clear loading state when operation completes
        if (state is FavoritesLoaded || state is FavoritesError) {
          if (_isLoading) {
            setState(() => _isLoading = false);
          }
        }

        // Show error Snackbar
        if (state is FavoritesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              duration: const Duration(seconds: 3),
              action: SnackBarAction(
                label: 'Dismiss',
                onPressed: () {
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                },
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        final favoriteIds = switch (state) {
          FavoritesLoaded(:final favoriteIds) => favoriteIds,
          FavoritesError(:final favoriteIds) => favoriteIds,
          _ => <int>{},
        };

        final isFavorited = favoriteIds.contains(widget.pokemon.id);

        return ScaleTransition(
          scale: _scaleAnimation,
          child: _isLoading
              ? SizedBox(
                  width:
                      widget.size ?? ResponsiveUtils.getFontSizeLarge(context),
                  height:
                      widget.size ?? ResponsiveUtils.getFontSizeLarge(context),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        widget.color ?? Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                )
              : IconButton(
                  icon: Icon(
                    isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: widget.color ?? Colors.white.withValues(alpha: 0.7),
                    size:
                        widget.size ??
                        ResponsiveUtils.getFontSizeLarge(context),
                  ),
                  onPressed: () => _onPressed(context, isFavorited),
                  splashRadius: 20,
                ),
        );
      },
    );
  }
}
