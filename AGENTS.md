# Agent Guide: Flutter Pokédex

## Quick Reference

**Project**: Flutter Pokédex mobile app (Android/iOS)  
**Architecture**: Clean Architecture (data/domain/presentation)  
**State Management**: BLoC pattern  
**Backend**: GraphQL (https://graphql.pokeapi.co/v1beta2)  
**DI**: get_it + injectable  
**Storage**: Hive (cache + persistence)

---

## Build, Run & Test Commands

```bash
# Install dependencies
flutter pub get

# Run code generation (after DI or build_runner changes)
flutter pub run build_runner build

# Clean and regenerate (if build issues occur)
flutter pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run

# Build for release
flutter build apk --release           # Android
flutter build ios --release           # iOS

# Analyze code
flutter analyze

# Format code
flutter format .

# Run all tests
flutter test

# Run a single test file
flutter test test/path/to/test_file.dart

# Run tests with coverage
flutter test --coverage

# NOTE: Currently no test files exist in this project
```

---

## Code Style Guidelines

### Import Order
1. Dart SDK imports (`dart:...`)
2. Flutter framework imports (`package:flutter/...`)
3. External package imports (`package:other/...`)
4. Internal package imports (`package:pokedex/...`)
5. Relative imports

```dart
import 'dart:async';

import 'package:flutter/material.dart';

import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

import 'package:pokedex/core/utils/result.dart';

import '../domain/entities/pokemon.dart';
```

### File Naming
- **Files**: lowercase_with_underscores.dart
- **Classes**: PascalCase
- **Variables/functions**: camelCase
- **Constants**: camelCase (final/const) or SCREAMING_SNAKE_CASE (static const)
- **BLoCs**: `feature_bloc.dart`, `feature_event.dart`, `feature_state.dart`
- **Pages**: `feature_page.dart`
- **DTOs**: `descriptive_dto.dart`

### Type Annotations
Always use explicit types:
```dart
// Good
final String name = 'Pikachu';
final List<Pokemon> pokemon = [];

// Avoid
final name = 'Pikachu';
final pokemon = [];
```

### Null Safety
- Use `?` for nullable types
- Use `required` for mandatory named parameters
- Prefer `??` and `?.` operators over null checks

```dart
class Pokemon {
  final int id;
  final String name;
  final String? imageUrl;  // Nullable

  const Pokemon({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  String get displayUrl => imageUrl ?? 'default.png';
}
```

### Error Handling

**Use the Result pattern** - Never throw exceptions from repository/datasource:
```dart
Future<Result<List<Pokemon>>> getPokemonList() async {
  try {
    final data = await dataSource.getPokemonList();
    return Success(data);
  } on Failure catch (failure) {
    return ResultFailure(failure);
  }
}
```

**Pattern matching on Results**:
```dart
switch (result) {
  case Success(:final data):
    // Handle success
  case ResultFailure(:final failure):
    // Handle failure
}
```

**Custom Failures** (in `core/exceptions/failures.dart`):
- ServerFailure - API errors
- NetworkFailure - Connectivity issues
- CacheFailure - Local storage errors

### Clean Architecture Layers

**Domain Layer** (entities, repositories, value objects):
```dart
// NO dependencies on data or presentation layers
// Pure business logic only
abstract class PokemonRepository {
  Future<Result<List<Pokemon>>> getPokemonList();
}
```

**Data Layer** (DTOs, datasources, repository implementations):
```dart
@LazySingleton(as: PokemonRepository)
class PokemonRepositoryImpl implements PokemonRepository {
  final PokemonGraphQLDataSource dataSource;
  // Implementation here
}
```

**Presentation Layer** (BLoCs, pages, widgets):
```dart
@injectable
class ListBloc extends Bloc<ListEvent, ListState> {
  final PokemonRepository repository;
  // BLoC logic here
}
```

### BLoC Pattern

**Events**: Immutable, extend base event, use sealed classes:
```dart
sealed class ListEvent extends Equatable {
  const ListEvent();
}

final class ListLoadRequested extends ListEvent {
  final int page;
  const ListLoadRequested({this.page = 0});
  @override
  List<Object?> get props => [page];
}
```

**States**: Immutable, extend base state:
```dart
sealed class ListState extends Equatable {
  const ListState();
}

final class ListLoading extends ListState {
  const ListLoading();
  @override
  List<Object?> get props => [];
}
```

**BLoC**: Use event handlers:
```dart
@injectable
class ListBloc extends Bloc<ListEvent, ListState> {
  ListBloc({required this.repository}) : super(const ListInitial()) {
    on<ListLoadRequested>(_onListLoadRequested);
  }

  Future<void> _onListLoadRequested(
    ListLoadRequested event,
    Emitter<ListState> emit,
  ) async {
    emit(const ListLoading());
    // Handle event
  }
}
```

### Dependency Injection

**Register services/repositories**:
```dart
@LazySingleton(as: PokemonRepository)
class PokemonRepositoryImpl implements PokemonRepository { }

@injectable
class ListBloc extends Bloc<ListEvent, ListState> { }

@lazySingleton
class SomeService { }
```

**After adding @injectable annotations, run**:
```bash
flutter pub run build_runner build
```

### Widget Patterns

**Pattern matching for state-based UI**:
```dart
@override
Widget build(BuildContext context) {
  return BlocBuilder<ListBloc, ListState>(
    builder: (context, state) => switch (state) {
      ListInitial() => const SizedBox.shrink(),
      ListLoading() => const LoadingWidget(),
      ListSuccess() => ContentWidget(state.pokemons),
      ListFailure() => ErrorWidget(state.failure),
    },
  );
}
```

**Const constructors**: Always use const where possible:
```dart
const SizedBox.shrink()
const EdgeInsets.all(16.0)
const ListInitial()
```

---

## GraphQL Schema Reference

**Schema file**: `graphql/schema.graphqls` (57,694 lines)

**NEVER read the entire file**. Use ripgrep to find specific types:
```bash
# Find a type definition
rg "^type pokemon " graphql/schema.graphqls -n

# Then read specific lines
# read(filePath="graphql/schema.graphqls", offset=LINE_NUM, limit=100)
```

**Key conventions**:
- Type names: lowercase (`pokemon`, `ability`, `move`)
- Relationships: camelCase plurals (`pokemontypes`, `pokemonabilities`)
- Filters: `{type}_bool_exp` (`pokemon_bool_exp`)
- Ordering: `{type}_order_by` (`pokemon_order_by`)
- **Language filtering**: Always use `language_id: {_eq: 9}` for English text

---

## Important Project Patterns

### GraphQL Queries
Use fragments to avoid duplication (`lib/features/pokemon/data/datasources/pokemon_queries.dart`)

### DTOs to Domain
All DTOs must have a `toDomain()` method:
```dart
Pokemon toDomain() => Pokemon(
  id: id,
  name: name,
  types: types,
);
```

### Logging
All repository calls are logged with request IDs and duration tracking.

### Constants
- Design tokens: `lib/core/theme/tokens.dart`
- Feature constants: `lib/features/pokemon/presentation/constants/`

---

## Common Tasks

### Adding a new BLoC
1. Create event, state, and bloc files
2. Add `@injectable` annotation to BLoC class
3. Run `flutter pub run build_runner build`
4. Use in widget: `BlocProvider(create: (_) => getIt<MyBloc>())`

### Adding a new GraphQL query
1. Check schema with ripgrep
2. Add query to `pokemon_queries.dart` (use fragments)
3. Add method to datasource
4. Create/update DTO with parser
5. Update repository implementation

### Modifying entities
1. Update entity class
2. Update corresponding DTO
3. Update `toDomain()` method
4. Update BLoC states if needed
5. Update UI widgets

---

**For comprehensive architecture and project context, see the full project documentation in this file's history or ask for specific details.**
