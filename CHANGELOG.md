# Changelog

## [0.18.1] - 2026-04-25

### Fixed — Commits/Branches/Tags Tab State Isolation

- **Root cause**: `RepoNotifier` used a single `_state` field for all tabs. When `listCommits()`/`listBranches()`/`listTags()` were called, they overwrote `_state`, causing the `RepoDetailPage` main builder to lose `RepoLoaded` and show loading spinners instead of tabs.
- **Fix**: Created separate state tracks (`CommitsState`, `BranchesState`, `TagsState`) with their own `Initial/Loading/Loaded/Error` classes, matching the existing `PullRequestsState` and `ReleasesState` pattern.
- `RepoNotifier` now has `_commitsState`, `_branchesState`, `_tagsState` fields with getters
- `listCommits()`, `listBranches()`, `listTags()` update their respective state tracks instead of the shared `_state`
- UI tabs (`_CommitsTab`, `_BranchesTab`, `_TagsTab`) now listen to `commitsState`/`branchesState`/`tagsState` respectively
- `CreatePRPage` updated to use `branchesState`
- Removed old `BranchesLoaded`/`CommitsLoaded`/`TagsLoaded` from `RepoState` hierarchy
- 247 tests passing, `flutter analyze` clean

## [0.18.0] - 2026-04-25

### Added — Organization Detail, Release Detail, Starred Repos, Fork

- `OrganizationDetailPage` with collapsible header and 3 tabs: Info, Repositories, Teams
- `ReleaseDetailPage` showing release info, body, assets with download links, tarball/zipball downloads
- `StarredReposPage` displaying user's starred repositories with pull-to-refresh
- Fork button in `RepoDetailPage` AppBar calling `createFork()` API
- `createFork()` method in `RepoNotifier` with `CreateForkUseCase`
- `ListOrgTeamsUseCase` added to `OrgNotifier` for teams tab
- Navigation from org avatars in `ProfilePage` to `OrganizationDetailPage`
- Navigation from release list items to `ReleaseDetailPage`
- Navigation from "My Stars" in `ProfilePage` to `StarredReposPage`
- New ARB keys: `info`, `teams`, `noTeams`, `location`, `visibility`, `assets`, `publishedAt`, `target`, `forked`
- 247 tests passing, `flutter analyze` clean

## [0.17.1] - 2026-04-25

### Added — Repository Deletion

- `DeleteRepoUseCase` with `DeleteRepoParams` in domain layer
- `deleteRepo()` method in `RepoNotifier` with `RepoLoading` → `RepoInitial` state transition
- Repository deletion implementation in `RepoSettingsPage`: confirmation dialog, API call, success navigation back to home
- `deleteRepoUseCase` wired through all 3 `Injection` initialization paths (`initialize()`, `updateAuth()`, `repoNotifier.updateUseCases()`)
- 247 tests passing, `flutter analyze` clean

## [0.17.0] - 2026-04-24

### Added — Activity Feed on Dashboard

- `listUserActivities()` API method in `GiteaApiService`: `GET /users/{username}/activities/feeds`
- `getUserActivities()` in `UserRepository` interface and `UserRepositoryImpl`
- `GetUserActivitiesUseCase` with `GetUserActivitiesParams`
- `UserNotifier.getUserActivities()` method and `_activities` field
- `_ActivityFeed` widget on Dashboard page showing recent user activities
- Activity types supported: create_repo, push_tag, delete_tag, create_issue, close_issue, reopen_issue, create_pull_request, merge_pull_request, close_pull_request, comment_issue, comment_pull_request, fork_repo, transfer_repo, delete_repo, wiki_page
- Activity cards show user avatar, action description, and timestamp
- Tap on activity card navigates to the related repository
- Shows up to 10 most recent activities

### Changed

- `UserNotifier` constructor and `updateUseCases()` now require `GetUserActivitiesUseCase`
- `Injection` class updated across all 3 initialization paths
- New ARB keys: `recentActivity`, `noActivity`, `createdRepo`, `pushedTag`, `deletedTag`, `createdIssue`, `closedIssue`, `reopenedIssue`, `createdPR`, `mergedPR`, `closedPR`, `commentedOnIssue`, `commentedOnPR`, `forkedRepo`, `transferredRepo`, `deletedRepo`, `updatedWiki`, `performedAction`, `inRepo`, `to`, `from`
- 247 tests passing, `flutter analyze` clean

## [0.16.0] - 2026-04-24

### Added — Notification Actions

- `markAllRead()` in `NotificationNotifier` using `MarkNotificationsReadUseCase`
- AppBar "Mark all as read" button now calls real API instead of just showing snackbar
- Single notification "Mark as read" button (check_circle icon) on unread notification cards
- Auto-refresh notification list after marking read

### Added — Create Issue Page

- `CreateIssuePage` with title and body input fields
- Submit button in AppBar with loading indicator
- Validation: title is required
- On success, pops with created issue; on error, shows snackbar

### Added — Deep Link Support

- `onGenerateRoute` in `IGiteaApp` for URL-based navigation
- Supported paths:
  - `/{owner}/{repo}` → RepoDetailPage
  - `/{owner}/{repo}/issues/{id}` → IssueDetailPage
  - `/{owner}/{repo}/pulls/{id}` → PRDetailPage

### Changed

- `NotificationNotifier` updated with `MarkNotificationsReadUseCase` in constructor and `updateUseCases()`
- `Injection` class updated for all 3 initialization paths
- New ARB keys: `newIssue`, `pleaseEnterTitle`
- 247 tests passing, `flutter analyze` clean

## [0.15.0] - 2026-04-24

### Added — Admin User Management

- New `AdminNotifier` with `AdminUsersState` and `AdminOperationState` for user CRUD operations
- `UserManagementPage` with full user list, create, edit, and delete functionality
- Admin-only access: visible only for `is_admin == true` users
- User list displays avatar, username, email, admin badge
- Create user dialog: username, email, full name, password, admin toggle, must-change-password toggle
- Edit user dialog: email, full name, admin toggle (username immutable)
- Delete user with confirmation dialog
- Auto-refresh user list after create/edit/delete operations
- New ARB keys: `createUser`, `editUser`, `deleteUser`, `deleteUserConfirmParams`, `userCreated`, `userUpdated`, `userDeleted`, `noUsersFound`, `pleaseEnterEmail`, `fullName`, `mustChangePassword`

### Changed

- `Injection` class updated with `AdminNotifier` initialization across all 3 paths (`initialize()`, `updateAuth()`)
- 247 tests passing, `flutter analyze` clean

## [0.14.0] - 2026-04-24

### Added — Internationalization (i18n) — Phase 12

- Full i18n support with 10 languages: English, Simplified Chinese (zh), Traditional Chinese (zh_TW), Japanese (ja), Korean (ko), Spanish (es), French (fr), German (de), Portuguese (pt), Russian (ru)
- `l10n.yaml` configured with `flutter gen-l10n`, generated files in `lib/l10n/`
- `AppLocalizations` wired into `IGiteaApp` with `localizationsDelegates` and `supportedLocales`
- All 12 page files updated to use `AppLocalizations.of(context)!` for hardcoded strings
- Language selector in Settings page with system-default option
- `ThemeNotifier.setLocale()`/`loadLocale()` with SharedPreferences persistence (`locale` key)
- `buildTestableWidget()` helper in `lib/widget_test_helpers.dart` for widget tests with l10n

### Added — Settings Page Language Selector

- Settings page now shows Language row below Theme picker
- Language dialog lists all 10 supported locales with checkmark on current selection
- Selecting "System default" clears persisted locale, uses platform locale

### Updated — Test Infrastructure

- Widget tests updated to use `buildTestableWidget()` with localizations support
- Fixed test assertions: "PRs" → "Pull Requests", "Access Token" → "Token", "Username & Password" → l10n check

### Changed

- 247 tests passing, `flutter analyze` clean

### Fixed — Issue List No-Refresh on Back Navigation

- `IssueNotifier` now uses a separate `IssuesListState` sealed class hierarchy for list data (`IssuesListInitial`, `IssuesListLoading`, `IssuesListLoaded`, `IssuesListError`), distinct from `IssueState` used for single-issue detail and other operations.
- `searchIssues()` and `listIssues()` update `_issuesListState` instead of `_state`, preventing navigation from overwriting list data.
- `IssueListPage` `_loadIssues()` skips redundant fetch when `IssuesListLoaded` already exists.
- `_IssueList` `RefreshIndicator` bug fixed: was creating a new `_IssueListPageState` instance instead of using the actual state's selected filter.

### Changed — IssueListPage Refactor

- `IssueListPage` now uses `searchIssues('', state)` global API instead of per-repo `listIssues` for cross-repository issue listing.
- Shows repo name on each issue card (from `issue.repository.full_name`).
- Filter chips for All/Open/Closed states.
- `searchIssues` now accepts optional `state` parameter.

### Added — Settings Page & Admin Features

- New `SettingsPage` with theme picker (light/dark/system), account info, sign-out.
- Admin section (visible only for `is_admin == true`): User Management (placeholder), Server Settings, Cron Tasks.
- Server Settings shows API/UI/Attachment/Repository configuration via dedicated use cases.
- Cron Tasks page displays all tasks with a "Run Now" button.
- New use cases: `EditUserUseCase`, `RunCronTaskUseCase`, `GetGeneralAPISettingsUseCase`, `GetGeneralUISettingsUseCase`, `GetGeneralAttachmentSettingsUseCase`, `GetGeneralRepoSettingsUseCase`.

### Changed — Profile Page

- Removed Repositories section from Profile page.
- Added Settings link (navigates to `SettingsPage`).
- Theme picker removed from Profile (moved to Settings).

## [0.12.0] - 2026-04-24

### Added — Comments & Issue/PR Operations

- Issue and PR detail pages now load and display comments with Markdown rendering.
- Comment input with send button on both Issue and PR detail pages.
- Close/Reopen issue button on IssueDetailPage using `EditIssueUseCase`.
- `CommentsState` sealed class and `listComments`/`createComment` methods in `IssueNotifier`.
- `searchIssues` global issue search method in `IssueNotifier`.
- PR merge button with confirmation dialog on PRDetailPage (for open, mergeable PRs).
- `mergePullRequest` API method, `MergePullRequestUseCase`, and `RepoNotifier.mergePullRequest()`.
- `issueSearchIssues` global issue search API method and `SearchIssuesUseCase`.

### Added — Search Page

- New `SearchPage` with tabs for searching repositories and issues globally.
- Added Search tab to HomePage navigation (first tab).
- `SearchResultsLoaded` state in `RepoNotifier` for repo search.
- `IssueListLoaded` state reused for global issue search results.

### Added — Star/Unstar Repositories

- Star/Unstar toggle button in RepoDetailPage AppBar.
- `userCurrentPutStar`, `userCurrentDeleteStar`, `userCurrentCheckStar` API methods.
- `starRepo`/`unstarRepo`/`checkStarred` repository methods and use cases.
- `toggleStar`/`checkStarred` methods in `RepoNotifier` with loading state.
- Star state persisted in `RepoNotifier` (checked on repo detail load).

### Added — Dark Mode & Settings

- `ThemeNotifier` with SharedPreferences persistence for light/dark/system theme preference.
- `SettingsPage` with theme picker, account info, and sign-out button.
- Settings tab added to HomePage navigation.
- Sign-out button moved from AppBar to Settings page.

### Changed

- `IssueNotifier` now includes `EditIssueUseCase`, `ListCommentsUseCase`, `CreateCommentUseCase`, `SearchIssuesUseCase`.
- `RepoNotifier` now includes `StarRepoUseCase`, `UnstarRepoUseCase`, `CheckStarredUseCase`, `MergePullRequestUseCase`.
- `IGiteaApp` now uses `ThemeNotifier` for `themeMode`.
- `Injection` wiring updated for all new use cases across all 3 initialization paths.
- 248 tests passing, `flutter analyze` clean.

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