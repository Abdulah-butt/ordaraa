# bloc_architecture

Flutter app architecture reference for building scalable, clean, and consistent apps.

This document is the source of truth for engineers and AI agents working in this repository. Follow it for folder placement, state management, navigation, theming, responsive UI, and duplication avoidance.

## 0. Starting a New App From This Base Project

To start a new app from this base project, the developer needs the following from this repository:

- `README.md`
- `pubspec.yaml` package list
- `tools/`
- `lib/`

Recommended setup flow:

1. Create a new Flutter app.
2. Copy the files and folders listed above from this repository into the new app and replace the generated ones where needed.
3. Run `flutter pub get`.
4. In the `ios/` folder, add the required `permission_handler` setup code.
5. In the `android/` folder, add internet permission.

After that, run the app. The basic architecture will be set up and running, and it can then be customized based on the requirements of the new app.

## 1. Tech Stack and Core Patterns

- `Flutter` + `MaterialApp.router`
- Routing: `go_router`
- Dependency injection: `get_it`
- State management: `flutter_bloc` with `Cubit`
- Networking: `dio`
- Local persistence: `hive`

Architectural style is layered with feature-oriented presentation:

- `presentation` depends on `domain`
- `domain` depends on abstractions
- `data` implements domain repositories
- `network` and `services` provide infrastructure

## 2. Folder Scheme

```text
lib/
  core/
    alert/          # global UI feedback helpers
    enums/          # shared enum definitions
    extensions/     # reusable extension methods
    navigation/     # AppNavigator + RouteParams base
    routes/         # AppRouter + page transition builder
    theme/          # theme, colors, typography
    utils/          # constants, assets, styles

  data/
    models/         # DTO and JSON mapping models
    repositories/   # concrete repository implementations

  domain/
    entities/       # pure business entities
    repositories/   # abstract repository contracts
    stores/         # global reactive stores
    usecases/       # reusable business actions

  network/
    dio/            # Dio implementation
    interceptors/   # auth/session/network interceptors

  presentation/
    pages/          # feature pages
    widgets/        # shared reusable widgets
    sheets/         # shared bottom sheet content

  services/         # platform or external services
  service_locator/  # DI bootstrap and registrations
```

## 2.1 Services Folder Standard

Device or platform-facing capabilities must live inside `lib/services/`.

Use a dedicated folder per service domain. Each service folder should normally contain at least two files:

- one abstract contract
- one implementation

Recommended naming pattern:

- `LocationService`
- `LocationServiceImpl`

Example:

```text
lib/services/
  location/
    location_service.dart        # abstract contract
    location_service_impl.dart   # concrete implementation
```

Service contracts should expose only the operations the app needs, for example:

- get current location
- check internet/connectivity state
- request device permissions
- read device information
- schedule or receive notifications

Use the `services/` folder for device or platform dependent concerns such as:

- internet/connectivity
- location
- notifications
- device info
- permissions
- date/time pickers
- upgrade or version checks

UI, Cubits, and use cases should depend on the abstract service contract. Register the implementation in `service_locator`.

## 3. App Bootstrap Flow

Startup chain:

1. `lib/main.dart`
2. `ServiceLocator.initialize()`
3. `AppRouter.initialize()`
4. `runApp(MainApp)`

`lib/main_app.dart` is responsible for:

- setting `MaterialApp.router` with `AppRouter.router`
- applying the app theme
- setting the global fallback widget
- disabling text scaling with `TextScaler.noScaling`
- overlaying internet connectivity state

## 4. Navigation Architecture

### 4.1 Router

- Central router lives in `lib/core/routes/app_router.dart`
- Every page should expose a static route path
- Route params should flow through `RouteParams`
- Use router-based navigation, not ad hoc route strings

### 4.2 AppNavigator Wrapper

`lib/core/navigation/app_navigator.dart` standardizes navigation operations such as:

- `push`
- `replace`
- `pushAndClearAllPrevious`
- `pop`
- `showBottomSheet`
- `showDialogBox`

Use `AppNavigator` for consistency instead of scattering raw navigation calls.

### 4.3 Navigator-Per-Feature Pattern

Each feature page should keep a `*_navigator.dart` file with:

- a navigator class that holds `BuildContext` and `AppNavigator`
- route methods or mixins needed by that feature

### 4.4 Route Params Contract

All page params should extend `RouteParams` and implement:

- `toMap()`
- `fromMap(Map<String, dynamic>)`

## 5. Page Module Contract

For each page feature, create these files together:

- `xxx_page.dart`
- `xxx_cubit.dart`
- `xxx_state.dart`
- `xxx_navigator.dart`
- `xxx_initial_params.dart`

This pattern is scaffolded in `tools/mason_template/page` and is the default page contract.

### 5.1 Page Rules

- In `initState`, set `cubit.navigator.context = context`
- In `initState`, call `cubit.onInit(initialParams)` when the feature needs setup
- Keep business logic out of the widget tree
- Move feature-only UI parts into `presentation/pages/<feature>/widgets/` when the page grows

### 5.2 Cubit Rules

Cubit responsibilities:

- input validation
- orchestration of use cases, repositories, and stores
- emitting UI state
- navigation through the feature navigator
- feedback through `AppSnackBar`

### 5.3 State Rules

State classes should be predictable value objects with:

- an `initial()` factory when appropriate
- `copyWith(...)`
- explicit loading, pagination, selection, and filter fields when needed

## 6. State Management Strategy

State is split into page state and global app state.

### 6.1 Page State

Feature Cubits under `presentation/pages/**` own screen-level state such as:

- loading
- pagination
- local filters
- tab selection
- transient UI behavior

### 6.2 Global State

Cross-page state belongs in `domain/stores` and should be used only when multiple features need to observe or share the same state.

### 6.3 Use Cases

Use cases in `domain/usecases` hold reusable business actions. If the same business flow appears in more than one Cubit, it should usually become a use case.

## 7. Data and Domain Boundaries

### 7.1 Domain

- `domain/entities` contains pure models
- `domain/repositories` contains abstract contracts
- `domain/usecases` contains business actions
- `domain/stores` contains app-wide reactive state

### 7.2 Data

- `data/models/*_json.dart` maps API or local payloads
- models should expose conversion helpers such as `toDomain()`
- repository implementations stay in `data/repositories`

### 7.3 Repository Implementations

Examples already present in this repo include:

- remote repositories backed by API services
- local repositories backed by Hive or other local persistence

Domain depends on abstractions. Concrete implementations are injected at startup.

## 8. Network Standards

- `NetworkRepository` is the abstraction
- `DioNetworkRepository` is the concrete implementation
- auth token injection is handled in `AuthInterceptor`
- API endpoints are centralized in `lib/network/api_endpoint.dart`

No page or widget should call `Dio` directly.

The same contract-first approach should be followed in `lib/services/`: define the abstract service first, then add its implementation.

## 9. Theme, Sizing, and Responsive UI Rules

### 9.1 Theme

Use the app theme as the single source of truth:

- `lib/core/theme/light_theme.dart`
- `lib/core/theme/dark_theme.dart`
- `AppColors`
- `AppTextStyles`

Do not hardcode random colors if the same intent already exists in the theme.

### 9.2 Extensions

Use extensions from `lib/core/extensions/` before introducing repeated helper code.

Examples already present include helpers for:

- theme access
- strings
- numbers
- dates
- iterables
- URLs

If the same transformation, formatting rule, or convenience access pattern appears in multiple places, create or extend an extension in `lib/core/extensions/`.

### 9.3 Style and Constants

Before adding new hardcoded UI values, check:

- `lib/core/utils/constants.dart`
- `lib/core/utils/style.dart`

Prefer shared spacing, text styles, borders, gradients, and other design helpers over one-off values.

### 9.4 Compact UI Requirement

All UI must be compact, responsive, and safe on small screens.

Mandatory rules:

- keep layouts tight and intentional rather than oversized
- avoid overflow on narrow devices
- prefer flexible widgets such as `Expanded`, `Flexible`, `Wrap`, and scrollable containers where needed
- avoid fixed heights and widths unless there is a strong reason
- test for long text, large lists, and smaller screen widths
- keep padding, icon size, and typography proportionate to mobile screens

### 9.5 Icons and Illustrations

Use icons and lightweight illustrations when they improve clarity or engagement, but keep them aligned with the current theme.

Rules:

- prefer theme-colored icons over arbitrary colors
- avoid decorative assets that fight the brand palette
- keep icon usage purposeful, not noisy
- if a reusable icon pattern appears more than once, extract it into a shared widget

### 9.6 Assets

All asset paths must be centralized in `lib/core/utils/assets.dart`.

Do not scatter raw asset strings across widgets.

## 10. Enum and Extension Standards

These rules are mandatory for engineers and AI agents.

### 10.1 Enums

If a value can belong to one of several known types, states, variants, or modes, prefer an enum instead of loose strings, ints, or booleans.

Rules:

- place shared enums in `lib/core/enums/`
- use clear names that reflect business meaning
- follow industry-standard naming and keep enum values explicit
- add mapping helpers only when needed, such as label conversion or API serialization
- avoid repeating magic string comparisons across the codebase

Examples of candidates for enums:

- login methods
- status types
- sort orders
- filter modes
- view variants

### 10.2 Extensions

If logic is duplicated across primitive values, domain values, or UI formatting helpers, prefer an extension.

Rules:

- place reusable extensions in `lib/core/extensions/`
- keep them focused and composable
- use extensions to remove duplication, not to hide complex business logic
- do not create multiple near-identical helpers in different files

## 11. Reuse and Duplication Prevention Rules

Follow these rules strictly:

1. If UI appears in two or more places, extract it to `presentation/widgets` or a feature-level `widgets/` folder.
2. If logic appears in two or more Cubits, extract it to a use case, store, service, or extension.
3. Keep responsibilities separated:
   - Page handles rendering and interaction wiring
   - Cubit handles state transitions and orchestration
   - Use case handles business actions
   - Repository handles data access
4. Never duplicate navigation URL building logic. Go through the navigator and route params contract.
5. Never duplicate API endpoint strings. Add them to `lib/network/api_endpoint.dart`.
6. Prefer existing shared components before creating new ones.
7. If a page needs helper widgets that are only used by that page, create a `widgets/` folder inside that page's folder and move them into separate files.
8. Do not leave large feature-only widget trees inside the main page file once they can be reasonably extracted.

## 12. Standard Workflow for a New Page

1. Create the page module files.
2. Add the page route in `AppRouter`.
3. Register the navigator and Cubit in `service_locator`.
4. Add use cases if business logic is reusable.
5. Add repository methods if new data access is needed.
6. Extract repeated UI parts to `widgets/`.
7. Use theme tokens, shared styles, and shared widgets.
8. If the page contains feature-only UI sections or helper widgets, create a local `widgets/` folder and split them into separate files.

## 13. Standard Workflow for a New Feature

1. Define or extend the domain entity.
2. Add or extend the repository contract in `domain/repositories`.
3. Implement the repository in `data/repositories`.
4. Map payloads using `data/models`.
5. Add a use case if the business flow is reusable.
6. Register dependencies in `service_locator`.
7. Consume the use case from the Cubit.
8. Build compact responsive UI with shared theme and style tokens.
9. Add route and navigator entry points if the feature is navigable.

## 14. AI Agent Guardrails

AI agents working in this repo must follow these rules:

- read this `README.md` first before making changes
- keep layered boundaries intact: `presentation -> domain -> data`
- keep the page-module file contract unless there is a clear reason not to
- use `get_it` registrations for new dependencies
- use `RouteParams` and app navigation abstractions
- use centralized theme, assets, constants, enums, and extensions
- create device or platform services inside `lib/services/<service_name>/` with an abstract contract and implementation pair
- prefer extraction over duplication
- create enums in `lib/core/enums/` when values have multiple known types
- create extensions in `lib/core/extensions/` when repeated helper logic appears
- keep UI compact, responsive, and free of small-screen overflow
- use icons or illustrations where helpful, but keep them consistent with theme coloring
- keep main page files small; move large feature-only UI sections into feature `widgets/`
- strictly create a screen-level `widgets/` folder for splash/auth/detail or any other page when extracting screen-specific widgets
- do not keep screen-specific helper widgets, decorative widgets, or long widget sections inside the main page file when they can live in separate files
- avoid direct framework or service calls from UI when abstractions already exist
- always access coloring from theme, extension we made on buildContext so it's future friendly for dual theme
- always access text sizing from theme, extension we made on buildContext
- never make a single file too lengthy, instead make smaller different files for widgets if needed and use them to keep code clean.

If unsure, align with the closest existing implementation in this repository and preserve the established structure.

## 15. Notes

- This repository already includes shared widgets, services, enums, and extensions. Reuse them before adding new abstractions.
- Some simple screens may not need the full page-module contract, but the default should still be the standard structure above.
