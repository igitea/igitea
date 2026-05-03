# iGitea

基于 OpenAPI 规范构建的跨平台 [Gitea](https://gitea.io) Flutter 客户端。

> 由 OpenCode 和 Kimi 2.6 构建 — 欢迎提交 PR！如果有多余的 token 帮帮我们吧，真的快撑不住了 lol！

## 截图

| 登录 | 个人资料 | 仓库 | Issue |
|:----:|:--------:|:----:|:-----:|
| <img src="doc/login.png" width="200" /> | <img src="doc/profile.png" width="200" /> | <img src="doc/repos.png" width="200" /> | <img src="doc/issues.png" width="200" /> |

## 功能特性

### 核心
- 跨平台：Android、iOS、macOS、Linux、Windows、**Web**
- Clean Architecture + Repository Pattern
- Material 3 设计系统，高级 UI 打磨
- 统一的 4px 间距网格和字体层级，覆盖所有页面
- 120+ 个数据模型，基于 OpenAPI 规范自动生成
- 49+ 个领域用例，采用 `Either<Failure, T>` 模式
- 270 个测试通过，`flutter analyze` 无错误

### 认证
- 用户名/密码登录（主要方式）
- Access Token 登录（次要方式）
- OAuth2 登录：浏览器授权 → 回调 Code → Token 交换
- 会话持久化与自动恢复

### 仓库
- 仓库列表、搜索、浏览
- 可折叠头部，支持 Star / Fork 操作
- 区块列表导航：代码、Issue、里程碑、Pull Request、Release、提交、分支、标签、Wiki、Webhook、标签（点击进入）
- 文件浏览器：面包屑导航和目录浏览
- 文件查看器：Markdown 渲染、图片展示、代码语法高亮
- 文件编辑：提交消息对话框
- 仓库设置：编辑描述、可见性、功能开关、删除仓库

### Issue 和 Pull Request
- Issue 和 PR 的列表、搜索、筛选
- 详情页：Markdown 正文、状态徽章、作者头像、标签
- 评论：Markdown 渲染与输入
- 创建 Issue：支持标题、正文、标签选择、里程碑选择
- 编辑 Issue：支持标题、正文、状态切换、标签选择、里程碑选择
- 关闭/重开 Issue，合并 PR（需确认）

### 里程碑
- 里程碑列表：进度条、打开/关闭统计
- 里程碑详情：可见关联 Issue，支持编辑和删除
- 创建里程碑：标题、描述、截止日期

### Wiki
- Wiki 页面列表
- Wiki 详情：Markdown 渲染，支持选择文本
- 创建 Wiki 页面：标题、Markdown 内容、预览切换、提交消息
- 编辑 Wiki 页面：同创建，预填现有内容
- 删除 Wiki 页面：确认对话框

### 标签管理
- 标签列表：颜色圆点指示器、名称、描述
- 创建标签：名称、描述、颜色选择器（预设色板）
- 编辑标签：同创建，支持删除

### Webhook 管理
- Webhook 列表：类型、URL、激活状态
- Webhook 详情：配置信息、事件列表、编辑、删除
- 创建 Webhook：URL、Secret、Content-Type、事件多选、激活开关
- 组织级 Webhook 管理

### 协作者
- 仓库协作者列表
- 搜索用户添加/移除协作者

### 分支保护
- 分支保护规则列表（分支名、创建时间）
- 按分支名创建保护规则
- 确认后删除保护规则

### 软件包
- 按类型筛选浏览软件包
- 软件包详情：类型、版本、创建者、创建时间、关联仓库
- 文件列表（可读的文件大小）
- 确认后删除软件包版本

### CI/CD Actions
- 按 workflow 文件分组显示工作流运行
- 状态筛选（success/failure/in_progress 等）+ 参与者筛选
- 滚动到底部自动加载更多（无限分页）
- Job 日志自动轮询刷新（每 5 秒）
- 运行详情：Job 列表、可展开日志、构建产物下载

### 组织和团队
- 查看组织信息、仓库列表、团队列表
- 点击组织头像跳转到详情页
- 组织仓库列表支持跳转
- 团队详情页：成员列表和仓库列表
- 创建/编辑/删除团队，权限管理
- 添加/移除团队成员（用户搜索）
- 编辑组织名称、描述、位置、网站、邮箱、可见性
- 从个人主页创建新组织

### Release
- 浏览 Release 及资源下载
- Release 详情页：正文、资源文件、tarball/zipball 下载链接

### 星标仓库
- 在个人主页查看所有星标仓库
- 一键 Star / Unstar

### 活动流
- 仪表盘显示最近活动
- 支持：创建/删除仓库、推送/删除标签、创建/关闭/重开 Issue 和 PR、评论、分叉、转移

### 通知
- 通知列表与未读标记
- 单条标记已读 / 全部标记已读

### 搜索
- 全局搜索：仓库和 Issue
- 实时搜索结果

### PR Diff 查看器
- 统一 diff 解析：文件级导航、@@ hunk 头部
- 行级新增（绿）/ 删除（红）着色，行号栏
- Unified / Split 视图切换
- 代码审查：Comment / Approve / Request Changes

### 文件操作
- 文件查看器：语法高亮、Markdown 渲染、编辑、下载
- 文件历史：提交时间线，点击进入提交详情
- 文件对比：Base/Head ref 输入，diff 渲染
- Blame 视图：逐行显示最后修改的 commit SHA 和作者

### Commit 详情
- 提交信息、作者、SHA 复制、统计（+/-）
- Changed files 可展开显示内联 diff（行级着色）

### 设置
- 主题：浅色 / 深色 / 跟随系统
- 语言选择（支持 10 种语言）
- 账户信息展示
- 管理后台：用户管理、系统 Hooks、定时任务、Action Runners、邮件记录、用户徽章（仅管理员可见）

### 国际化
- 英语 (en)
- 简体中文 (zh)
- 繁体中文 (zh_TW)
- 日语 (ja)
- 韩语 (ko)
- 西班牙语 (es)
- 法语 (fr)
- 德语 (de)
- 葡萄牙语 (pt)
- 俄语 (ru)

### Deep Link
- `/{owner}/{repo}` — 仓库
- `/{owner}/{repo}/issues/{id}` — Issue
- `/{owner}/{repo}/pulls/{id}` — Pull Request

## 技术栈

| 层级 | 技术 |
|------|------|
| 框架 | Flutter |
| 状态管理 | ChangeNotifier + ListenableBuilder |
| HTTP | http package |
| 存储 | path_provider, shared_preferences |
| 国际化 | flutter_localizations |
| UI | Material 3 |
| 链接 | url_launcher |
| 文件选择 | file_picker |
| Markdown | flutter_markdown |

## 开始使用

### 前置要求

- Flutter SDK >= 3.11.5
- Dart SDK >= 3.11.5

### 构建

```bash
# 安装依赖
flutter pub get

# 运行（开发）
flutter run

# 构建 APK（Android）
flutter build apk --debug

# 构建 macOS
flutter build macos

# 构建 Web
flutter build web
```

### 测试

```bash
flutter analyze
flutter test
```

## 项目进度

所有阶段已完成。

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
| 10 | Issue/PR 详情与搜索 | ✅ 完成 |
| 11 | 设置页与管理功能 | ✅ 完成 |
| 12 | 国际化 | ✅ 完成 |
| 13 | Wiki、里程碑 CRUD、Webhook、标签管理、OAuth2、Actions | ✅ 完成 |

## 许可证

MIT
