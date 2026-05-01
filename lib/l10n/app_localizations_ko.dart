// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'iGitea';

  @override
  String get language => '언어';

  @override
  String get settings => '설정';

  @override
  String get profile => '프로필';

  @override
  String get search => '검색';

  @override
  String get notifications => '알림';

  @override
  String get dashboard => '대시보드';

  @override
  String get signOut => '로그아웃';

  @override
  String get signIn => '로그인';

  @override
  String get username => '사용자 이름';

  @override
  String get password => '비밀번호';

  @override
  String get login => '로그인';

  @override
  String get loginWithToken => '토큰으로 로그인';

  @override
  String get token => '토큰';

  @override
  String get cancel => '취소';

  @override
  String get confirm => '확인';

  @override
  String get save => '저장';

  @override
  String get delete => '삭제';

  @override
  String get edit => '편집';

  @override
  String get create => '생성';

  @override
  String get close => '닫기';

  @override
  String get reopen => '다시 열기';

  @override
  String get merge => '머지';

  @override
  String get submit => '제출';

  @override
  String get retry => '재시도';

  @override
  String get loading => '로딩 중...';

  @override
  String get error => '오류';

  @override
  String get noData => '데이터 없음';

  @override
  String get searchRepos => '저장소 검색';

  @override
  String get searchIssues => '이슈 검색';

  @override
  String get noResults => '결과 없음';

  @override
  String get repositories => '저장소';

  @override
  String get repositorySections => 'Repository Sections';

  @override
  String get issues => '이슈';

  @override
  String get pullRequests => '풀 요청';

  @override
  String get releases => '릴리스';

  @override
  String get branches => '브랜치';

  @override
  String get code => '코드';

  @override
  String get stars => '스타';

  @override
  String get forks => '포크';

  @override
  String get watchers => '워처';

  @override
  String get open => '열림';

  @override
  String get closed => '닫힘';

  @override
  String get all => '전체';

  @override
  String get mergePullRequest => '풀 요청 머지';

  @override
  String get mergeConfirmMessage => '이 풀 요청을 머지하시겠습니까?';

  @override
  String issueNumber(Object issueNumber) {
    return '이슈 #$issueNumber';
  }

  @override
  String pullRequestNumber(Object pullRequestNumber) {
    return 'PR #$pullRequestNumber';
  }

  @override
  String get comments => '댓글';

  @override
  String get addComment => '댓글 추가...';

  @override
  String get sendComment => '보내기';

  @override
  String get noComments => '댓글이 없습니다';

  @override
  String get labels => '레이블';

  @override
  String get milestones => '마일스톤';

  @override
  String get assignees => '담당자';

  @override
  String get assignee => 'Assignee';

  @override
  String get participants => '참가자';

  @override
  String get timeline => '타임라인';

  @override
  String get theme => '테마';

  @override
  String get themeLight => '라이트';

  @override
  String get themeDark => '다크';

  @override
  String get themeSystem => '시스템';

  @override
  String get account => '계정';

  @override
  String get accountInfo => '계정 정보';

  @override
  String get email => '이메일';

  @override
  String get website => '웹사이트';

  @override
  String get bio => '자기소개';

  @override
  String joinedOn(Object date) {
    return 'Joined on $date';
  }

  @override
  String joinedOnParams(Object date) {
    return '$date 가입';
  }

  @override
  String followerCount(Object count) {
    return '$count followers';
  }

  @override
  String followerCountParams(Object count) {
    return '$count 팔로워';
  }

  @override
  String followingCount(Object count) {
    return '$count following';
  }

  @override
  String followingCountParams(Object count) {
    return '$count 팔로잉';
  }

  @override
  String repositoryCount(Object count) {
    return '$count repositories';
  }

  @override
  String repositoryCountParams(Object count) {
    return '$count 리포지토리';
  }

  @override
  String get starredRepos => '스타한 리포지토리';

  @override
  String get organisations => '조직';

  @override
  String get adminPanel => '관리 패널';

  @override
  String get userManagement => '사용자 관리';

  @override
  String get serverSettings => '서버 설정';

  @override
  String get cronTasks => 'Cron 작업';

  @override
  String get apiSettings => 'API 설정';

  @override
  String get uiSettings => 'UI 설정';

  @override
  String get attachmentSettings => '첨부 파일 설정';

  @override
  String get repoSettings => '리포지토리 설정';

  @override
  String get runNow => '지금 실행';

  @override
  String lastRun(Object time) {
    return 'Last run: $time';
  }

  @override
  String lastRunParams(Object time) {
    return '마지막 실행: $time';
  }

  @override
  String nextRun(Object time) {
    return 'Next run: $time';
  }

  @override
  String nextRunParams(Object time) {
    return '다음 실행: $time';
  }

  @override
  String get recentActivity => '최근 활동';

  @override
  String get myIssues => '내 이슈';

  @override
  String get myRepos => '내 저장소';

  @override
  String get myStars => '즐겨찾기';

  @override
  String get feed => '피드';

  @override
  String get markAllRead => '모두 읽음으로 표시';

  @override
  String get markRead => '읽음으로 표시';

  @override
  String unreadNotifications(Object count) {
    return 'Unread notifications: $count';
  }

  @override
  String unreadNotificationsParams(Object count) {
    return '읽지 않은 알림: $count';
  }

  @override
  String get noUnreadNotifications => '읽지 않은 알림 없음';

  @override
  String get readMore => '더 읽기';

  @override
  String ago(Object time) {
    return '$time ago';
  }

  @override
  String agoParams(Object time) {
    return '$time 전';
  }

  @override
  String get fileBrowser => '파일 브라우저';

  @override
  String get readme => 'README';

  @override
  String get commits => '커밋';

  @override
  String get commitHistory => '커밋 기록';

  @override
  String get viewFile => '파일 보기';

  @override
  String get downloadFile => '파일 다운로드';

  @override
  String get copyPath => '경로 복사';

  @override
  String get fileName => '파일 이름';

  @override
  String get fileSize => '파일 크기';

  @override
  String get lastModified => '최종 수정';

  @override
  String get openInBrowser => '브라우저에서 열기';

  @override
  String get signInRequired => '로그인 필요';

  @override
  String get signInMessage => '계속하려면 로그인하세요';

  @override
  String get loginFailed => '로그인 실패';

  @override
  String get networkError => '네트워크 오류';

  @override
  String get unknownError => '알 수 없는 오류가 발생했습니다';

  @override
  String get refresh => '새로고침';

  @override
  String get copyToClipboard => '클립보드에 복사';

  @override
  String get copied => '복사됨!';

  @override
  String get filterIssues => '이슈 필터';

  @override
  String get newIssue => '새 이슈';

  @override
  String get newPullRequest => '새 풀 요청';

  @override
  String get title => '제목';

  @override
  String get description => '설명';

  @override
  String get body => '본문';

  @override
  String get state => '상태';

  @override
  String get priority => '우선순위';

  @override
  String get milestone => '마일스톤';

  @override
  String get createdAt => '생성일';

  @override
  String get updatedAt => '수정일';

  @override
  String get dueDate => '마감일';

  @override
  String get noMilestones => '마일스톤 없음';

  @override
  String get noLabels => '레이블 없음';

  @override
  String get openIssue => '이슈 열기';

  @override
  String get closeIssue => '이슈 닫기';

  @override
  String get reopenIssue => '이슈 다시 열기';

  @override
  String get deleteComment => '댓글 삭제';

  @override
  String get editComment => '댓글 편집';

  @override
  String get deleteRepo => '저장소 삭제';

  @override
  String get deleteRepoConfirm => '이 저장소를 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.';

  @override
  String get generalSettings => '일반 설정';

  @override
  String get appearance => '외관';

  @override
  String get languageSelector => '언어';

  @override
  String get selectLanguage => '언어 선택';

  @override
  String get systemDefault => '시스템 기본값';

  @override
  String get followSystem => '시스템 설정 따르기';

  @override
  String get unsavedChanges => '저장하지 않은 변경사항';

  @override
  String get unsavedChangesMessage => '저장하지 않은 변경사항이 있습니다. 페이지를 벗어나시겠습니까?';

  @override
  String get leave => '떠나기';

  @override
  String get stay => '남기';

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
  String get quickActions => '빠른 작업';

  @override
  String get yourRepositories => '내 저장소';

  @override
  String get noRepositoriesFound => '저장소를 찾을 수 없습니다';

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
  String get enterSearchQueryRepos => '검색어를 입력하세요';

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
  String get repos => '저장소';

  @override
  String get followers => '팔로워';

  @override
  String get following => '팔로잉';

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
  String get repository => '저장소';

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
  String get commitRepo => 'committed to';

  @override
  String get renameRepo => 'renamed repository';

  @override
  String get starRepo => 'starred repository';

  @override
  String get watchRepo => 'started watching repository';

  @override
  String get reopenPR => 'reopened pull request';

  @override
  String get approvePR => 'approved pull request';

  @override
  String get rejectPR => 'rejected pull request';

  @override
  String get publishRelease => 'published release';

  @override
  String get deleteBranch => 'deleted branch';

  @override
  String get autoMergePR => 'auto-merged pull request';

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

  @override
  String get info => 'Info';

  @override
  String get teams => 'Teams';

  @override
  String get noTeams => 'No teams';

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
  String get noMembers => 'No members';

  @override
  String get editOrganization => 'Edit Organization';

  @override
  String get createOrganization => 'Create Organization';

  @override
  String get createRepository => 'Create Repository';

  @override
  String get repositoryName => '저장소 이름';

  @override
  String get repositoryNameHint => 'my-awesome-repo';

  @override
  String get repositoryNameRequired => '저장소 이름은 필수입니다';

  @override
  String get descriptionHint => '저장소에 대한 간단한 설명';

  @override
  String get public => 'Public';

  @override
  String get publicDescription => '인터넷의 모든 사람이 이 저장소를 볼 수 있습니다';

  @override
  String get privateDescription => '누가 보고 커밋할 수 있는지 선택할 수 있습니다';

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
  String get noWikiPages => 'No wiki pages';

  @override
  String get noWikiPagesDescription =>
      'This repository doesn\'t have any wiki pages yet.';

  @override
  String get createFirstWikiPage => 'Create First Page';

  @override
  String get lastCommit => 'Last commit';

  @override
  String get noContent => 'No content';

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
  String get noWebhooks => 'No webhooks';

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
  String get viewDiff => 'View Diff';

  @override
  String get unifiedView => 'Unified view';

  @override
  String get splitView => 'Split view';

  @override
  String get compareVersions => 'Compare Versions';

  @override
  String get baseRef => 'Base (older)';

  @override
  String get headRef => 'Head (newer)';

  @override
  String get compare => 'Compare';

  @override
  String get actions => 'Actions';

  @override
  String get noActions => 'No workflow runs';

  @override
  String get run => 'Run';

  @override
  String get status => 'Status';

  @override
  String get jobs => 'Jobs';

  @override
  String get noJobs => 'No jobs';

  @override
  String get artifacts => 'Artifacts';

  @override
  String get branch => 'Branch';

  @override
  String get author => 'Author';

  @override
  String get filterByActor => 'Filter by actor';

  @override
  String get filterByStatus => 'Filter by status';

  @override
  String get reviewChanges => 'Review Changes';

  @override
  String get reviewBody => 'Review comment';

  @override
  String get reviews => 'Reviews';

  @override
  String get approve => 'Approve';

  @override
  String get requestChanges => 'Request Changes';

  @override
  String get comment => 'Comment';

  @override
  String get blame => 'Blame';

  @override
  String get diffView => 'Diff View';

  @override
  String get pickColor => 'Pick Color';

  @override
  String get sshKeys => 'SSH Keys';

  @override
  String get allRepos => 'All Repos';

  @override
  String get configuration => 'Configuration';

  @override
  String get none => 'None';

  @override
  String get more => 'More';

  @override
  String get units => 'Units';

  @override
  String get permission => 'Permission';

  @override
  String get repoList => 'Repositories';

  @override
  String get noChanges => 'No changes';

  @override
  String get limited => 'Limited';

  @override
  String get unknownSection => 'Unknown section';

  @override
  String get deleteKey => 'Delete Key';

  @override
  String get deleteKeyConfirm =>
      'Are you sure you want to delete this SSH key?';

  @override
  String get keyDeleted => 'Key deleted successfully';

  @override
  String get addSshKey => 'Add SSH Key';

  @override
  String get add => 'Add';

  @override
  String get keyAdded => 'Key added successfully';

  @override
  String get deleteCommentConfirm =>
      'Are you sure you want to delete this comment?';

  @override
  String get requestReviewers => 'Request Reviewers';

  @override
  String get addReviewerHint => 'Enter reviewer username';

  @override
  String get subscribe => 'Subscribe';

  @override
  String get unsubscribe => 'Unsubscribe';

  @override
  String get setDueDate => 'Set Due Date';

  @override
  String get removeDueDate => 'Remove Due Date';

  @override
  String get topics => 'Topics';

  @override
  String get noTopics => 'No topics';

  @override
  String get branchProtection => 'Branch Protection';

  @override
  String get protectBranch => 'Protect Branch';

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
  String get searchRepositoriesHint => '저장소 검색';

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
}
