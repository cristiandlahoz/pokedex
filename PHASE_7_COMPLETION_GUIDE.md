# Phase 7 Completion Guide

## Status: Files Renamed, Content Updates Pending

The files have been renamed from "list" to "home", but class names and imports still need updating.

## What's Done ✅

Files renamed:
- `lib/features/pokemon/bloc/list_bloc.dart` → `home_bloc.dart`
- `lib/features/pokemon/bloc/list_event.dart` → `home_event.dart`
- `lib/features/pokemon/bloc/list_state.dart` → `home_state.dart`
- `lib/features/pokemon/presentation/pages/list_page.dart` → `home_page.dart`
- `lib/features/pokemon/presentation/widgets/list/` → `home/`
- `lib/features/pokemon/presentation/constants/list.dart` → `home.dart`

## What Remains 🔨

### Required Changes (Run with Flutter tools locally)

#### 1. Update BLoC Class Names

**In `lib/features/pokemon/bloc/home_bloc.dart`:**
- `class ListBloc` → `class HomeBloc`
- `ListEvent` → `HomeEvent`
- `ListState` → `HomeState`
- `ListInitial` → `HomeInitial`
- `ListLoading` → `HomeLoading`
- `ListSuccess` → `HomeSuccess`
- `ListLoadingMore` → `HomeLoadingMore`
- `ListLoadMoreFailure` → `HomeLoadMoreFailure`
- `ListFailure` → `HomeFailure`

**In `lib/features/pokemon/bloc/home_event.dart`:**
- `class ListEvent` → `class HomeEvent`
- `ListLoadRequested` → `HomeLoadRequested`
- `ListLoadMoreRequested` → `HomeLoadMoreRequested`
- `ListSearchSubmitted` → `HomeSearchSubmitted`
- `ListSortApplied` → `HomeSortApplied`
- `ListFilterApplied` → `HomeFilterApplied`
- `ListFiltersCleared` → `HomeFiltersCleared`

**In `lib/features/pokemon/bloc/home_state.dart`:**
- `class ListState` → `class HomeState`
- `ListInitial` → `HomeInitial`
- `ListLoading` → `HomeLoading`
- `ListSuccess` → `HomeSuccess`
- `ListLoadingMore` → `HomeLoadingMore`
- `ListLoadMoreFailure` → `HomeLoadMoreFailure`
- `ListFailure` → `HomeFailure`

#### 2. Update Page Class Names

**In `lib/features/pokemon/presentation/pages/home_page.dart`:**
- `class PokemonListPage` → `class HomePage`
- `_PokemonListPageState` → `_HomePageState`
- `State<PokemonListPage>` → `State<HomePage>`
- `late final ListBloc _pokemonBloc` → `late final HomeBloc _homeBloc`
- All `ListBloc` → `HomeBloc`
- All `ListEvent` → `HomeEvent`
- All `ListState` → `HomeState`
- All state class names (ListLoading → HomeLoading, etc.)

**In `lib/features/pokemon/presentation/pages/details_page.dart`:**
- `class PokemonDetailsPage` → `class DetailsPage`
- `_PokemonDetailsPageState` → `_DetailsPageState`
- `State<PokemonDetailsPage>` → `State<DetailsPage>`

#### 3. Update Constants

**In `lib/features/pokemon/presentation/constants/home.dart`:**
- `class ListConstants` → `class HomeConstants`

#### 4. Update Navigation

**In `lib/features/pokemon/presentation/utils/navigation.dart`:**
```dart
// Change import
import '../pages/details_page.dart';  // was list_page

// Update class reference
MaterialPageRoute(
  builder: (context) => DetailsPage(pokemon: pokemon),  // was PokemonDetailsPage
),
```

#### 5. Update main.dart

**In `lib/main.dart`:**
```dart
// Change import
import 'features/pokemon/presentation/pages/home_page.dart';  // was list_page

// Update class reference
runApp(const MaterialApp(home: HomePage()));  // was PokemonListPage
```

#### 6. Update All Import Statements

Find and replace across ALL files in `lib/features/pokemon/`:

**Imports to update:**
- `import '../bloc/list_bloc.dart'` → `import '../bloc/home_bloc.dart'`
- `import '../bloc/list_event.dart'` → `import '../bloc/home_event.dart'`
- `import '../bloc/list_state.dart'` → `import '../bloc/home_state.dart'`
- `import '../../bloc/list_bloc.dart'` → `import '../../bloc/home_bloc.dart'`
- `import '../constants/list.dart'` → `import '../constants/home.dart'`
- `import '../widgets/list/` → `import '../widgets/home/`
- `from 'list_event.dart'` → `from 'home_event.dart'`
- `from 'list_state.dart'` → `from 'home_state.dart'`

**Widget files to update (in `lib/features/pokemon/presentation/widgets/home/`):**
- `app_bar.dart` - imports only
- `card.dart` - imports only
- `card_image.dart` - imports only
- `card_info.dart` - imports only
- `content.dart` - imports and class references
- `id_badge.dart` - imports only
- `search_field.dart` - imports only
- `states.dart` - imports and class references

#### 7. Run Flutter Tools

After making all changes above:

```bash
# Get dependencies (if needed)
flutter pub get

# Regenerate DI code
flutter pub run build_runner build --delete-conflicting-outputs

# Verify no errors
flutter analyze

# Verify build
flutter build apk --debug  # or flutter build ios
```

## Automated Approach (Optional)

You can use find/replace tools to speed this up:

```bash
# Example using sed (macOS/Linux)
# From the lib/ directory:

# Update imports
find . -name "*.dart" -exec sed -i '' 's|bloc/list_|bloc/home_|g' {} +
find . -name "*.dart" -exec sed -i '' 's|constants/list\.dart|constants/home.dart|g' {} +
find . -name "*.dart" -exec sed -i '' 's|widgets/list/|widgets/home/|g' {} +

# Update class names
find . -name "*.dart" -exec sed -i '' 's|ListBloc|HomeBloc|g' {} +
find . -name "*.dart" -exec sed -i '' 's|ListEvent|HomeEvent|g' {} +
find . -name "*.dart" -exec sed -i '' 's|ListState|HomeState|g' {} +
find . -name "*.dart" -exec sed -i '' 's|ListInitial|HomeInitial|g' {} +
find . -name "*.dart" -exec sed -i '' 's|ListLoading|HomeLoading|g' {} +
find . -name "*.dart" -exec sed -i '' 's|ListSuccess|HomeSuccess|g' {} +
find . -name "*.dart" -exec sed -i '' 's|ListLoadingMore|HomeLoadingMore|g' {} +
find . -name "*.dart" -exec sed -i '' 's|ListLoadMoreFailure|HomeLoadMoreFailure|g' {} +
find . -name "*.dart" -exec sed -i '' 's|ListFailure|HomeFailure|g' {} +
find . -name "*.dart" -exec sed -i '' 's|ListConstants|HomeConstants|g' {} +
find . -name "*.dart" -exec sed -i '' 's|PokemonListPage|HomePage|g' {} +
find . -name "*.dart" -exec sed -i '' 's|PokemonDetailsPage|DetailsPage|g' {} +
find . -name "*.dart" -exec sed -i '' 's|_PokemonListPageState|_HomePageState|g' {} +
find . -name "*.dart" -exec sed -i '' 's|_PokemonDetailsPageState|_DetailsPageState|g' {} +
```

## Phase 8: Final Cleanup

After completing Phase 7:

1. Run `flutter analyze` and fix any remaining issues
2. Run `dart format lib -l 100` to format code
3. Verify app builds and runs correctly
4. Test all functionality (list, search, filter, sort, details)
5. Check that structured logs appear in console
6. Commit final changes

## Final Commit Messages

**After completing class name updates:**
```
refactor: complete rename from List to Home (Phase 7 complete)

Update all class names and imports from "List" to "Home" naming convention.
Improves code clarity and follows standard mobile app patterns.

Changes:
- Updated all BLoC class names (ListBloc → HomeBloc, etc.)
- Updated all page class names (PokemonListPage → HomePage, etc.)
- Updated all imports across ~30 files
- Updated main.dart and navigation

Benefits:
- Clearer naming that reflects intent (Home is landing page)
- Standard mobile app naming patterns
- Better user mental model
```

**After Phase 8:**
```
refactor: final cleanup and verification (Phase 8 complete)

Run analyzer, format code, and verify build. All 8 phases complete.

Summary:
- Removed unnecessary UseCase layer
- Replaced Dartz with native Dart 3.0 Result pattern
- Integrated canonical logging infrastructure
- Extracted magic numbers to constants
- Created specialized DTO parsers
- Extracted domain service for type effectiveness
- Renamed List → Home for clarity
- Final code cleanup

The refactoring is production-ready and follows Clean Architecture principles.
```
