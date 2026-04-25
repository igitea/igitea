// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'iGitea';

  @override
  String get language => '言語';

  @override
  String get settings => '設定';

  @override
  String get profile => 'プロフィール';

  @override
  String get search => '検索';

  @override
  String get notifications => '通知';

  @override
  String get dashboard => 'ダッシュボード';

  @override
  String get signOut => 'サインアウト';

  @override
  String get signIn => 'サインイン';

  @override
  String get username => 'ユーザー名';

  @override
  String get password => 'パスワード';

  @override
  String get login => 'ログイン';

  @override
  String get loginWithToken => 'トークンでログイン';

  @override
  String get token => 'トークン';

  @override
  String get cancel => 'キャンセル';

  @override
  String get confirm => '確認';

  @override
  String get save => '保存';

  @override
  String get delete => '削除';

  @override
  String get edit => '編集';

  @override
  String get create => '作成';

  @override
  String get close => '閉じる';

  @override
  String get reopen => '再開';

  @override
  String get merge => 'マージ';

  @override
  String get submit => '送信';

  @override
  String get retry => '再試行';

  @override
  String get loading => '読み込み中...';

  @override
  String get error => 'エラー';

  @override
  String get noData => 'データがありません';

  @override
  String get searchRepos => 'リポジトリを検索';

  @override
  String get searchIssues => 'イシューを検索';

  @override
  String get noResults => '結果が見つかりません';

  @override
  String get repositories => 'リポジトリ';

  @override
  String get issues => 'イシュー';

  @override
  String get pullRequests => 'プルリクエスト';

  @override
  String get releases => 'リリース';

  @override
  String get branches => 'ブランチ';

  @override
  String get code => 'コード';

  @override
  String get stars => 'スター';

  @override
  String get forks => 'フォーク';

  @override
  String get watchers => 'ウォッチャー';

  @override
  String get open => 'オープン';

  @override
  String get closed => 'クローズ';

  @override
  String get all => 'すべて';

  @override
  String get mergePullRequest => 'プルリクエストをマージ';

  @override
  String get mergeConfirmMessage => 'このプルリクエストをマージしてもよろしいですか？';

  @override
  String issueNumber(Object issueNumber) {
    return 'イシュー #$issueNumber';
  }

  @override
  String pullRequestNumber(Object pullRequestNumber) {
    return 'PR #$pullRequestNumber';
  }

  @override
  String get comments => 'コメント';

  @override
  String get addComment => 'コメントを追加...';

  @override
  String get sendComment => '送信';

  @override
  String get noComments => 'コメントはまだありません';

  @override
  String get labels => 'ラベル';

  @override
  String get milestones => 'マイルストーン';

  @override
  String get assignees => '担当者';

  @override
  String get assignee => 'Assignee';

  @override
  String get participants => '参加者';

  @override
  String get timeline => 'タイムライン';

  @override
  String get theme => 'テーマ';

  @override
  String get themeLight => 'ライト';

  @override
  String get themeDark => 'ダーク';

  @override
  String get themeSystem => 'システム';

  @override
  String get account => 'アカウント';

  @override
  String get accountInfo => 'アカウント情報';

  @override
  String get email => 'メールアドレス';

  @override
  String get website => 'ウェブサイト';

  @override
  String get bio => '自己紹介';

  @override
  String joinedOn(Object date) {
    return 'Joined on $date';
  }

  @override
  String joinedOnParams(Object date) {
    return '$date に加入';
  }

  @override
  String followerCount(Object count) {
    return '$count followers';
  }

  @override
  String followerCountParams(Object count) {
    return '$count フォロワー';
  }

  @override
  String followingCount(Object count) {
    return '$count following';
  }

  @override
  String followingCountParams(Object count) {
    return '$count フォロー中';
  }

  @override
  String repositoryCount(Object count) {
    return '$count repositories';
  }

  @override
  String repositoryCountParams(Object count) {
    return '$count リポジトリ';
  }

  @override
  String get starredRepos => 'スター付きリポジトリ';

  @override
  String get organisations => '組織';

  @override
  String get adminPanel => '管理パネル';

  @override
  String get userManagement => 'ユーザー管理';

  @override
  String get serverSettings => 'サーバー設定';

  @override
  String get cronTasks => 'Cronタスク';

  @override
  String get apiSettings => 'API設定';

  @override
  String get uiSettings => 'UI設定';

  @override
  String get attachmentSettings => '添付ファイル設定';

  @override
  String get repoSettings => 'リポジトリ設定';

  @override
  String get runNow => '今すぐ実行';

  @override
  String lastRun(Object time) {
    return 'Last run: $time';
  }

  @override
  String lastRunParams(Object time) {
    return '最終実行: $time';
  }

  @override
  String nextRun(Object time) {
    return 'Next run: $time';
  }

  @override
  String nextRunParams(Object time) {
    return '次回実行: $time';
  }

  @override
  String get recentActivity => '最近のアクティビティ';

  @override
  String get myIssues => '自分のイシュー';

  @override
  String get myRepos => '自分のリポジトリ';

  @override
  String get myStars => 'スター付き';

  @override
  String get feed => 'フィード';

  @override
  String get markAllRead => 'すべて既読にする';

  @override
  String get markRead => '既読にする';

  @override
  String unreadNotifications(Object count) {
    return 'Unread notifications: $count';
  }

  @override
  String unreadNotificationsParams(Object count) {
    return '未読通知: $count';
  }

  @override
  String get noUnreadNotifications => '未読通知はありません';

  @override
  String get readMore => '続きを読む';

  @override
  String ago(Object time) {
    return '$time ago';
  }

  @override
  String agoParams(Object time) {
    return '$time 前';
  }

  @override
  String get fileBrowser => 'ファイルブラウザ';

  @override
  String get readme => 'README';

  @override
  String get commits => 'コミット';

  @override
  String get commitHistory => 'コミット履歴';

  @override
  String get viewFile => 'ファイルを表示';

  @override
  String get downloadFile => 'ファイルをダウンロード';

  @override
  String get copyPath => 'パスをコピー';

  @override
  String get fileName => 'ファイル名';

  @override
  String get fileSize => 'ファイルサイズ';

  @override
  String get lastModified => '最終更新';

  @override
  String get openInBrowser => 'ブラウザで開く';

  @override
  String get signInRequired => 'サインインが必要です';

  @override
  String get signInMessage => '続行するにはサインインしてください';

  @override
  String get loginFailed => 'ログインに失敗しました';

  @override
  String get networkError => 'ネットワークエラー';

  @override
  String get unknownError => '不明なエラーが発生しました';

  @override
  String get refresh => '更新';

  @override
  String get copyToClipboard => 'クリップボードにコピー';

  @override
  String get copied => 'コピーしました！';

  @override
  String get filterIssues => 'イシューをフィルター';

  @override
  String get newIssue => '新しいイシュー';

  @override
  String get newPullRequest => '新しいプルリクエスト';

  @override
  String get title => 'タイトル';

  @override
  String get description => '説明';

  @override
  String get body => '本文';

  @override
  String get state => '状態';

  @override
  String get priority => '優先度';

  @override
  String get milestone => 'マイルストーン';

  @override
  String get createdAt => '作成日';

  @override
  String get updatedAt => '更新日';

  @override
  String get dueDate => '期日';

  @override
  String get noMilestones => 'マイルストーンなし';

  @override
  String get noLabels => 'ラベルなし';

  @override
  String get openIssue => 'イシューを開く';

  @override
  String get closeIssue => 'イシューを閉じる';

  @override
  String get reopenIssue => 'イシューを再開';

  @override
  String get deleteComment => 'コメントを削除';

  @override
  String get editComment => 'コメントを編集';

  @override
  String get deleteRepo => 'リポジトリを削除';

  @override
  String get deleteRepoConfirm => 'このリポジトリを削除してもよろしいですか？この操作は元に戻せません。';

  @override
  String get generalSettings => '一般設定';

  @override
  String get appearance => '外観';

  @override
  String get languageSelector => '言語';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get systemDefault => 'システムのデフォルト';

  @override
  String get followSystem => 'システムに従う';

  @override
  String get unsavedChanges => '未保存の変更';

  @override
  String get unsavedChangesMessage => '未保存の変更があります。このページを離れてもよろしいですか？';

  @override
  String get leave => '離れる';

  @override
  String get stay => '残る';

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
  String get defaultBranch => 'Default branch';

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
  String get noActivity => 'No recent activity';

  @override
  String get createdRepo => 'created repository';

  @override
  String get pushedTag => 'pushed tag';

  @override
  String get deletedTag => 'deleted tag';

  @override
  String get createdIssue => 'created issue';

  @override
  String get closedIssue => 'closed issue';

  @override
  String get reopenedIssue => 'reopened issue';

  @override
  String get createdPR => 'created pull request';

  @override
  String get mergedPR => 'merged pull request';

  @override
  String get closedPR => 'closed pull request';

  @override
  String get commentedOnIssue => 'commented on issue';

  @override
  String get commentedOnPR => 'commented on pull request';

  @override
  String get forkedRepo => 'forked repository';

  @override
  String get transferredRepo => 'transferred repository';

  @override
  String get deletedRepo => 'deleted repository';

  @override
  String get updatedWiki => 'updated wiki';

  @override
  String get performedAction => 'performed action';

  @override
  String get inRepo => 'in';

  @override
  String get to => 'to';

  @override
  String get from => 'from';

  @override
  String get headBranch => 'Head branch';

  @override
  String get baseBranch => 'Base branch';

  @override
  String get pleaseFillAllFields => 'Please fill all required fields';

  @override
  String get settingsSaved => 'Settings saved';

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
  String get commitMessage => 'Commit message';

  @override
  String get commit => 'Commit';

  @override
  String get commitMessageHint => 'Enter a commit message...';

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
  String get tags => 'Tags';

  @override
  String get noCommits => 'No commits';

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
  String get url => 'URL';
}
