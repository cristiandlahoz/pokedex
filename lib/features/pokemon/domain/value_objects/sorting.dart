import 'package:equatable/equatable.dart';

enum SortField {
  id,
  name,
  height,
  weight,
  baseExperience,
}

enum SortDirection {
  ascending,
  descending,
}

class Sorting extends Equatable {
  final SortField field;
  final SortDirection direction;

  const Sorting({
    required this.field,
    required this.direction,
  });

  static const defaultCriteria = Sorting(
    field: SortField.id,
    direction: SortDirection.ascending,
  );

  bool get isDefault =>
      field == SortField.id && direction == SortDirection.ascending;

  Sorting copyWith({
    SortField? field,
    SortDirection? direction,
  }) {
    return Sorting(
      field: field ?? this.field,
      direction: direction ?? this.direction,
    );
  }

  @override
  List<Object?> get props => [field, direction];
}

extension SortFieldExtension on SortField {
  String get displayName {
    switch (this) {
      case SortField.id:
        return 'Pokédex Number';
      case SortField.name:
        return 'Name';
      case SortField.height:
        return 'Height';
      case SortField.weight:
        return 'Weight';
      case SortField.baseExperience:
        return 'Base Experience';
    }
  }
}

extension SortDirectionExtension on SortDirection {
  String get displayName {
    switch (this) {
      case SortDirection.ascending:
        return 'Ascending';
      case SortDirection.descending:
        return 'Descending';
    }
  }

  String get shortName {
    switch (this) {
      case SortDirection.ascending:
        return 'A → Z';
      case SortDirection.descending:
        return 'Z → A';
    }
  }
}
