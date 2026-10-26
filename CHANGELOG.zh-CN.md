# 更新日志

## [Unreleased]

### 新增
- **固定在底部的评论输入框**：Issue 与 Pull Request 页面（独立页面及桌面/平板分栏）中，评论框始终固定在底部，长对话滚动时不会消失；最多扩展到六行，桌面端支持 ⌘/Ctrl + Enter 发送，会随屏幕键盘上移，发送后自动滚动到新评论
- **平板工作区**：布局断点改为在所有平台上按窗口宽度判断，横屏的 iPad 与 Android 平板可使用三栏仓库概览与 Issue 列表-详情工作区，不再是拉伸的手机单栏
- **带文字的平板导航栏**：窗口宽度在 760–1000 之间时侧边栏自动收为导航栏；触屏设备上每项在图标下方显示文字
- **`LabelBadge` / `LabelRow`**：统一的 Issue 标签胶囊，淡色底 + 经对比度校验的文字，替换原先五处各自实现
- **`AvatarFallback`**：无头像时以稳定的强调色淡底显示首字母；组织头像改用圆角方形，与个人头像区分
- **`AppSectionAction`**：区块标题右侧低调的品牌色「查看全部」链接
- **界面审查工具**（`tool/ui_review`）：使用模拟 Gitea 后端，在手机、平板、桌面尺寸及亮/暗色模式下渲染关键页面
- 新增平板断点、带文字导航栏、标签对比度与头像占位的测试

### 变更
- **触控舒适度**：手机与平板上的文字在系统字号基础上放大 8%；触屏上图标按钮增大到 40pt、侧边栏行 44pt，列表行内边距加大
- **符合平台习惯的界面元素**：键盘提示、快捷键按钮与 tooltip 只在鼠标/键盘平台显示；平板上不再因双击打开而延迟单击
- **手机外壳**：一级页面使用大标题；主题切换从手机顶栏移除（个人资料页改为显示设置入口）；收件箱铃铛显示未读红点
- **仪表盘**：窄窗口下五个工作入口改为分组列表，不再出现参差网格；手机主视觉卡片副标题可显示两行并使用紧凑的新建按钮，支持下拉刷新的平台隐藏刷新按钮
- **Issue 列表**：类型筛选标签已本地化，新增「请求审核」标签，「保存筛选」移入筛选工具栏作为图标按钮
- **仓库顶栏**：手机上将派生、在浏览器中打开与设置收入「更多」菜单
- **个人资料**：组织头像下方显示组织名称
- **Issue 详情**：标签单独成行，位于编辑与订阅按钮上方
- **界面审查服务**（`tool/ui_review/fake_server.dart`）：将审查数据作为本地 Gitea API 提供，便于在模拟器中试用应用
- **仓库区块**遵循仓库设置：仓库关闭了代码、Issue 与里程碑、Pull Request、Release、Wiki 或 Actions 时，对应区块会被隐藏
- **README 预览**在手机上截取为带渐隐的短摘要（宽窗口更长），并在段落处截断，避免未闭合的代码块吞掉后续内容
- **代码查看**：制表符按 4 列显示，缩进较深的代码也能在手机上看清
- **更友好的错误提示**：「not found」与权限错误在所有语言中都显示为易懂的句子
- **应用名称**：iOS 主屏、Android 启动器、macOS 菜单栏、Web、Windows 与 Linux 标题栏统一显示为「iGitea」
- **统一的应用图标**：iOS、Android（自适应与旧版）、macOS、Windows、Web 以及 Play 商店/MSIX 素材统一使用应用内的青绿色代码方块标志，由 `tool/icons/generate_icons.py` 生成；移除了未再使用的茶壶图标源文件
- **启动屏**：iOS 与 Android 启动屏在亮/暗色模式下使用应用底色，不再白屏闪烁
- **仪表盘入口**：内容宽度小于 760pt 时改用分组列表，iPad mini 与竖屏 iPad 不再截断「已加星标的仓库」
- 界面审查工具新增 iPad mini 与 13 英寸 iPad Pro 尺寸
- **Android 调试版**可以通过明文 HTTP 访问开发机上的 Gitea 服务（`10.0.2.2`、`127.0.0.1`、`localhost`）；正式版不受影响

### 修复
- **iOS 与 macOS 图标集**：多个尺寸复用了 1x 图片（图标模糊），iOS 图标还带有 App Store 不接受的透明通道；现在每个尺寸都按精确像素生成，并在系统要求处保持不透明
- **Apple 平台与 Windows 上的等宽字体**：代码块、Diff、Blame、提交 SHA 与 Token 使用的 `monospace` 字体只在 Android 与 Linux 上存在，其他平台回退为比例字体；现在改用 Menlo / SF Mono / Consolas
- **刘海屏手机列表顶部的空白条**：二级页面与首页标签页的正文仍带有状态栏内边距，导致未设置内边距的列表（如代码查看）顶部出现空白
- 仓库头部的分支图标与分支名不再间隔过大
- 组织、团队与关注者页面的标签页标题在手机上不再折成两行
- `#a2eeef` 等浅色标签在浅色背景上无法看清的问题

## [0.41.0] - 2026-10-26

### 新增
- **桌面工作区**：三栏仓库概览（左侧分组导航栏、中间 README/概览、右侧「关于」上下文栏）、宽屏下的 Issue 列表-详情-元数据三栏工作区，以及可折叠并持久化的图标栏侧边栏
- **桌面交互层**：`AppHoverRegion` 提供 hover 意图防抖、单层悬浮底色、焦点环、Enter/空格激活、右键上下文菜单与双击打开；已应用到外壳、仓库行、Issue 卡片、通知与动态流
- **快捷键帮助**：`?` / `⌘/` 打开快捷键面板，`⌘B` 折叠侧边栏
- **桌面外壳基础**：`DesktopLayout` 窗口尺寸断点、仓库/Issue 分栏断点、带滚动条的桌面滚动行为，以及更宽的 macOS 默认窗口
- 桌面组件测试：hover 防抖、上下文菜单、双击、键盘激活、三栏仓库工作区、Issue 列表-详情工作区与侧边栏快捷键

### 变更
- **悬浮细节**：紧凑列表行改用 30ms 进入 / 60ms 离开的意图延迟，并将高亮绘制在内容背后，快速划过时不再闪烁图标、文字或边框
- **仓库上下文**：桌面端将语言、主题、克隆地址与元数据移入右侧独立面板，中间保留 README 与快捷操作
- **Issue 详情**：新增嵌入式列表-详情模式，隐藏独立页面外壳，并避免切换行时短暂显示上一条 Issue
- **选中态**：选中的卡片使用淡色背景与品牌色描边，Issue 列表可清晰标识当前行
- **仪表盘**：主视觉卡片新增适合桌面阅读的副标题
- 移除仓库上下文栏中重复的快捷操作

### 修复
- **Hover 闪烁**：悬浮高亮改为从目标颜色的 alpha=0 版本过渡，而不是从 `Colors.transparent` 过渡。透明黑到浅色插值会在每个按钮、侧边栏行和列表卡片上产生一帧深灰闪烁；现在 hover 过渡干净无频闪。

## [0.40.0] - 2026-10-24

### Changed
- **Issue / PR 详情细节**：Issue 状态改用语义化绿/紫徽标，页面内边距统一为 20px，评论加载失败显示本地化友好文案而非原始网络错误
- **仓库 README**：仓库概览新增 README 预览卡片，包含骨架屏、统一 Markdown 样式与「查看全部」入口；仓库没有 README 时自动隐藏
- **登录与收件箱细节**：登录页的超时/网络错误改为本地化友好文案；收件箱为空时隐藏「全部已读」按钮；启动页加载指示更清晰
- **里程碑**：改为分组行，加入进度条、到期日胶囊（逾期标红）、开启/关闭数量与带文字的创建按钮
- **通知**：改为紧凑分组行，未读行淡青底色、主题图标、仓库/时间信息、未读圆点与统一的加载更多
- **PR 详情**：限制为 980px 阅读宽度并统一页面内边距
- **发布与 Git 标签**：发布和 Git 标签列表改为紧凑分组行，展示预发布/草稿徽标、作者与日期信息及下载菜单，与提交、分支列表保持一致
- **仓库子页面**：提交历史与分支改为紧凑分组行，展示作者/时间/短 SHA、默认分支与保护标识；中文文案区分 `Git 标签` 与 `议题标签`
- **表单**：创建仓库与新建 Issue 改为分组卡片布局，限制 760px 阅读宽度，底部提供明确的取消/提交按钮，里程碑改用 Forui 选择器，错误提示更友好；所有新建/编辑表单统一采用更窄的表单宽度
- **个人资料仓库**：个人主页新增最近仓库列表，展示语言与星标信息，并提供「查看全部」、骨架屏与错误态
- **搜索**：仓库/Issue/用户支持 400ms 防抖即时搜索；结果改为紧凑分组行并展示语言/星标/Fork 信息，清空输入后回到对应标签的引导空态
- **移动端外壳**：移除重复的铃铛按钮，修正手机端顶栏操作顺序，并验证了仪表盘、个人资料与探索页的窄屏布局
- **仓库代码浏览**：代码页改为单张卡片，加入分支胶囊、路径上下文、青绿文件夹图标、文件大小、骨架行与友好重试；README、Issue/PR 正文与 Wiki 统一使用同一套 Markdown 文档样式
- **仓库 Issue / PR 标签页**：统一分段状态控件、图标筛选、本地化空态/错误态与带文字的创建按钮；所有仓库区块页在标题下显示 `owner/repo` 上下文
- **列表与加载**：动态流与关注列表合并为单张分组卡片，公开资料加载改为结构化骨架屏而非渐变占位
- **暗色模式审计**：在 macOS 上验证了新导航、仓库概览、代码骨架、文件列表与 Markdown 阅读器的暗色表现
- **UI 品质专项「精密仪器」**：以暖中性画布、发丝级描边、语义化 Git 配色与单一青绿强调色为核心的设计令牌刷新；新增 `AppPalette` 主题扩展、`AppSurface` 悬浮卡片、`AppSkeleton` 微光骨架屏与 `AppSegmentedControl` 分段控件
- **桌面外壳**：自建侧边栏（带动效选中指示与账户卡片）、更克制的顶栏（⌘K 搜索提示、主题切换）、⌘1–⌘4 标签快捷键，以及延伸到透明标题栏下方的 macOS 窗口和全新品牌图标
- **仪表盘**：编辑式日期/主视觉卡片、响应式五宫格工作区、双栏「收藏/快捷方式 + 动态流」、骨架加载、创建仓库入口与紧凑仓库行
- **仓库概览**：用内容卡片替换原青绿渐变头部，集中展示身份、元信息、内联统计、语言分布、主题标签与可复制的克隆地址
- **探索 / Issue / 登录 / 设置**：紧凑分段控件与搜索优先布局、带内联标签的紧凑 Issue 行、品牌化登录卡片、更友好的空态/错误态与超时/网络提示
- **个人资料**：登录用户与公开用户统一为卡片式头部 + 内联统计，账户操作分组呈现，退出登录改为更安静的列表行
- **动效**：页面淡入淡出转场、保留状态的标签交叉淡入、悬浮过渡与微光骨架屏；系统开启「减少动态效果」时全部动效自动收敛
- **字体与色彩**：为 Material 组件恢复 Inter 行高，补充错误/警告/信息/紫色语义令牌，Forui 与遗留 Material 表面共享焦点环与悬浮反馈
- **启动与窗口**：品牌化启动页、关闭窗口状态恢复以保证每次以舒适的桌面尺寸打开、README 截图同步更新
- **Forui 设计系统**：界面整体改用 Forui（shadcn 风格）——引入 `forui` 0.21.3，用统一的 `FTheme`（青绿品牌色、亮/暗色）包裹全部路由，接入 `FToaster`/`FTooltipGroup`，并生成近似的 Material 主题，让尚未迁移的页面也立刻呈现新风格
- **自适应应用外壳**：`HomePage` 基于 `FScaffold`/`FHeader` 重写；宽屏使用 `FSidebar`，手机使用 `FBottomNavigationBar`；标题与操作按钮随当前 Tab 变化，Tab 页面不再各自嵌套 AppBar（消除双层标题栏）
- **首页仪表盘**：区块改为 Forui 卡片 + `FTappable` 行 + `FButton` 操作，加载/空态/错误占位统一使用新的 Forui 状态组件
- **卡片**：`PremiumCard`/`PremiumListCard` 改为基于 `FCard`，仓库、通知、搜索、个人资料等卡片共享 Forui 的边框、圆角与按压反馈
- **仓库列表**：搜索框改用 Forui 文本框，页面改用 `AppPage` 外壳与 `AppEmpty`/`AppError` 状态
- **空态**：`EmptyState` 统一委托给 Forui 的 `AppEmpty`
- **登录页**：改用 Forui 重写——账户/令牌/OAuth2 分段切换、`FTextFormField`/`FTextFormField.password`、`FButton` 提交、`FAlert` 错误提示、Toast 反馈，并在高屏上垂直居中、窄屏可滚动
- **通知页**：改用 Forui 的加载/错误/空态，主题图标换为 `FIcons`，「加载更多」改用 Forui 按钮
- **议题列表**：页面改用 `AppPage`，搜索框换 Forui 文本框，open/closed/all 改为分段按钮，筛选标签与已保存筛选改用 `AppFilterChip`，加载/错误态统一
- **议题详情**：`AppPage` 头部 + Forui 的浏览器打开/删除操作，错误与加载态统一
- **个人资料**：账户操作合并为一个 `AppSection`（`AppTile` 行），管理员标识改用 `FBadge`，退出登录确认改用 `FDialog`
- **搜索页**：仓库/议题/用户切换由 Material `TabBar` 改为分段按钮，搜索框与状态视图改用 Forui
- **仓库详情**：`AppPage` 头部 + Forui 的星标/关注/Fork 操作，仓库功能区合并为一个 `AppSection`（`AppTile` + `FIcons`），加载/错误态统一
- **设置页**：`AppPage` + 分组 `AppSection`（外观 / 账户 / 管理），主题与语言选择改用 `FDialog`，退出登录改用 `FDialog` 确认，服务器设置改为分组只读列表
- **议题表单**：新建/编辑议题改用 Forui 输入框、可选标签按钮、open/closed 分段选择与内联提交按钮，SnackBar 改为 Forui Toast
- **新建 PR**：表单改为 Forui 布局（`FTextField` 标题/正文 + `FButton` 提交）
- **PR 详情**：`AppPage` 头部 + 审查/浏览器打开操作，合并确认改用 `FDialog`，评论输入与加载/错误态 Forui 化
- **表单页批量迁移 Forui**：新建/编辑标签、新建/编辑里程碑、新建/编辑组织、新建/编辑团队、新建/编辑 Release、新建仓库、迁移仓库、新建 Webhook、新建管理 Webhook——统一使用 `AppPage`、`FTextFormField`/`FTextField`、`FButton`、`FDialog` 与 `showFToast`
- **审查弹窗**：`CreateReviewDialog` 改为 `FDialog`，审查动作使用 Forui 分段按钮
- **邮箱页**：`AppPage` 头部操作、Forui 列表行、添加/删除弹窗与 Toast
- **账户与用户页**：SSH 密钥、访问令牌、GPG 密钥、OAuth 应用、关注列表、用户/星标仓库、组织列表、用户管理全部迁移到 `AppPage` + Forui 列表行/`FDialog`/Toast（令牌页保留作用域分组与创建弹窗）
- **文件与 Diff 查看器**：仓库文件、Blame、历史、对比、PR 文件列表、PR Diff 页改用 `AppPage` 工具栏 + `FHeaderAction`、溢出菜单 `FPopoverMenu`、Forui 状态视图与弹窗；代码/Diff 渲染逻辑不动
- **管理页**：仪表盘、Hooks、Cron、Runners、邮件、徽章改为分组 `AppSection`/`AppTile` 列表，搜索、操作与弹窗 Forui 化
- **仓库详情子页**：分支、提交、Release、Tag、标签列表、里程碑、协作者、分支/标签保护、仓库设置、Stargazers 全部迁移到 `AppPage`；Stargazers 使用 `FTabs`，设置页使用 `FSwitch`，弹窗使用 `FDialog`
- **Actions / Webhook / Wiki / 包页面**：工作流运行列表（`FPopoverMenu` 筛选）、运行详情、仓库与组织密钥/变量、Webhook 列表（创建弹窗改用 `FSelect`/`FSwitch`）、Wiki 列表/详情/编辑、包列表/详情全部 Forui 化
- **活动流与用户主页**：活动流改用 `AppPage` + Forui 行与 `FIcons` 图标；他人主页改用 `AppPage` 与 `AppError`
- **筛选面板**：议题与仓库筛选底部弹窗改用 Forui 标签按钮（`FButton`）、`FCheckbox` 与分段类型/排序控件
- **Material 收尾清理**：议题/团队/组织详情、议题列表、个人主页、仓库详情、PR 详情、新建仓库页不再使用 Material 卡片/行/输入框/按钮/标签/弹窗/图标；保存筛选、Topics、Fork、依赖等弹窗统一为 `FDialog`
- **筛选面板改用 `FSheet`**：议题与仓库筛选在议题列表、仓库详情、搜索页均以 Forui 模态面板（`showFSheet`）打开
- **清除最后的 Material 外壳**：团队/组织详情改为 `AppPage` + `FTabs`（去掉折叠式 Material 头部与可滑动 `TabBarView`），组织的溢出操作收进 `FPopoverMenu`
- **一致性收尾**：新建/编辑表单中剩余的 `SwitchListTile`/`CheckboxListTile` 改为 `FSwitch`/`FCheckbox`，剩余筛选 `Chip` 改为 `AppFilterChip`，最后一批 Material 图标与 SnackBar 也替换完毕
- **打磨**：`Wrap` 中的标签型 `FButton` 改为内容宽度、页面列改为拉伸使筛选行左对齐、头像回退改用 `FAvatar`，并用 Forui 新界面刷新了 README 截图
- **macOS 窗口**：桌面窗口现在以合适尺寸打开（最大 1200×860 并居中，最小 420×640），不再沿用很小的历史窗口尺寸，侧栏布局有足够空间

### Added
- `AppTheme`（品牌色板、亮/暗 Forui 主题、触屏/桌面密度）
- 共享 Forui 组件：`AppPage`、`AppSection`、`AppTile`、`AppFilterChip`、`AppLoading`、`AppEmpty`、`AppError`、`AppSectionPlaceholder`；`AppTile` 新增 destructive 变体，`AppPage` 保留透明 `Material` 祖先以兼容迁移中的旧组件
- `AppSection`/`AppTile` 测试，以及「标题随 Tab 切换」的首页测试
- i18n：新增 `savedFilters`（中/繁）与 `saveFilter`（繁中）

### Removed
- 移除旧首页组件 `HomeIconTile`、`HomeRepoTile`、`HomeSectionCard`、`HomeRecentTile` 及其测试（由 `AppSection`/`AppTile` 取代）

## [0.37.0] - 2026-09-10

### Changed
- **Release 正文取自 CHANGELOG.md**：`create-release` 任务改为用 `scripts/release-notes.mjs` 提取对应版本的更新日志段落，不再用 GitHub 自动生成的 notes

### Performance
- **请求超时分级**：常规 API 请求超时 15 秒（原 30 秒），二进制下载 45 秒；GET 重试收敛为 1 次且 5xx 不再重试——慢/失败的服务器现在 ~15–35 秒内报错，不再傻等最多 ~93 秒
- **后台 JSON 解码**：`GiteaApiService` 中超过 64KB 的响应体改在后台 isolate 解码（`compute`），大响应到达时不再卡 UI 线程
- **Diff 懒加载**：PR diff 查看器将 diff 行展平为行模型，由 `ListView.builder` 按需构建；diff 解析移到后台 isolate（commit 详情与文件对比页同样处理）；单文件超过 3000 行时截断显示并提供「显示完整 diff」按钮
- **代码查看器分块渲染**：源码文件按每 500 行分块渲染，不再一次性构建整棵 `HighlightView` + 行号列的 widget 树，并移除了昂贵的 `IntrinsicHeight` 布局
- **文件大小守卫**：超过 1MB 的文本文件和超过 512KB 的 Markdown 文档不再内联渲染（改为显示大小提示和浏览器/下载入口）；超过 1MB 的文件禁止进入编辑
- **头像缓存**：`UserAvatar`/`OrgAvatar` 改用 `cached_network_image`，带磁盘缓存与降采样（`maxWidthDiskCache`/`memCacheWidth`），弱网下不再重复下载、头像不再闪烁；文件图片预览与管理徽章图片通过 `cacheWidth`/`cacheHeight` 降采样
- **响应缓存限容**：`ApiClient` 内存缓存达到 100 条后驱逐最旧条目，避免长时间使用内存无限增长

### Added
- **弱网提示**：新增 `SlowLoadingIndicator` 组件，仓库详情、issue 详情、文件页加载超过 10 秒后显示「网络似乎较慢」提示，长时间等待不再像应用卡死
- **新增 l10n key**：stillLoading、showEntireDiff、fileTooLargeParams、previewTruncatedParams、documentTooLarge（en / zh / zh_TW）
- **活动流页面**：新增 `ActivityPage`，展示用户完整活动流（`/users/{username}/activities/feeds`），支持滚动到底自动分页加载，加载/错误/空态完整，点击可跳转相关仓库
- **活动行组件**：新增 `ActivityTile`，将 Gitea `op_type`（push、issue、PR、合并、Release、分支、收藏、Fork、审查等）映射为图标与本地化动作文案
- **首页「最近」改为真实活动**：首页最近区块现在展示 5 条最新活动（原先是通知流），并提供「查看全部」入口跳转活动流页面
- **新增 l10n key**：viewAll、activityCreatedRepo、activityPushed、activityOpenedIssue、activityOpenedPr、activityMergedPr、activityCommentedIssue、activityCommentedPr、activityPublishedRelease、activityCreatedBranch、activityDeletedBranch、activityStarred、activityForked、activityApprovedPr、activityRequestedChanges（en / zh / zh_TW）

### Fixed
- **首页加载状态补全**：收藏区块现在有加载中的进度指示和失败后的错误提示+重试（原先失败时静默显示空态，无法区分「加载失败」与「真的没有仓库」）
- **共享状态污染修复**：首页收藏与最近活动列表改为页面本地状态，不再写入共享的 `UserNotifier`——首页不再覆盖个人资料页的完整仓库列表和活动流分页数据
- **UserNotifier 状态补全**：新增 `activitiesLoading`、`activitiesError`、`reposLoading` 状态字段

## [0.36.0] - 2026-08-16

### Changed
- **允许 HTTP 服务器地址**：登录不再强制 HTTPS，支持没有 TLS 证书的 Gitea 实例
- **存储回退到 SharedPreferences**：移除 `flutter_secure_storage` 依赖（在原生钥匙串/凭据可用前暂不使用）

## [0.35.0] - 2026-08-15

### Added
- **GitHub Mobile 风格首页**：四区块仪表盘（我的工作快捷入口 / 收藏=我的仓库 / 快捷方式=已提及+已请求审核 / 最近=通知），支持下拉刷新
- **底部导航改名**：主页 / 收件箱 / 探索 / 个人资料，AppBar 带头像
- **议题过滤 `reviewRequested`**：`IssueFilterState` + notifier 接线，`IssueListPage` 支持 `initialFilter` 预过滤快捷跳转
- **首页组件**：`HomeSectionCard`、`HomeIconTile`、`HomeRepoTile`、`HomeRecentTile`（哑组件，Material 3 token）
- **新增 l10n key**：myWork、favorites、shortcuts、recent、mentioned、reviewRequested、recentEmpty、home、inbox、explore、topRepositories（10 种语言）

### Docs
- **首页改造实施规格**：`docs/igitea-home-redesign-spec.md` —— 参照 GitHub Mobile 风格的新首页实施指南（区块结构、API 映射、组件规格、l10n key、分步实施顺序、测试计划、验收标准）

## [0.34.2] - 2026-06-01

### Fixed
- **登录页面表单间距**：增加间距以防止登录表单字段中的标签/提示重叠

## [0.34.1] - 2026-05-26

### Added
- **下拉刷新**：Issue详情和PR详情页面支持下拉刷新，重新加载Issue/PR详情、评论、仓库信息、订阅状态和反应
- **最近活动无限滚动**：仪表板最近活动现在滚动到底部时自动加载更多（无感分页）

## [0.34.0] - 2026-05-26

### Audited
- **并行6专家代码审计**：框架层、业务逻辑、渲染层、手势交互、输入体验、无障碍访问
  - 识别62个问题（4个P0关键、24个P1高优、34个P2中优）
  - 完整报告：`PARALLEL_AUDIT_REPORT.md`
  - 关键P0发现：ApiClient内存泄漏、createComment编译错误、设置页崩溃、搜索缺少防抖

### Fixed
- **ApiClient内存泄漏** [P0]：新增`close()`方法，`updateAuth()`中释放旧client，`app.dart`中重建去重
- **设置页崩溃** [P0]：将盲目`Right`强转改为`Either`模式匹配+错误SnackBar
- **搜索防抖** [P0]：`IssueListPage`搜索栏新增300ms定时器防抖
- **未等待的异步初始化** [P1]：为`_tryRestoreSession`、`loadThemeMode`、`loadLocale`添加`.catchError(debugPrint)`
- **吞掉的API异常** [P1]：3个check方法中`catch (_)`改为`on AuthenticationException` / `on NotFoundException`
- **基础URL路径丢失** [P1]：`Uri.replace(path:)`改为`Uri.resolve()`以支持子路径
- **UserNotifier状态污染** [P1]：`listCurrentUserRepos`错误不再覆盖profile状态，改用`_reposError`字段
- **通知列表销毁** [P1]：`markThreadRead`/`markAllRead`错误不再用error state替换整个列表
- **无效按钮** [P1]：修复`tag_detail_page`空`onPressed`（添加url_launcher）和`search_page`重试按钮
- **SafeArea双重内边距** [P1]：移除筛选BottomSheet的手动底部padding
- **脆弱的OverlayEntry** [P1]：issue/PR详情中的`late final`改为`late`
- **重复方法** [P1]：移除`tag_protections_page`中未使用的`_create()`
- **硬编码日期字符串** [P1]：替换为ARB本地化字符串（`yearsAgo`、`monthsAgo`、`daysAgo`、`hoursAgo`、`justNow`）
- **缺少加载占位** [P1]：admin badges的`Image.network`添加`loadingBuilder`
- **手势冲突** [P1]：issue/PR详情长按检测器添加`HitTestBehavior.opaque`
- **评论懒加载** [P1]：eager `Column`替换为`ListView.builder`（shrinkWrap + NeverScrollableScrollPhysics）
- **Repo issues搜索防抖** [P1]：新增300ms定时器防抖
- **键盘收起** [P1]：搜索页添加`textInputAction.search` + `FocusScope.unfocus()`
- **键盘遮挡对话框** [P1]：SSH key对话框包裹`SingleChildScrollView`
- **头像alt文本** [P1]：`UserAvatar`和`OrgAvatar`添加`semanticLabel`
- **图片预览alt文本** [P1]：`repo_file_page`图片预览添加`semanticLabel`
- **登录logo语义** [P1]：logo包裹`Semantics(label: l10n.appTitle)`
- **操作图标提示** [P1]：topic编辑图标添加`Tooltip`
- **反应按钮无障碍** [P1]：反应按钮添加`Semantics(label: 'Add reaction')`
- **PremiumCard setState安全** [P1]：tap回调添加`if (mounted)`守卫
- **TokensPage无效InkWell** [P1]：移除`onTap: null`包装器
- **编辑图标点击区域** [P1]：增大到48dp并添加Tooltip/Semantics标签
- **Notifier错误处理** [P2]：PackageNotifier竞态条件、OrgActions/RepoActions/UserOAuth/Token/Admin notifier错误状态
- **认证持久化顺序** [P2]：状态变更前先保存凭证
- **仓库删除状态** [P2]：新增`RepoDeleted`状态替代复用`RepoInitial`
- **输入验证** [P2]：OAuth2验证器、焦点链、自动填充、maxLength限制、TextFormField迁移
- **键盘类型** [P2]：website字段URL键盘、评论textCapitalization
- **图片约束** [P2]：repo文件查看器限制图片尺寸
- **ListView性能** [P2]：添加`itemExtent`和`AutomaticKeepAliveClientMixin`
- **手势反馈** [P2]：GestureDetector改InkWell、条件InkWell包装、按压反馈
- **颜色主题** [P2]：badge颜色、diff统计、语言点使用主题色
- **减少动画** [P2]：dashboard/empty state尊重`MediaQuery.disableAnimations`
- **语义层级** [P2]：标题层级、信息行合并、装饰元素排除
- **硬编码字符串** [P2]：`loadMore`、筛选对话框字符串替换为l10n键
- **评论静默刷新** [P2]：提交评论不再显示全屏loading，列表无缝更新
- **评论无限滚动** [P2]：滚动到底部200px内自动加载更多评论（Issue/PR详情页）

### Added
- **Issue List 高级筛选**：标签、里程碑、类型、指派给我、我创建的、提及我的
  - 触屏友好的 BottomSheet 交互，支持拖拽关闭、应用/重置按钮
  - 已应用的筛选器以可删除 Chip 形式显示在列表上方
  - 仓库 Issues Tab：新增 SearchBar 支持文本搜索
- **仓库搜索高级筛选**：排序、顺序、仅私有、归档、模板
  - 排序选项：相关度、字母顺序、最新、最近更新、最多星标、最大
  - 顺序选项：默认、升序、降序
  - 筛选选项：仅私有仓库、包含归档仓库、仅模板
  - 已应用的筛选器以可删除 Chip 形式显示
- **筛选对话框防重复弹出**：防止同时打开多个 BottomSheet

## [0.33.0] - 2026-05-11

### Added
- **Dashboard 重构**：快速操作改为竖排入口列表（Repo、Issues、动态、星标、组织）
- **独立动态页面**：点击"动态活动"卡片进入全屏活动列表
- **我的 Issue 筛选**：`IssueListPage` 支持 `initialFilter: 'assigned'` 参数过滤指派给我的 Issue
- **Issue 按负责人搜索**：`searchIssues` 新增 `assigned` 参数
- **Dashboard 国际化**：所有 subtitle 字符串已本地化（新增 6 个 ARB 键）

### Fixed
- Dashboard 动态页面像素溢出（改用 ListView 包裹）
- 动态列表动画与加载更多冲突（移除 FadeInWrapper）
- 组织入口缺少返回按钮（改用 OrganizationsListPage 导航）
- 恢复意外的类删除（_WelcomeCard、_RepoSummary、_QuickActions）
- 移除冗余的 dashboard 区块：通知入口、我的 Issue 入口、仓库摘要列表

## [0.32.0] - 2026-05-11

### Added
- **无限滚动分页**：动态活动、Admin 用户搜索、用户仓库、Release 列表每页加载 20 条，底部"加载更多"按钮

## [0.31.0] - 2026-05-10

### Added
- **Issue/PR 表情反应**：在 Issue、PR 和评论上添加/删除表情反应
  - API：6 个方法支持 Issue 和评论的 reactions（列表/添加/删除）
  - Repository + Use Cases：`ReactionRepository`，6 个 Use Cases
  - UI：表情反应行，支持 emoji 按钮，用户自己的反应高亮显示
  - GitHub 风格选择器：按钮下方浮起下拉面板，平滑动画，count=0 时自动隐藏
  - 支持：+1、-1、laugh、hooray、confused、heart、eyes
- **分支 → 代码浏览**：点击分支列表中的分支，现在直接跳转到该分支的代码浏览器
- **保存筛选条件**：通过 SharedPreferences 保存和恢复 Issue 列表筛选条件预设（状态 + 搜索关键词）
  - 模型：`SavedFilter`，包含 id/name/state/query 字段
  - 服务：`SavedFilterService`，支持延迟初始化 SharedPreferences
  - UI：可展开的保存筛选条件栏，支持应用/删除，保存当前筛选条件按钮
- **仓库关注/取消关注**：仓库详情头部添加关注按钮，支持订阅/取消订阅仓库通知
  - API：`repoAddSubscription`/`repoDeleteSubscription`/`repoCheckSubscription`
  - Use Cases：`AddRepoSubscriptionUseCase`/`DeleteRepoSubscriptionUseCase`/`CheckRepoSubscriptionUseCase`
  - Notifier：`checkWatched`/`toggleWatch` 方法，`isWatched`/`watchLoading` 状态
- **国际化翻译补全**：为 de、es、fr、ja、ko、pt、ru、zh_TW 共 8 个区域各补充 117 个缺失键（共 936 条），全部 8 个区域现已与英文模板完全对齐（710 个键）
- **无限滚动分页**：评论、组织仓库、星标仓库、通知、PR 列表每页加载 20 条，底部"加载更多"按钮
- **权限感知 UI**：因期编辑、里程碑编辑、Issue 编辑按钮在无 push/admin 权限时自动隐藏

### Fixed
- 翻译了全部 8 个 ARB 文件中残留的 2,161 条英文占位条目
- Emoji 反应：所有 reaction 为 0 时选择按钮保持可见
- Emoji 反应：乐观本地更新，防止切换时闪烁/整个行消失
- 截止日期设置：使用 UTC ISO8601 格式（Z 后缀）兼容 Gitea Go 后端
- 截止日期清除：改用 PATCH issue 端点代替 POST deadline 端点
- 截止日期：仅静默刷新该数据，不再全页 loading 闪烁
- Issue 详情页：修复缺少 initState 导致的无限加载 Bug
- 时间线：过滤掉 comment 类型事件（已在评论区独立显示）

## [0.30.0] - 2026-05-05

### Added
- **Webhook 编辑**：完整编辑表单（URL、内容类型、事件、启用开关），通过 `CreateWebhookPage` 预填字段实现
  - 仓库层：`editHook` 方法、`EditHookUseCase`、RepoNotifier `editHook()`
- **组织 Webhook CRUD**：列出、创建、编辑、删除组织级 Webhook
  - Use Cases：`ListOrgHooksUseCase`、`CreateOrgHookUseCase`、`EditOrgHookUseCase`、`DeleteOrgHookUseCase`
  - 点击编辑 Webhook，完整表单支持 URL/密钥/内容类型/启用
- **PR 审查增强**：类型化 `PullReview` 模型、审查摘要徽章（通过/需修改计数）
- Release/Issue/PR 标签页：创建按钮现在遵循仓库权限（需 push/admin 权限）
- Release：同时检查 `has_releases` 标志
- Issue：同时检查 `has_issues` 标志
- PR：同时检查 `has_pull_requests` 标志
- **Use case 层**：为 issue 订阅、依赖、时间线、截止日期、评论编辑/删除添加仓库方法和 use case（10 个新 use case）

## [0.29.0] - 2026-05-05

### Added
- 仓库主题管理：通过对话框编辑主题，支持添加/删除标签并批量保存
  - API 层：`repoReplaceTopics`、`repoAddTopic`、`repoDeleteTopic`
  - Use Cases：`ListTopicsUseCase`、`ReplaceTopicsUseCase`、`AddTopicUseCase`、`DeleteTopicUseCase`
  - UI：仓库头部主题编辑按钮，对话框内可添加/删除主题标签
  - i18n：新增 `addTopic` 键
- **管理员：创建系统 Webhook** — 新的 `CreateAdminWebhookPage` 页面，支持 URL/Secret/ContentType/事件选择
  - Use Case：`CreateAdminHookUseCase`，Notifier：`createHook(body)`
  - 管理后台 Webhook 页面新增 FAB 和 AppBar `+` 按钮
- **组织删除** — 组织详情页增加删除按钮，确认后删除并返回
  - Use Case：`DeleteOrgUseCase`，Notifier：`deleteOrg(org)`
  - i18n：`deleteOrganization`、`deleteOrganizationConfirm`、`organizationDeleted`
- **Actions 构件** — 按运行获取类型化构件列表，通过干净架构层下载
  - API：`repoListActionArtifactsByRun` 返回 `ActionArtifactsResponse`
  - Use Cases：`ListActionArtifactsByRunUseCase`、`DownloadActionArtifactUseCase`
  - 页面：改用类型化 `ActionArtifact` 模型代替 raw map
- **仓库迁移** — 从外部服务导入仓库（`MigrateRepoPage`）
  - 克隆地址、服务选择、认证字段、迁移选项
  - Use Case：`MigrateRepoUseCase` + `MigrateRepoParams`
  - 入口：个人资料页"导入仓库"卡片
- **Issue 截止日期快捷编辑** — 在 Issue 详情页直接设置/清除截止日期
  - 编辑按钮打开日期选择器，清除按钮直接移除截止日期
  - 无需跳转到编辑页
- **架构清理** — 为 5 个直接调用 `Injection.apiService` 的功能添加 use case 层
  - 分支保护：`ListBranchProtectionsUseCase` 等 + 类型化 `BranchProtection` 模型
  - 标签保护：`ListTagProtectionsUseCase` 等
  - 邮箱：`ListEmailsUseCase`、`AddEmailUseCase`、`DeleteEmailUseCase`
  - SSH 密钥：`ListCurrentUserKeysUseCase`、`AddKeyUseCase`、`DeleteKeyUseCase`
  - GPG 密钥：`ListGPGKeysUseCase`、`AddGPGKeyUseCase`、`DeleteGPGKeyUseCase`（新增仓库方法）
  - 5 个页面重构，16 个新 use case，7 个测试文件 mock 更新

## [0.28.0] - 2026-05-05

### Added
- Issue 详情：显示截止日期并标注逾期警告
- Issue 依赖：点击依赖项可直接跳转到对应 Issue 详情页
- i18n：新增 "overdue" 翻译键（中英文）
- **个人访问令牌管理**：在设置页面中可列出、创建和删除令牌（`TokensPage`）
  - 创建对话框支持权限范围选择（8 个类别 × 读写）
  - 创建失败时显示具体错误信息

### Changed
- Issue 详情：订阅按钮使用 Material 3 ActionChip 并支持加载状态
- 令牌页面优化：M3 卡片、骨架屏加载、空状态/错误状态样式

### Fixed
- 创建令牌：传入正确的 Gitea 用户名（之前误传了令牌名称）
- 创建令牌：创建后显示完整 sha1 令牌值
- 权限范围：移除了无效 scope（pull_request、gpg_key、public_key）
- 创建对话框：按钮禁用状态正确响应输入变化
- 创建对话框：使用 FocusNode 替代 autofocus 避免 Flutter 键盘断言崩溃

## [0.27.0] - 2026-05-03

### Added
- 管理后台：系统级管理仪表盘
  - 系统 Hooks：列出、查看、删除管理员 Webhook
  - 定时任务：列出计划任务并触发手动执行
  - Action Runners：列出自托管 Runner 并获取注册 Token
  - 邮件记录：浏览管理员邮件日志
  - 用户徽章：管理用户徽章（列出、创建、删除）
- 用户 OAuth2 应用管理（`OAuthAppsPage`）
  - 通过 `GET/POST/DELETE /user/applications/oauth2` 列出、创建、删除 OAuth2 应用
  - 显示客户端 ID、重定向 URI 和创建时间
- 为 17 个页面新增 Widget 测试（共 35 个测试用例，全部通过）
- 组织/仓库 Actions 密钥与变量管理
  - 组织 Actions 密钥：通过 `GET/PUT/DELETE /orgs/{org}/actions/secrets` 列出、创建、删除
  - 组织 Actions 变量：通过 `GET/PUT/DELETE /orgs/{org}/actions/variables` 列出、查看、创建、删除
  - 仓库 Actions 密钥：通过 `GET/PUT/DELETE /repos/{owner}/{repo}/actions/secrets` 列出、创建、删除
  - 仓库 Actions 变量：通过 `GET/PUT/DELETE /repos/{owner}/{repo}/actions/variables` 列出、查看、创建、删除

### Added
- Search 页面新增用户搜索标签页（`_UserSearchResults` / `_SearchUserCard`）
  - `SearchPage` 第三个标签页，与仓库、问题并列
  - 通过 `GET /users/search` 调用，新增 `SearchPublicUsersUseCase`
  - 点击用户可跳转到 `UserProfilePage`
- 用户 GPG 密钥管理（`GpgKeysPage`）
  - 通过 `GET/POST/DELETE /user/gpg_keys` 列出、添加、删除 GPG 密钥
  - 显示密钥 ID、能力（签名/认证）、验证状态
  - 公钥内容在可展开的 `ExpansionTile` 中展示
- 标签保护（`TagProtectionsPage`）
  - 通过 `/repos/{owner}/{repo}/tag_protections` 列出、创建、删除标签保护规则
  - 从 `RepoSettingsPage` 进入
- Issue 时间线与依赖（`_TimelineSection`、`_DependenciesSection`）
  - 时间线：`GET /repos/{owner}/{repo}/issues/{index}/timeline`，按事件类型显示图标
  - 依赖：`GET/POST/DELETE /repos/{owner}/{repo}/issues/{index}/dependencies`
  - 两者均以可展开卡片形式展示在 `IssueDetailPage` 内
- 仓库语言统计条形图（`_LanguageBar`）
  - `GET /repos/{owner}/{repo}/languages` 渲染为彩色分段条 + 百分比图例
  - 展示前 6 种语言，未知语言使用哈希 fallback 颜色
- 仓库星标用户与订阅者（`RepoStargazersPage`）
  - 双标签页页面，分别列出星标用户（`/stargazers`）和订阅者（`/subscribers`）
  - `RepoDetailPage` 头部的统计卡片可点击跳转
- 新增 `OrganizationsListPage`：组织列表全屏页面
  - 每个列表项显示头像、组织名称和简介
  - 使用 `PremiumCard` 和 `FadeInWrapper` 动画
  - 点击可跳转到 `OrganizationDetailPage`
- Issue 详情页订阅/取消订阅切换
  - `ActionChip` 根据当前订阅状态显示「订阅」或「取消订阅」
  - 通过 `GET /repos/{owner}/{repo}/issues/{index}/subscriptions/check` 获取状态
  - 切换使用 `PUT /subscriptions/{user}`（订阅）或 `DELETE /subscriptions/{user}`（取消订阅）
- `app.dart` 中添加 Deep Link 路由
  - `/explore` → SearchPage、`/notifications` → NotificationPage、`/settings` → SettingsPage、`/stars` → StarredReposPage
  - `/org/{org}` → OrganizationDetailPage、`/user/{username}` → UserProfilePage
  - Android：`igitea://` scheme intent filter；iOS：`CFBundleURLTypes` 自定义 URL scheme
  - 保留现有仓库/Issue/PR 路由（`/{owner}/{repo}`、`/{owner}/{repo}/issues/{n}`）
- 错误边界：`main.dart` 中通过 `ErrorWidget.builder` 设置自定义错误 UI
  - 替代默认的红屏错误，显示友好的提示信息
- API 客户端改进（`api_client.dart`）
  - GET 请求失败时自动重试（最多 2 次，递进延迟）
  - 内存响应缓存，支持可配置 TTL（`getCachedBody` / `setCached`）
  - `clearCache()` 支持缓存失效
- 从设置 → 管理后台进入（仅管理员）
- 从设置 → OAuth 应用进入
- 从组织详情页（工具栏图标）和仓库设置页进入
- 全部使用 `buildTestableWidget()` 包装，支持国际化
- 通知导航：点击通知可跳转到相关页面
  - Issue 通知 → IssueDetailPage
  - PR 通知 → PRDetailPage
  - Commit 通知 → CommitDetailPage
  - 仓库通知 → RepoDetailPage
  - 用户关注通知 → UserProfilePage
  - 点击时自动标记为已读
- 仪表盘活动动态：点击动态可跳转到对应的详情页面
  - Issue 动态 → IssueDetailPage
  - PR 动态 → PRDetailPage
  - 仓库动态 → RepoDetailPage
  - 用户关注事件 → UserProfilePage
  - 内容解析改进（支持纯数字和 "issue #3" 格式）

### Fixed
- NotifySubjectType 类型转换错误（String → Map）in notificationsubject.dart
- IssueFormFieldType / IssueFormFieldVisible 类型转换错误 in issueformfield.dart
- 代码生成器：添加 NotifySubjectType、IssueFormFieldType、IssueFormFieldVisible 到字符串类型白名单
- Issue 列表：filter 顺序改为 open → closed → all；"all" 现在发送 `state=all` 而非 null（原本默认为 open）

### Changed
- 管理后台子项直接移至设置页，移除了中间的管理后台仪表盘页面
- 替换内联 CronTasksPage 为已有 AdminCronPage（移除重复）
- 重构 `UserProfilePage` 视觉风格，与 `ProfilePage` 保持一致
  - 渐变背景 Header：大头像、用户名、@username、个人描述、管理员标识
  - 统计卡片使用 `PremiumCard`，排版统一
  - 信息卡片（邮箱、位置、网站、注册时间）聚合在 `PremiumCard` 中，使用 `_InfoTile`
  - 组织列表支持水平滚动、逐入动画（`FadeInWrapper`）和悬停提示
  - 仓库列表使用 `PremiumCard`，点击可跳转到 `RepoDetailPage`
  - 新增 `location` 字段显示
  - 邮箱和网站支持点击打开（邮件客户端 / 浏览器）
- Follow 按钮移入 `_UserHeader`，放在 `@username` 右侧
  - 紧凑的胶囊形状按钮（高度 28，圆角 100）
  - Follow 状态使用 `FilledButton`，Unfollow 状态使用 `OutlinedButton`
  - Loading 状态使用小型 `CircularProgressIndicator`
- `ProfilePage` 和 `UserProfilePage` 的组织区块标题支持点击（带右箭头指示器）
  - 点击可跳转到 `OrganizationsListPage`

## [0.26.0] - 2026-05-02

### Added
- Team CRUD：创建/编辑/删除团队，添加/移除团队成员（用户搜索对话框）
- 仓库协作者管理：查看/添加/移除协作者（用户搜索）
- 分支保护管理：查看/创建/删除分支保护规则
- 组织 Webhook 管理：查看/创建/删除组织级 Webhook
- Issue 列表新增标签显示（彩色芯片）
- 发布工作流新增 Windows MSIX 安装包

### Fixed
- Issue 详情页里程碑编辑器无限加载
- 标签文字因缺失透明度通道导致不可见
- 里程碑下拉框因并发状态写入导致无限加载

## [0.25.0] - 2026-05-02

### Added
- 软件包管理：按类型筛选浏览包列表，包详情（版本信息、文件列表），删除包版本
- 个人页新增软件包入口
- Release CRUD：创建/编辑/删除 Release，分支下拉选择，标签名（手动输入或选择已有），草稿/预发布开关
- 包详情页新增版本列表，支持分页和版本切换
- 创建/编辑标签时新增常用标签快速选择（bug、enhancement、documentation 等）
- 标签模板集：从预定义模板一键创建所有标签
- 创建/编辑标签页面新增 7 个 i18n 翻译键

### Fixed
- 包列表按名称去重
- 包 URL 使用正确的 Gitea Web UI 格式
- 修复从组织和团队详情页返回时的 ScrollController 断言错误
- 修复通知页面因类型转换导致的崩溃（API 返回的 `NotificationSubject.type` 是字符串而非对象）

## [0.24.0] - 2026-05-02

### 新增
- 仓库 Issue 列表页面添加「创建 Issue」浮动按钮
- Issue 列表项显示开启人、相对时间、评论数
- 仓库 Issue 列表加入 Open/Closed/All 筛选栏，支持下拉刷新
- 仓库 PR 列表页面添加「创建 PR」浮动按钮
- 仓库 PR 列表加入 Open/Closed/All 筛选栏，支持下拉刷新
- PR 列表项显示开启人、相对时间、评论数

### 修复
- 里程碑编辑：修正 `due_on` 日期格式（添加时区偏移），解决服务器解析错误
- 查看/编辑 Issue 返回后自动刷新列表数据
- macOS DMG：修正应用名称为 `igitea.app`（原为不存在的 `Runner.app`）
- macOS：添加 ad-hoc 签名，减少 Gatekeeper 弹窗
- Linux AppImage：使用已有的 Android launcher 图标替代缺失的 `assets/icon.png`
- Linux AppImage：设置 `APPIMAGE_EXTRACT_AND_RUN=1` 适配无 FUSE 的 CI 环境
- Issue 评论气泡：移除最小宽度限制，短评论不再过宽
- Issue 评论气泡：菜单按钮改为覆盖层，减少气泡高度
- 发布工作流：从已归档的 `subosito/flutter-action` 迁移至 `flutter-actions/setup-flutter@v4`

## [0.23.2] - 2026-05-01

### 新增 — GitHub Release Workflow

- `.github/workflows/release.yml`：推送 `v*` 标签自动构建 Android（APK+AAB）、iOS（IPA）、macOS（DMG）、Linux（AppImage）、Windows（ZIP）
- 所有构建产物自动上传至 GitHub Release

## [0.23.1] - 2026-05-01

### 修复

- 中文翻译：补齐 400+ 个 key 的中文翻译
- `igiteaVersion` 从 ARB 迁移为 Dart 常量

## [0.23.0] - 2026-05-01

### 新增 — 里程碑 CRUD

- `CreateMilestonePage`：创建里程碑页面
  - 标题输入（必填验证）
  - 描述输入（Markdown，多行）
  - 日期选择器设置截止日期
  - AppBar 保存按钮带加载指示器
- `EditMilestonePage`：编辑里程碑页面
  - 预填现有数据（标题、描述、截止日期）
  - 支持清除截止日期
  - 保存成功自动刷新列表
- `MilestoneDetailPage` 增强：
  - AppBar 添加编辑和删除按钮
  - 删除前显示确认对话框
  - 编辑后返回自动刷新
- `_MilestonesTab` 增强：
  - 添加浮动操作按钮（FAB）用于新建里程碑
  - 空状态显示时仍可创建
  - 创建/编辑后自动刷新
- 新增 UseCases：`GetMilestoneUseCase`、`EditMilestoneUseCase`、`DeleteMilestoneUseCase`
- 新增 ARB 键：`createMilestone`、`editMilestone`、`deleteMilestone`、`deleteMilestoneConfirm`、`milestoneDeleted`、`milestoneTitle`、`milestoneDescription`、`milestoneDueDate` 等
- 更新 `Injection` 类：三个初始化路径均添加里程碑 CRUD use cases
- 更新 `IssueNotifier`：新增 `createMilestone`、`editMilestone`、`deleteMilestone` 方法

### 新增 — Wiki 完整支持

- `WikiEditPage`：创建和编辑 Wiki 页面
  - 标题输入框（创建时必填，编辑时只读）
  - Markdown 内容编辑器，支持实时预览切换
  - 可选的提交消息输入
  - 表单验证：标题不能为空
  - AppBar 保存按钮带加载指示器
- `WikiListPage` 重构：
  - 添加浮动操作按钮（FAB）用于创建新页面
  - 使用 `EmptyState` 组件替代内联空状态
  - 支持国际化（l10n）
  - 点击页面后返回自动刷新列表
- `WikiDetailPage` 增强：
  - AppBar 添加编辑和删除按钮
  - 删除前显示确认对话框
  - 支持 Markdown 内容选择
  - 使用 `Either` 模式替代 try-catch
- 新增 UseCases：`GetWikiPageUseCase`、`ListWikiPagesUseCase`、`CreateWikiPageUseCase`、`EditWikiPageUseCase`、`DeleteWikiPageUseCase`
- 新增 Repository 方法：`getWikiPage`、`listWikiPages`、`createWikiPage`、`editWikiPage`、`deleteWikiPage`
- 新增 ARB 键：`wiki`、`newWikiPage`、`editWikiPage`、`deleteWikiPage`、`deleteWikiPageConfirm`、`wikiPageDeleted`、`wikiPageTitle`、`wikiPageContent`、`noWikiPages`、`createFirstWikiPage`、`lastCommit`、`commitMessage`、`saved`、`created` 等
- 更新 `Injection` 类：三个初始化路径均添加 Wiki use cases
- 更新 `RepoNotifier`：添加 Wiki 相关字段和方法

### 修复

- 修复 `RepoDetailPage` 中未显示 Wiki 入口的问题：在仓库区块列表中添加 Wiki 选项（`id: 'wiki'`），并在 `_RepoSectionPage` 中处理 Wiki 导航到 `WikiListPage`
- 修复 Wiki 页面双层返回按钮：Wiki 绕过 `_RepoSectionPage` 直接导航
- 修复 Issue 编辑页标签闪烁消失：`IssueNotifier._state` 被 `listLabels`/`listMilestones` 互相覆盖，改为本地缓存
- 修复 Issue 标签保存不生效：Gitea API 标签需通过 `PUT /issues/{index}/labels` 独立端点管理，`EditIssueOption` 不支持 `labels` 字段
- 修复 Issue 创建/编辑时标签数据格式：API 期望 label ID（int）而非 label 名称（String）
- 修复 Commit 详情页 Changed files 窗口缩放时右侧溢出：diff 行用 `SingleChildScrollView(horizontal)` 包裹

### 新增 — Webhook 管理

- `WebhookListPage`：仓库 Webhook 列表，FAB 新建，下拉刷新，空状态处理
- `WebhookDetailPage`：查看配置（URL、Content-Type）、事件列表、状态，支持删除
- `CreateWebhookPage`：创建表单（URL、Secret、Content-Type、事件多选、Active 开关）
- 新增 UseCases：`ListHooksUseCase`、`CreateHookUseCase`、`DeleteHookUseCase`
- 更新 `RepoNotifier`：新增 Hook 相关方法

### 新增 — 标签管理

- `LabelListPage`：仓库标签列表，带颜色圆点指示器
- `CreateLabelPage`：创建标签（名称、描述、预设色板选择器）
- `EditLabelPage`：编辑标签 + 删除按钮 + 确认对话框
- `IssueNotifier`：新增 `createLabel`、`editLabel`、`deleteLabel` 方法
- 新增 UseCases：`EditLabelUseCase`、`DeleteLabelUseCase`
- 仓库区块列表新增 Labels 入口

### 新增 — OAuth2 登录

- 登录页新增 OAuth2 标签页（第三个标签）
- 流程：填写 Client ID/Secret → 浏览器授权 → 粘贴 Code → 交换 Token → 自动登录
- `AuthMethod.oauth2` + `refreshToken` 支持
- `AuthStorage` 新增 refresh token 持久化
- 新增 `postRaw` API 方法用于 `/login/oauth/access_token` 端点

### 新增 — Issue 创建/编辑增强

- `CreateIssuePage`：新增标签多选（FilterChip 带颜色指示）+ 里程碑下拉选择
- `EditIssuePage`：标签/里程碑选择同样增强，FilterChip 显示标签颜色
- 创建/编辑请求支持 `labels`（ID 列表）和 `milestone` 字段

### 新增 — PR Diff 查看器

- `DiffParser`：统一 diff 格式解析器（DiffFile → DiffHunk → DiffLine）
- `PrDiffViewerPage`：文件级导航、@@ hunk 头部、行级新增（绿）/删除（红）着色、行号栏
- Unified/Split 视图模式切换
- `PrFilesPage` 新增"View Diff"按钮 + 文件项点击进入 diff 查看器

### 新增 — 文件历史与对比

- `FileHistoryPage`：文件提交历史列表，关联 CommitDetailPage
- `FileComparePage`：Base/Head ref 输入 → diff 渲染
- `FileBlamePage`：利用 blame API 逐行显示 commit SHA + 作者头像 + 行号 + 代码
- 文件查看器 AppBar 新增 `⋯` 菜单（History / Compare / Blame）
- `listCommits` 全线支持 `path` 参数过滤

### 新增 — Commit 内联 Diff

- `commit_detail_page.dart`：changed files 可展开显示内联 diff
- 新增 `repoGetCommitDiff` API → `GET /git/commits/{sha}.diff`
- 文件头部显示 `+n -m` 增减统计，点击展开/收起

### 新增 — CI/CD Actions 集成

- `ActionsListPage` 增强：
  - 按 workflow 文件分组显示运行列表
  - 状态筛选器（All / success / failure / in_progress / queued / cancelled / skipped）
  - 参与者（actor）筛选器
  - 无限滚动分页，滚动到底部自动加载更多
  - 退出页面后返回保持状态（`AutomaticKeepAliveClientMixin`）
  - `repoListActionWorkflows` 获取 workflow 列表
  - Job 日志自动轮询刷新（每 5 秒）
  - 构建产物下载：artifact 项增加下载按钮，保存到应用文档目录

### 新增 — PR 代码审查

- PR 详情页 AppBar 新增 Review 按钮（Comment / Approve / Request Changes）
- 审查列表：状态徽章、作者、正文、时间戳
- 新增 `repoCreatePullReviewRequests`：PR 审查请求对话框，支持添加审查者

### 新增 — Webhook 编辑

- Webhook 详情页 AppBar 新增编辑按钮，对话框更新 URL

### 新增 — Issue/PR 评论编辑与删除

- 评论气泡右上角 `⋯` 菜单：编辑（内联 TextField + Save/Cancel）/ 删除（确认对话框）
- 依赖 `issueEditComment` / `issueDeleteComment` API

### 新增 — Issue 订阅与截止日期

- Issue 详情页新增订阅按钮（ActionChip）
- Issue 编辑页新增截止日期选择器（日期选择 + 清除）

### 新增 — 仓库主题标签

- 仓库头部显示 topics 标签（Chip 列表）

### 新增 — 分支保护

- 仓库设置页新增"分支保护"按钮，一键保护默认分支

### 新增 — 活跃度翻译完善

- 补齐所有 26 种 `op_type` 的翻译键
- 修复 `comment_pull_request` → `comment_pull` 不匹配 bug
- 新增事件：commit_repo、rename_repo、star_repo、watch_repo、approve PR、reject PR 等

### 变更

- 文件查看器 AppBar 重构：原 History 按钮移入 `⋯` 菜单
- `UIConstants` 替换所有硬编码间距（16→`md`、8→`sm`、4→`xs`）
- `home_page.dart`：移除无用 `_TabData` 类，抽离 `_buildNavigationRail`/`_buildNavigationBar`
- `ListCommitsParams` 新增 `path` 参数
- `state?.value == 'open'` 字符串比较 → `state?.isOpen` 枚举扩展
- Injection 三条路径新增 `_assertUseCasesInitialized()` 安全断言

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