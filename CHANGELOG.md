# Changelog

## [Unreleased]

### Added
- Create issue FAB on repo issues tab
- Opener, relative time, and comment count to issue list items
- Open/Closed/All filter chips on repo issues tab with pull-to-refresh

### Fixed
- Milestone edit: fix `due_on` date format (add timezone offset) to prevent server parse error
- macOS DMG: use correct app name `igitea.app` instead of `Runner.app`
- macOS: add ad-hoc codesigning to reduce Gatekeeper friction
- Linux AppImage: use existing Android launcher icon instead of missing `assets/icon.png`
- Linux AppImage: set `APPIMAGE_EXTRACT_AND_RUN=1` for FUSE-less CI environments
- Issue comment list: remove minimum bubble width so short comments don't look too wide
- Issue comment list: move menu button to overlay to reduce bubble height
- Release workflow: migrate from archived `subosito/flutter-action` to `flutter-actions/setup-flutter@v4`

## [0.23.2] - 2026-05-01

### Added — GitHub Release Workflow

- `.github/workflows/release.yml`: push `v*` tag triggers automated builds for Android (APK+AAB), iOS (IPA), macOS (DMG), Linux (AppImage), Windows (ZIP)
- All artifacts attached to GitHub Release

## [0.23.1] - 2026-05-01

### Fixed

- Chinese translations: completed 400+ keys
- Moved `igiteaVersion` from ARB to Dart constant

### Changed — i18n: Replace hardcoded English strings across all pages

- 20+ pages updated: repo detail, settings, dashboard, repo list, organizations, teams, issues, SSH keys, login, commit/PR detail, actions, file compare/history, repo file
- Replaced hardcoded strings for stat labels, clone URLs, PR states, relative dates, form validation, empty states with l10n calls
- Added 20 new ARB keys for previously untranslated strings
- Added Chinese translations for all new keys
- Used existing `l10n.ago()` for relative date formatting across 10+ files

## [0.23.0] - 2026-05-01

### Added — Milestone CRUD

- `CreateMilestonePage`: create milestone page
  - Title input (required validation)
  - Description input (Markdown, multiline)
  - Date picker for due date
  - AppBar save button with loading indicator
- `EditMilestonePage`: edit milestone page
  - Pre-filled with existing data (title, description, due date)
  - Support clearing due date
  - Auto-refresh list after save
- `MilestoneDetailPage` enhanced:
  - AppBar edit and delete buttons
  - Confirmation dialog before deletion
  - Auto-refresh after editing
- `_MilestonesTab` enhanced:
  - Add FAB for creating new milestones
  - Create/edit triggers auto-refresh
- New UseCases: `GetMilestoneUseCase`, `EditMilestoneUseCase`, `DeleteMilestoneUseCase`
- New ARB keys: `createMilestone`, `editMilestone`, `deleteMilestone`, `deleteMilestoneConfirm`, `milestoneDeleted`, `milestoneTitle`, `milestoneDescription`, `milestoneDueDate`, etc.
- Update `Injection` class: add milestone CRUD use cases to all three init paths
- Update `IssueNotifier`: add `createMilestone`, `editMilestone`, `deleteMilestone` methods

### Added — Full Wiki Support

- `WikiEditPage`: create and edit wiki pages
  - Title input (required when creating, read-only when editing)
  - Markdown content editor with live preview toggle
  - Optional commit message input
  - Form validation: title cannot be empty
  - AppBar save button with loading indicator
- `WikiListPage` refactored:
  - Add FloatingActionButton (FAB) for creating new pages
  - Use `EmptyState` widget instead of inline empty state
  - Full i18n support
  - Auto-refresh list after returning from page detail
- `WikiDetailPage` enhanced:
  - AppBar edit and delete buttons
  - Confirmation dialog before deletion
  - Support for selectable Markdown content
  - Use `Either` pattern instead of try-catch
- New UseCases: `GetWikiPageUseCase`, `ListWikiPagesUseCase`, `CreateWikiPageUseCase`, `EditWikiPageUseCase`, `DeleteWikiPageUseCase`
- New Repository methods: `getWikiPage`, `listWikiPages`, `createWikiPage`, `editWikiPage`, `deleteWikiPage`
- New ARB keys: `wiki`, `newWikiPage`, `editWikiPage`, `deleteWikiPage`, `deleteWikiPageConfirm`, `wikiPageDeleted`, `wikiPageTitle`, `wikiPageContent`, `noWikiPages`, `createFirstWikiPage`, `lastCommit`, `commitMessage`, `saved`, `created`, etc.
- Update `Injection` class: add Wiki use cases to all three initialization paths
- Update `RepoNotifier`: add Wiki-related fields and methods

### Fixed

- Fix missing Wiki entry in `RepoDetailPage`: add Wiki option to repository sections list (`id: 'wiki'`), and handle Wiki navigation to `WikiListPage` in `_RepoSectionPage`
- Fix double back button in Wiki pages: bypass `_RepoSectionPage` wrapper for wiki navigation
- Fix label flickering in Issue edit page: `IssueNotifier._state` overwritten by `listLabels`/`listMilestones`; cache data locally
- Fix issue labels not saving: `EditIssueOption` lacks `labels` field; use separate `PUT /issues/{index}/labels` endpoint
- Fix issue label data format: API expects label IDs (int), not names (String)
- Fix commit detail changed files overflow on window resize: wrap diff lines in `SingleChildScrollView(horizontal)`

### Added — Webhook Management

- `WebhookListPage`: list webhooks with FAB create, pull-to-refresh, empty state
- `WebhookDetailPage`: config (URL, Content-Type), events list, delete action
- `CreateWebhookPage`: URL, secret, content type, event multi-select, active toggle
- New UseCases: `ListHooksUseCase`, `CreateHookUseCase`, `DeleteHookUseCase`
- Update `RepoNotifier` with hook methods

### Added — Label Management

- `LabelListPage`: list repo labels with color indicators
- `CreateLabelPage`: name, description, preset color picker
- `EditLabelPage`: edit with delete button and confirmation dialog
- `IssueNotifier`: add `createLabel`, `editLabel`, `deleteLabel` methods
- New UseCases: `EditLabelUseCase`, `DeleteLabelUseCase`
- Add Labels entry to repo detail section list

### Added — OAuth2 Login

- New OAuth2 tab on login page (3rd tab)
- Flow: fill Client ID/Secret → browser authorize → paste code → exchange token → auto-login
- `AuthMethod.oauth2` + `refreshToken` support
- `AuthStorage` refresh token persistence
- Add `postRaw` API method for `/login/oauth/access_token` endpoint

### Added — Issue Create/Edit Enhancements

- `CreateIssuePage`: add label multi-select (FilterChip with color) + milestone dropdown
- `EditIssuePage`: same label/milestone enhancements, FilterChip shows label colors
- Create/edit requests include `labels` (ID list) and `milestone` fields

### Added — PR Diff Viewer

- `DiffParser`: unified diff parser (DiffFile → DiffHunk → DiffLine)
- `PrDiffViewerPage`: file-level nav, @@ hunk headers, line-level add/delete coloring, line numbers
- Unified/Split view mode toggle
- `PrFilesPage`: add "View Diff" button + file tap navigates to diff viewer

### Added — File History, Compare & Blame

- `FileHistoryPage`: commit history for a file, navigates to CommitDetailPage
- `FileComparePage`: base/head ref input → diff rendering
- `FileBlamePage`: blame API (SHA + author avatar per line), falls back to simple line view
- File viewer AppBar `⋯` menu: History / Compare / Blame
- `listCommits` supports `path` parameter for file-level filtering

### Added — CI/CD Actions Integration

- `ActionsListPage` enhanced:
  - Group runs by workflow file
  - Status filter chips (All / success / failure / in_progress / queued / cancelled / skipped)
  - Actor filter chips
  - Infinite scroll pagination
  - State preserved on navigation (AutomaticKeepAliveClientMixin)
  - `repoListActionWorkflows` API for workflow list
  - Job log auto-polling every 5s
  - Artifact download with save to documents directory

### Added — PR Code Review

- Review button in PR detail AppBar (Comment / Approve / Request Changes)
- Review list with state badges, author, body, timestamp
- Review request dialog: add reviewers by username

### Added — Webhook Edit

- Edit button in WebhookDetailPage, dialog to update URL

### Added — Comment Edit/Delete

- `⋯` menu on own comments: edit (inline TextField) / delete (confirmation dialog)
- Uses `issueEditComment` / `issueDeleteComment` APIs

### Added — Issue Subscription & Due Date

- Subscribe button on issue detail page
- Due date picker on issue edit page with set/clear

### Added — Repository Topics

- Display repo topics as Chip badges in repo header

### Added — Branch Protection

- Protect default branch button in repo settings page

### Added — Activity Feed Translation

- All 26 op_type values now have translation keys
- Fixed `comment_pull_request` → `comment_pull` mismatch
- New events: commit_repo, rename_repo, star_repo, watch_repo, approve/reject PR, etc.

### Changed

- File viewer AppBar: History button moved to `⋯` menu
- `UIConstants` replaces all hardcoded spacing (16→`md`, 8→`sm`, 4→`xs`)
- `home_page.dart`: remove unused `_TabData` class, extract rail/bar builders
- `ListCommitsParams` add `path` parameter
- `state?.value == 'open'` → `state?.isOpen` enum extension
- Injection: add `_assertUseCasesInitialized()` to all 3 init paths
- Add `repositorySections` ARB key and `_RepoSectionPage` wrapper for section navigation

### Fixed

- Fix shared-state bug where returning from Commit/PR detail left `RepoDetailPage` stuck in loading: separate `CommitDetailState`, `PullRequestDetailState`, `TagDetailState` from `RepoState`
- Fix infinite loading in `TeamDetailPage` → Repositories tab: separate `teamMembersState` and `teamReposState` from `teamDetailState`
- Fix `RangeError` crash in file viewer: wrap syntax highlighting in try-catch, fix nested setState, remove unsupported 'zig' language (`repo_file_page.dart`)
- Fix trailing newline creating phantom line number
- Fix file extension detection for Dockerfile and Makefile
- Reset editor text when exiting edit mode to discard unsaved changes
- Fix `RenderFlex` overflow in file viewer by replacing `Expanded` with `ConstrainedBox` in horizontal scrollable
- Fix Android APK crash on launch: align `applicationId` and `MainActivity` package with namespace (`com.charleypeng.igitea`)

## [0.22.0] - 2026-04-26

### Added — Milestones

- Milestones tab in `RepoDetailPage` (8th tab) showing all repository milestones with progress bars and issue counts
- `MilestoneDetailPage` with milestone progress indicator, open/closed issue statistics, and linked issue list
- Milestone card UI with `PremiumCard` styling, progress bar, due date display, and completion percentage
- Issue list filtering by milestone using existing `listIssuesUseCase` with `milestones` parameter
- New ARB keys: `milestones`, `noMilestonesFound`, `milestoneProgress`, `linkedIssues`, `total`, `complete`
- 247 tests passing (updated `RepoDetailPage` widget test for 8 tabs), `flutter analyze` clean

## [0.21.0] - 2026-04-26

### Added — Create Repository

- `CreateRepoPage` for creating new repositories
  - Form fields: repository name (required), description (optional)
  - Visibility selector: Public / Private with descriptive subtitles and checkmark indicators
  - README initialization toggle with SwitchListTile
  - Form validation for required name field
  - Error display in styled container
  - Success SnackBar with created repository name
  - Auto-refreshes user's repository list on success
- `CreateRepoUseCase` with `CreateRepoParams` supporting name, description, private, autoInit, defaultBranch, license, readme
- `userCreateRepo` API method in `GiteaApiService` (POST /user/repos)
- New ARB keys: `createRepository`, `repositoryName`, `repositoryNameHint`, `repositoryNameRequired`, `descriptionHint`, `publicDescription`, `privateDescription`, `initializeWithReadme`, `initializeWithReadmeDescription`, `repoCreated`
- Entry point: `ProfilePage` "Create Repository" card above Starred Repositories
- 247 tests passing, `flutter analyze` clean

## [0.20.0] - 2026-04-26

### Changed — UI Quality Enhancement

- **Alignment fixes**: Established consistent 4px-based spacing grid (`UIConstants`) across all pages
  - Standardized page padding to 16px horizontal, card margins to 12px bottom, internal card padding to 16px
  - Fixed inconsistent list paddings, tab content misalignments, and mixed card margins
- **Repo Detail Page redesign**: Major visual overhaul with premium feel
  - Header: Added subtle gradient background using primary color at 30% opacity
  - Stats: Redesigned as compact grid cards with icons above numbers
  - Tab bar: Custom pill-shaped active indicator with rounded corners, smooth label color transitions
  - File list: Redesigned items with file type color coding, monospace size display, hover effects
  - Clone URLs: Styled as compact copy rows with subtle background
  - All tabs: Consistent card-based list items with better visual hierarchy
- **Premium effects across all pages**:
  - New reusable `PremiumCard` widget with flat design, 12px border radius, subtle borders, and ink well tap effects
  - New `EmptyState` widget with icons, titles, subtitles, and action buttons for consistent empty states
  - All list pages (dashboard, issues, search, repos, notifications, profile) migrated to consistent card layouts
  - Typography hierarchy: Bold for display, semi-bold (w600) for titles, medium (w500) for subtitles
  - Consistent avatar sizing per context (xs/sm/md/lg/xl/xxl)
- **New files**: `lib/core/constants/ui_constants.dart`, `lib/presentation/widgets/premium_card.dart`, `lib/presentation/widgets/empty_state.dart`
- 247 tests passing, `flutter analyze` clean

## [0.19.0] - 2026-04-25

### Added — Team Detail, Edit Organization, Create Organization

- `TeamDetailPage` with collapsible header and 3 tabs: Info, Members, Repositories
  - Info tab: team description, units, permission, all-repositories flag
  - Members tab: list of team members with avatars
  - Repositories tab: list of team repos with navigation to `RepoDetailPage`
- `EditOrgPage` for editing organization name, description, location, website, email, visibility
  - Accessible via edit button in `OrganizationDetailPage` AppBar
  - Auto-refreshes org detail on save success
- `CreateOrgPage` for creating new organizations
  - Accessible via add button in `ProfilePage` organisations section
  - Form validation for required username field
- Pull-to-refresh on all organization and team tabs (`_ReposTab`, `_TeamsTab`, `_MembersTab`)
- New use cases: `GetTeamUseCase`, `ListTeamMembersUseCase`, `ListTeamReposUseCase`, `EditOrgUseCase`, `CreateOrgUseCase`
- New ARB keys: `members`, `noMembers`, `editOrganization`, `createOrganization`
- 247 tests passing, `flutter analyze` clean

## [0.18.2] - 2026-04-25

### Added — Edit Issue Page

- `EditIssuePage` for editing issue title, body, state, labels, and milestone
- Segmented button for Open/Closed state toggle
- Filter chips for multi-select labels (loads available labels from API)
- Dropdown for milestone selection (loads available milestones from API)
- Markdown preview toggle for body editing
- Title validation: prevents saving empty titles
- Save button with loading indicator in AppBar
- On save success, returns to `IssueDetailPage` and auto-refreshes issue + comments
- Replaced inline label-only editor dialog with full edit page navigation
- New ARB keys: `editIssue`, `titleRequired`, `selectMilestone`
- 247 tests passing, `flutter analyze` clean

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