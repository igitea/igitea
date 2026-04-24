# Changelog

## [0.11.0] - 2026-04-24

### Fixed — StateType Parsing Error

- `StateType.fromJson` now accepts both `String` and `Map<String, dynamic>` to handle Gitea API returning issue/PR state as `"open"`/`"closed"` strings.
- `StateType` model now has a `value` field to store the string state.
- All models updated (Issue, PullRequest, NotificationSubject, Milestone) to pass raw json state without Map casting.
- All UI code updated to use `state?.value == 'open'` instead of `state?.toString().contains('open')`.
- Tests updated: 248 passing.

## [0.10.0] - 2026-04-24

### Added — Repo Detail Page

- `RepoDetailPage` with 5 tabs: Code, Issues, Pull Requests, Releases, Branches.
- File browser (`_CodeTab`) with breadcrumb navigation and directory traversal.
- `RepoFilePage` with Markdown rendering (flutter_markdown), image display, and code syntax highlighting (highlight).
- `file_icon.dart` helper widget for file type icons.
- Navigation from repo cards in Dashboard, RepoList, Profile, and Notification pages.

### Added — API & Data Layer

- `repoGetContents` and `repoListPullRequests` API methods in `GiteaApiService`.
- `getRepoContents` and `listPullRequests` in repository layer.
- `GetRepoContentsUseCase` and `ListPullRequestsUseCase` with DI wiring.
- `ContentsState`, `PullRequestsState`, and `ReleasesState` in `RepoNotifier`.

### Dependencies

- Added `flutter_markdown` and `highlight` packages.

## [0.9.0] - 2026-04-24

### Added — Avatar System

- Reusable `UserAvatar` and `OrgAvatar` widgets in `lib/presentation/widgets/`.
- User avatars on Profile, Dashboard, Issue cards, Notification cards.
- Organization avatars on Profile page org list.
- Repo owner avatars on RepoList and Dashboard.
- Graceful fallback to initials when avatar_url is null.

### Fixed — setState During Build

- Deferred `notifyListeners()` calls in `initState` via `WidgetsBinding.instance.addPostFrameCallback` across all pages to prevent "setState() or markNeedsBuild() called during build" errors.
- Fixed async `logout()` call in ProfilePage sign-out dialog.

### Changed

- Phase 8 marked complete: 234 tests, `flutter analyze` clean.

## [0.8.0] - 2026-04-24

### Added — Phase 8: Testing & Quality (in progress)

- 234 unit/widget tests passing across all layers.
- `flutter analyze` clean with no warnings.

### Changed

- Login page redesigned: username/password as primary auth method, token as secondary tab.
- Adaptive layout: NavigationRail on desktop, NavigationBar on mobile.

### Added — Web Platform Support

- Web platform target added (Android, iOS, macOS, Linux, Windows, Web).
- CORS middleware configuration for Gitea server compatibility.
- dart:io conditional imports for web compatibility.

## [0.7.0] - 2026-04-24

### Added — Phase 7: UI Layer

- Material 3 pages: Login, Dashboard, Repo List, Issue List, Notifications, Profile.
- Home page with bottom navigation routing.
- `lib/presentation/pages/` and `lib/presentation/state/` structure.

## [0.6.0] - 2026-04-24

### Added — Phase 6: State Management

- ChangeNotifier-based state managers: `AuthNotifier`, `UserNotifier`, `RepoNotifier`, `IssueNotifier`, `OrganizationNotifier`, `NotificationNotifier`.
- Loading / loaded / error state handling per feature.

## [0.5.0] - 2026-04-24

### Added — Phase 5: Domain Use Cases

- 30+ use case classes across 9 files: `auth_usecases`, `user_usecases`, `repo_usecases`, `issue_usecases`, `organization_usecases`, `notification_usecases`, `package_usecases`, `misc_usecases`, `admin_usecases`.
- All use cases return `Either<Failure, T>` for typed error handling.

## [0.4.0] - 2026-04-24

### Added — Phase 4: Repository Layer

- 8 repository interfaces in `lib/domain/repositories/`.
- 8 repository implementations in `lib/data/repositories/` mapping exceptions to domain failures.

## [0.1.0] - 2026-04-23

### Added — Phase 1: Project Bootstrap

- Bootstrap Flutter project with Android, iOS, macOS, Linux, and Windows support.
- Set up Clean Architecture folder structure under `lib/`.
- Add approved third-party dependencies: `http`, `path_provider`, `shared_preferences`, `url_launcher`, `file_picker`.
- Initialize bilingual README and CHANGELOG.

### Added — Phase 2: Model Generation

- Add `tools/generate_models.py` to generate Dart data models from `doc/openapi.yaml`.
- Generate 120+ Dart model classes under `lib/data/models/generated/`.
- Add unit tests for model serialization round-trips.

### Added — Phase 3: API Service

- Implement `ApiClient` with token/Basic auth, timeout, and error mapping.
- Implement `GiteaApiService` with 93 core API methods across all 10 tags.
- Add `tools/generate_api_service.py` for generating service methods from OpenAPI spec.
- Add unit tests for `ApiClient` and `GiteaApiService` covering success, 4xx, 5xx, and network failures.