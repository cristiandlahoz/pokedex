# Context Document: Flutter Pokédex with GraphQL

## Project Overview

This is a Flutter-based Pokédex mobile application built for a college development project. It integrates with the PokeAPI GraphQL endpoint to provide an interactive Pokemon exploration experience with advanced filtering, sorting, details display, and user experience features.

**Repository**: cristiandlahoz/pokedex  
**Platform**: Android/iOS (Flutter multiplatform)  
**Backend**: GraphQL API (https://graphql.pokeapi.co/v1beta2)  
**Current Status**: In active development - deadline tomorrow night  
**Total Code**: ~7,063 lines of Dart code

## Project Goals and Requirements

This is an academic project with specific mandatory requirements and optional enhancements. The evaluation criteria breakdown:

### Mandatory Requirements (Must be completed by tomorrow night)

1. **UI/UX (25%)** - Material Design 3, responsive design, search with debounce, error handling
2. **GraphQL Integration (10%)** - Optimized queries, pagination, caching, offline support
3. **Architecture (15%)** - Clean Architecture with 3-layer structure (data/domain/presentation)
4. **State Management (15%)** - BLoC pattern implementation
5. **Filtering and Sorting (10%)** - By type, generation, region, abilities, power
6. **Favorites and Persistence (10%)** - Local storage with Hive
7. **Animations (5%)** - Hero transitions, microinteractions
8. **Share Feature (5%)** - Generate and share Pokemon cards as images
9. **Interactive Map (5%)** - Show Pokemon regions/game appearances
10. **Accessibility/i18n (5%)** - Semantic labels, multi-language support
11. **Interactive Trivia (10%)** - "Who's that Pokemon?" game with scoring

### Detailed Details Page Requirements

The details page must include:
- Pokemon identity (name, number, types, sprites/artwork)
- Base stats (HP, Atk, Def, SpA, SpD, Spe) with radar chart or bars
- Abilities (name, isHidden flag, effect description max 140-160 chars)
- Evolution chain/branches with triggers (level, item, trade, friendship, time)
- Moves (filtered by version group/method, paginated, sortable)
- Type matchups (weaknesses/resistances/immunities with multipliers)
- Weight/height/egg groups metadata
- Variant forms support (Alolan, Galarian, etc.)
- Shiny toggle
- Favorite toggle with animation
- Share card functionality

### Optional Requirements
- Dark/Light mode
- Animated onboarding

## Architecture

The project follows **Clean Architecture** with strict separation of concerns:

```
lib/
├── core/                          # Shared infrastructure
│   ├── constants/                 # App-wide constants
│   ├── di/                        # Dependency injection (get_it + injectable)
│   ├── exceptions/                # Custom exceptions and failures
│   ├── graphql/                   # GraphQL client configuration
│   ├── logging/                   # Structured logging system
│   ├── theme/                     # Design tokens and theming
│   └── utils/                     # Utilities (Result type, responsive utils)
├── features/
│   └── pokemon/
│       ├── data/                  # Data layer
│       │   ├── datasources/       # GraphQL data sources
│       │   ├── dtos/              # Data Transfer Objects
│       │   └── repositories/      # Repository implementations
│       ├── domain/                # Domain layer
│       │   ├── entities/          # Business entities
│       │   ├── repositories/      # Repository contracts
│       │   ├── services/          # Business logic services
│       │   └── value_objects/     # Domain value objects
│       └── presentation/          # Presentation layer
│           ├── bloc/              # BLoC state management
│           ├── pages/             # Screen widgets
│           ├── widgets/           # Reusable UI components
│           └── utils/             # UI utilities
└── main.dart                      # App entry point
```

### Key Architectural Patterns

**Repository Pattern**: Abstracts data sources behind clean interfaces
- `PokemonRepository` (interface) in domain layer
- `PokemonRepositoryImpl` (implementation) in data layer
- Datasources handle GraphQL queries

**Result Pattern**: Type-safe error handling without exceptions
```dart
sealed class Result<T> {}
class Success<T> implements Result<T> { final T data; }
class ResultFailure<T> implements Result<T> { final Failure failure; }
```

**BLoC Pattern**: Unidirectional data flow for state management
- Events trigger state changes
- States represent UI snapshots
- Separation between business logic and UI

**Dependency Injection**: Using get_it + injectable
- Lazy singletons for services
- Injectable factories for BLoCs
- Modular dependency configuration

## Technology Stack

### Core Dependencies
- `flutter_bloc ^9.1.1` - State management
- `graphql_flutter ^5.2.1` - GraphQL client with caching
- `get_it ^9.0.5` - Service locator
- `injectable ^2.6.0` - Code generation for DI
- `hive ^2.2.3` + `hive_flutter ^1.1.0` - Local storage and GraphQL cache
- `equatable ^2.0.5` - Value equality for entities

### UI Dependencies
- `flutter_svg ^2.0.10` - SVG asset rendering (type icons)
- `cached_network_image ^3.4.1` - Image caching

### Development Dependencies
- `injectable_generator ^2.4.1` - DI code generation
- `build_runner ^2.4.7` - Code generation runner
- `mockito ^5.4.4` - Testing mocks
- `bloc_test ^10.0.0` - BLoC testing utilities

## Data Layer

### GraphQL Configuration

**Endpoint**: `https://graphql.pokeapi.co/v1beta2`

**Cache Strategy**: Hive-based GraphQL cache
- `FetchPolicy.cacheAndNetwork` for list queries (cache-first, then network)
- `FetchPolicy.cacheFirst` for details queries
- `FetchPolicy.cacheOnly` as fallback for offline support
- Network timeout: Configurable via `AppConstants.networkTimeoutSeconds`

### Query Structure

The app uses GraphQL fragments to eliminate duplication:

1. **BasicPokemonFields** - Used in list and search queries
   - id, name, height, weight, base_experience
   - pokemontypes with nested type data
   - pokemonsprites for images

2. **TypeEffectivenessFields** - Used in details queries
   - Type efficacies for damage calculations
   - Both offensive and defensive matchups

### Data Sources

**PokemonGraphQLDataSource** (`lib/features/pokemon/data/datasources/pokemon_graphql_datasource.dart`)

Methods:
- `getPokemonList()` - Paginated list with filtering/sorting
- `getPokemonDetails()` - Full details for a single Pokemon
- `searchPokemon()` - Search by name with ILIKE pattern matching

**Query Builder** (`query_builders/pokemon_query_builder.dart`)
- Dynamically builds GraphQL `order_by` clauses from Sorting value objects
- Constructs `where` clauses from Filters value objects
- Supports complex filtering (types, generations) with `_and` logic

### DTOs (Data Transfer Objects)

**ListItemDto** - Maps GraphQL response to Pokemon entity
- Handles sprite fallbacks (official-artwork → home → front_default)
- Parses type data into PokemonTypes enum
- `toDomain()` method converts to domain entity

**DetailsDto** - Maps complex details response
- Includes parsers for abilities, stats, moves, type effectiveness
- Handles nested GraphQL data structures
- Multiple parser files in `dtos/parsers/`

## GraphQL Schema Reference

### Schema Source of Truth

**CRITICAL**: For any question related to the GraphQL API schema structure, field availability, relationship definitions, or query capabilities, the authoritative source is:

**File**: `graphql/schema.graphqls` (57,694 lines)

**Important Notes**:
- The schema uses `pokemon_v2_*` table naming in the backend but exposes simplified type names
- All types are lowercase (e.g., `type pokemon`, `type ability`, `type move`)
- Relationships use camelCase (e.g., `pokemontypes`, `pokemonabilities`, `pokemonevolution`)
- The schema follows Hasura GraphQL conventions with auto-generated aggregates, filters, and ordering types

### Efficient Schema Lookup Strategy

Given the schema's size (57,694 lines), **always use targeted searches instead of reading the entire file**. Use ripgrep (rg) for fast, efficient lookups:

#### Pattern 1: Find Type Definition Line Number
```bash
# Find where a specific type is defined
rg "^type pokemon " graphql/schema.graphqls -n
# Returns: 34912:type pokemon {

# Then read specific range with Read tool
# read(filePath="graphql/schema.graphqls", offset=34911, limit=200)
```

#### Pattern 2: Search for Evolution-Related Types
```bash
# Find all types related to evolution
rg "^type.*evolution" graphql/schema.graphqls -n -i
```

#### Pattern 3: Search for Field Within Type
```bash
# Find if a field exists in pokemon type
rg "^\s+pokemonevolutions" graphql/schema.graphqls -A 10 -B 2
```

#### Pattern 4: Find Input/Filter Types
```bash
# Find boolean expression filters for pokemon
rg "input pokemon_bool_exp" graphql/schema.graphqls -n -A 50
```

#### Pattern 5: Find All Related Types for an Entity
```bash
# Find all pokemon-related type definitions (excluding aggregates)
rg "^type pokemon" graphql/schema.graphqls -n | rg -v "(_aggregate|_avg|_max|_min|_stddev|_sum|_var)"
```

### Core Types Quick Reference

Use this index to quickly locate important type definitions. Always verify field availability by reading the actual schema at these line numbers.

| Category | Type Name | Line Number | Purpose |
|----------|-----------|-------------|---------|
| **Core Pokemon** | `pokemon` | 34912 | Main Pokemon entity with all basic fields |
| | `pokemonspecies` | 42171 | Species-level data (evolution, habitat, descriptions) |
| **Pokemon Details** | `pokemonability` | 35766 | Pokemon-to-ability junction (includes is_hidden) |
| | `pokemonstat` | 44363 | Pokemon base stats (HP, Attack, Defense, etc.) |
| | `pokemontype` | 44680 | Pokemon-to-type junction |
| | `pokemonmove` | 41287 | Pokemon-to-move junction (learn method, level) |
| | `pokemonsprites` | 44120 | Sprite URLs (front_default, official-artwork, etc.) |
| **Evolution** | `pokemonevolution` | 37729 | Evolution triggers and chains |
| | `evolutionchain` | 9257 | Evolution chain structure |
| | `evolutiontrigger` | 9530 | Evolution trigger types (level, item, trade) |
| **Abilities** | `ability` | 17 | Ability definitions |
| | `abilityflavortext` | 1400 | Ability descriptions by language/version |
| | `abilityeffecttext` | 1113 | Ability effect descriptions |
| **Moves** | `move` | 21968 | Move definitions (power, accuracy, pp) |
| | `movelearnmethod` | 27332 | How moves are learned (level-up, TM, egg) |
| | `moveeffecteffecttext` | 26738 | Move effect descriptions |
| **Stats** | `stat` | 51979 | Stat definitions (hp, attack, defense, etc.) |
| **Types** | `type` | 53595 | Type definitions with effectiveness data |
| **Other** | `generation` | 10439 | Generation data (I-IX) |
| | `versiongroup` | 56072 | Game version groupings |
| | `region` | 51392 | Region data (Kanto, Johto, etc.) |
| | `language` | 16854 | Language codes (9 = English) |

**Usage Example**:
```bash
# Want to know what fields are available in pokemonevolution?
rg "^type pokemonevolution " graphql/schema.graphqls -n
# Returns: 37729

# Then read in code:
# read("graphql/schema.graphqls", offset=37728, limit=100)
```

### Common Schema Search Patterns

#### Find Available Fields in a Type
```bash
# List all direct fields in pokemon type (exclude nested queries)
rg "^type pokemon " graphql/schema.graphqls -n -A 200 | rg "^\s+[a-z_]+:" | head -20
```

#### Find Relationship Fields
```bash
# Find all relationship arrays in pokemon type
rg "^type pokemon " graphql/schema.graphqls -n -A 200 | rg '"""An array relationship"""' -A 1
```

#### Check if Field Exists
```bash
# Does pokemon have a 'forms' field?
rg "^type pokemon " graphql/schema.graphqls -A 500 | rg "^\s+forms"
```

#### Find Filter Capabilities
```bash
# What can I filter pokemon by?
rg "input pokemon_bool_exp" graphql/schema.graphqls -A 100
```

#### Find Ordering Options
```bash
# What can I order pokemon by?
rg "input pokemon_order_by" graphql/schema.graphqls -A 50
```

### Schema Naming Conventions

Understanding these patterns helps construct queries without looking up every detail:

1. **Type Names**: All lowercase, no prefixes
   - Table `pokemon_v2_pokemon` → Type `pokemon`
   - Table `pokemon_v2_pokemon_species` → Type `pokemonspecies`

2. **Relationship Fields**: CamelCase, pluralized for arrays
   - `pokemon.pokemontypes` → Array of pokemontype objects
   - `pokemon.pokemonabilities` → Array of pokemonability objects
   - `pokemonevolution.evolutionchain` → Single evolutionchain object

3. **Filter Inputs**: `{typename}_bool_exp`
   - `pokemon_bool_exp` - For filtering pokemon queries
   - `ability_bool_exp` - For filtering abilities

4. **Ordering Inputs**: `{typename}_order_by`
   - `pokemon_order_by` - For sorting pokemon results
   - `move_order_by` - For sorting moves

5. **Aggregate Types**: `{typename}_aggregate`, `{typename}_aggregate_fields`
   - Used for counts, sums, averages
   - Example: `pokemonabilities_aggregate(where: {is_hidden: {_eq: true}})`

6. **Comparison Operators**: Available in all `_bool_exp` filters
   - `_eq`, `_neq` - Equality
   - `_gt`, `_gte`, `_lt`, `_lte` - Comparisons
   - `_in`, `_nin` - Array membership
   - `_ilike`, `_like` - Pattern matching
   - `_is_null` - Null checks

### Cross-Reference to Existing Queries

The project already has well-structured queries that demonstrate best practices. Reference these for patterns:

**Location**: `lib/features/pokemon/data/datasources/pokemon_queries.dart`

**Key Patterns Used**:
1. **Fragments for Reusability**:
   - `BasicPokemonFields` - id, name, types, sprites (used in list/search)
   - `TypeEffectivenessFields` - type matchup data (used in details)

2. **Nested Relationships**:
   - `pokemontypes { type { id name } }` - Access type through junction table
   - `pokemonabilities { ability { abilityflavortexts } }` - Multi-level nesting

3. **Filtering by Language**:
   - All text uses `where: {language_id: {_eq: 9}}` for English
   - Flavor texts ordered by `order_by: {version_id: desc}` for latest

4. **Limiting Results**:
   - Moves limited to `${DesignTokens.defaultMovesLimit}` (50)
   - Always use `limit` for performance on large relationships

**When Building New Queries**:
- Start with the schema to understand available fields
- Check existing queries for similar patterns
- Use fragments to avoid duplication
- Always filter language_id for text fields
- Limit large relationship arrays

## Domain Layer

### Entities

**Pokemon** (`pokemon.dart`)
- id, name, imageUrl, height, weight, types
- displayName computed property (capitalized)
- Extends Equatable for value equality

**PokemonDetails** (`pokemon_details.dart`)
- Extends Pokemon with additional fields
- genus, description, abilities, stats, moves
- breeding info (egg groups, gender ratio)
- training info (base experience, capture rate)
- type defenses and offenses

**Supporting Entities**:
- `PokemonTypes` - Enum for all 18 Pokemon types
- `PokemonAbility` - name, isHidden, effect
- `PokemonStat` - name, baseStat, effort
- `PokemonMove` - name, power, accuracy, pp, type
- `PokemonGeneration` - id, name (I-IX)
- `TypeDefenseInfo` - type, damageFactor (multipliers)

### Value Objects

**Filters** (`filters.dart`)
- types: List<PokemonTypes>
- generations: List<PokemonGeneration>
- Computed properties: isEmpty, activeFilterCount, hasTypeFilters, hasGenerationFilters
- Immutable with copyWith

**Sorting** (`sorting.dart`)
- field: SortField enum (id, name, height, weight, baseExperience)
- direction: SortDirection enum (ascending, descending)
- defaultCriteria: id ascending
- Extensions for display names

### Repositories (Interfaces)

**PokemonRepository** - Abstract contract
```dart
Future<Result<List<Pokemon>>> getPokemonList({int page, int limit, Sorting?, Filters?});
Future<Result<PokemonDetails>> getPokemonDetails(int id);
Future<Result<List<Pokemon>>> searchPokemon(String query);
```

### Services

**CatchRateCalculator** - Calculates catch probability
**TypeEffectivenessCalculator** - Computes type matchups

## Presentation Layer

### BLoC Architecture

**ListBloc** (`home_bloc.dart`)
- Manages Pokemon list state
- Handles pagination (initial load + load more)
- Search with debounce (300-500ms via Timer in widget)
- Sorting and filtering application
- Internal state tracking for current sort/filter

**Events**:
- ListLoadRequested (with optional isRefresh flag)
- ListLoadMoreRequested
- ListSearchSubmitted
- ListSortApplied
- ListFilterApplied
- ListFiltersCleared

**States**:
- ListInitial
- ListLoading
- ListSuccess (pokemons, hasReachedMax, currentPage, sort, filter)
- ListLoadingMore (extends ListSuccess)
- ListFailure
- ListLoadMoreFailure (shows snackbar, maintains list)

**DetailsBloc** (`details_bloc.dart`)
- Loads Pokemon details by ID
- States: DetailsInitial, DetailsLoading, DetailsSuccess, DetailsFailure

### Pages

**PokemonListPage** (`home_page.dart`)
- Main list view with search, sort, filter
- Infinite scroll with threshold-based pagination
- Uses ScrollPaginationMixin for scroll handling
- Debounced search (300-500ms via Timer)
- Modal bottom sheets for sort/filter menus
- Pull-to-refresh support

**PokemonDetailsPage** (`details_page.dart`)
- Tabbed interface: About, Stats, Moves, Other
- NestedScrollView with collapsing header
- Fade-in animation on load
- Type-based color theming
- Sections: Species, Physical Stats, Catch Rate, Training, Breeding, Abilities, Evolution, Base Stats, Type Effectiveness, Moves

### UI Components

**Home Widgets**:
- ListAppBar - Search field with debounce, sort/filter buttons with badge
- ListContent - Grid of Pokemon cards with pull-to-refresh
- PokemonCard - Card with image, name, ID, types
- SearchField - Debounced text input
- Loading/Error states

**Details Widgets**:
- DetailsAppBar - Collapsing app bar with back button
- DetailsHeader - Hero image with background color
- Section components (abilities, stats, moves, etc.)
- TypeBadge - Displays type with icon and color

**Menus**:
- SortMenu - Bottom sheet with sort field/direction pickers
- FilterMenu - Bottom sheet with type and generation multi-select

### Utilities

**TypeHelper** - Type color/icon mapping
**TypeColors** - Color constants for each Pokemon type
**TypeIcons** - SVG asset paths for type icons
**Navigation** - Routing helpers
**ScrollPaginationMixin** - Reusable pagination logic

## Core Infrastructure

### Logging System

**Logger** (`logger.dart`)
- CanonicalLogger implementation
- Structured event logging (RequestEvent, ResponseEvent, ErrorEvent)
- Request ID tracking for correlation
- Duration tracking for performance monitoring

**BlocObserver** (`bloc_observer.dart`)
- Logs all BLoC events, state changes, and errors
- Integrates with Logger for consistency

### Theme System

**Tokens** (`tokens.dart`)
- Design constants (padding, border radius, animation duration)
- defaultPageSize: 20
- defaultMovesLimit: 50
- searchDebounceMs: 400

**AppTheme** - Material 3 theme configuration
**AppColors** - Color palette
**Type-specific colors** in TypeColors utility

### Exception Handling

**Exceptions** (`exceptions.dart`)
- GraphQLException with error parsing
- NetworkException, CacheException

**Failures** (`failures.dart`)
- ServerFailure, NetworkFailure, CacheFailure
- All extend abstract Failure class with message property

## State Management Flow

### List Loading Flow
1. User opens app → ListLoadRequested event
2. ListBloc emits ListLoading
3. Repository calls datasource.getPokemonList()
4. GraphQL query with pagination, sort, filter
5. Response mapped via ListItemDto.fromJson()
6. DTOs converted to Pokemon entities
7. Success/Failure result returned
8. ListBloc emits ListSuccess or ListFailure

### Pagination Flow
1. User scrolls to threshold → ListLoadMoreRequested
2. ListBloc checks state (not loading, not at max)
3. Emits ListLoadingMore (maintains current list)
4. Fetches next page with currentPage + 1
5. Appends results to existing list
6. Updates hasReachedMax if returned < pageSize

### Search Flow
1. User types in search field
2. Timer debounces input (400ms)
3. ListSearchSubmitted event fired
4. If empty query → triggers ListLoadRequested (reset to normal list)
5. Else → GraphQL search with ILIKE pattern
6. Results displayed with hasReachedMax=true (no pagination for search)

### Filtering/Sorting Flow
1. User opens filter/sort menu
2. Makes selection → closes modal
3. ListFilterApplied or ListSortApplied event
4. BLoC updates internal _currentFilter or _currentSort
5. Triggers ListLoadRequested(isRefresh: true)
6. Fetches page 0 with new filters/sort

## Current Implementation Status

### Completed Features
- GraphQL client with caching (Hive)
- Clean Architecture structure (data/domain/presentation)
- BLoC state management for list and details
- Pokemon list with pagination
- Search with debounce
- Filtering by type and generation
- Sorting by multiple fields
- Details page with tabs
- Type effectiveness display
- Abilities, stats, moves sections
- Error handling with retry
- Loading states
- Type-based theming

### Missing/Incomplete Features (based on requirements)
- **Radar chart for stats** (currently using bars, requirement specifies radar)
- **Evolution chain display** (section exists but not populated)
- **Favorites system** (persistence with Hive)
- **Offline mode** (cache exists but no dedicated favorites view)
- **Share Pokemon card** (generate image)
- **Interactive map** (regions/games)
- **Accessibility** (Semantics labels)
- **Internationalization** (i18n for trivia minimum)
- **Trivia game** ("Who's that Pokemon?")
- **Hero animations** (between list and details)
- **Microinteractions** (favorite toggle animation)
- **Dark/light mode** (optional)
- **Onboarding** (optional)
- **Moves filtering** (by method: level-up/TM/Tutor/Egg)
- **Pokemon forms/variants** (Alolan, Galarian, etc.)
- **Shiny toggle**
- **Gender ratio display**
- **Egg groups display**

## Known Technical Patterns

### Error Handling Pattern
```dart
try {
  final result = await repository.getPokemonList();
  switch (result) {
    case Success(:final data):
      // Handle success
    case ResultFailure(:final failure):
      // Handle failure
  }
} catch (e) {
  // Unexpected errors
}
```

### Widget State Pattern
Using pattern matching on states:
```dart
Widget build(BuildContext context) => switch (state) {
  ListInitial() => SizedBox.shrink(),
  ListLoading() => LoadingState(),
  ListSuccess() => ContentWidget(),
  ListFailure() => ErrorState(),
};
```

### Mixin Usage
`ScrollPaginationMixin` provides reusable scroll-based pagination logic:
- initializeScrollPagination()
- disposeScrollPagination()
- Abstract canLoadMore getter
- Abstract onLoadMore() method

## File Naming Conventions

- **Entities**: Lowercase with underscores (e.g., `pokemon.dart`, `pokemon_details.dart`)
- **BLoCs**: Feature name + `_bloc.dart`, `_event.dart`, `_state.dart`
- **Pages**: Feature name + `_page.dart`
- **Widgets**: Descriptive names (e.g., `app_bar.dart`, `card.dart`)
- **Constants**: Feature or scope name (e.g., `home.dart`, `app.dart`)
- **DTOs**: Descriptive + `_dto.dart` (e.g., `list_item_dto.dart`)

## Key Constants and Configuration

**AppConstants** (`lib/core/constants/app.dart`):
- searchDebounceMs: 400
- networkTimeoutSeconds: (to be verified)
- animationDurationMs: (to be verified)
- detailsTopBorderRadius: 32.0 (based on details page)

**DesignTokens** (`lib/core/theme/tokens.dart`):
- defaultPageSize: 20
- defaultMovesLimit: 50
- Various padding/spacing values

**ListConstants** (`lib/features/pokemon/presentation/constants/home.dart`):
- scrollThreshold: (pixel threshold for pagination trigger)

## GraphQL Query Examples

**List Query**:
```graphql
query GetPokemonList($limit: Int, $offset: Int, $order_by: [pokemon_order_by!], $where: pokemon_bool_exp) {
  pokemon(limit: $limit, offset: $offset, order_by: $order_by, where: $where) {
    id
    name
    height
    weight
    base_experience
    pokemontypes { type { id name } }
    pokemonsprites { sprites }
  }
}
```

**Search Query**:
```graphql
query SearchPokemon($name: String!) {
  pokemon(where: {name: {_ilike: $name}}) {
    # Same fields as list
  }
}
```

**Details Query** - Complex nested query including:
- Basic Pokemon fields
- Abilities with flavor text
- Stats with effort values
- Moves (limited to defaultMovesLimit)
- Species data (genus, description, capture rate, etc.)
- Type effectiveness for both offense and defense

## Important Implementation Notes

1. **Sprite Fallback**: Images prioritize official-artwork → home → front_default
2. **Language Filtering**: All text data uses language_id = 9 (English)
3. **Type Effectiveness**: Uses both `typeefficacies` and `TypeefficaciesByTargetTypeId` for comprehensive matchup data
4. **Pagination**: Offset-based (page * limit), not cursor-based despite cursor mention in requirements
5. **Cache-First Details**: Details page tries cache-first, falls back to cache-only for offline
6. **Search Limitations**: Search results don't support pagination (hasReachedMax always true)
7. **Error Recovery**: Load more failures show snackbar but maintain existing list
8. **Request Tracking**: Every repository call gets unique requestId for logging

## Development Workflow

1. **Code Generation**: Run `flutter pub run build_runner build` after DI changes
2. **Dependency Injection**: All services/repos registered via injectable annotations
3. **BLoC Creation**: Use getIt<BlocType>() in widgets, auto-disposed with widget lifecycle
4. **Adding Features**: Follow clean architecture layers (entity → repository interface → repository impl → datasource → DTO → BLoC → UI)

## Next Steps for Completion

To meet tomorrow night deadline, prioritize in order:
1. Evolution chain implementation (mandatory, 25% of UI/UX grade)
2. Radar chart for stats (mandatory, replacing bars)
3. Favorites with persistence (mandatory, 10% of grade)
4. Trivia game (mandatory, 10% of grade)
5. Share Pokemon card feature (mandatory, 5%)
6. Interactive map (mandatory, 5%)
7. Hero animations (mandatory, 5% animations grade)
8. Accessibility labels (mandatory, 5%)
9. i18n for trivia (mandatory, 5%)
10. Moves filtering by method (mandatory detail requirement)
11. Pokemon forms/variants (mandatory detail requirement)

Optional if time permits: Dark mode, onboarding