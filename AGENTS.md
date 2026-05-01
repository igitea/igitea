# iGitea — Agent Instructions

## Project Overview

Cross-platform Flutter client for Gitea, built from OpenAPI spec. Phases 1–12 complete.

## Dev Commands

```bash
flutter pub get          # fetch dependencies
flutter analyze         # type/lint check (~120s)
flutter test            # all tests (~247 passing)
flutter test test/widget/  # widget tests only
flutter gen-l10n        # regenerate i18n files after ARB changes
```

**Verification order:** `flutter analyze` → `flutter test` → build

## Build Commands

```bash
flutter build apk --debug      # Android debug APK
flutter build macos            # macOS
flutter build web              # web
flutter run                    # dev run
```

## Architecture

```
lib/
├── core/di/injection.dart       # DI wiring (all use cases, notifiers)
├── data/
│   ├── datasources/remote/     # GiteaApiService (93+ API methods)
│   └── repositories/           # 8 repository implementations
├── domain/
│   ├── repositories/           # 8 repository interfaces
│   └── usecases/               # 35+ use cases (Either<Failure,T>)
├── l10n/                       # ARB files + flutter-gen generated code
│   ├── app_en.arb              # template (all keys)
│   └── app_localizations*.dart # generated — DO NOT EDIT
└── presentation/
    ├── pages/                  # 12 Material 3 pages
    ├── state/                  # ChangeNotifier notifiers
    └── widgets/                # UserAvatar, OrgAvatar, FileIcon
```

## Critical Patterns

- **DI:** `Injection` class wires all use cases and notifiers. 3 initialization paths (`initialize()`, `updateAuth()`, `updateUseCases()`) must stay in sync.
- **StateType:** `state?.value == 'open'` (String). `fromJson` accepts both `String` and `Map`.
- **IssueNotifier:** Has 2 state tracks: `_state` (detail/labels/comments) and `_issuesListState` (search/list). Don't conflate them.
- **ThemeNotifier:** Persists `theme_mode` and `locale` via SharedPreferences.
- **Widget tests:** Wrap with `buildTestableWidget()` from `lib/widget_test_helpers.dart` for l10n support.
- **opencode.json:** Repo-level config at project root.

## i18n

- ARB files in `lib/l10n/`. Edit `app_en.arb` as the template.
- After changing ARB files: `flutter gen-l10n` (runs automatically with `generate: true` in pubspec.yaml).
- Supported: en, zh, zh_TW, ja, ko, es, fr, de, pt, ru.
- Translations for de/es/fr/ja/ko/pt/ru are incomplete (~101 keys missing). Fall back to English.

## Codegen

```bash
python3 tools/generate_models.py         # regenerate Dart models from doc/openapi.yaml
python3 tools/generate_api_service.py   # regenerate GiteaApiService methods
```

## Model Generation

- Models live in `lib/data/models/generated/generated_models.dart`
- Regenerate after modifying `doc/openapi.yaml`

## Testing

- Tests live in `test/` mirroring `lib/` structure
- Widget tests require `buildTestableWidget()` wrapper
- State tests use mocked use cases injected directly into notifiers

## Style

- All user-facing strings: `AppLocalizations.of(context)!`
- Params use `*Params` ARB method suffix: `l10n.joinedOnParams(date: dateValue)`
- No comments unless requested (per CLAUDE.md)

## Workflow — Always End With

After any meaningful change (feature, fix, refactor), update **both** the English and Chinese versions together:
- `README.md` + `README.zh-CN.md` — features, phase status, test count
- `CHANGELOG.md` + `CHANGELOG.zh-CN.md` — version entry with Added/Changed/Fixed

Then commit with a clear message (e.g. `feat: ...`, `fix: ...`, `docs: ...`).

## Changelog Conventions

Entries go under `## [Unreleased]` during development. When cutting a release:

1. Replace `## [Unreleased]` with `## [x.y.z] - YYYY-MM-DD` (e.g. `## [0.13.0] - 2026-05-01`)
2. Add a new `## [Unreleased]` heading above it for future work
3. Read version from `pubspec.yaml` (`version:` line) to keep consistent

## Key Files

- `lib/core/di/injection.dart` — all DI wiring
- `lib/presentation/state/issue_notifier.dart` — IssueNotifier with IssuesListState
- `lib/presentation/state/theme_notifier.dart` — ThemeNotifier with locale
- `lib/l10n/app_en.arb` — i18n template
- `lib/app.dart` — IGiteaApp with localizationsDelegates
