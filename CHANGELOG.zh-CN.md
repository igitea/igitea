# 更新日志

## [0.9.0] - 2026-04-24

### 新增 — 头像系统

- 在 `lib/presentation/widgets/` 下新增可复用 `UserAvatar` 和 `OrgAvatar` 小部件。
- 个人主页、仪表盘、Issue 卡片、通知卡片显示用户头像。
- 个人主页展示组织头像。
- 仓库列表和仪表盘显示仓库所有者头像。
- 当 avatar_url 为空时，优雅回退显示首字母。

### 修复 — 构建期间 setState 问题

- 所有页面的 `initState` 中，通过 `WidgetsBinding.instance.addPostFrameCallback` 延迟调用 `notifyListeners()`，避免 "setState() or markNeedsBuild() called during build" 错误。
- 修复个人主页退出登录对话框中的异步 `logout()` 调用。

### 变更

- 阶段 8 标记完成：234 个测试，`flutter analyze` 无警告。

## [0.8.0] - 2026-04-24

### 新增 — 阶段 8：测试与质量（进行中）

- 234 个单元/Widget 测试全部通过，覆盖各层。
- `flutter analyze` 无警告。

### 变更

- 登录页重新设计：用户名/密码为主要认证方式，Token 为次要标签页。
- 自适应布局：桌面端 NavigationRail，移动端 NavigationBar。

### 新增 — Web 平台支持

- 新增 Web 平台目标（覆盖 Android、iOS、macOS、Linux、Windows、Web）。
- CORS 中间件配置，兼容 Gitea 服务器。
- dart:io 条件导入，确保 Web 兼容性。

## [0.7.0] - 2026-04-24

### 新增 — 阶段 7：UI 层

- Material 3 页面：登录、仪表盘、仓库列表、Issue 列表、通知、个人主页。
- 首页底部导航路由。
- `lib/presentation/pages/` 和 `lib/presentation/state/` 目录结构。

## [0.6.0] - 2026-04-24

### 新增 — 阶段 6：状态管理

- 基于 ChangeNotifier 的状态管理器：`AuthNotifier`、`UserNotifier`、`RepoNotifier`、`IssueNotifier`、`OrganizationNotifier`、`NotificationNotifier`。
- 各功能模块的 loading / loaded / error 状态处理。

## [0.5.0] - 2026-04-24

### 新增 — 阶段 5：领域用例

- 9 个文件共 30+ 用例类：`auth_usecases`、`user_usecases`、`repo_usecases`、`issue_usecases`、`organization_usecases`、`notification_usecases`、`package_usecases`、`misc_usecases`、`admin_usecases`。
- 所有用例返回 `Either<Failure, T>`，实现类型化错误处理。

## [0.4.0] - 2026-04-24

### 新增 — 阶段 4：仓库层

- `lib/domain/repositories/` 下 8 个仓库接口。
- `lib/data/repositories/` 下 8 个仓库实现，将异常映射为领域层 Failure。

## [0.1.0] - 2026-04-23

### 新增 — 阶段 1：项目初始化

- 初始化 Flutter 项目，支持 Android、iOS、macOS、Linux、Windows 平台。
- 在 `lib/` 下搭建 Clean Architecture 目录结构。
- 添加已批准的第三方依赖：`http`、`path_provider`、`shared_preferences`、`url_launcher`、`file_picker`。
- 初始化双语 README 和 CHANGELOG。

### 新增 — 阶段 2：模型生成

- 添加 `tools/generate_models.py`，用于从 `doc/openapi.yaml` 生成 Dart 数据模型。
- 在 `lib/data/models/generated/` 下生成 120+ 个 Dart 模型类。
- 添加模型序列化单元测试。

### 新增 — 阶段 3：API 服务

- 实现 `ApiClient`，支持 token/Basic 认证、超时和错误映射。
- 实现 `GiteaApiService`，覆盖全部 10 个 tag 的 93 个核心 API 方法。
- 添加 `tools/generate_api_service.py`，用于从 OpenAPI spec 自动生成 service 方法。
- 添加 `ApiClient` 和 `GiteaApiService` 单元测试，覆盖成功、4xx、5xx 及网络异常路径。