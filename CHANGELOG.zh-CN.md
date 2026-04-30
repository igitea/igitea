# 更新日志

## [Unreleased]

### 变更

- 重构 `RepoDetailPage`：将横向 `TabBar` 改为纵向区块列表（代码、Issue、里程碑、Pull Request、Release、提交、分支、标签），点击进入对应页面
- 新增 `repositorySections` ARB 键和 `_RepoSectionPage` 页面包装器

### 修复

- 修复共享状态 bug：从 Commit/PR 详情返回后 `RepoDetailPage` 一直 loading，将 `CommitDetailState`、`PullRequestDetailState`、`TagDetailState` 从 `RepoState` 中分离
- 修复 `TeamDetailPage` → 仓库标签页无限 loading：将 `teamMembersState` 和 `teamReposState` 从 `teamDetailState` 中分离
- 修复文件查看器 `RangeError` 崩溃：为语法高亮添加 try-catch、修复嵌套 setState、移除不支持的 'zig' 语言（`repo_file_page.dart`）
- 修复末尾换行符产生幽灵行号的问题
- 修复 Dockerfile 和 Makefile 的文件扩展名检测
- 退出编辑模式时重置编辑器文本（丢弃未保存的更改）
- 修复文件查看器中 `RenderFlex` 溢出错误：在水平滚动视图中将 `Expanded` 替换为 `ConstrainedBox`

## [0.22.0] - 2026-04-26

### 新增 — 里程碑

- `RepoDetailPage` 里程碑标签页（第8个标签）：显示仓库所有里程碑，带进度条和问题计数
- `MilestoneDetailPage`：里程碑详情页，含进度指示器、打开/关闭问题统计、关联问题列表
- 里程碑卡片 UI：使用 `PremiumCard` 样式，进度条、截止日期、完成百分比
- 使用现有 `listIssuesUseCase` 的 `milestones` 参数按里程碑过滤问题
- 新增 ARB 键值：`milestones`、`noMilestonesFound`、`milestoneProgress`、`linkedIssues`、`total`、`complete`
- 247 个测试通过（更新 `RepoDetailPage` 组件测试为8个标签），`flutter analyze` 无警告

## [0.21.0] - 2026-04-26

### 新增 — 创建仓库

- `CreateRepoPage`：创建新仓库页面
  - 表单字段：仓库名称（必填）、描述（可选）
  - 可见性选择器：公开/私有，带描述性副标题和勾选标记指示器
  - README 初始化开关：使用 SwitchListTile
  - 表单验证：名称必填
  - 错误显示：带样式的容器
  - 成功提示：Snackbar 显示创建的仓库名称
  - 创建成功后自动刷新用户仓库列表
- `CreateRepoUseCase` 和 `CreateRepoParams`：支持名称、描述、私有、自动初始化、默认分支、许可证、README
- `userCreateRepo` API 方法：GiteaApiService（POST /user/repos）
- 新增 ARB 键值：`createRepository`、`repositoryName`、`repositoryNameHint`、`repositoryNameRequired`、`descriptionHint`、`publicDescription`、`privateDescription`、`initializeWithReadme`、`initializeWithReadmeDescription`、`repoCreated`
- 入口：`ProfilePage` 中"创建仓库"卡片位于"星标仓库"上方
- 247 个测试通过，`flutter analyze` 无警告

## [0.20.0] - 2026-04-26

### 变更 — UI 品质提升

- **对齐整改**：建立统一的 4px 间距网格系统（`UIConstants`），覆盖所有页面
  - 页面水平内边距统一为 16px，卡片底部间距统一为 12px，卡片内部间距统一为 16px
  - 修复列表内边距不一致、Tab 内容错位、卡片边距混乱等问题
- **仓库详情页重新设计**：大幅视觉升级，提升品质感
  - 头部：添加主色 30% 透明度的渐变背景
  - 统计：重新设计为紧凑型网格卡片，图标在数字上方
  - 标签栏：自定义药丸形激活指示器，圆角设计，平滑标签颜色过渡
  - 文件列表：重新设计列表项，带文件类型颜色区分、等宽字体显示大小、悬停效果
  - 克隆地址：设计为带微妙背景的紧凑复制行
  - 所有标签页：统一的卡片式列表项，更好的视觉层级
- **全站质感提升**：
  - 新增可复用 `PremiumCard` 组件：扁平化设计、12px 圆角、微妙边框、InkWell 点击效果
  - 新增 `EmptyState` 组件：统一的空状态页面，带图标、标题、副标题和操作按钮
  - 所有列表页面（仪表盘、Issue、搜索、仓库、通知、个人主页）统一迁移到卡片布局
  - 字体层级：Display 粗体、Title 半粗体 (w600)、Subtitle 中等 (w500)
  - 头像尺寸按场景统一（xs/sm/md/lg/xl/xxl）
- **新增文件**：`lib/core/constants/ui_constants.dart`、`lib/presentation/widgets/premium_card.dart`、`lib/presentation/widgets/empty_state.dart`
- 247 个测试通过，`flutter analyze` 无警告

## [0.19.0] - 2026-04-25

### 新增 — 团队详情、编辑组织、创建组织

- `TeamDetailPage`：可折叠头部 + 3 个标签页：信息、成员、仓库
  - 信息标签页：团队描述、工作单元、权限、全部仓库标识
  - 成员标签页：团队成员列表，带头像
  - 仓库标签页：团队仓库列表，支持跳转到 `RepoDetailPage`
- `EditOrgPage`：编辑组织名称、描述、位置、网站、邮箱、可见性
  - 通过 `OrganizationDetailPage` AppBar 的编辑按钮进入
  - 保存成功后自动刷新组织详情
- `CreateOrgPage`：创建新组织
  - 通过 `ProfilePage` 组织区域的添加按钮进入
  - 用户名必填字段验证
- 所有组织和团队标签页支持下拉刷新（`_ReposTab`、`_TeamsTab`、`_MembersTab`）
- 新增用例：`GetTeamUseCase`、`ListTeamMembersUseCase`、`ListTeamReposUseCase`、`EditOrgUseCase`、`CreateOrgUseCase`
- 新增 ARB 键：`members`、`noMembers`、`editOrganization`、`createOrganization`
- 247 个测试通过，`flutter analyze` 无警告

## [0.18.2] - 2026-04-25

### 新增 — 编辑 Issue 页面

- `EditIssuePage`：支持编辑 Issue 标题、正文、状态、标签和里程碑
- SegmentedButton 切换 Open/Closed 状态
- FilterChip 多选标签（从 API 加载可用标签）
- Dropdown 选择里程碑（从 API 加载可用里程碑）
- Markdown 预览切换（编辑/预览正文）
- 标题验证：禁止保存空标题
- AppBar 保存按钮带加载指示器
- 保存成功后返回 `IssueDetailPage` 并自动刷新 Issue 和评论
- 将原来的内联标签编辑器对话框替换为完整的编辑页面导航
- 新增 ARB 键：`editIssue`、`titleRequired`、`selectMilestone`
- 247 个测试通过，`flutter analyze` 无警告

## [0.18.1] - 2026-04-25

### 修复 — Commits/Branches/Tags 标签页状态隔离

- **根因**：`RepoNotifier` 所有标签页共用同一个 `_state` 字段。调用 `listCommits()`/`listBranches()`/`listTags()` 时会覆盖 `_state`，导致 `RepoDetailPage` 主构建器丢失 `RepoLoaded` 状态，显示加载转圈而非标签页。
- **修复**：创建独立的状态轨道（`CommitsState`、`BranchesState`、`TagsState`），各含 `Initial/Loading/Loaded/Error` 子类，与现有的 `PullRequestsState` 和 `ReleasesState` 模式一致。
- `RepoNotifier` 新增 `_commitsState`、`_branchesState`、`_tagsState` 字段及 getter
- `listCommits()`、`listBranches()`、`listTags()` 分别更新各自的状态轨道，不再共用 `_state`
- UI 标签页（`_CommitsTab`、`_BranchesTab`、`_TagsTab`）分别监听 `commitsState`/`branchesState`/`tagsState`
- `CreatePRPage` 更新为使用 `branchesState`
- 从 `RepoState` 层级中移除旧的 `BranchesLoaded`/`CommitsLoaded`/`TagsLoaded`
- 247 个测试通过，`flutter analyze` 无警告

## [0.18.0] - 2026-04-25

### 新增 — 组织详情、发布详情、星标仓库、分叉仓库

- `OrganizationDetailPage`：可折叠头部 + 3 个标签页：信息、仓库、团队
- `ReleaseDetailPage`：显示发布信息、正文、资源文件下载链接、tarball/zipball 下载
- `StarredReposPage`：显示用户星标仓库列表，支持下拉刷新
- `RepoDetailPage` AppBar 新增 Fork 按钮，调用 `createFork()` API
- `RepoNotifier` 新增 `createFork()` 方法，使用 `CreateForkUseCase`
- `OrgNotifier` 新增 `ListOrgTeamsUseCase`，支持团队标签页
- `ProfilePage` 组织头像可点击，跳转到 `OrganizationDetailPage`
- 发布列表项可点击，跳转到 `ReleaseDetailPage`
- `ProfilePage` "我的星标"可点击，跳转到 `StarredReposPage`
- 新增 ARB 键：`info`、`teams`、`noTeams`、`location`、`visibility`、`assets`、`publishedAt`、`target`、`forked`
- 247 个测试通过，`flutter analyze` 无警告

## [0.17.1] - 2026-04-25

### 新增 — 仓库删除

- 领域层新增 `DeleteRepoUseCase` 及 `DeleteRepoParams`
- `RepoNotifier` 新增 `deleteRepo()` 方法，状态流转：`RepoLoading` → `RepoInitial`
- `RepoSettingsPage` 实现仓库删除功能：确认对话框、API 调用、成功后返回首页
- `deleteRepoUseCase` 已接入全部 3 个 `Injection` 初始化路径（`initialize()`、`updateAuth()`、`repoNotifier.updateUseCases()`）
- 247 个测试通过，`flutter analyze` 无警告

## [0.17.0] - 2026-04-24

### 新增 — Dashboard 活动流

- `GiteaApiService` 新增 `listUserActivities()` API 方法：`GET /users/{username}/activities/feeds`
- `UserRepository` 接口和 `UserRepositoryImpl` 中新增 `getUserActivities()`
- `GetUserActivitiesUseCase` 及 `GetUserActivitiesParams`
- `UserNotifier` 新增 `getUserActivities()` 方法和 `_activities` 字段
- Dashboard 页面新增 `_ActivityFeed` 小组件，显示最近用户活动
- 支持的活动类型：创建仓库、推送标签、删除标签、创建/关闭/重开 Issue、创建/合并/关闭 PR、评论 Issue/PR、分叉仓库、转移仓库、删除仓库、更新 Wiki
- 活动卡片显示用户头像、操作描述和时间戳
- 点击活动卡片跳转到相关仓库
- 显示最近 10 条活动

### 变更

- `UserNotifier` 构造函数和 `updateUseCases()` 现在需要 `GetUserActivitiesUseCase`
- `Injection` 类更新所有 3 个初始化路径
- 新增 ARB 键：`recentActivity`、`noActivity`、`createdRepo`、`pushedTag`、`deletedTag`、`createdIssue`、`closedIssue`、`reopenedIssue`、`createdPR`、`mergedPR`、`closedPR`、`commentedOnIssue`、`commentedOnPR`、`forkedRepo`、`transferredRepo`、`deletedRepo`、`updatedWiki`、`performedAction`、`inRepo`、`to`、`from`
- 247 个测试通过，`flutter analyze` 无警告

## [0.16.0] - 2026-04-24

### 新增 — 通知操作

- `NotificationNotifier` 新增 `markAllRead()` 方法，使用 `MarkNotificationsReadUseCase`
- AppBar "全部标记为已读" 按钮现在调用真实 API，不再只是显示提示
- 单条通知 "标记为已读" 按钮（未读通知卡片上的勾选图标）
- 标记已读后自动刷新通知列表

### 新增 — 新建 Issue 页面

- `CreateIssuePage` 标题和正文输入表单
- AppBar 提交按钮带加载指示器
- 验证：标题必填
- 创建成功后返回创建的 Issue，失败时显示提示

### 新增 — Deep Link 支持

- `IGiteaApp` 新增 `onGenerateRoute` 支持基于 URL 的导航
- 支持路径：
  - `/{owner}/{repo}` → 仓库详情页
  - `/{owner}/{repo}/issues/{id}` → Issue 详情页
  - `/{owner}/{repo}/pulls/{id}` → PR 详情页

### 变更

- `NotificationNotifier` 构造函数和 `updateUseCases()` 中新增 `MarkNotificationsReadUseCase`
- `Injection` 类更新所有 3 个初始化路径
- 新增 ARB 键：`newIssue`、`pleaseEnterTitle`
- 247 个测试通过，`flutter analyze` 无警告

## [0.15.0] - 2026-04-24

### 新增 — 管理员用户管理

- 新增 `AdminNotifier`，包含 `AdminUsersState` 和 `AdminOperationState`，支持用户增删改查
- `UserManagementPage` 用户管理页面：用户列表、创建、编辑、删除
- 仅管理员可见：`is_admin == true` 的用户才能访问
- 用户列表显示头像、用户名、邮箱、管理员徽章
- 创建用户对话框：用户名、邮箱、全名、密码、管理员开关、首次登录必须改密开关
- 编辑用户对话框：邮箱、全名、管理员开关（用户名不可修改）
- 删除用户带确认对话框
- 创建/编辑/删除后自动刷新用户列表
- 新增 ARB 键：`createUser`、`editUser`、`deleteUser`、`deleteUserConfirmParams`、`userCreated`、`userUpdated`、`userDeleted`、`noUsersFound`、`pleaseEnterEmail`、`fullName`、`mustChangePassword`

### 变更

- `Injection` 类更新，在 3 个初始化路径（`initialize()`、`updateAuth()`）中添加 `AdminNotifier`
- 247 个测试通过，`flutter analyze` 无警告

## [0.12.0] - 2026-04-24

### 新增 — 评论与 Issue/PR 操作

- Issue 和 PR 详情页现在加载并显示评论，支持 Markdown 渲染。
- Issue 和 PR 详情页添加评论输入框和发送按钮。
- IssueDetailPage 添加关闭/重开 Issue 按钮，使用 `EditIssueUseCase`。
- `IssueNotifier` 新增 `CommentsState` 密封类及 `listComments`/`createComment` 方法。
- `IssueNotifier` 新增 `searchIssues` 全局 Issue 搜索方法。
- PRDetailPage 添加合并按钮（带确认对话框），仅对开放且可合并的 PR 显示。
- 新增 `mergePullRequest` API 方法、`MergePullRequestUseCase` 及 `RepoNotifier.mergePullRequest()`。
- 新增 `issueSearchIssues` 全局 Issue 搜索 API 方法及 `SearchIssuesUseCase`。

### 新增 — 搜索页面

- 新增 `SearchPage`，支持仓库和 Issue 全局搜索标签页。
- HomePage 导航新增搜索标签页（第一个标签）。
- `RepoNotifier` 复用 `SearchResultsLoaded` 状态进行仓库搜索。
- `IssueListLoaded` 状态复用于全局 Issue 搜索结果。

### 新增 — Star/Unstar 仓库

- RepoDetailPage AppBar 添加 Star/Unstar 切换按钮。
- 新增 `userCurrentPutStar`、`userCurrentDeleteStar`、`userCurrentCheckStar` API 方法。
- 新增 `starRepo`/`unstarRepo`/`checkStarred` 仓库方法和用例。
- `RepoNotifier` 新增 `toggleStar`/`checkStarred` 方法及加载状态。
- Star 状态在仓库详情加载时检查。

### 新增 — 暗黑模式与设置

- `ThemeNotifier` 使用 SharedPreferences 持久化 light/dark/system 主题偏好。
- `SettingsPage` 包含主题选择器、账户信息和退出登录按钮。
- HomePage 导航新增设置标签页。
- 退出登录按钮从 AppBar 移至设置页面。

### 变更

- `IssueNotifier` 新增 `EditIssueUseCase`、`ListCommentsUseCase`、`CreateCommentUseCase`、`SearchIssuesUseCase`。
- `RepoNotifier` 新增 `StarRepoUseCase`、`UnstarRepoUseCase`、`CheckStarredUseCase`、`MergePullRequestUseCase`。
- `IGiteaApp` 使用 `ThemeNotifier` 管理 `themeMode`。
- `Injection` 在所有 3 个初始化路径中更新了新的用例注入。
- 248 个测试通过，`flutter analyze` 无警告。

## [0.11.0] - 2026-04-24

### 修复 — StateType 解析错误

- `StateType.fromJson` 现在同时支持 `String` 和 `Map<String, dynamic>` 类型输入，以处理 Gitea API 返回 `"open"`/`"closed"` 字符串格式的 issue/PR 状态。
- `StateType` 模型新增 `value` 字段，用于存储字符串状态。
- 所有相关模型（Issue、PullRequest、NotificationSubject、Milestone）已更新，直接传入原始 json state 而非强制转换为 Map。
- 所有 UI 代码更新为使用 `state?.value == 'open'` 替代 `state?.toString().contains('open')`。
- 测试更新：248 个测试全部通过。

## [0.10.0] - 2026-04-24

### 新增 — 仓库详情页

- `RepoDetailPage`，包含 5 个标签页：代码、Issue、Pull Request、Release、分支。
- 文件浏览器（`_CodeTab`），支持面包屑导航和目录遍历。
- `RepoFilePage`，支持 Markdown 渲染（flutter_markdown）、图片展示和代码语法高亮（highlight）。
- `file_icon.dart` 文件类型图标辅助小部件。
- 从仪表盘、仓库列表、个人主页和通知页面的仓库卡片导航。

### 新增 — API 与数据层

- `GiteaApiService` 中新增 `repoGetContents` 和 `repoListPullRequests` API 方法。
- 仓库层新增 `getRepoContents` 和 `listPullRequests`。
- 新增 `GetRepoContentsUseCase` 和 `ListPullRequestsUseCase`，并完成依赖注入配置。
- `RepoNotifier` 中新增 `ContentsState`、`PullRequestsState` 和 `ReleasesState`。

### 依赖

- 新增 `flutter_markdown` 和 `highlight` 包。

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