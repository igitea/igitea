// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'iGitea';

  @override
  String get language => '语言';

  @override
  String get settings => '设置';

  @override
  String get profile => '个人资料';

  @override
  String get search => '搜索';

  @override
  String get notifications => '通知';

  @override
  String get dashboard => '仪表盘';

  @override
  String get signOut => '退出登录';

  @override
  String get signIn => '登录';

  @override
  String get username => '用户名';

  @override
  String get password => '密码';

  @override
  String get login => '登录';

  @override
  String get loginWithToken => '使用令牌登录';

  @override
  String get token => '令牌';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get edit => '编辑';

  @override
  String get create => '创建';

  @override
  String get close => '关闭';

  @override
  String get reopen => '重新打开';

  @override
  String get merge => '合并';

  @override
  String get submit => '提交';

  @override
  String get retry => '重试';

  @override
  String get loading => '加载中...';

  @override
  String get error => '错误';

  @override
  String get noData => '暂无数据';

  @override
  String get searchRepos => '搜索仓库';

  @override
  String get searchIssues => '搜索问题';

  @override
  String get noResults => '未找到结果';

  @override
  String get repositories => '仓库';

  @override
  String get repositorySections => 'Repository Sections';

  @override
  String get issues => '问题';

  @override
  String get pullRequests => '拉取请求';

  @override
  String get releases => '发布';

  @override
  String get branches => '分支';

  @override
  String get code => '代码';

  @override
  String get stars => '星标';

  @override
  String get forks => '分叉';

  @override
  String get watchers => '关注者';

  @override
  String get open => '打开';

  @override
  String get closed => '已关闭';

  @override
  String get all => '全部';

  @override
  String get mergePullRequest => '合并拉取请求';

  @override
  String get mergeConfirmMessage => '确定要合并此拉取请求吗？';

  @override
  String issueNumber(Object issueNumber) {
    return '问题 #$issueNumber';
  }

  @override
  String pullRequestNumber(Object pullRequestNumber) {
    return 'PR #$pullRequestNumber';
  }

  @override
  String get comments => '评论';

  @override
  String get addComment => '添加评论...';

  @override
  String get sendComment => '发送';

  @override
  String get noComments => '暂无评论';

  @override
  String get labels => '标签';

  @override
  String get milestones => '里程碑';

  @override
  String get assignees => '指派人';

  @override
  String get assignee => 'Assignee';

  @override
  String get participants => '参与者';

  @override
  String get timeline => '时间线';

  @override
  String get theme => '主题';

  @override
  String get themeLight => '浅色';

  @override
  String get themeDark => '深色';

  @override
  String get themeSystem => '跟随系统';

  @override
  String get account => '账户';

  @override
  String get accountInfo => '账户信息';

  @override
  String get email => '邮箱';

  @override
  String get website => '网站';

  @override
  String get bio => '简介';

  @override
  String joinedOn(Object date) {
    return '加入于 $date';
  }

  @override
  String joinedOnParams(Object date) {
    return '加入于 $date';
  }

  @override
  String followerCount(Object count) {
    return '$count 粉丝';
  }

  @override
  String followerCountParams(Object count) {
    return '$count 粉丝';
  }

  @override
  String followingCount(Object count) {
    return '$count 关注';
  }

  @override
  String followingCountParams(Object count) {
    return '$count 关注';
  }

  @override
  String repositoryCount(Object count) {
    return '$count 个仓库';
  }

  @override
  String repositoryCountParams(Object count) {
    return '$count 个仓库';
  }

  @override
  String get starredRepos => '星标仓库';

  @override
  String get organisations => '组织';

  @override
  String get adminPanel => '管理面板';

  @override
  String get userManagement => '用户管理';

  @override
  String get serverSettings => '服务器设置';

  @override
  String get cronTasks => '定时任务';

  @override
  String get apiSettings => 'API 设置';

  @override
  String get uiSettings => '界面设置';

  @override
  String get attachmentSettings => '附件设置';

  @override
  String get repoSettings => '仓库设置';

  @override
  String get runNow => '立即运行';

  @override
  String lastRun(Object time) {
    return '上次运行：$time';
  }

  @override
  String lastRunParams(Object time) {
    return '上次运行：$time';
  }

  @override
  String nextRun(Object time) {
    return '下次运行：$time';
  }

  @override
  String nextRunParams(Object time) {
    return '下次运行：$time';
  }

  @override
  String get recentActivity => '最近活动';

  @override
  String get myIssues => '我的 Issue';

  @override
  String get myRepos => '我的仓库';

  @override
  String get myStars => '我的星标';

  @override
  String get feed => '动态';

  @override
  String get markAllRead => '全部标记为已读';

  @override
  String get markRead => '标记为已读';

  @override
  String unreadNotifications(Object count) {
    return '未读通知：$count';
  }

  @override
  String unreadNotificationsParams(Object count) {
    return '未读通知：$count';
  }

  @override
  String get noUnreadNotifications => '没有未读通知';

  @override
  String get readMore => '阅读更多';

  @override
  String ago(Object time) {
    return '$time前';
  }

  @override
  String agoParams(Object time) {
    return '$time前';
  }

  @override
  String get fileBrowser => '文件浏览器';

  @override
  String get readme => '说明文档';

  @override
  String get commits => '提交';

  @override
  String get commitHistory => '提交历史';

  @override
  String get viewFile => '查看文件';

  @override
  String get downloadFile => '下载文件';

  @override
  String get copyPath => '复制路径';

  @override
  String get fileName => '文件名';

  @override
  String get fileSize => '文件大小';

  @override
  String get lastModified => '最后修改';

  @override
  String get openInBrowser => '在浏览器中打开';

  @override
  String get signInRequired => '需要登录';

  @override
  String get signInMessage => '请登录以继续';

  @override
  String get loginFailed => '登录失败';

  @override
  String get networkError => '网络错误';

  @override
  String get unknownError => '发生未知错误';

  @override
  String get refresh => '刷新';

  @override
  String get copyToClipboard => '复制到剪贴板';

  @override
  String get copied => '已复制！';

  @override
  String get filterIssues => '筛选问题';

  @override
  String get newIssue => '新建问题';

  @override
  String get newPullRequest => '新建拉取请求';

  @override
  String get title => '标题';

  @override
  String get description => '描述';

  @override
  String get body => '正文';

  @override
  String get state => '状态';

  @override
  String get priority => '优先级';

  @override
  String get milestone => '里程碑';

  @override
  String get createdAt => '创建于';

  @override
  String get updatedAt => '更新于';

  @override
  String get dueDate => '截止日期';

  @override
  String get noMilestones => '暂无里程碑';

  @override
  String get noLabels => '暂无标签';

  @override
  String get openIssue => '打开问题';

  @override
  String get closeIssue => '关闭问题';

  @override
  String get reopenIssue => '重新打开问题';

  @override
  String get deleteComment => '删除评论';

  @override
  String get editComment => '编辑评论';

  @override
  String get deleteRepo => '删除仓库';

  @override
  String get deleteRepoConfirm => '确定要删除此仓库吗？此操作不可撤销。';

  @override
  String get generalSettings => '通用设置';

  @override
  String get appearance => '外观';

  @override
  String get languageSelector => '语言';

  @override
  String get selectLanguage => '选择语言';

  @override
  String get systemDefault => '系统默认';

  @override
  String get followSystem => '跟随系统';

  @override
  String get unsavedChanges => '未保存的更改';

  @override
  String get unsavedChangesMessage => '您有未保存的更改。确定要离开吗？';

  @override
  String get leave => '离开';

  @override
  String get stay => '留下';

  @override
  String get restoringSession => 'Restoring session...';

  @override
  String get pleaseEnterServerUrl => '请输入服务器地址';

  @override
  String get pleaseEnterValidUrl => '请输入有效的 URL';

  @override
  String get connectToGitea => '连接到你的 Gitea 实例';

  @override
  String get usernamePassword => '用户名和密码';

  @override
  String get serverUrl => '服务器地址';

  @override
  String get enterUsername => '输入用户名';

  @override
  String get pleaseEnterUsername => '请输入用户名';

  @override
  String get enterPassword => '输入密码';

  @override
  String get pleaseEnterPassword => '请输入密码';

  @override
  String get pasteAccessToken => '粘贴你的访问令牌';

  @override
  String get pleaseEnterAccessToken => '请输入访问令牌';

  @override
  String get signInWithToken => '使用 Token 登录';

  @override
  String get welcomeToIgitea => '欢迎使用 iGitea';

  @override
  String get signInToGetStarted => '登录以开始使用';

  @override
  String get quickActions => '快捷操作';

  @override
  String get yourRepositories => '我的仓库';

  @override
  String get noRepositoriesFound => '未找到仓库';

  @override
  String helloParams(Object full_name) {
    return 'Hello, $full_name!';
  }

  @override
  String get user => 'User';

  @override
  String get private => '私有';

  @override
  String get untitled => 'Untitled';

  @override
  String get enterSearchQueryRepos => '输入搜索关键词查找仓库';

  @override
  String get enterSearchQueryIssues => 'Enter a search query to find issues';

  @override
  String get noIssuesFound => 'No issues found.';

  @override
  String get failedToLoadProfile => 'Failed to load profile';

  @override
  String get unknownUser => 'Unknown User';

  @override
  String get admin => 'Admin';

  @override
  String get repos => '仓库';

  @override
  String get followers => '关注者';

  @override
  String get following => '正在关注';

  @override
  String get signOutConfirmMessage => 'Are you sure you want to sign out?';

  @override
  String get chooseTheme => 'Choose Theme';

  @override
  String get loadingSettings => 'Loading settings...';

  @override
  String get userManagementComingSoon => 'User management coming soon';

  @override
  String get maxResponseItems => 'Max Response Items';

  @override
  String get defaultPagingNum => 'Default Paging Num';

  @override
  String get defaultMaxBlobSize => 'Default Max Blob Size';

  @override
  String get defaultTheme => 'Default Theme';

  @override
  String get allowedReactions => 'Allowed Reactions';

  @override
  String get attachments => 'Attachments';

  @override
  String get enabled => 'Enabled';

  @override
  String get maxFiles => 'Max Files';

  @override
  String get maxSize => 'Max Size';

  @override
  String get allowedTypes => 'Allowed Types';

  @override
  String get bytes => 'bytes';

  @override
  String get repository => '仓库';

  @override
  String get httpGitDisabled => 'HTTP Git Disabled';

  @override
  String get lfsDisabled => 'LFS Disabled';

  @override
  String get migrationsDisabled => 'Migrations Disabled';

  @override
  String get mirrorsDisabled => 'Mirrors Disabled';

  @override
  String get starsDisabled => 'Stars Disabled';

  @override
  String get timeTrackingDisabled => 'Time Tracking Disabled';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get schedule => 'Schedule';

  @override
  String get next => 'Next';

  @override
  String get executions => 'Executions';

  @override
  String get failedToLoadCronTasks => 'Failed to load cron tasks';

  @override
  String get noCronTasksFound => 'No cron tasks found';

  @override
  String cronTriggeredParams(Object name) {
    return 'Cron \"$name\" triggered';
  }

  @override
  String get unknown => '未知';

  @override
  String openedParams(Object time) {
    return 'opened $time';
  }

  @override
  String get noDescriptionProvided => '未提供描述';

  @override
  String get failedToLoadComments => 'Failed to load comments';

  @override
  String get writeComment => '写评论';

  @override
  String commentsCountParams(Object count) {
    return '$count comments';
  }

  @override
  String updatedParams(Object time) {
    return 'Updated $time';
  }

  @override
  String commentsParams(Object count) {
    return 'Comments ($count)';
  }

  @override
  String get files => 'files';

  @override
  String get mergeable => 'Mergeable';

  @override
  String get merged => 'Merged';

  @override
  String get draft => 'Draft';

  @override
  String get failedToLoadRepo => 'Failed to load repository';

  @override
  String get copyUrl => 'Copy URL';

  @override
  String get urlCopied => 'URL copied';

  @override
  String get emptyDirectory => 'Empty directory';

  @override
  String get noIssues => '暂无 Issue';

  @override
  String get noPullRequests => 'No pull requests';

  @override
  String get noReleases => 'No releases';

  @override
  String get noBranches => 'No branches';

  @override
  String get preRelease => 'Pre-release';

  @override
  String get archived => '已归档';

  @override
  String get defaultBranch => '默认分支';

  @override
  String get copyCode => 'Copy code';

  @override
  String get failedToLoadFile => 'Failed to load file';

  @override
  String get filePreviewNotAvailable => 'File preview not available';

  @override
  String get download => 'Download';

  @override
  String get failedToOpenDownloadUrl => 'Failed to open download URL';

  @override
  String get noNotifications => '暂无通知';

  @override
  String get noTitle => 'No title';

  @override
  String get allNotificationsMarkedAsRead => 'All notifications marked as read';

  @override
  String get createUser => '创建用户';

  @override
  String get editUser => '编辑用户';

  @override
  String get deleteUser => '删除用户';

  @override
  String deleteUserConfirmParams(Object username) {
    return '确定要删除用户\"$username\"吗？此操作无法撤销。';
  }

  @override
  String get userCreated => '用户创建成功';

  @override
  String get userUpdated => '用户更新成功';

  @override
  String get userDeleted => '用户删除成功';

  @override
  String get noUsersFound => '未找到用户';

  @override
  String get pleaseEnterEmail => '请输入邮箱';

  @override
  String get fullName => '全名';

  @override
  String get mustChangePassword => '首次登录必须修改密码';

  @override
  String get pleaseEnterTitle => '请输入标题';

  @override
  String get noActivity => '暂无活动';

  @override
  String get createdRepo => '创建了仓库';

  @override
  String get pushedTag => '推送了标签';

  @override
  String get deletedTag => '删除了标签';

  @override
  String get createdIssue => '创建了问题';

  @override
  String get closedIssue => '关闭了问题';

  @override
  String get reopenedIssue => '重新打开了问题';

  @override
  String get createdPR => '创建了拉取请求';

  @override
  String get mergedPR => '合并了拉取请求';

  @override
  String get closedPR => '关闭了拉取请求';

  @override
  String get commentedOnIssue => '评论了问题';

  @override
  String get commentedOnPR => '评论了拉取请求';

  @override
  String get forkedRepo => '分叉了仓库';

  @override
  String get transferredRepo => '转移了仓库';

  @override
  String get deletedRepo => '删除了仓库';

  @override
  String get updatedWiki => '更新了 Wiki';

  @override
  String get performedAction => '执行了操作';

  @override
  String get commitRepo => '提交了代码到';

  @override
  String get renameRepo => '重命名了仓库';

  @override
  String get starRepo => '收藏了仓库';

  @override
  String get watchRepo => '关注了仓库';

  @override
  String get reopenPR => '重新打开了 PR';

  @override
  String get approvePR => '批准了 PR';

  @override
  String get rejectPR => '驳回了 PR';

  @override
  String get publishRelease => '发布了版本';

  @override
  String get deleteBranch => '删除了分支';

  @override
  String get autoMergePR => '自动合并了 PR';

  @override
  String get pullReviewDismissed => '驳回了审查';

  @override
  String get pullRequestReady => '标记 PR 为就绪';

  @override
  String get mirrorSyncPush => '同步推送了镜像';

  @override
  String get mirrorSyncCreate => '同步创建了镜像';

  @override
  String get mirrorSyncDelete => '同步删除了镜像';

  @override
  String get inRepo => '在';

  @override
  String get to => '到';

  @override
  String get from => '从';

  @override
  String get headBranch => '源分支';

  @override
  String get baseBranch => '目标分支';

  @override
  String get pleaseFillAllFields => '请填写所有必填字段';

  @override
  String get settingsSaved => '设置已保存';

  @override
  String get privateRepo => '私有仓库';

  @override
  String get privateRepoDesc => '仅对你和协作者可见';

  @override
  String get enableIssues => '启用 Issues';

  @override
  String get enablePullRequests => '启用 Pull Requests';

  @override
  String get enableWiki => '启用 Wiki';

  @override
  String get preview => 'Preview';

  @override
  String get commitMessage => 'Commit Message';

  @override
  String get commit => 'Commit';

  @override
  String get commitMessageHint => 'Describe your changes (optional)';

  @override
  String get cannotGetFileSha => 'Cannot get file SHA. Please reload the file.';

  @override
  String get failedToSaveFile => 'Failed to save file';

  @override
  String get fileSaved => 'File saved successfully';

  @override
  String get discard => 'Discard';

  @override
  String get message => 'Message';

  @override
  String get ok => 'OK';

  @override
  String get sha => 'SHA';

  @override
  String get changedFiles => 'Changed Files';

  @override
  String get tags => '标签';

  @override
  String get noCommits => '暂无提交';

  @override
  String get noTags => 'No tags';

  @override
  String get protected => 'Protected';

  @override
  String get latestCommit => 'Latest Commit';

  @override
  String get permissions => 'Permissions';

  @override
  String get canPush => 'Can Push';

  @override
  String get canMerge => 'Can Merge';

  @override
  String get downloads => 'Downloads';

  @override
  String get tarball => 'Tarball';

  @override
  String get zipball => 'Zipball';

  @override
  String get downloadTarball => 'Download Tarball';

  @override
  String get downloadZipball => 'Download Zipball';

  @override
  String get url => '链接';

  @override
  String get info => '信息';

  @override
  String get teams => '团队';

  @override
  String get noTeams => '暂无团队';

  @override
  String get location => '位置';

  @override
  String get visibility => '可见性';

  @override
  String get assets => '资源';

  @override
  String get publishedAt => '发布时间';

  @override
  String get target => '目标';

  @override
  String get forked => '已分叉';

  @override
  String get forkRepoConfirm => '这将为您创建一个此仓库的分叉。';

  @override
  String get editIssue => '编辑 Issue';

  @override
  String get titleRequired => '标题不能为空';

  @override
  String get selectMilestone => '选择里程碑';

  @override
  String get members => '成员';

  @override
  String get noMembers => '暂无成员';

  @override
  String get editOrganization => '编辑组织';

  @override
  String get createOrganization => '创建组织';

  @override
  String get createRepository => '创建仓库';

  @override
  String get repositoryName => '仓库名称';

  @override
  String get repositoryNameHint => 'my-awesome-repo';

  @override
  String get repositoryNameRequired => '仓库名称为必填项';

  @override
  String get descriptionHint => '仓库的简短描述';

  @override
  String get public => '公开';

  @override
  String get publicDescription => '任何人都可以看到此仓库';

  @override
  String get privateDescription => '你可以选择谁可以看到并提交到此仓库';

  @override
  String get initializeWithReadme => '使用 README 初始化';

  @override
  String get initializeWithReadmeDescription => '添加 README 文件帮助他人了解你的项目';

  @override
  String repoCreated(Object repoName) {
    return '仓库 \'$repoName\' 创建成功';
  }

  @override
  String get complete => '完成';

  @override
  String get wiki => 'Wiki';

  @override
  String get newWikiPage => 'New Wiki Page';

  @override
  String get editWikiPage => 'Edit Wiki Page';

  @override
  String get deleteWikiPage => 'Delete Wiki Page';

  @override
  String get deleteWikiPageConfirm =>
      'Are you sure you want to delete this wiki page? This action cannot be undone.';

  @override
  String get wikiPageDeleted => 'Wiki page deleted';

  @override
  String get wikiPageTitle => 'Page Title';

  @override
  String get wikiPageTitleHint => 'e.g. Home';

  @override
  String get wikiPageContent => 'Content';

  @override
  String get wikiPageContentHint => 'Write in Markdown...';

  @override
  String get noWikiPages => '暂无 Wiki 页面';

  @override
  String get noWikiPagesDescription =>
      'This repository doesn\'t have any wiki pages yet.';

  @override
  String get createFirstWikiPage => 'Create First Page';

  @override
  String get lastCommit => 'Last commit';

  @override
  String get noContent => '无内容';

  @override
  String get saved => 'Saved';

  @override
  String get created => 'Created';

  @override
  String get createMilestone => 'Create Milestone';

  @override
  String get editMilestone => 'Edit Milestone';

  @override
  String get deleteMilestone => 'Delete Milestone';

  @override
  String get deleteMilestoneConfirm =>
      'Are you sure you want to delete this milestone? This action cannot be undone.';

  @override
  String get milestoneDeleted => 'Milestone deleted';

  @override
  String get milestoneTitle => 'Title';

  @override
  String get milestoneDescription => 'Description';

  @override
  String get milestoneDescriptionHint => 'Describe this milestone';

  @override
  String get milestoneDueDate => 'Due Date';

  @override
  String get milestoneState => 'State';

  @override
  String get milestoneStateOpen => 'Open';

  @override
  String get milestoneStateClosed => 'Closed';

  @override
  String get total => 'Total';

  @override
  String get clear => 'Clear';

  @override
  String get webhooks => 'Webhooks';

  @override
  String get webhook => 'Webhook';

  @override
  String get noWebhooks => '暂无 Webhook';

  @override
  String get createWebhook => 'Create Webhook';

  @override
  String get editWebhook => 'Edit Webhook';

  @override
  String get deleteWebhook => 'Delete Webhook';

  @override
  String get deleteWebhookConfirm =>
      'Are you sure you want to delete this webhook? This action cannot be undone.';

  @override
  String get webhookDeleted => 'Webhook deleted';

  @override
  String get webhookUrl => 'Payload URL';

  @override
  String get webhookUrlHint => 'https://example.com/webhook';

  @override
  String get webhookSecret => 'Secret';

  @override
  String get webhookSecretHint => 'Optional secret token';

  @override
  String get webhookContentType => 'Content Type';

  @override
  String get webhookContentTypeJson => 'application/json';

  @override
  String get webhookContentTypeForm => 'application/x-www-form-urlencoded';

  @override
  String get webhookEvents => 'Events';

  @override
  String get webhookEventsHint => 'Select events to trigger this webhook';

  @override
  String get webhookActive => 'Active';

  @override
  String get webhookInactive => 'Inactive';

  @override
  String get webhookType => 'Type';

  @override
  String get webhookCreatedAt => 'Created';

  @override
  String get webhookUpdatedAt => 'Updated';

  @override
  String get webhookLastDelivery => 'Last Delivery';

  @override
  String get webhookSelectAllEvents => 'Select All';

  @override
  String get webhookPushEvents => 'Push';

  @override
  String get webhookPullRequestEvents => 'Pull Requests';

  @override
  String get webhookIssuesEvents => 'Issues';

  @override
  String get webhookCreateEvents => 'Create';

  @override
  String get webhookDeleteEvents => 'Delete';

  @override
  String get webhookReleaseEvents => 'Releases';

  @override
  String get webhookWikiEvents => 'Wiki';

  @override
  String get webhookStarEvents => 'Star';

  @override
  String get webhookForkEvents => 'Fork';

  @override
  String get loginWithOAuth2 => 'Login with OAuth2';

  @override
  String get oauth2 => 'OAuth2';

  @override
  String get oauth2Description => 'Authorize via Gitea OAuth2 application';

  @override
  String get oauth2ClientId => 'Client ID';

  @override
  String get oauth2ClientSecret => 'Client Secret';

  @override
  String get oauth2RedirectUri => 'Redirect URI';

  @override
  String get oauth2RedirectUriHint => 'igitea://oauth/callback';

  @override
  String get oauth2Authorize => 'Open Authorization Page';

  @override
  String get oauth2ExchangeCode => 'Exchange Code for Token';

  @override
  String get oauth2AuthorizationCode => 'Authorization Code';

  @override
  String get oauth2AuthorizationCodeHint =>
      'Paste the code from the redirect URL';

  @override
  String get oauth2TokenRefreshed => 'Token refreshed successfully';

  @override
  String get createLabel => 'Create Label';

  @override
  String get editLabel => 'Edit Label';

  @override
  String get deleteLabel => 'Delete Label';

  @override
  String get deleteLabelConfirm =>
      'Are you sure you want to delete this label?';

  @override
  String get labelDeleted => 'Label deleted';

  @override
  String get labelName => 'Name';

  @override
  String get labelNameHint => 'e.g. bug';

  @override
  String get labelDescription => 'Description';

  @override
  String get labelDescriptionHint => 'Optional description';

  @override
  String get labelColor => 'Color';

  @override
  String get labelColorHint => 'Hex color, e.g. #FF0000';

  @override
  String get filesChanged => 'Files Changed';

  @override
  String get noFilesChanged => 'No files changed';

  @override
  String get viewDiff => '查看 Diff';

  @override
  String get unifiedView => '统一视图';

  @override
  String get splitView => '分屏视图';

  @override
  String get compareVersions => '版本对比';

  @override
  String get baseRef => '基点（旧版）';

  @override
  String get headRef => '对比点（新版）';

  @override
  String get compare => '对比';

  @override
  String get actions => 'Actions';

  @override
  String get noActions => '暂无工作流';

  @override
  String get run => 'Run';

  @override
  String get status => 'Status';

  @override
  String get jobs => 'Jobs';

  @override
  String get noJobs => '暂无 Job';

  @override
  String get artifacts => '构建产物';

  @override
  String get branch => 'Branch';

  @override
  String get author => 'Author';

  @override
  String get filterByActor => 'Filter by actor';

  @override
  String get filterByStatus => 'Filter by status';

  @override
  String get reviewChanges => '审查变更';

  @override
  String get reviewBody => 'Review comment';

  @override
  String get reviews => 'Reviews';

  @override
  String get approve => '批准';

  @override
  String get requestChanges => '请求变更';

  @override
  String get comment => '评论';

  @override
  String get blame => 'Blame';

  @override
  String get diffView => 'Diff 查看';

  @override
  String get pickColor => 'Pick Color';

  @override
  String get sshKeys => 'SSH 密钥';

  @override
  String get allRepos => 'All Repos';

  @override
  String get configuration => '配置';

  @override
  String get none => '无';

  @override
  String get more => '更多';

  @override
  String get units => 'Units';

  @override
  String get permission => 'Permission';

  @override
  String get repoList => '仓库列表';

  @override
  String get noChanges => '无变更';

  @override
  String get limited => '受限';

  @override
  String get unknownSection => 'Unknown section';

  @override
  String get deleteKey => '删除密钥';

  @override
  String get deleteKeyConfirm => '确定要删除此 SSH 密钥吗？';

  @override
  String get keyDeleted => '密钥已删除';

  @override
  String get addSshKey => '添加 SSH 密钥';

  @override
  String get add => '添加';

  @override
  String get keyAdded => '密钥已添加';

  @override
  String get deleteCommentConfirm => '确定要删除此评论吗？';

  @override
  String get requestReviewers => '请求审查';

  @override
  String get addReviewerHint => 'Enter reviewer username';

  @override
  String get subscribe => '订阅';

  @override
  String get unsubscribe => '取消订阅';

  @override
  String get setDueDate => '设置截止日期';

  @override
  String get removeDueDate => '移除截止日期';

  @override
  String get topics => '主题标签';

  @override
  String get noTopics => '暂无主题标签';

  @override
  String get branchProtection => '分支保护';

  @override
  String get protectBranch => '保护分支';

  @override
  String get https => 'HTTPS';

  @override
  String get ssh => 'SSH';

  @override
  String get teamAdminAccess => '团队管理员访问权限';

  @override
  String get details => '详情';

  @override
  String get id => 'ID';

  @override
  String get searchRepositoriesHint => '搜索仓库';

  @override
  String get publicKey => '公钥';

  @override
  String get failedToGetAccessToken => '获取访问令牌失败';

  @override
  String get fileNotFound => '文件未找到';

  @override
  String get noSshKeysFound => '暂无 SSH 密钥';

  @override
  String get other => '其他';

  @override
  String get usernameRequired => '用户名不能为空';

  @override
  String get myLaptopHint => '我的笔记本';

  @override
  String get sshPublicKeyHint => '粘贴你的 SSH 公钥';

  @override
  String get noChangesFoundForFile => '未找到此文件的变更';

  @override
  String commitUpdateFile(Object fileName) {
    return '更新 $fileName';
  }

  @override
  String get api => 'API';

  @override
  String get ui => 'UI';

  @override
  String get justNow => '刚刚';

  @override
  String get igiteaVersion => 'iGitea v0.12.0';
}

/// The translations for Chinese, as used in Taiwan (`zh_TW`).
class AppLocalizationsZhTw extends AppLocalizationsZh {
  AppLocalizationsZhTw() : super('zh_TW');

  @override
  String get appTitle => 'iGitea';

  @override
  String get language => '語言';

  @override
  String get settings => '設定';

  @override
  String get profile => '個人資料';

  @override
  String get search => '搜尋';

  @override
  String get notifications => '通知';

  @override
  String get dashboard => '儀表板';

  @override
  String get signOut => '登出';

  @override
  String get signIn => '登入';

  @override
  String get username => '使用者名稱';

  @override
  String get password => '密碼';

  @override
  String get login => '登入';

  @override
  String get loginWithToken => '使用令牌登入';

  @override
  String get token => '令牌';

  @override
  String get cancel => '取消';

  @override
  String get confirm => '確認';

  @override
  String get save => '儲存';

  @override
  String get delete => '刪除';

  @override
  String get edit => '編輯';

  @override
  String get create => '建立';

  @override
  String get close => '關閉';

  @override
  String get reopen => '重新開啟';

  @override
  String get merge => '合併';

  @override
  String get submit => '提交';

  @override
  String get retry => '重試';

  @override
  String get loading => '載入中...';

  @override
  String get error => '錯誤';

  @override
  String get noData => '暫無資料';

  @override
  String get searchRepos => '搜尋倉庫';

  @override
  String get searchIssues => '搜尋問題';

  @override
  String get noResults => '找不到結果';

  @override
  String get repositories => '倉庫';

  @override
  String get repositorySections => 'Repository Sections';

  @override
  String get issues => '問題';

  @override
  String get pullRequests => '拉取請求';

  @override
  String get releases => '發布';

  @override
  String get branches => '分支';

  @override
  String get code => '程式碼';

  @override
  String get stars => '星標';

  @override
  String get forks => '分叉';

  @override
  String get watchers => '關注者';

  @override
  String get open => '開啟';

  @override
  String get closed => '已關閉';

  @override
  String get all => '全部';

  @override
  String get mergePullRequest => '合併拉取請求';

  @override
  String get mergeConfirmMessage => '確定要合併此拉取請求嗎？';

  @override
  String issueNumber(Object issueNumber) {
    return '問題 #$issueNumber';
  }

  @override
  String pullRequestNumber(Object pullRequestNumber) {
    return 'PR #$pullRequestNumber';
  }

  @override
  String get comments => '評論';

  @override
  String get addComment => '新增評論...';

  @override
  String get sendComment => '傳送';

  @override
  String get noComments => '暫無評論';

  @override
  String get labels => '標籤';

  @override
  String get milestones => '里程碑';

  @override
  String get assignees => '指派人';

  @override
  String get assignee => 'Assignee';

  @override
  String get participants => '參與者';

  @override
  String get timeline => '時間線';

  @override
  String get theme => '主題';

  @override
  String get themeLight => '淺色';

  @override
  String get themeDark => '深色';

  @override
  String get themeSystem => '跟隨系統';

  @override
  String get account => '帳戶';

  @override
  String get accountInfo => '帳戶資訊';

  @override
  String get email => '電子郵件';

  @override
  String get website => '網站';

  @override
  String get bio => '簡介';

  @override
  String joinedOn(Object date) {
    return '加入於 $date';
  }

  @override
  String joinedOnParams(Object date) {
    return '加入於 $date';
  }

  @override
  String followerCount(Object count) {
    return '$count 粉絲';
  }

  @override
  String followerCountParams(Object count) {
    return '$count 粉絲';
  }

  @override
  String followingCount(Object count) {
    return '$count 關注';
  }

  @override
  String followingCountParams(Object count) {
    return '$count 關注';
  }

  @override
  String repositoryCount(Object count) {
    return '$count 個倉庫';
  }

  @override
  String repositoryCountParams(Object count) {
    return '$count 個倉庫';
  }

  @override
  String get starredRepos => '星標倉庫';

  @override
  String get organisations => '組織';

  @override
  String get adminPanel => '管理面板';

  @override
  String get userManagement => '使用者管理';

  @override
  String get serverSettings => '伺服器設定';

  @override
  String get cronTasks => '排程任務';

  @override
  String get apiSettings => 'API 設定';

  @override
  String get uiSettings => '介面設定';

  @override
  String get attachmentSettings => '附件設定';

  @override
  String get repoSettings => '倉庫設定';

  @override
  String get runNow => '立即執行';

  @override
  String lastRun(Object time) {
    return '上次執行：$time';
  }

  @override
  String lastRunParams(Object time) {
    return '上次執行：$time';
  }

  @override
  String nextRun(Object time) {
    return '下次執行：$time';
  }

  @override
  String nextRunParams(Object time) {
    return '下次執行：$time';
  }

  @override
  String get recentActivity => '最近活動';

  @override
  String get myIssues => '我的 Issue';

  @override
  String get myRepos => '我的倉庫';

  @override
  String get myStars => '我的星標';

  @override
  String get feed => '動態';

  @override
  String get markAllRead => '全部標記為已讀';

  @override
  String get markRead => '標記為已讀';

  @override
  String unreadNotifications(Object count) {
    return '未讀通知：$count';
  }

  @override
  String unreadNotificationsParams(Object count) {
    return '未讀通知：$count';
  }

  @override
  String get noUnreadNotifications => '沒有未讀通知';

  @override
  String get readMore => '閱讀更多';

  @override
  String ago(Object time) {
    return '$time前';
  }

  @override
  String agoParams(Object time) {
    return '$time前';
  }

  @override
  String get fileBrowser => '檔案瀏覽器';

  @override
  String get readme => '說明文件';

  @override
  String get commits => '提交';

  @override
  String get commitHistory => '提交歷史';

  @override
  String get viewFile => '檢視檔案';

  @override
  String get downloadFile => '下載檔案';

  @override
  String get copyPath => '複製路徑';

  @override
  String get fileName => '檔案名稱';

  @override
  String get fileSize => '檔案大小';

  @override
  String get lastModified => '最後修改';

  @override
  String get openInBrowser => '在瀏覽器中開啟';

  @override
  String get signInRequired => '需要登入';

  @override
  String get signInMessage => '請登入以繼續';

  @override
  String get loginFailed => '登入失敗';

  @override
  String get networkError => '網路錯誤';

  @override
  String get unknownError => '發生未知錯誤';

  @override
  String get refresh => '重新整理';

  @override
  String get copyToClipboard => '複製到剪貼簿';

  @override
  String get copied => '已複製！';

  @override
  String get filterIssues => '篩選問題';

  @override
  String get newIssue => '新建問題';

  @override
  String get newPullRequest => '新建拉取請求';

  @override
  String get title => '標題';

  @override
  String get description => '描述';

  @override
  String get body => '正文';

  @override
  String get state => '狀態';

  @override
  String get priority => '優先順序';

  @override
  String get milestone => '里程碑';

  @override
  String get createdAt => '建立於';

  @override
  String get updatedAt => '更新於';

  @override
  String get dueDate => '截止日期';

  @override
  String get noMilestones => '暫無里程碑';

  @override
  String get noLabels => '暫無標籤';

  @override
  String get openIssue => '開啟問題';

  @override
  String get closeIssue => '關閉問題';

  @override
  String get reopenIssue => '重新開啟問題';

  @override
  String get deleteComment => '刪除評論';

  @override
  String get editComment => '編輯評論';

  @override
  String get deleteRepo => '刪除倉庫';

  @override
  String get deleteRepoConfirm => '確定要刪除此倉庫嗎？此操作不可撤銷。';

  @override
  String get generalSettings => '通用設定';

  @override
  String get appearance => '外觀';

  @override
  String get languageSelector => '語言';

  @override
  String get selectLanguage => '選擇語言';

  @override
  String get systemDefault => '系統預設';

  @override
  String get followSystem => '跟隨系統';

  @override
  String get unsavedChanges => '未儲存的變更';

  @override
  String get unsavedChangesMessage => '您有未儲存的變更。確定要離開嗎？';

  @override
  String get leave => '離開';

  @override
  String get stay => '留下';

  @override
  String get restoringSession => 'Restoring session...';

  @override
  String get pleaseEnterServerUrl => '请输入服务器地址';

  @override
  String get pleaseEnterValidUrl => '请输入有效的 URL';

  @override
  String get connectToGitea => '连接到你的 Gitea 实例';

  @override
  String get usernamePassword => '用户名和密码';

  @override
  String get serverUrl => '服务器地址';

  @override
  String get enterUsername => '输入用户名';

  @override
  String get pleaseEnterUsername => '请输入用户名';

  @override
  String get enterPassword => '输入密码';

  @override
  String get pleaseEnterPassword => '请输入密码';

  @override
  String get pasteAccessToken => '粘贴你的访问令牌';

  @override
  String get pleaseEnterAccessToken => '请输入访问令牌';

  @override
  String get signInWithToken => '使用 Token 登录';

  @override
  String get welcomeToIgitea => '欢迎使用 iGitea';

  @override
  String get signInToGetStarted => '登录以开始使用';

  @override
  String get quickActions => '快捷操作';

  @override
  String get yourRepositories => '我的倉庫';

  @override
  String get noRepositoriesFound => '未找到倉庫';

  @override
  String helloParams(Object full_name) {
    return 'Hello, $full_name!';
  }

  @override
  String get user => 'User';

  @override
  String get private => '私有';

  @override
  String get untitled => 'Untitled';

  @override
  String get enterSearchQueryRepos => '輸入搜尋關鍵字查找倉庫';

  @override
  String get enterSearchQueryIssues => 'Enter a search query to find issues';

  @override
  String get noIssuesFound => 'No issues found.';

  @override
  String get failedToLoadProfile => 'Failed to load profile';

  @override
  String get unknownUser => 'Unknown User';

  @override
  String get admin => 'Admin';

  @override
  String get repos => '倉庫';

  @override
  String get followers => '關注者';

  @override
  String get following => '正在關注';

  @override
  String get signOutConfirmMessage => 'Are you sure you want to sign out?';

  @override
  String get chooseTheme => 'Choose Theme';

  @override
  String get loadingSettings => 'Loading settings...';

  @override
  String get userManagementComingSoon => 'User management coming soon';

  @override
  String get maxResponseItems => 'Max Response Items';

  @override
  String get defaultPagingNum => 'Default Paging Num';

  @override
  String get defaultMaxBlobSize => 'Default Max Blob Size';

  @override
  String get defaultTheme => 'Default Theme';

  @override
  String get allowedReactions => 'Allowed Reactions';

  @override
  String get attachments => 'Attachments';

  @override
  String get enabled => 'Enabled';

  @override
  String get maxFiles => 'Max Files';

  @override
  String get maxSize => 'Max Size';

  @override
  String get allowedTypes => 'Allowed Types';

  @override
  String get bytes => 'bytes';

  @override
  String get repository => '倉庫';

  @override
  String get httpGitDisabled => 'HTTP Git Disabled';

  @override
  String get lfsDisabled => 'LFS Disabled';

  @override
  String get migrationsDisabled => 'Migrations Disabled';

  @override
  String get mirrorsDisabled => 'Mirrors Disabled';

  @override
  String get starsDisabled => 'Stars Disabled';

  @override
  String get timeTrackingDisabled => 'Time Tracking Disabled';

  @override
  String get yes => '是';

  @override
  String get no => '否';

  @override
  String get schedule => 'Schedule';

  @override
  String get next => 'Next';

  @override
  String get executions => 'Executions';

  @override
  String get failedToLoadCronTasks => 'Failed to load cron tasks';

  @override
  String get noCronTasksFound => 'No cron tasks found';

  @override
  String cronTriggeredParams(Object name) {
    return 'Cron \"$name\" triggered';
  }

  @override
  String get unknown => '未知';

  @override
  String openedParams(Object time) {
    return 'opened $time';
  }

  @override
  String get noDescriptionProvided => '未提供描述';

  @override
  String get failedToLoadComments => 'Failed to load comments';

  @override
  String get writeComment => '写評論';

  @override
  String commentsCountParams(Object count) {
    return '$count comments';
  }

  @override
  String updatedParams(Object time) {
    return 'Updated $time';
  }

  @override
  String commentsParams(Object count) {
    return 'Comments ($count)';
  }

  @override
  String get files => 'files';

  @override
  String get mergeable => 'Mergeable';

  @override
  String get merged => 'Merged';

  @override
  String get draft => 'Draft';

  @override
  String get failedToLoadRepo => 'Failed to load repository';

  @override
  String get copyUrl => 'Copy URL';

  @override
  String get urlCopied => 'URL copied';

  @override
  String get emptyDirectory => 'Empty directory';

  @override
  String get noIssues => '暂无 Issue';

  @override
  String get noPullRequests => 'No pull requests';

  @override
  String get noReleases => 'No releases';

  @override
  String get noBranches => 'No branches';

  @override
  String get preRelease => 'Pre-release';

  @override
  String get archived => '已归档';

  @override
  String get defaultBranch => '默认分支';

  @override
  String get copyCode => 'Copy code';

  @override
  String get failedToLoadFile => 'Failed to load file';

  @override
  String get filePreviewNotAvailable => 'File preview not available';

  @override
  String get download => 'Download';

  @override
  String get failedToOpenDownloadUrl => 'Failed to open download URL';

  @override
  String get noNotifications => '暂无通知';

  @override
  String get noTitle => 'No title';

  @override
  String get allNotificationsMarkedAsRead => 'All notifications marked as read';

  @override
  String get createUser => 'Create User';

  @override
  String get editUser => 'Edit User';

  @override
  String get deleteUser => 'Delete User';

  @override
  String deleteUserConfirmParams(Object username) {
    return 'Are you sure you want to delete user \"$username\"? This action cannot be undone.';
  }

  @override
  String get userCreated => 'User created successfully';

  @override
  String get userUpdated => 'User updated successfully';

  @override
  String get userDeleted => 'User deleted successfully';

  @override
  String get noUsersFound => 'No users found';

  @override
  String get pleaseEnterEmail => 'Please enter an email';

  @override
  String get fullName => 'Full name';

  @override
  String get mustChangePassword => 'Must change password on first login';

  @override
  String get pleaseEnterTitle => 'Please enter a title';

  @override
  String get noActivity => '暂无活动';

  @override
  String get createdRepo => '建立了倉庫';

  @override
  String get pushedTag => '推送了標籤';

  @override
  String get deletedTag => '刪除了標籤';

  @override
  String get createdIssue => '建立了 Issue';

  @override
  String get closedIssue => '關閉了 Issue';

  @override
  String get reopenedIssue => '重新打开了 Issue';

  @override
  String get createdPR => '建立了 PR';

  @override
  String get mergedPR => '合併了 PR';

  @override
  String get closedPR => '關閉了 PR';

  @override
  String get commentedOnIssue => '評論了 Issue';

  @override
  String get commentedOnPR => '評論了 PR';

  @override
  String get forkedRepo => 'Fork 了倉庫';

  @override
  String get transferredRepo => '转移了倉庫';

  @override
  String get deletedRepo => '刪除了倉庫';

  @override
  String get updatedWiki => '更新了 Wiki';

  @override
  String get performedAction => '执行了操作';

  @override
  String get commitRepo => '提交了代码到';

  @override
  String get renameRepo => '重新命名了倉庫';

  @override
  String get starRepo => '收藏了倉庫';

  @override
  String get watchRepo => '关注了倉庫';

  @override
  String get reopenPR => '重新打开了 PR';

  @override
  String get approvePR => '批准了 PR';

  @override
  String get rejectPR => '驳回了 PR';

  @override
  String get publishRelease => '发布了版本';

  @override
  String get deleteBranch => '刪除了分支';

  @override
  String get autoMergePR => '自动合併了 PR';

  @override
  String get pullReviewDismissed => '驳回了审查';

  @override
  String get pullRequestReady => '标记 PR 为就绪';

  @override
  String get mirrorSyncPush => '同步推送了镜像';

  @override
  String get mirrorSyncCreate => '同步建立了镜像';

  @override
  String get mirrorSyncDelete => '同步刪除了镜像';

  @override
  String get inRepo => 'in';

  @override
  String get to => 'to';

  @override
  String get from => 'from';

  @override
  String get headBranch => '源分支';

  @override
  String get baseBranch => '目标分支';

  @override
  String get pleaseFillAllFields => '请填写所有必填项';

  @override
  String get settingsSaved => '設定已保存';

  @override
  String get privateRepo => 'Private repository';

  @override
  String get privateRepoDesc => 'Only visible to you and collaborators';

  @override
  String get enableIssues => 'Enable Issues';

  @override
  String get enablePullRequests => 'Enable Pull Requests';

  @override
  String get enableWiki => 'Enable Wiki';

  @override
  String get preview => 'Preview';

  @override
  String get commitMessage => 'Commit Message';

  @override
  String get commit => 'Commit';

  @override
  String get commitMessageHint => 'Describe your changes (optional)';

  @override
  String get cannotGetFileSha => 'Cannot get file SHA. Please reload the file.';

  @override
  String get failedToSaveFile => 'Failed to save file';

  @override
  String get fileSaved => 'File saved successfully';

  @override
  String get discard => 'Discard';

  @override
  String get message => 'Message';

  @override
  String get ok => 'OK';

  @override
  String get sha => 'SHA';

  @override
  String get changedFiles => 'Changed Files';

  @override
  String get tags => '標籤';

  @override
  String get noCommits => '暂无提交';

  @override
  String get noTags => 'No tags';

  @override
  String get protected => 'Protected';

  @override
  String get latestCommit => 'Latest Commit';

  @override
  String get permissions => 'Permissions';

  @override
  String get canPush => 'Can Push';

  @override
  String get canMerge => 'Can Merge';

  @override
  String get downloads => 'Downloads';

  @override
  String get tarball => 'Tarball';

  @override
  String get zipball => 'Zipball';

  @override
  String get downloadTarball => 'Download Tarball';

  @override
  String get downloadZipball => 'Download Zipball';

  @override
  String get url => '链接';

  @override
  String get info => 'Info';

  @override
  String get teams => 'Teams';

  @override
  String get noTeams => '暂无团队';

  @override
  String get location => 'Location';

  @override
  String get visibility => 'Visibility';

  @override
  String get assets => 'Assets';

  @override
  String get publishedAt => 'Published At';

  @override
  String get target => 'Target';

  @override
  String get forked => '已分叉';

  @override
  String get forkRepoConfirm =>
      'This will create a fork of this repository in your account.';

  @override
  String get editIssue => 'Edit Issue';

  @override
  String get titleRequired => 'Title is required';

  @override
  String get selectMilestone => 'Select milestone';

  @override
  String get members => 'Members';

  @override
  String get noMembers => '暂无成员';

  @override
  String get editOrganization => 'Edit Organization';

  @override
  String get createOrganization => 'Create Organization';

  @override
  String get createRepository => 'Create Repository';

  @override
  String get repositoryName => '倉庫名稱';

  @override
  String get repositoryNameHint => 'my-awesome-repo';

  @override
  String get repositoryNameRequired => '倉庫名稱為必填項';

  @override
  String get descriptionHint => '倉庫的簡短描述';

  @override
  String get public => '公开';

  @override
  String get publicDescription => '任何人都可以看到此倉庫';

  @override
  String get privateDescription => '你可以選擇誰可以看到並提交到此倉庫';

  @override
  String get initializeWithReadme => 'Initialize with README';

  @override
  String get initializeWithReadmeDescription =>
      'Add a README file to help others understand your project';

  @override
  String repoCreated(Object repoName) {
    return 'Repository \'$repoName\' created successfully';
  }

  @override
  String get complete => 'complete';

  @override
  String get wiki => 'Wiki';

  @override
  String get newWikiPage => 'New Wiki Page';

  @override
  String get editWikiPage => 'Edit Wiki Page';

  @override
  String get deleteWikiPage => 'Delete Wiki Page';

  @override
  String get deleteWikiPageConfirm =>
      'Are you sure you want to delete this wiki page? This action cannot be undone.';

  @override
  String get wikiPageDeleted => 'Wiki page deleted';

  @override
  String get wikiPageTitle => 'Page Title';

  @override
  String get wikiPageTitleHint => 'e.g. Home';

  @override
  String get wikiPageContent => 'Content';

  @override
  String get wikiPageContentHint => 'Write in Markdown...';

  @override
  String get noWikiPages => '暂无 Wiki 页面';

  @override
  String get noWikiPagesDescription =>
      'This repository doesn\'t have any wiki pages yet.';

  @override
  String get createFirstWikiPage => 'Create First Page';

  @override
  String get lastCommit => 'Last commit';

  @override
  String get noContent => '无内容';

  @override
  String get saved => 'Saved';

  @override
  String get created => 'Created';

  @override
  String get createMilestone => 'Create Milestone';

  @override
  String get editMilestone => 'Edit Milestone';

  @override
  String get deleteMilestone => 'Delete Milestone';

  @override
  String get deleteMilestoneConfirm =>
      'Are you sure you want to delete this milestone? This action cannot be undone.';

  @override
  String get milestoneDeleted => 'Milestone deleted';

  @override
  String get milestoneTitle => 'Title';

  @override
  String get milestoneDescription => 'Description';

  @override
  String get milestoneDescriptionHint => 'Describe this milestone';

  @override
  String get milestoneDueDate => 'Due Date';

  @override
  String get milestoneState => 'State';

  @override
  String get milestoneStateOpen => 'Open';

  @override
  String get milestoneStateClosed => 'Closed';

  @override
  String get total => 'Total';

  @override
  String get clear => 'Clear';

  @override
  String get webhooks => 'Webhooks';

  @override
  String get webhook => 'Webhook';

  @override
  String get noWebhooks => '暂无 Webhook';

  @override
  String get createWebhook => 'Create Webhook';

  @override
  String get editWebhook => 'Edit Webhook';

  @override
  String get deleteWebhook => 'Delete Webhook';

  @override
  String get deleteWebhookConfirm =>
      'Are you sure you want to delete this webhook? This action cannot be undone.';

  @override
  String get webhookDeleted => 'Webhook deleted';

  @override
  String get webhookUrl => 'Payload URL';

  @override
  String get webhookUrlHint => 'https://example.com/webhook';

  @override
  String get webhookSecret => 'Secret';

  @override
  String get webhookSecretHint => 'Optional secret token';

  @override
  String get webhookContentType => 'Content Type';

  @override
  String get webhookContentTypeJson => 'application/json';

  @override
  String get webhookContentTypeForm => 'application/x-www-form-urlencoded';

  @override
  String get webhookEvents => 'Events';

  @override
  String get webhookEventsHint => 'Select events to trigger this webhook';

  @override
  String get webhookActive => 'Active';

  @override
  String get webhookInactive => 'Inactive';

  @override
  String get webhookType => 'Type';

  @override
  String get webhookCreatedAt => 'Created';

  @override
  String get webhookUpdatedAt => 'Updated';

  @override
  String get webhookLastDelivery => 'Last Delivery';

  @override
  String get webhookSelectAllEvents => 'Select All';

  @override
  String get webhookPushEvents => 'Push';

  @override
  String get webhookPullRequestEvents => 'Pull Requests';

  @override
  String get webhookIssuesEvents => 'Issues';

  @override
  String get webhookCreateEvents => 'Create';

  @override
  String get webhookDeleteEvents => 'Delete';

  @override
  String get webhookReleaseEvents => 'Releases';

  @override
  String get webhookWikiEvents => 'Wiki';

  @override
  String get webhookStarEvents => 'Star';

  @override
  String get webhookForkEvents => 'Fork';

  @override
  String get loginWithOAuth2 => 'Login with OAuth2';

  @override
  String get oauth2 => 'OAuth2';

  @override
  String get oauth2Description => 'Authorize via Gitea OAuth2 application';

  @override
  String get oauth2ClientId => 'Client ID';

  @override
  String get oauth2ClientSecret => 'Client Secret';

  @override
  String get oauth2RedirectUri => 'Redirect URI';

  @override
  String get oauth2RedirectUriHint => 'igitea://oauth/callback';

  @override
  String get oauth2Authorize => 'Open Authorization Page';

  @override
  String get oauth2ExchangeCode => 'Exchange Code for Token';

  @override
  String get oauth2AuthorizationCode => 'Authorization Code';

  @override
  String get oauth2AuthorizationCodeHint =>
      'Paste the code from the redirect URL';

  @override
  String get oauth2TokenRefreshed => 'Token refreshed successfully';

  @override
  String get createLabel => 'Create Label';

  @override
  String get editLabel => 'Edit Label';

  @override
  String get deleteLabel => 'Delete Label';

  @override
  String get deleteLabelConfirm =>
      'Are you sure you want to delete this label?';

  @override
  String get labelDeleted => 'Label deleted';

  @override
  String get labelName => 'Name';

  @override
  String get labelNameHint => 'e.g. bug';

  @override
  String get labelDescription => 'Description';

  @override
  String get labelDescriptionHint => 'Optional description';

  @override
  String get labelColor => 'Color';

  @override
  String get labelColorHint => 'Hex color, e.g. #FF0000';

  @override
  String get filesChanged => 'Files Changed';

  @override
  String get noFilesChanged => 'No files changed';

  @override
  String get viewDiff => '查看 Diff';

  @override
  String get unifiedView => '统一视图';

  @override
  String get splitView => '分屏视图';

  @override
  String get compareVersions => '版本对比';

  @override
  String get baseRef => '基点（旧版）';

  @override
  String get headRef => '对比点（新版）';

  @override
  String get compare => '对比';

  @override
  String get actions => 'Actions';

  @override
  String get noActions => '暂无工作流';

  @override
  String get run => 'Run';

  @override
  String get status => 'Status';

  @override
  String get jobs => 'Jobs';

  @override
  String get noJobs => '暂无 Job';

  @override
  String get artifacts => '构建产物';

  @override
  String get branch => 'Branch';

  @override
  String get author => 'Author';

  @override
  String get filterByActor => 'Filter by actor';

  @override
  String get filterByStatus => 'Filter by status';

  @override
  String get reviewChanges => '审查变更';

  @override
  String get reviewBody => 'Review comment';

  @override
  String get reviews => 'Reviews';

  @override
  String get approve => '批准';

  @override
  String get requestChanges => '请求变更';

  @override
  String get comment => '評論';

  @override
  String get blame => 'Blame';

  @override
  String get diffView => 'Diff 查看';

  @override
  String get pickColor => 'Pick Color';

  @override
  String get sshKeys => 'SSH 金鑰';

  @override
  String get allRepos => 'All Repos';

  @override
  String get configuration => '配置';

  @override
  String get none => '无';

  @override
  String get more => '更多';

  @override
  String get units => 'Units';

  @override
  String get permission => 'Permission';

  @override
  String get repoList => '倉庫列表';

  @override
  String get noChanges => '无变更';

  @override
  String get limited => '受限';

  @override
  String get unknownSection => 'Unknown section';

  @override
  String get deleteKey => '刪除金鑰';

  @override
  String get deleteKeyConfirm => '确定要刪除此 SSH 金鑰吗？';

  @override
  String get keyDeleted => '金鑰已刪除';

  @override
  String get addSshKey => '新增 SSH 金鑰';

  @override
  String get add => '新增';

  @override
  String get keyAdded => '金鑰已新增';

  @override
  String get deleteCommentConfirm => '确定要刪除此評論吗？';

  @override
  String get requestReviewers => '请求审查';

  @override
  String get addReviewerHint => 'Enter reviewer username';

  @override
  String get subscribe => '订阅';

  @override
  String get unsubscribe => '取消订阅';

  @override
  String get setDueDate => '設定截止日期';

  @override
  String get removeDueDate => '移除截止日期';

  @override
  String get topics => '主题標籤';

  @override
  String get noTopics => '暂无主题標籤';

  @override
  String get branchProtection => '分支保护';

  @override
  String get protectBranch => '保护分支';

  @override
  String get https => 'HTTPS';

  @override
  String get ssh => 'SSH';

  @override
  String get teamAdminAccess => 'Team Admin Access';

  @override
  String get details => 'Details';

  @override
  String get id => 'ID';

  @override
  String get searchRepositoriesHint => '搜尋倉庫';

  @override
  String get publicKey => 'Public Key';

  @override
  String get failedToGetAccessToken => 'Failed to get access token';

  @override
  String get fileNotFound => 'File not found';

  @override
  String get noSshKeysFound => 'No SSH keys found';

  @override
  String get other => 'Other';

  @override
  String get usernameRequired => 'Username is required';

  @override
  String get myLaptopHint => 'My Laptop';

  @override
  String get sshPublicKeyHint => 'Paste your SSH public key here';

  @override
  String get noChangesFoundForFile => 'No changes found for this file';

  @override
  String commitUpdateFile(Object fileName) {
    return 'Update $fileName';
  }

  @override
  String get api => 'API';

  @override
  String get ui => 'UI';

  @override
  String get justNow => 'just now';

  @override
  String get igiteaVersion => 'iGitea v0.23.0';
}
