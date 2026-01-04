import 'package:equatable/equatable.dart';

// Simple state - only favoriteIds set
sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoaded extends FavoritesState {
  final Set<int> favoriteIds;

  const FavoritesLoaded(this.favoriteIds);

  @override
  List<Object?> get props => [favoriteIds];
}

class FavoritesError extends FavoritesState {
  final String message;
  final Set<int> favoriteIds;

  const FavoritesError({required this.message, required this.favoriteIds});

  @override
  List<Object?> get props => [message, favoriteIds];
}
