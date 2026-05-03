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
  String get users => 'Users';

  @override
  String get enterSearchQueryUsers => 'Enter a search query to find users';

  @override
  String get noResults => '結果が見つかりません';

  @override
  String get repositories => 'リポジトリ';

  @override
  String get repositorySections => 'Repository Sections';

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
    return '$date に参加';
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
  String get myIssues => 'マイ Issue';

  @override
  String get myRepos => 'マイリポジトリ';

  @override
  String get myStars => 'スター';

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
  String get pleaseEnterServerUrl => 'サーバーURLを入力してください';

  @override
  String get pleaseEnterValidUrl => '有効なURLを入力してください';

  @override
  String get connectToGitea => 'Giteaインスタンスに接続';

  @override
  String get usernamePassword => 'Username & Password';

  @override
  String get serverUrl => 'サーバーURL';

  @override
  String get enterUsername => 'ユーザー名を入力';

  @override
  String get pleaseEnterUsername => 'ユーザー名を入力してください';

  @override
  String get enterPassword => 'パスワードを入力';

  @override
  String get pleaseEnterPassword => 'パスワードを入力してください';

  @override
  String get pasteAccessToken => 'Paste your personal access token';

  @override
  String get pleaseEnterAccessToken => 'Please enter an access token';

  @override
  String get signInWithToken => 'トークンでログイン';

  @override
  String get welcomeToIgitea => 'Welcome to iGitea';

  @override
  String get signInToGetStarted => 'Sign in to get started';

  @override
  String get quickActions => 'クイック操作';

  @override
  String get yourRepositories => 'あなたのリポジトリ';

  @override
  String get noRepositoriesFound => 'リポジトリが見つかりません';

  @override
  String helloParams(Object full_name) {
    return 'Hello, $full_name!';
  }

  @override
  String get user => 'User';

  @override
  String get private => '非公開';

  @override
  String get untitled => '無題';

  @override
  String get enterSearchQueryRepos => '検索キーワードを入力';

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
  String get repos => 'リポジトリ';

  @override
  String get followers => 'フォロワー';

  @override
  String get following => 'フォロー中';

  @override
  String get follow => 'Follow';

  @override
  String get unfollow => 'Unfollow';

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
  String get repository => 'リポジトリ';

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
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

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
  String get unknown => '不明';

  @override
  String openedParams(Object time) {
    return 'opened $time';
  }

  @override
  String get noDescriptionProvided => '説明がありません';

  @override
  String get failedToLoadComments => 'Failed to load comments';

  @override
  String get writeComment => 'コメントを書く';

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
  String get draft => '下書き';

  @override
  String get failedToLoadRepo => 'Failed to load repository';

  @override
  String get copyUrl => 'Copy URL';

  @override
  String get urlCopied => 'URL copied';

  @override
  String get emptyDirectory => 'Empty directory';

  @override
  String get noIssues => 'Issueなし';

  @override
  String get noPullRequests => 'No pull requests';

  @override
  String get noReleases => 'No releases';

  @override
  String get noBranches => 'No branches';

  @override
  String get preRelease => 'Pre-release';

  @override
  String get archived => 'アーカイブ済み';

  @override
  String get defaultBranch => 'デフォルトブランチ';

  @override
  String get copyCode => 'Copy code';

  @override
  String get failedToLoadFile => 'Failed to load file';

  @override
  String get filePreviewNotAvailable => 'File preview not available';

  @override
  String get download => 'ダウンロード';

  @override
  String get failedToOpenDownloadUrl => 'Failed to open download URL';

  @override
  String get noNotifications => '通知なし';

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
  String get noActivity => 'アクティビティなし';

  @override
  String get createdRepo => 'リポジトリを作成';

  @override
  String get pushedTag => 'タグをプッシュ';

  @override
  String get deletedTag => 'タグを削除';

  @override
  String get createdIssue => 'Issueを作成';

  @override
  String get closedIssue => 'Issueをクローズ';

  @override
  String get reopenedIssue => 'Issueを再開';

  @override
  String get createdPR => 'PRを作成';

  @override
  String get mergedPR => 'PRをマージ';

  @override
  String get closedPR => 'PRをクローズ';

  @override
  String get commentedOnIssue => 'Issueにコメント';

  @override
  String get commentedOnPR => 'PRにコメント';

  @override
  String get forkedRepo => 'フォークしました';

  @override
  String get transferredRepo => 'transferred repository';

  @override
  String get deletedRepo => 'リポジトリを削除';

  @override
  String get updatedWiki => 'Wikiを更新';

  @override
  String get performedAction => 'performed action';

  @override
  String get commitRepo => 'committed to';

  @override
  String get renameRepo => 'リポジトリ名を変更';

  @override
  String get starRepo => 'スターを付けた';

  @override
  String get watchRepo => 'started watching repository';

  @override
  String get reopenPR => 'PRを再開';

  @override
  String get approvePR => 'PRを承認';

  @override
  String get rejectPR => 'rejected pull request';

  @override
  String get publishRelease => 'リリースを公開';

  @override
  String get deleteBranch => 'ブランチを削除';

  @override
  String get autoMergePR => 'PRを自動マージ';

  @override
  String get pullReviewDismissed => 'dismissed pull request review';

  @override
  String get pullRequestReady => 'marked pull request as ready for review';

  @override
  String get mirrorSyncPush => 'synced push to mirror';

  @override
  String get mirrorSyncCreate => 'synced create to mirror';

  @override
  String get mirrorSyncDelete => 'synced delete to mirror';

  @override
  String get inRepo => 'で';

  @override
  String get to => 'へ';

  @override
  String get from => 'から';

  @override
  String get headBranch => '送信元ブランチ';

  @override
  String get baseBranch => '送信先ブランチ';

  @override
  String get pleaseFillAllFields => '必須項目をすべて入力してください';

  @override
  String get settingsSaved => '設定を保存しました';

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
  String get preview => 'プレビュー';

  @override
  String get commitMessage => 'Commit Message';

  @override
  String get commit => 'コミット';

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
  String get tags => 'タグ';

  @override
  String get noCommits => 'コミットなし';

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

  @override
  String get info => 'Info';

  @override
  String get teams => 'Teams';

  @override
  String get noTeams => 'チームなし';

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
  String get forked => 'Forked';

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
  String get noMembers => 'メンバーなし';

  @override
  String get editOrganization => 'Edit Organization';

  @override
  String get createOrganization => 'Create Organization';

  @override
  String get createRepository => 'Create Repository';

  @override
  String get repositoryName => 'リポジトリ名';

  @override
  String get repositoryNameHint => 'my-awesome-repo';

  @override
  String get repositoryNameRequired => 'リポジトリ名は必須です';

  @override
  String get descriptionHint => 'リポジトリの簡単な説明';

  @override
  String get public => '公開';

  @override
  String get publicDescription => 'インターネット上の誰でもこのリポジトリを見ることができます';

  @override
  String get privateDescription => 'あなたが誰に閲覧・コミットを許可するか選択できます';

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
  String get noWikiPages => 'Wikiページなし';

  @override
  String get noWikiPagesDescription =>
      'This repository doesn\'t have any wiki pages yet.';

  @override
  String get createFirstWikiPage => 'Create First Page';

  @override
  String get lastCommit => 'Last commit';

  @override
  String get noContent => '内容なし';

  @override
  String get saved => 'Saved';

  @override
  String get created => 'Created';

  @override
  String get createMilestone => 'マイルストーンを作成';

  @override
  String get editMilestone => 'マイルストーンを編集';

  @override
  String get deleteMilestone => 'マイルストーンを削除';

  @override
  String get deleteMilestoneConfirm => 'このマイルストーンを削除してもよろしいですか？';

  @override
  String get milestoneDeleted => 'マイルストーンを削除しました';

  @override
  String get milestoneTitle => 'タイトル';

  @override
  String get milestoneDescription => 'Description';

  @override
  String get milestoneDescriptionHint => 'Describe this milestone';

  @override
  String get milestoneDueDate => '期限';

  @override
  String get milestoneState => '状態';

  @override
  String get milestoneStateOpen => 'オープン';

  @override
  String get milestoneStateClosed => 'クローズ';

  @override
  String get total => 'Total';

  @override
  String get clear => 'クリア';

  @override
  String get webhooks => 'Webhooks';

  @override
  String get webhook => 'Webhook';

  @override
  String get noWebhooks => 'Webhookなし';

  @override
  String get createWebhook => 'Webhookを作成';

  @override
  String get editWebhook => 'Webhookを編集';

  @override
  String get deleteWebhook => 'Webhookを削除';

  @override
  String get deleteWebhookConfirm => 'このWebhookを削除してもよろしいですか？';

  @override
  String get webhookDeleted => 'Webhookを削除しました';

  @override
  String get webhookUrl => 'URL';

  @override
  String get webhookUrlHint => 'https://example.com/webhook';

  @override
  String get webhookSecret => 'シークレット';

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
  String get webhookActive => 'アクティブ';

  @override
  String get webhookInactive => '非アクティブ';

  @override
  String get webhookType => 'タイプ';

  @override
  String get webhookCreatedAt => '作成日';

  @override
  String get webhookUpdatedAt => '更新日';

  @override
  String get webhookLastDelivery => 'Last Delivery';

  @override
  String get webhookSelectAllEvents => 'Select All';

  @override
  String get webhookPushEvents => 'プッシュ';

  @override
  String get webhookPullRequestEvents => 'Pull Request';

  @override
  String get webhookIssuesEvents => 'Issue';

  @override
  String get webhookCreateEvents => '作成';

  @override
  String get webhookDeleteEvents => '削除';

  @override
  String get webhookReleaseEvents => 'リリース';

  @override
  String get webhookWikiEvents => 'Wiki';

  @override
  String get webhookStarEvents => 'スター';

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
  String get createLabel => 'ラベルを作成';

  @override
  String get editLabel => 'ラベルを編集';

  @override
  String get deleteLabel => 'ラベルを削除';

  @override
  String get deleteLabelConfirm => 'このラベルを削除してもよろしいですか？';

  @override
  String get labelDeleted => 'ラベルを削除しました';

  @override
  String get labelName => '名前';

  @override
  String get labelNameHint => '例: bug';

  @override
  String get labelDescription => '説明';

  @override
  String get labelDescriptionHint => '説明（任意）';

  @override
  String get labelColor => '色';

  @override
  String get labelColorHint => '16進数カラー（例: #FF0000）';

  @override
  String get filesChanged => '変更されたファイル';

  @override
  String get noFilesChanged => '変更されたファイルはありません';

  @override
  String get viewDiff => '差分を見る';

  @override
  String get unifiedView => '統一表示';

  @override
  String get splitView => '分割表示';

  @override
  String get compareVersions => 'バージョン比較';

  @override
  String get baseRef => 'Base (older)';

  @override
  String get headRef => 'Head (newer)';

  @override
  String get compare => '比較';

  @override
  String get actions => 'Actions';

  @override
  String get noActions => 'ワークフローなし';

  @override
  String get run => 'Run';

  @override
  String get status => 'ステータス';

  @override
  String get jobs => 'ジョブ';

  @override
  String get noJobs => 'ジョブなし';

  @override
  String get artifacts => 'アーティファクト';

  @override
  String get branch => 'ブランチ';

  @override
  String get author => '作成者';

  @override
  String get filterByActor => '実行者で絞り込み';

  @override
  String get filterByStatus => 'ステータスで絞り込み';

  @override
  String get reviewChanges => '変更をレビュー';

  @override
  String get reviewBody => 'レビューコメント';

  @override
  String get reviews => 'レビュー';

  @override
  String get approve => '承認';

  @override
  String get requestChanges => '変更を依頼';

  @override
  String get comment => 'コメント';

  @override
  String get blame => ' blame';

  @override
  String get diffView => '差分表示';

  @override
  String get pickColor => '色を選択';

  @override
  String get sshKeys => 'SSH鍵';

  @override
  String get allRepos => 'すべてのリポジトリ';

  @override
  String get configuration => '設定';

  @override
  String get none => 'なし';

  @override
  String get more => 'もっと';

  @override
  String get units => '単位';

  @override
  String get permission => '権限';

  @override
  String get repoList => 'リポジトリ一覧';

  @override
  String get noChanges => '変更なし';

  @override
  String get limited => '制限付き';

  @override
  String get unknownSection => 'Unknown section';

  @override
  String get deleteKey => '鍵を削除';

  @override
  String get deleteKeyConfirm => 'このSSH鍵を削除してもよろしいですか？';

  @override
  String get keyDeleted => '鍵を削除しました';

  @override
  String get addSshKey => 'SSH鍵を追加';

  @override
  String get add => '追加';

  @override
  String get keyAdded => '鍵を追加しました';

  @override
  String get deleteCommentConfirm => 'このコメントを削除してもよろしいですか？';

  @override
  String get requestReviewers => 'レビュアーを依頼';

  @override
  String get addReviewerHint => 'Enter reviewer username';

  @override
  String get subscribe => '購読';

  @override
  String get unsubscribe => '購読解除';

  @override
  String get subscribed => 'Subscribed';

  @override
  String get unsubscribed => 'Unsubscribed';

  @override
  String get setDueDate => '期限を設定';

  @override
  String get removeDueDate => '期限を削除';

  @override
  String get topics => 'トピック';

  @override
  String get noTopics => 'トピックなし';

  @override
  String get branchProtection => 'ブランチ保護';

  @override
  String get protectBranch => 'ブランチを保護';

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
  String get searchRepositoriesHint => 'リポジトリを検索';

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
  String get packages => 'パッケージ';

  @override
  String get noPackages => 'パッケージが見つかりません';

  @override
  String get packageType => '種類';

  @override
  String get packageVersion => 'バージョン';

  @override
  String get packageFiles => 'ファイル';

  @override
  String get packageSize => 'サイズ';

  @override
  String get packageCreator => '作成者';

  @override
  String get packageCreated => '作成日時';

  @override
  String get packageRepository => 'リポジトリ';

  @override
  String get deletePackage => 'パッケージを削除';

  @override
  String get deletePackageConfirm => 'このパッケージバージョンを削除してもよろしいですか？この操作は元に戻せません。';

  @override
  String get packageDeleted => 'パッケージバージョンが削除されました';

  @override
  String get allTypes => 'すべて';

  @override
  String get installation => 'インストール';

  @override
  String get packageUrl => 'パッケージURL';

  @override
  String get copy => 'コピー';

  @override
  String get totalSize => '合計サイズ';

  @override
  String get versions => 'バージョン';

  @override
  String get noVersions => 'バージョンなし';

  @override
  String get createRelease => 'リリースを作成';

  @override
  String get editRelease => 'リリースを編集';

  @override
  String get deleteRelease => 'リリースを削除';

  @override
  String get deleteReleaseConfirm => 'このリリースを削除してもよろしいですか？この操作は元に戻せません。';

  @override
  String get releaseTagName => 'タグ名';

  @override
  String get releaseTagNameRequired => 'タグ名は必須です';

  @override
  String get releaseTitle => 'リリースタイトル';

  @override
  String get releaseBody => 'リリースノート';

  @override
  String get targetCommitish => 'ターゲット';

  @override
  String get tagMessage => 'タグメッセージ';

  @override
  String get releaseCreated => 'リリースを作成しました';

  @override
  String get releaseUpdated => 'リリースを更新しました';

  @override
  String get releaseDeleted => 'リリースを削除しました';

  @override
  String get chooseTag => 'タグを選択';

  @override
  String get defaultLabels => 'クイック選択';

  @override
  String get applyLabelSet => 'Apply label set';

  @override
  String get applyLabelSetDescription =>
      'Select a predefined label set to create all labels at once.';

  @override
  String applyAllLabels(Object count) {
    return 'Apply all ($count labels)';
  }

  @override
  String applyAllLabelsParams(Object count) {
    return 'Apply all ($count labels)';
  }

  @override
  String get creating => 'Creating...';

  @override
  String get addCustomLabel => 'Add custom label';

  @override
  String get selectTemplate => 'Select a template';

  @override
  String get createTeam => 'チームを作成';

  @override
  String get editTeam => 'チームを編集';

  @override
  String get deleteTeam => 'チームを削除';

  @override
  String get deleteTeamConfirm => 'このチームを削除してもよろしいですか？';

  @override
  String get teamName => 'チーム名';

  @override
  String get teamNameRequired => 'チーム名は必須です';

  @override
  String get teamDescription => '説明';

  @override
  String get teamPermission => '権限';

  @override
  String get searchMembers => 'ユーザー検索';

  @override
  String get addMember => 'メンバー追加';

  @override
  String get removeMember => '削除';

  @override
  String removeMemberConfirmParams(Object username) {
    return '$username をチームから削除しますか？';
  }

  @override
  String get teamCreated => 'チームを作成しました';

  @override
  String get teamUpdated => 'チームを更新しました';

  @override
  String get teamDeleted => 'チームを削除しました';

  @override
  String get memberAdded => 'メンバーを追加しました';

  @override
  String get memberRemoved => 'メンバーを削除しました';

  @override
  String get noSearchResults => 'ユーザーが見つかりません';

  @override
  String get teamCanCreateOrgRepos => 'Can create org repos';

  @override
  String get teamIncludesAllRepos => 'Includes all repositories';

  @override
  String get collaborators => 'コラボレーター';

  @override
  String get noCollaborators => 'なし';

  @override
  String get addCollaborator => '追加';

  @override
  String get removeCollaborator => '削除';

  @override
  String removeCollaboratorConfirmParams(Object username) {
    return '$username を削除しますか？';
  }

  @override
  String get collaboratorAdded => '追加しました';

  @override
  String get collaboratorRemoved => '削除しました';

  @override
  String get contentType => 'コンテンツタイプ';

  @override
  String get active => '有効';

  @override
  String get emails => 'メールアドレス';

  @override
  String get addEmail => 'メール追加';

  @override
  String get gpgKeys => 'GPG Keys';

  @override
  String get addGpgKey => 'Add GPG Key';

  @override
  String get gpgKeyHint => '-----BEGIN PGP PUBLIC KEY BLOCK-----';

  @override
  String get gpgKeyAdded => 'GPG key added';

  @override
  String get gpgKeyDeleted => 'GPG key deleted';

  @override
  String get deleteGpgKey => 'Delete GPG Key';

  @override
  String get deleteGpgKeyConfirm =>
      'Are you sure you want to delete this GPG key?';

  @override
  String get noGpgKeys => 'No GPG keys';

  @override
  String get sign => 'Sign';

  @override
  String get certify => 'Certify';

  @override
  String get verified => 'Verified';

  @override
  String get tagProtections => 'Tag Protections';

  @override
  String get manageTagProtections => 'Manage tag protection rules';

  @override
  String get createTagProtection => 'Create Tag Protection';

  @override
  String get namePattern => 'Name Pattern';

  @override
  String get tagProtectionCreated => 'Tag protection created';

  @override
  String get tagProtectionDeleted => 'Tag protection deleted';

  @override
  String get deleteTagProtection => 'Delete Tag Protection';

  @override
  String get deleteTagProtectionConfirm =>
      'Are you sure you want to delete this tag protection?';

  @override
  String get noTagProtections => 'No tag protections';

  @override
  String get allowedUsers => 'Allowed users';

  @override
  String get dependencies => 'Dependencies';

  @override
  String get addDependency => 'Add Dependency';

  @override
  String get dependencyAdded => 'Dependency added';

  @override
  String get dependencyRemoved => 'Dependency removed';

  @override
  String get removeDependency => 'Remove Dependency';

  @override
  String get removeDependencyConfirm => 'Remove this dependency?';

  @override
  String get noDependencies => 'No dependencies';

  @override
  String get blocks => 'Blocks';

  @override
  String get dependsOn => 'Depends on';

  @override
  String get issueNumberHint => 'Issue #';

  @override
  String get events => 'events';

  @override
  String get items => 'items';

  @override
  String get commented => 'commented';

  @override
  String get labelUpdated => 'Label updated';

  @override
  String get milestoneUpdated => 'Milestone updated';

  @override
  String get assigneeUpdated => 'Assignee updated';

  @override
  String get reopened => 'Reopened';

  @override
  String get stargazers => 'Stargazers';

  @override
  String get subscribers => 'Subscribers';

  @override
  String get noStargazers => 'No stargazers yet';

  @override
  String get noSubscribers => 'No subscribers yet';
}
