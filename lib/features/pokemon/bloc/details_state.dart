import 'package:equatable/equatable.dart';
import '../../../core/exceptions/failures.dart';
import '../domain/entities/pokemon_details.dart';
import '../domain/value_objects/game_version.dart';

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
  final GameVersion? selectedGameVersion;
  final bool isShiny;

  const DetailsSuccess(
    this.pokemon, {
    this.selectedGameVersion,
    this.isShiny = false,
  });

  List<GameVersion> get allGameVersions {
    final availableVersionNames = pokemon.moves
        .map((move) => move.versionGroup)
        .where((vg) => vg != null)
        .toSet();
    
    return GameVersion.allVersions
        .where((version) => availableVersionNames.contains(version.name))
        .toList();
  }

  DetailsSuccess copyWith({
    PokemonDetails? pokemon,
    GameVersion? selectedGameVersion,
    bool clearGameVersion = false,
    bool? isShiny,
  }) {
    return DetailsSuccess(
      pokemon ?? this.pokemon,
      selectedGameVersion: clearGameVersion
          ? null
          : (selectedGameVersion ?? this.selectedGameVersion),
      isShiny: isShiny ?? this.isShiny,
    );
  }

  @override
  List<Object?> get props => [pokemon, selectedGameVersion, isShiny];
}

class DetailsFailure extends DetailsState {
  final Failure failure;

  const DetailsFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}
