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
  String get myIssues => '我的问题';

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
  String get deleteRepoConfirm => '确定要删除此仓库吗？此操作无法撤销。';

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
  String get pleaseEnterServerUrl => 'Please enter a server URL';

  @override
  String get pleaseEnterValidUrl => 'Please enter a valid URL';

  @override
  String get connectToGitea => 'Connect to your Gitea instance';

  @override
  String get usernamePassword => 'Username & Password';

  @override
  String get serverUrl => 'Server URL';

  @override
  String get enterUsername => 'Enter your username';

  @override
  String get pleaseEnterUsername => 'Please enter your username';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get pasteAccessToken => 'Paste your personal access token';

  @override
  String get pleaseEnterAccessToken => 'Please enter an access token';

  @override
  String get signInWithToken => 'Sign In with Token';

  @override
  String get welcomeToIgitea => 'Welcome to iGitea';

  @override
  String get signInToGetStarted => 'Sign in to get started';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get yourRepositories => 'Your Repositories';

  @override
  String get noRepositoriesFound => 'No repositories found.';

  @override
  String helloParams(Object full_name) {
    return 'Hello, $full_name!';
  }

  @override
  String get user => 'User';

  @override
  String get private => 'Private';

  @override
  String get untitled => 'Untitled';

  @override
  String get enterSearchQueryRepos =>
      'Enter a search query to find repositories';

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
  String get repos => 'Repos';

  @override
  String get followers => 'Followers';

  @override
  String get following => 'Following';

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
  String get repository => 'Repository';

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
  String get yes => 'Yes';

  @override
  String get no => 'No';

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
  String get unknown => 'Unknown';

  @override
  String openedParams(Object time) {
    return 'opened $time';
  }

  @override
  String get noDescriptionProvided => 'No description provided.';

  @override
  String get failedToLoadComments => 'Failed to load comments';

  @override
  String get writeComment => 'Write a comment...';

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
  String get noIssues => 'No issues';

  @override
  String get noPullRequests => 'No pull requests';

  @override
  String get noReleases => 'No releases';

  @override
  String get noBranches => 'No branches';

  @override
  String get preRelease => 'Pre-release';

  @override
  String get archived => 'Archived';

  @override
  String get defaultBranch => 'Default';

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
  String get noNotifications => 'No notifications';

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
  String get inRepo => '在';

  @override
  String get to => '到';

  @override
  String get from => '从';
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
  String get myIssues => '我的問題';

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
  String get deleteRepoConfirm => '確定要刪除此倉庫嗎？此操作無法復原。';

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
}
