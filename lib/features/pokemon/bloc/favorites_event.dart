import 'package:equatable/equatable.dart';

import '../domain/entities/pokemon.dart';

// Simple event - only toggle
sealed class FavoritesEvent extends Equatable {
  const FavoritesEvent();

  @override
  List<Object?> get props => [];
}

class FavoritesLoadRequested extends FavoritesEvent {
  const FavoritesLoadRequested();
}

class FavoriteToggled extends FavoritesEvent {
  final Pokemon pokemon;

  const FavoriteToggled(this.pokemon);

  @override
  List<Object?> get props => [pokemon];
}
