# iGitea

基于 OpenAPI 规范构建的跨平台 [Gitea](https://gitea.io) Flutter 客户端。

## 截图

| 登录 | 仓库 | Issue | 个人资料 |
|:----:|:----:|:-----:|:--------:|
| ![登录](doc/login.png) | ![仓库](doc/repos.png) | ![Issue](doc/issues.png) | ![个人资料](doc/profile.png) |

## 功能特性

- 跨平台支持：Android、iOS、macOS、Linux、Windows、**Web**
- Clean Architecture + Repository Pattern
- 从 Gitea OpenAPI 规范自动生成 120+ 个 Dart 数据模型
- 覆盖全部 Gitea API 端点的 REST API 客户端
- 8 个仓库接口及实现，异常→Failure 映射
- 35+ 领域用例，采用 `Either<Failure, T>` 模式
- 基于 ChangeNotifier 的状态管理，覆盖认证、用户、仓库、Issue、组织、通知、主题
- Material 3 页面：登录、仪表盘、搜索、仓库列表、Issue 列表、通知、个人主页、设置
- 自适应布局：桌面端 NavigationRail / 移动端 NavigationBar
- 登录页：用户名/密码（主要）、Token（次要），OAuth2 计划中
- 头像显示：用户/组织头像通过 NetworkImage 获取，无头像时优雅回退至首字母
- 仓库详情页：5 个标签页——代码（文件浏览器）、Issue、Pull Request、Release、分支
- Issue 和 PR 详情页：Markdown 正文渲染、状态徽章、作者头像、标签、分支信息
- Issue 和 PR 详情页评论加载与显示，支持 Markdown 渲染和评论输入
- 关闭/重开 Issue、合并 PR（带确认对话框）
- 全局搜索页面，支持仓库和 Issue 搜索
- 仓库详情页 Star/Unstar 切换按钮
- 文件浏览器：面包屑导航和目录浏览
- 文件查看器：Markdown 渲染、图片展示、代码语法高亮
- 暗黑模式：支持浅色/深色/跟随系统切换
- 设置页：主题选择器、账户信息、退出登录、管理面板
- **国际化**：支持 10 种语言（EN、ZH、ZH_TW、JA、KO、ES、FR、DE、PT、RU）
- 设置页语言选择器，语言偏好持久化
- 管理员用户管理：列表、创建、编辑、删除用户（仅管理员）
- 通知操作：单条标记已读、全部标记已读
- 新建 Issue 页面：在任何仓库创建 Issue
- Deep Link 支持：通过 URL 路径打开 Issue、PR 和仓库
- Dashboard 活动流：显示最近用户活动（创建仓库、推送标签、创建/关闭 Issue、PR 等）
- 仓库设置：编辑描述、可见性、功能开关，以及删除仓库
- 247 个单元/Widget 测试，`flutter analyze` 无警告

## 项目进度

阶段 1–12 已完成：

| 阶段 | 描述 | 状态 |
|------|------|------|
| 1 | 项目初始化 | ✅ 完成 |
| 2 | 模型生成 | ✅ 完成 |
| 3 | API 服务 | ✅ 完成 |
| 4 | 仓库层 | ✅ 完成 |
| 5 | 领域用例 | ✅ 完成 |
| 6 | 状态管理 | ✅ 完成 |
| 7 | UI 层 | ✅ 完成 |
| 8 | 测试与质量 | ✅ 完成 |
| 9 | 仓库详情与文件浏览器 | ✅ 完成 |
| 10 | Issue/PR 详情页与搜索 | ✅ 完成 |
| 11 | 设置页与管理功能 | ✅ 完成 |
| 12 | 国际化 (i18n) | ✅ 完成 |

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

### Web 构建

```bash
flutter build web
```

## 架构

```
lib/
├── core/            # 工具类、常量、错误/Failure 类型
├── data/
│   ├── datasources/ # ApiClient、GiteaApiService
│   ├── models/      # 120+ 个自动生成的 Dart 模型类
│   └── repositories/# 8 个仓库实现
├── domain/
│   ├── repositories/# 8 个仓库接口
│   └── usecases/    # 30+ 用例类
└── presentation/
     ├── pages/       # Material 3 UI 页面
     ├── state/       # ChangeNotifier 状态管理器
     └── widgets/     # 可复用头像和文件图标小部件
```

## 技术栈

- **Flutter 3.x** / **Dart 3.x**
- **Material 3** 设计体系
- **Clean Architecture** — domain/data/presentation 分层
- **ChangeNotifier** 状态管理（无第三方状态管理依赖）
- **Either\<Failure, T\>** 类型化错误处理
- **http** 包用于 HTTP 请求

## 许可证

MIT License。详见 [LICENSE](LICENSE)。