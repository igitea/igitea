# iGitea

基于 OpenAPI 规范构建的跨平台 [Gitea](https://gitea.io) Flutter 客户端。

## 功能特性

- 跨平台支持：Android、iOS、macOS、Linux、Windows
- Clean Architecture + Repository Pattern
- 从 Gitea OpenAPI 规范自动生成数据模型
- 使用 Flutter `ChangeNotifier` 内置状态管理

## 快速开始

### 环境要求

- Flutter SDK >= 3.11.5
- Dart SDK >= 3.11.5

### 构建运行

```bash
flutter pub get
flutter run
```

### 桌面端构建

```bash
# macOS
flutter build macos

# Linux
flutter build linux

# Windows
flutter build windows
```

### 移动端构建

```bash
# Android
flutter build apk

# iOS
flutter build ios
```

## 架构

- `lib/core/` — 工具类、常量、错误类型
- `lib/data/` — 数据模型、远程数据源、仓库实现
- `lib/domain/` — 实体、仓库接口、用例
- `lib/presentation/` — 页面、组件、状态管理

## 许可证

MIT License。详见 [LICENSE](LICENSE)。
