## MVI architecture for Homework Grade Calculator (lib/)

This document describes a practical Model-View-Intent (MVI) architecture for the final-grade calculator Flutter app. It focuses on keeping UI thin, business logic pure and testable, and state predictable and serializable for persistence.

### Folder layout (recommended)

```
lib/
  main.dart               # app entry, minimal wiring
  app.dart                # top-level MaterialApp, theme, routes
  ARCHITECTURE.md         # this file
  src/
    core/
      constants.dart      # numeric weights, string keys, default values
      validators.dart     # input validators and clamping helpers
    models/
      grade.dart          # domain model + helper conversions
      homework_item.dart  # small model for a homework entry
      app_state.dart      # immutable state representing the whole screen
    intents/
      grade_intent.dart   # typed user intents/events
    usecases/
      calculate_grade.dart# pure function / logic to compute final grade
    reducers/             # optional: pure reducers
      grade_reducer.dart
    presenters/
      grade_presenter.dart# Presenter (MVI) - receives intents, emits states, uses usecases + repo
    repositories/
      grade_repository.dart      # repository interface
      grade_repository_impl.dart # shared_preferences implementation (or Hive)
    views/
      home_page.dart        # UI screen - subscribes to presenter state
      widgets/
        numeric_input_tile.dart
        homework_list.dart
        homework_row.dart
        grade_result_card.dart
    di/
      injector.dart         # small factory/DI helpers

```

Notes:
- Keeping code inside `src/` helps make `lib/` tidy and intentionally highlights public entry points.

### Responsibilities

- View (UI widgets in `views/`):
  - Convert user interactions into typed Intents and forward them to the Presenter.
  - Subscribe to the Presenter's state stream and render UI purely from state.
  - No business logic or persistence in view code.

- Intent (`intents/`):
  - Small, typed classes/enums that describe user actions (e.g., UpdateParticipation, AddHomework, RemoveHomework(index), UpdateHomework(index, value), Calculate, Reset).

- Presenter (`presenters/grade_presenter.dart`):
  - Central coordinator for MVI. Receives Intents, validates them, optionally runs a Reducer/Usecase, updates state, and emits the new AppState.
  - Handles persistence via repository. Loads saved state at start and saves on important changes.
  - Exposes a single source of truth: a Stream<AppState> or ValueListenable<AppState>.

- Models (`models/`):
  - Immutable data shapes. `AppState` should be copyWith-able for easy state transitions.

- Usecases/Reducers:
  - Keep pure domain logic in `usecases/` (e.g., grade calculation). Reducers are pure functions that accept (oldState, intent) and return newState.

- Repository (`repositories/`):
  - Abstracts persistence concerns. Implement a `GradeRepository` interface and a `SharedPreferences`-based implementation for simplicity.

### Data flow (MVI)

1. User interacts with the UI (View). View creates a typed Intent and calls `presenter.dispatch(intent)`.
2. Presenter receives the Intent and either:
   - uses a Reducer to produce a new AppState synchronously, or
   - runs a Usecase (e.g., calculate final grade) and then updates state.
3. Presenter emits the new AppState through `stateStream` (or `ValueNotifier`).
4. View rebuilds from the emitted AppState.
5. Presenter persists the state (or selected fields) via Repository.

### Key types & simple contracts

- GradeIntent (sealed/union-like):
  - UpdateParticipation(double value)
  - AddHomework()
  - RemoveHomework(int index)
  - UpdateHomework(int index, double value)
  - UpdatePresentation(double value)
  - UpdateMidterm1(double value)
  - UpdateMidterm2(double value)
  - UpdateFinalProject(double value)
  - Calculate()
  - ResetHomeworks()

- AppState (immutable):
  - double participation
  - List<HomeworkItem> homeworks
  - double presentation
  - double midterm1
  - double midterm2
  - double finalProject
  - double? finalResult
  - String? errorMessage
  - bool isLoading

Presenter contract:
- Input: GradeIntent events (via dispatch)
- Output: Stream<AppState> (always emits a well-formed AppState)
- Error policy: set `errorMessage` in AppState on validation/persistence errors; do not throw from Presenter.

Usecase contract (calculate_grade):
- Input: numeric fields or AppState
- Output: double in range [0, 100] (clamped/rounded as desired)
- Behavior: pure, deterministic, fully covered by unit tests

### Homework weighting choices (important)

Two sensible handling strategies for homework weight (20% total across 4 homeworks):

- Option A (fixed slots): always expect 4 homework slots. Each slot carries 5% (20%/4). Missing slots are treated as 0. This is simple and deterministic.
- Option B (scale by provided items): average the provided homework grades, then scale to full 20%. This is friendlier if the user has fewer than 4 grades.

Recommendation: Implement Option A initially (treat missing as 0) and expose Option B as a toggle later if desired. Document the chosen approach in the UI.

### Validation & edge cases

- Input validation: clamp numeric inputs to [0,100] or set an error message and prevent Calculate. Prefer showing inline validation messages using `validators.dart`.
- Non-numeric input: UI widgets should only accept numeric keyboard and parse safely; Presenter should handle parse errors and reflect them in `AppState.errorMessage`.
- Persistence errors: Presenter should surface non-blocking warnings (snackbar via UI when `errorMessage` is set) and fall back to defaults.
- Concurrency: Presenter should serialize intent handling (queue) to avoid race conditions when saving/loading.

### Persistence

- Start with `shared_preferences` for simplicity. Save the AppState as a JSON string or save individual keys for each field and numeric list for homeworks.
- If you want typed, fast local DB later, migrate to `hive`.
- File: `repositories/grade_repository_impl.dart` with `save(AppState)` and `Future<AppState?> load()` methods.

### Dependency choice for Presenter streams

- Minimal dependencies: use `ValueNotifier<AppState>` and `ValueListenableBuilder` in UI.
- If you want reactive streams: use `StreamController.broadcast()` or `rxdart`'s BehaviorSubject for last-value replay semantics.

### Testing

- Unit tests for `calculate_grade` covering normal, boundary and invalid values.
- Unit tests for reducer/presenter ensuring intents produce correct state transitions.
- Widget tests for `homework_list` interactions (add/remove/update) and `home_page` rendering from state.

### Example development tasks (next steps)

- Create file skeletons matching the folder layout.
- Implement `AppState` with `copyWith` and JSON serialization for persistence.
- Implement `calculate_grade` with unit tests.
- Implement Presenter wiring, load saved state on startup, and wire `home_page` to presenter using `StreamBuilder` or `ValueListenableBuilder`.
- Implement the Homework UI with add/remove buttons and validation.

If you want, I can now create the skeleton files and a working example using `shared_preferences` and a simple UI, or I can implement only the MVI core (models, intents, presenter, usecase) — tell me which you prefer.

---

This architecture balances clarity, testability, and practical persistence for the homework exercise. It keeps UI code minimal and pushes logic into small, testable modules.
