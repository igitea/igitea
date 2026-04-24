# iGitea

A cross-platform Flutter client for [Gitea](https://gitea.io), built from the OpenAPI specification.

## Features

- Cross-platform support: Android, iOS, macOS, Linux, Windows, **Web**
- Clean Architecture with Repository Pattern
- 120+ auto-generated data models from Gitea OpenAPI spec
- Full REST API client covering all Gitea API endpoint tags
- 8 repository interfaces + implementations with exception→failure mapping
- 35+ domain use cases with `Either<Failure, T>` pattern
- ChangeNotifier-based state managers for Auth, User, Repo, Issue, Org, Notification, Theme
- Material 3 UI: Login, Dashboard, Search, Repo List, Issue List, Notifications, Profile, Settings
- Adaptive layout: NavigationRail (desktop) / NavigationBar (mobile)
- Login page: username/password (primary), token (secondary), OAuth2 planned
- Avatar display: user/org avatars with NetworkImage, graceful fallback to initials
- Repo detail page with 5 tabs: Code (file browser), Issues, Pull Requests, Releases, Branches
- Issue and PR detail pages with Markdown body, state badges, author avatars, labels, branch info
- Comments on Issue and PR detail pages with Markdown rendering and input
- Close/reopen issues, merge PRs with confirmation dialog
- Global search page for repositories and issues
- Star/unstar repositories with toggle button in repo detail
- File browser with breadcrumb navigation and directory browsing
- File viewer: Markdown rendering, image display, code syntax highlighting
- Dark mode with light/dark/system theme switcher
- Settings page with theme picker, account info, and sign-out
- 247 unit/widget tests, `flutter analyze` clean

## Project Status

Phases 1–9 complete, Phase 1–11 complete:

| Phase | Description | Status |
|-------|-------------|--------|
| 1 | Project Bootstrap | ✅ Done |
| 2 | Model Generation | ✅ Done |
| 3 | API Service | ✅ Done |
| 4 | Repository Layer | ✅ Done |
| 5 | Domain Use Cases | ✅ Done |
| 6 | State Management | ✅ Done |
| 7 | UI Layer | ✅ Done |
| 8 | Testing & Quality | ✅ Done |
| 9 | Repo Detail & File Browser | ✅ Done |
| 10 | Issue/PR Detail Pages & Search | ✅ Done |
| 11 | Settings Page & Admin Features | ✅ Done |

## Getting Started

### Prerequisites

- Flutter SDK >= 3.11.5
- Dart SDK >= 3.11.5

### Build

```bash
flutter pub get
flutter run
```

### Build for Desktop

```bash
# macOS
flutter build macos

# Linux
flutter build linux

# Windows
flutter build windows
```

### Build for Mobile

```bash
# Android
flutter build apk

# iOS
flutter build ios
```

### Build for Web

```bash
flutter build web
```

## Architecture

```
lib/
├── core/            # Utilities, constants, error/failure types
├── data/
│   ├── datasources/ # ApiClient, GiteaApiService
│   ├── models/      # 120+ generated Dart model classes
│   └── repositories/# 8 repository implementations
├── domain/
│   ├── repositories/# 8 repository interfaces
│   └── usecases/    # 30+ use case classes
└── presentation/
     ├── pages/       # Material 3 UI pages
     ├── state/       # ChangeNotifier state managers
     └── widgets/     # Reusable avatar and file icon widgets
```

## Tech Stack

- **Flutter 3.x** / **Dart 3.x**
- **Material 3** design system
- **Clean Architecture** — domain/data/presentation separation
- **ChangeNotifier** for state management (no third-party dependencies)
- **Either\<Failure, T\>** for typed error handling
- **http** package for HTTP

## License

MIT License. See [LICENSE](LICENSE).