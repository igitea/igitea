# iGitea

A cross-platform Flutter client for [Gitea](https://gitea.io), built from the OpenAPI specification.

## Features

- Cross-platform support: Android, iOS, macOS, Linux, Windows
- Clean Architecture with Repository Pattern
- Auto-generated data models from Gitea OpenAPI spec
- Built-in state management using Flutter `ChangeNotifier`

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

## Architecture

- `lib/core/` — Utilities, constants, and error types
- `lib/data/` — Data models, remote data sources, and repository implementations
- `lib/domain/` — Entities, repository interfaces, and use cases
- `lib/presentation/` — UI pages, widgets, and state managers

## License

MIT License. See [LICENSE](LICENSE).
