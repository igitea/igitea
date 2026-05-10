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
  String get users => 'ユーザー';

  @override
  String get enterSearchQueryUsers => '検索クエリを入力してユーザーを検索';

  @override
  String get noResults => '結果が見つかりません';

  @override
  String get repositories => 'リポジトリ';

  @override
  String get repositorySections => 'リポジトリセクション';

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
  String get assignee => '担当者';

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
    return '$count フォロワー';
  }

  @override
  String followerCountParams(Object count) {
    return '$count フォロワー';
  }

  @override
  String followingCount(Object count) {
    return '$count フォロー中';
  }

  @override
  String followingCountParams(Object count) {
    return '$count フォロー中';
  }

  @override
  String repositoryCount(Object count) {
    return '$count リポジトリ';
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
    return '最終実行: $time';
  }

  @override
  String lastRunParams(Object time) {
    return '最終実行: $time';
  }

  @override
  String nextRun(Object time) {
    return '次回実行: $time';
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
    return '未読通知: $count';
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
    return '$time 前';
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
  String get restoringSession => 'セッションを復元中...';

  @override
  String get pleaseEnterServerUrl => 'サーバーURLを入力してください';

  @override
  String get pleaseEnterValidUrl => '有効なURLを入力してください';

  @override
  String get connectToGitea => 'Giteaインスタンスに接続';

  @override
  String get usernamePassword => 'ユーザー名とパスワード';

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
  String get pasteAccessToken => '個人アクセストークンを貼り付け';

  @override
  String get pleaseEnterAccessToken => 'アクセストークンを入力してください';

  @override
  String get signInWithToken => 'トークンでログイン';

  @override
  String get welcomeToIgitea => 'iGiteaへようこそ';

  @override
  String get signInToGetStarted => 'サインインして開始';

  @override
  String get quickActions => 'クイック操作';

  @override
  String get yourRepositories => 'あなたのリポジトリ';

  @override
  String get noRepositoriesFound => 'リポジトリが見つかりません';

  @override
  String helloParams(Object full_name) {
    return 'こんにちは、$full_nameさん！';
  }

  @override
  String get user => 'ユーザー';

  @override
  String get private => '非公開';

  @override
  String get untitled => '無題';

  @override
  String get enterSearchQueryRepos => '検索キーワードを入力';

  @override
  String get enterSearchQueryIssues => '検索キーワードを入力してIssueを検索';

  @override
  String get noIssuesFound => 'Issueが見つかりません。';

  @override
  String get failedToLoadProfile => 'プロフィールの読み込みに失敗しました';

  @override
  String get unknownUser => '不明なユーザー';

  @override
  String get admin => '管理者';

  @override
  String get repos => 'リポジトリ';

  @override
  String get followers => 'フォロワー';

  @override
  String get following => 'フォロー中';

  @override
  String get follow => 'フォロー';

  @override
  String get unfollow => 'フォロー解除';

  @override
  String get signOutConfirmMessage => 'サインアウトしてもよろしいですか？';

  @override
  String get chooseTheme => 'テーマを選択';

  @override
  String get loadingSettings => '設定を読み込み中...';

  @override
  String get userManagementComingSoon => 'ユーザー管理機能は近日公開';

  @override
  String get maxResponseItems => '最大応答項目数';

  @override
  String get defaultPagingNum => 'デフォルトページング数';

  @override
  String get defaultMaxBlobSize => 'デフォルト最大Blobサイズ';

  @override
  String get defaultTheme => 'デフォルトテーマ';

  @override
  String get allowedReactions => '許可されたリアクション';

  @override
  String get attachments => '添付ファイル';

  @override
  String get enabled => '有効';

  @override
  String get maxFiles => '最大ファイル数';

  @override
  String get maxSize => '最大サイズ';

  @override
  String get allowedTypes => '許可されたタイプ';

  @override
  String get bytes => 'バイト';

  @override
  String get repository => 'リポジトリ';

  @override
  String get httpGitDisabled => 'HTTP Git無効';

  @override
  String get lfsDisabled => 'LFS無効';

  @override
  String get migrationsDisabled => 'マイグレーション無効';

  @override
  String get mirrorsDisabled => 'ミラー無効';

  @override
  String get starsDisabled => 'スター無効';

  @override
  String get timeTrackingDisabled => '時間追跡無効';

  @override
  String get yes => 'はい';

  @override
  String get no => 'いいえ';

  @override
  String get schedule => 'スケジュール';

  @override
  String get next => '次へ';

  @override
  String get executions => '実行';

  @override
  String get failedToLoadCronTasks => 'Cronタスクの読み込みに失敗しました';

  @override
  String get noCronTasksFound => 'Cronタスクが見つかりません';

  @override
  String cronTriggeredParams(Object name) {
    return 'Cron \"$name\" が実行されました';
  }

  @override
  String get unknown => '不明';

  @override
  String openedParams(Object time) {
    return '$time に作成';
  }

  @override
  String get noDescriptionProvided => '説明がありません';

  @override
  String get failedToLoadComments => 'コメントの読み込みに失敗しました';

  @override
  String get writeComment => 'コメントを書く';

  @override
  String commentsCountParams(Object count) {
    return '$count コメント';
  }

  @override
  String updatedParams(Object time) {
    return '$time に更新';
  }

  @override
  String commentsParams(Object count) {
    return 'コメント ($count)';
  }

  @override
  String get files => 'ファイル';

  @override
  String get mergeable => 'マージ可能';

  @override
  String get merged => 'マージ済み';

  @override
  String get draft => '下書き';

  @override
  String get failedToLoadRepo => 'リポジトリの読み込みに失敗しました';

  @override
  String get copyUrl => 'URLをコピー';

  @override
  String get urlCopied => 'URLをコピーしました';

  @override
  String get emptyDirectory => '空のディレクトリ';

  @override
  String get noIssues => 'Issueなし';

  @override
  String get noPullRequests => 'プルリクエストなし';

  @override
  String get noReleases => 'リリースなし';

  @override
  String get noBranches => 'ブランチなし';

  @override
  String get preRelease => 'プレリリース';

  @override
  String get archived => 'アーカイブ済み';

  @override
  String get defaultBranch => 'デフォルトブランチ';

  @override
  String get copyCode => 'コードをコピー';

  @override
  String get failedToLoadFile => 'ファイルの読み込みに失敗しました';

  @override
  String get filePreviewNotAvailable => 'ファイルプレビューは利用できません';

  @override
  String get download => 'ダウンロード';

  @override
  String get failedToOpenDownloadUrl => 'ダウンロードURLを開けませんでした';

  @override
  String get noNotifications => '通知なし';

  @override
  String get noTitle => 'タイトルなし';

  @override
  String get allNotificationsMarkedAsRead => 'すべての通知を既読にしました';

  @override
  String get createUser => 'ユーザーを作成';

  @override
  String get editUser => 'ユーザーを編集';

  @override
  String get deleteIssue => 'Issueを削除';

  @override
  String get deleteIssueConfirm => 'このIssueを削除してもよろしいですか？この操作は元に戻せません。';

  @override
  String get issueDeleted => 'Issueを削除しました';

  @override
  String get deleteUser => 'ユーザーを削除';

  @override
  String deleteUserConfirmParams(Object username) {
    return 'ユーザー \"$username\" を削除してもよろしいですか？この操作は元に戻せません。';
  }

  @override
  String get userCreated => 'ユーザーを作成しました';

  @override
  String get userUpdated => 'ユーザーを更新しました';

  @override
  String get userDeleted => 'ユーザーを削除しました';

  @override
  String get noUsersFound => 'ユーザーが見つかりません';

  @override
  String get pleaseEnterEmail => 'メールアドレスを入力してください';

  @override
  String get fullName => 'フルネーム';

  @override
  String get mustChangePassword => '初回ログイン時にパスワードを変更する必要があります';

  @override
  String get pleaseEnterTitle => 'タイトルを入力してください';

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
  String get transferredRepo => 'リポジトリを転送しました';

  @override
  String get deletedRepo => 'リポジトリを削除';

  @override
  String get updatedWiki => 'Wikiを更新';

  @override
  String get performedAction => 'アクションを実行しました';

  @override
  String get commitRepo => 'コミットしました';

  @override
  String get renameRepo => 'リポジトリ名を変更';

  @override
  String get starRepo => 'スターを付けた';

  @override
  String get watchRepo => 'ウォッチを開始しました';

  @override
  String get reopenPR => 'PRを再開';

  @override
  String get approvePR => 'PRを承認';

  @override
  String get rejectPR => 'PRを却下しました';

  @override
  String get publishRelease => 'リリースを公開';

  @override
  String get deleteBranch => 'ブランチを削除';

  @override
  String get autoMergePR => 'PRを自動マージ';

  @override
  String get pullReviewDismissed => 'PRレビューを却下しました';

  @override
  String get pullRequestReady => 'PRをレビュー可能としてマークしました';

  @override
  String get mirrorSyncPush => 'プッシュをミラーに同期しました';

  @override
  String get mirrorSyncCreate => '作成をミラーに同期しました';

  @override
  String get mirrorSyncDelete => '削除をミラーに同期しました';

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
  String get privateRepo => 'プライベートリポジトリ';

  @override
  String get privateRepoDesc => 'あなたとコラボレーターのみ表示可能';

  @override
  String get enableIssues => 'Issueを有効化';

  @override
  String get enablePullRequests => 'プルリクエストを有効化';

  @override
  String get enableWiki => 'Wikiを有効化';

  @override
  String get preview => 'プレビュー';

  @override
  String get commitMessage => 'コミットメッセージ';

  @override
  String get commit => 'コミット';

  @override
  String get commitMessageHint => '変更内容を記述（任意）';

  @override
  String get cannotGetFileSha => 'ファイルSHAを取得できません。ファイルを再読み込みしてください。';

  @override
  String get failedToSaveFile => 'ファイルの保存に失敗しました';

  @override
  String get fileSaved => 'ファイルを保存しました';

  @override
  String get discard => '破棄';

  @override
  String get message => 'メッセージ';

  @override
  String get ok => 'OK';

  @override
  String get sha => 'SHA';

  @override
  String get changedFiles => '変更されたファイル';

  @override
  String get tags => 'タグ';

  @override
  String get noCommits => 'コミットなし';

  @override
  String get noTags => 'タグなし';

  @override
  String get protected => '保護済み';

  @override
  String get latestCommit => '最新コミット';

  @override
  String get permissions => '権限';

  @override
  String get canPush => 'プッシュ可能';

  @override
  String get canMerge => 'マージ可能';

  @override
  String get downloads => 'ダウンロード';

  @override
  String get tarball => 'Tarball';

  @override
  String get zipball => 'Zipball';

  @override
  String get downloadTarball => 'Tarballをダウンロード';

  @override
  String get downloadZipball => 'Zipballをダウンロード';

  @override
  String get url => 'URL';

  @override
  String get info => '情報';

  @override
  String get teams => 'チーム';

  @override
  String get noTeams => 'チームなし';

  @override
  String get location => '場所';

  @override
  String get visibility => '可視性';

  @override
  String get assets => 'アセット';

  @override
  String get publishedAt => '公開日時';

  @override
  String get target => 'ターゲット';

  @override
  String get forked => 'フォーク済み';

  @override
  String get forkRepoConfirm => 'アカウントにこのリポジトリのフォークを作成します。';

  @override
  String get editIssue => 'Issueを編集';

  @override
  String get titleRequired => 'タイトルは必須です';

  @override
  String get selectMilestone => 'マイルストーンを選択';

  @override
  String get members => 'メンバー';

  @override
  String get noMembers => 'メンバーなし';

  @override
  String get editOrganization => '組織を編集';

  @override
  String get createOrganization => '組織を作成';

  @override
  String get createRepository => 'リポジトリを作成';

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
  String get initializeWithReadme => 'READMEで初期化';

  @override
  String get initializeWithReadmeDescription => 'READMEファイルを追加してプロジェクトの理解を助けます';

  @override
  String repoCreated(Object repoName) {
    return 'リポジトリ \'$repoName\' を作成しました';
  }

  @override
  String get complete => '完了';

  @override
  String get wiki => 'Wiki';

  @override
  String get newWikiPage => '新しいWikiページ';

  @override
  String get editWikiPage => 'Wikiページを編集';

  @override
  String get deleteWikiPage => 'Wikiページを削除';

  @override
  String get deleteWikiPageConfirm => 'このWikiページを削除してもよろしいですか？この操作は元に戻せません。';

  @override
  String get wikiPageDeleted => 'Wikiページを削除しました';

  @override
  String get wikiPageTitle => 'ページタイトル';

  @override
  String get wikiPageTitleHint => 'e.g. Home';

  @override
  String get wikiPageContent => 'コンテンツ';

  @override
  String get wikiPageContentHint => 'Markdownで記述...';

  @override
  String get noWikiPages => 'Wikiページなし';

  @override
  String get noWikiPagesDescription => 'このリポジトリにはまだWikiページがありません。';

  @override
  String get createFirstWikiPage => '最初のページを作成';

  @override
  String get lastCommit => '最終コミット';

  @override
  String get noContent => '内容なし';

  @override
  String get saved => '保存済み';

  @override
  String get created => '作成済み';

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
  String get milestoneDescription => '説明';

  @override
  String get milestoneDescriptionHint => 'このマイルストーンを説明';

  @override
  String get milestoneDueDate => '期限';

  @override
  String get milestoneState => '状態';

  @override
  String get milestoneStateOpen => 'オープン';

  @override
  String get milestoneStateClosed => 'クローズ';

  @override
  String get total => '合計';

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
  String get webhookSecretHint => 'オプションのシークレットトークン';

  @override
  String get webhookContentType => 'コンテンツタイプ';

  @override
  String get webhookContentTypeJson => 'application/json';

  @override
  String get webhookContentTypeForm => 'application/x-www-form-urlencoded';

  @override
  String get webhookEvents => 'イベント';

  @override
  String get webhookEventsHint => 'このWebhookをトリガーするイベントを選択';

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
  String get webhookLastDelivery => '最終配信';

  @override
  String get webhookSelectAllEvents => 'すべて選択';

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
  String get webhookForkEvents => 'フォーク';

  @override
  String get loginWithOAuth2 => 'OAuth2でログイン';

  @override
  String get oauth2 => 'OAuth2';

  @override
  String get oauth2Description => 'Gitea OAuth2アプリケーションで認証';

  @override
  String get oauth2ClientId => 'クライアントID';

  @override
  String get oauth2ClientSecret => 'クライアントシークレット';

  @override
  String get oauth2RedirectUri => 'リダイレクトURI';

  @override
  String get oauth2RedirectUriHint => 'igitea://oauth/callback';

  @override
  String get oauth2Authorize => '認証ページを開く';

  @override
  String get oauth2ExchangeCode => 'コードをトークンと交換';

  @override
  String get oauth2AuthorizationCode => '認証コード';

  @override
  String get oauth2AuthorizationCodeHint => 'リダイレクトURLからコードを貼り付け';

  @override
  String get oauth2TokenRefreshed => 'トークンを更新しました';

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
  String get baseRef => 'ベース（古い）';

  @override
  String get headRef => 'ヘッド（新しい）';

  @override
  String get compare => '比較';

  @override
  String get actions => 'Actions';

  @override
  String get noActions => 'ワークフローなし';

  @override
  String get run => '実行';

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
  String get unknownSection => '不明なセクション';

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
  String get addReviewerHint => 'レビュアー名を入力';

  @override
  String get subscribe => '購読';

  @override
  String get unsubscribe => '購読解除';

  @override
  String get subscribed => '購読中';

  @override
  String get unsubscribed => '購読解除済み';

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
  String get teamAdminAccess => 'チーム管理者アクセス';

  @override
  String get details => '詳細';

  @override
  String get id => 'ID';

  @override
  String get searchRepositoriesHint => 'リポジトリを検索';

  @override
  String get publicKey => '公開鍵';

  @override
  String get failedToGetAccessToken => 'アクセストークンの取得に失敗しました';

  @override
  String get fileNotFound => 'ファイルが見つかりません';

  @override
  String get noSshKeysFound => 'SSH鍵が見つかりません';

  @override
  String get other => 'その他';

  @override
  String get usernameRequired => 'ユーザー名は必須です';

  @override
  String get myLaptopHint => 'マイラップトップ';

  @override
  String get sshPublicKeyHint => '公開SSH鍵をここに貼り付け';

  @override
  String get noChangesFoundForFile => 'このファイルに変更は見つかりません';

  @override
  String commitUpdateFile(Object fileName) {
    return '$fileName を更新';
  }

  @override
  String get api => 'API';

  @override
  String get ui => 'UI';

  @override
  String get justNow => 'たった今';

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
  String get applyLabelSet => 'ラベルセットを適用';

  @override
  String get applyLabelSetDescription => '定義済みのラベルセットを選択して一括作成します。';

  @override
  String applyAllLabels(Object count) {
    return 'すべて適用（$count ラベル）';
  }

  @override
  String applyAllLabelsParams(Object count) {
    return 'すべて適用（$count ラベル）';
  }

  @override
  String get creating => '作成中...';

  @override
  String get addCustomLabel => 'カスタムラベルを追加';

  @override
  String get selectTemplate => 'テンプレートを選択';

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
  String get teamCanCreateOrgRepos => '組織リポジトリを作成可能';

  @override
  String get teamIncludesAllRepos => 'すべてのリポジトリを含む';

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
  String get gpgKeys => 'GPGキー';

  @override
  String get addGpgKey => 'GPGキーを追加';

  @override
  String get gpgKeyHint => '-----BEGIN PGP PUBLIC KEY BLOCK-----';

  @override
  String get gpgKeyAdded => 'GPGキーを追加しました';

  @override
  String get gpgKeyDeleted => 'GPGキーを削除しました';

  @override
  String get deleteGpgKey => 'GPGキーを削除';

  @override
  String get deleteGpgKeyConfirm => 'このGPGキーを削除してもよろしいですか？';

  @override
  String get noGpgKeys => 'GPGキーがありません';

  @override
  String get sign => '署名';

  @override
  String get certify => '認証';

  @override
  String get verified => '確認済み';

  @override
  String get tagProtections => 'タグ保護';

  @override
  String get manageTagProtections => 'タグ保護ルールを管理';

  @override
  String get createTagProtection => 'タグ保護を作成';

  @override
  String get namePattern => '名前パターン';

  @override
  String get tagProtectionCreated => 'タグ保護を作成しました';

  @override
  String get tagProtectionDeleted => 'タグ保護を削除しました';

  @override
  String get deleteTagProtection => 'タグ保護を削除';

  @override
  String get deleteTagProtectionConfirm => 'このタグ保護を削除してもよろしいですか？';

  @override
  String get noTagProtections => 'タグ保護がありません';

  @override
  String get allowedUsers => '許可ユーザー';

  @override
  String get dependencies => '依存関係';

  @override
  String get addDependency => '依存関係を追加';

  @override
  String get dependencyAdded => '依存関係を追加しました';

  @override
  String get dependencyRemoved => '依存関係を削除しました';

  @override
  String get removeDependency => '依存関係を削除';

  @override
  String get removeDependencyConfirm => 'この依存関係を削除しますか？';

  @override
  String get noDependencies => '依存関係がありません';

  @override
  String get blocks => 'ブロック';

  @override
  String get dependsOn => '依存先';

  @override
  String get issueNumberHint => 'Issue #';

  @override
  String get events => 'イベント';

  @override
  String get items => '項目';

  @override
  String get commented => 'コメントしました';

  @override
  String get labelUpdated => 'ラベルを更新しました';

  @override
  String get milestoneUpdated => 'マイルストーンを更新しました';

  @override
  String get assigneeUpdated => '担当者を更新しました';

  @override
  String get reopened => '再開しました';

  @override
  String get stargazers => 'スターしたユーザー';

  @override
  String get subscribers => '購読者';

  @override
  String get noStargazers => 'まだスターがありません';

  @override
  String get noSubscribers => 'まだ購読者がありません';

  @override
  String get adminHooksTitle => 'システムフック';

  @override
  String get adminCronTitle => 'Cronタスク';

  @override
  String get adminRunnersTitle => 'Actionsランナー';

  @override
  String get adminEmailsTitle => 'メール';

  @override
  String get adminBadgesTitle => 'バッジ';

  @override
  String get adminRunCron => '今すぐ実行';

  @override
  String get adminGetToken => '登録トークンを取得';

  @override
  String get adminNoHooks => 'システムフックが設定されていません';

  @override
  String get adminNoCron => 'Cronタスクがありません';

  @override
  String get adminNoRunners => 'Actionsランナーがありません';

  @override
  String get adminNoEmails => 'メールがありません';

  @override
  String get adminNoBadges => 'バッジがありません';

  @override
  String get adminBadgeUsername => 'ユーザー名';

  @override
  String get adminBadgeDescription => '説明';

  @override
  String get oauthAppsTitle => 'OAuthアプリケーション';

  @override
  String get oauthNoApps => 'OAuthアプリケーションがありません';

  @override
  String get oauthCreateApp => 'OAuthアプリを作成';

  @override
  String get oauthRedirectUri => 'リダイレクトURI';

  @override
  String get oauthDeleteAppConfirm => 'OAuthアプリケーションを削除';

  @override
  String get name => '名前';

  @override
  String get confirmDelete => '削除を確認';

  @override
  String get actionsSecretsTitle => 'Actions Secrets';

  @override
  String get actionsVariablesTitle => 'Actions Variables';

  @override
  String get actionsNoSecrets => 'Secretsが設定されていません';

  @override
  String get actionsNoVariables => 'Variablesが設定されていません';

  @override
  String get actionsCreateSecret => 'Secretを作成';

  @override
  String get actionsCreateVariable => 'Variableを作成';

  @override
  String get actionsSecretName => 'Secret名';

  @override
  String get actionsSecretValue => 'Secret値';

  @override
  String get actionsVariableName => 'Variable名';

  @override
  String get actionsVariableValue => 'Variable値';

  @override
  String get actionsDeleteSecretConfirm => 'このSecretを削除しますか？';

  @override
  String get actionsDeleteVariableConfirm => 'このVariableを削除しますか？';

  @override
  String get deleted => '削除済み';

  @override
  String get overdue => '期限超過';

  @override
  String get addTopic => 'トピックを追加';

  @override
  String get importRepository => 'リポジトリをインポート';

  @override
  String get import => 'インポート';

  @override
  String get repoImported => 'リポジトリをインポートしました';

  @override
  String get cloneUrl => 'クローンURL';

  @override
  String get repoOwner => '所有者';

  @override
  String get gitService => 'Gitサービス';

  @override
  String get authentication => '認証';

  @override
  String get authUsername => '認証ユーザー名';

  @override
  String get authPassword => '認証パスワード';

  @override
  String get authToken => '認証トークン';

  @override
  String get migrationOptions => 'オプション';

  @override
  String get migrateData => 'インポートするデータ';

  @override
  String get mirror => 'ミラー';

  @override
  String get mirrorInterval => 'ミラー間隔';

  @override
  String get requiredField => 'この項目は必須です';

  @override
  String get personal => '個人';

  @override
  String get deleteOrganization => '組織を削除';

  @override
  String get deleteOrganizationConfirm => 'この組織を削除してもよろしいですか？この操作は元に戻せません。';

  @override
  String get organizationDeleted => '組織を削除しました';

  @override
  String get accessTokens => 'アクセストークン';

  @override
  String get createToken => 'トークンを作成';

  @override
  String get tokenName => 'トークン名';

  @override
  String get tokenCreated => 'トークンを作成しました';

  @override
  String get tokenValueWarning => 'このトークンを今すぐコピーしてください。後で表示することはできません。';

  @override
  String get failedToCreateToken => 'トークンの作成に失敗しました';

  @override
  String get deleteToken => 'トークンを削除';

  @override
  String get deleteTokenConfirm => '削除しますか？';

  @override
  String get tokenDeleted => 'トークンを削除しました';

  @override
  String get noTokens => 'アクセストークンがありません';

  @override
  String get scopes => 'スコープ';

  @override
  String get selectAll => 'すべて選択';

  @override
  String get deselectAll => 'すべて解除';

  @override
  String get reactions => 'Reactions';

  @override
  String get watch => 'Watch';

  @override
  String get unwatch => 'Unwatch';

  @override
  String get savedFilters => 'Saved Filters';

  @override
  String get saveCurrentFilter => 'Save current filter';

  @override
  String get deleteFilter => 'Delete filter';

  @override
  String get filterName => 'Filter name';

  @override
  String get noSavedFilters => 'No saved filters yet';
}
