# iGitea

A cross-platform Flutter client for [Gitea](https://gitea.io), built from the OpenAPI specification.

> Built with OpenCode & Kimi 2.6 — PRs welcome! Help us if you have extra token, we are desperately waiting lol!

## Screenshots

| Login | Profile | Repository | Issue |
|:-----:|:-------:|:----------:|:-----:|
| <img src="doc/login.png" width="200" /> | <img src="doc/profile.png" width="200" /> | <img src="doc/repos.png" width="200" /> | <img src="doc/issues.png" width="200" /> |

## Features

### Core
- Cross-platform: Android, iOS, macOS, Linux, Windows, **Web**
- Clean Architecture + Repository Pattern
- Material 3 Design System with premium UI polish
- Consistent 4px spacing grid and typography hierarchy across all pages
- 120+ data models auto-generated from OpenAPI spec
- 45+ domain use cases with `Either<Failure, T>` pattern

### Authentication
- Username/password login (primary)
- Access token login (secondary)
- OAuth2 login: browser authorization → callback code → token exchange
- Session persistence and auto-restore

### Repositories
- List, search, and browse repositories
- Collapsible header with star/fork actions
- Section list navigation: Code, Issues, Milestones, Pull Requests, Releases, Commits, Branches, Tags, Wiki, Webhooks, Labels (tap to open)
- File browser with breadcrumb navigation
- File viewer with Markdown rendering, images, and syntax highlighting
- Edit files with commit message dialog
- Repository settings: edit description, visibility, features, or delete

### Issues & Pull Requests
- List, search, filter issues and PRs
- Detail pages with Markdown body, state badges, author avatars, labels
- Comments with Markdown rendering
- Create issues: title, body, label selection, milestone selection
- Edit issues: title, body, state toggle, label selection, milestone selection
- Close/reopen issues, merge PRs with confirmation

### Milestones
- List milestones with progress bars and open/closed counts
- Milestone detail with linked issues, edit and delete actions
- Create milestones: title, description, due date

### Wiki
- Wiki page list
- Wiki detail with Markdown rendering (selectable text)
- Create wiki pages: title, Markdown content, preview toggle, commit message
- Edit wiki pages: same as create, pre-filled with existing content
- Delete wiki pages with confirmation dialog

### Labels
- List labels with color indicators, name, and description
- Create labels: name, description, color picker (preset palette)
- Edit labels: same as create, with delete support

### Webhooks
- List webhooks with type, URL, and active status
- Webhook detail: configuration, events list, delete action
- Create webhooks: URL, secret, content type, event multi-select, active toggle

### Organizations & Teams
- View organization info, repositories, and teams
- Click org avatars to navigate to detail page
- List organization repositories with navigation
- Team detail page with members and repositories
- Edit organization name, description, location, website, email, visibility
- Create new organizations from profile

### Releases
- Browse releases with assets download
- Release detail page with body, assets, tarball/zipball links

### Starred Repositories
- View all starred repositories from profile
- Star/unstar with toggle button

### Activity Feed
- Dashboard shows recent activities
- Supports: create/delete repo, push/delete tag, create/close/reopen issues and PRs, comments, fork, transfer

### Notifications
- List notifications with unread badge
- Mark single or all as read

### Search
- Global search for repositories and issues
- Real-time search results

### Settings
- Theme: Light / Dark / System
- Language selection (10 supported)
- Account info display
- Admin panel for user management (admin only)

### Internationalization
- English (en)
- Chinese Simplified (zh)
- Chinese Traditional (zh_TW)
- Japanese (ja)
- Korean (ko)
- Spanish (es)
- French (fr)
- German (de)
- Portuguese (pt)
- Russian (ru)

### Deep Links
- `/{owner}/{repo}` — repository
- `/{owner}/{repo}/issues/{id}` — issue
- `/{owner}/{repo}/pulls/{id}` — pull request

## Tech Stack

| Layer | Technology |
|-------|------------|
| Framework | Flutter |
| State | ChangeNotifier + ListenableBuilder |
| HTTP | http package |
| Storage | path_provider, shared_preferences |
| i18n | flutter_localizations |
| UI | Material 3 |
| Links | url_launcher |
| File Picker | file_picker |
| Markdown | flutter_markdown |

## Getting Started

### Prerequisites

- Flutter SDK >= 3.11.5
- Dart SDK >= 3.11.5

### Build

```bash
# Install dependencies
flutter pub get

# Run (dev)
flutter run

# Build APK (Android)
flutter build apk --debug

# Build macOS
flutter build macos

# Build web
flutter build web
```

### Test

```bash
flutter analyze
flutter test
```

## Project Status

All phases complete.

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
| 10 | Issue/PR Detail & Search | ✅ Done |
| 11 | Settings & Admin | ✅ Done |
| 12 | Internationalization | ✅ Done |
| 13 | Wiki, Milestone CRUD, Webhooks, Labels, OAuth2 | ✅ Done |

## License

MIT
