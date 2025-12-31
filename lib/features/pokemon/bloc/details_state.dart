import 'package:equatable/equatable.dart';
import '../../../core/exceptions/failures.dart';
import '../domain/entities/pokemon_details.dart';

sealed class DetailsState extends Equatable {
  const DetailsState();

  @override
  List<Object?> get props => [];
}

class DetailsInitial extends DetailsState {
  const DetailsInitial();
}

class DetailsLoading extends DetailsState {
  const DetailsLoading();
}

class DetailsSuccess extends DetailsState {
  final PokemonDetails pokemon;
  final bool hasMoreMoves;
  final int currentMovesPage;

  const DetailsSuccess(
    this.pokemon, {
    this.hasMoreMoves = true,
    this.currentMovesPage = 0,
  });

  DetailsSuccess copyWith({
    PokemonDetails? pokemon,
    bool? hasMoreMoves,
    int? currentMovesPage,
  }) {
    return DetailsSuccess(
      pokemon ?? this.pokemon,
      hasMoreMoves: hasMoreMoves ?? this.hasMoreMoves,
      currentMovesPage: currentMovesPage ?? this.currentMovesPage,
    );
  }

  @override
  List<Object?> get props => [pokemon, hasMoreMoves, currentMovesPage];
}

class DetailsLoadingMoreMoves extends DetailsSuccess {
  const DetailsLoadingMoreMoves(
    super.pokemon, {
    required super.hasMoreMoves,
    required super.currentMovesPage,
  });
}

class DetailsFailure extends DetailsState {
  final Failure failure;

  const DetailsFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}
