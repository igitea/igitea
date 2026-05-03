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
  String get users => 'Users';

  @override
  String get enterSearchQueryUsers => 'Enter a search query to find users';

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
    return '$date에 가입';
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
  String get pleaseEnterServerUrl => '서버 URL을 입력하세요';

  @override
  String get pleaseEnterValidUrl => '유효한 URL을 입력하세요';

  @override
  String get connectToGitea => 'Gitea 인스턴스에 연결';

  @override
  String get usernamePassword => 'Username & Password';

  @override
  String get serverUrl => '서버 URL';

  @override
  String get enterUsername => '사용자명 입력';

  @override
  String get pleaseEnterUsername => '사용자명을 입력하세요';

  @override
  String get enterPassword => '비밀번호 입력';

  @override
  String get pleaseEnterPassword => '비밀번호를 입력하세요';

  @override
  String get pasteAccessToken => 'Paste your personal access token';

  @override
  String get pleaseEnterAccessToken => 'Please enter an access token';

  @override
  String get signInWithToken => '토큰으로 로그인';

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
  String get private => '비공개';

  @override
  String get untitled => '제목 없음';

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
  String get yes => '예';

  @override
  String get no => '아니오';

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
  String get unknown => '알 수 없음';

  @override
  String openedParams(Object time) {
    return 'opened $time';
  }

  @override
  String get noDescriptionProvided => '설명이 제공되지 않았습니다';

  @override
  String get failedToLoadComments => 'Failed to load comments';

  @override
  String get writeComment => '댓글 작성';

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
  String get draft => '초안';

  @override
  String get failedToLoadRepo => 'Failed to load repository';

  @override
  String get copyUrl => 'Copy URL';

  @override
  String get urlCopied => 'URL copied';

  @override
  String get emptyDirectory => 'Empty directory';

  @override
  String get noIssues => '이슈 없음';

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
  String get defaultBranch => '기본 브랜치';

  @override
  String get copyCode => 'Copy code';

  @override
  String get failedToLoadFile => 'Failed to load file';

  @override
  String get filePreviewNotAvailable => 'File preview not available';

  @override
  String get download => '다운로드';

  @override
  String get failedToOpenDownloadUrl => 'Failed to open download URL';

  @override
  String get noNotifications => '알림 없음';

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
  String get noActivity => '활동 없음';

  @override
  String get createdRepo => '저장소를 생성했습니다';

  @override
  String get pushedTag => 'pushed tag';

  @override
  String get deletedTag => 'deleted tag';

  @override
  String get createdIssue => '이슈를 생성했습니다';

  @override
  String get closedIssue => '이슈를 닫았습니다';

  @override
  String get reopenedIssue => '이슈를 재열었습니다';

  @override
  String get createdPR => 'PR을 생성했습니다';

  @override
  String get mergedPR => 'PR을 병합했습니다';

  @override
  String get closedPR => 'PR을 닫았습니다';

  @override
  String get commentedOnIssue => '이슈에 댓글을 남겼습니다';

  @override
  String get commentedOnPR => 'PR에 댓글을 남겼습니다';

  @override
  String get forkedRepo => '포크했습니다';

  @override
  String get transferredRepo => 'transferred repository';

  @override
  String get deletedRepo => '저장소를 삭제했습니다';

  @override
  String get updatedWiki => 'Wiki를 업데이트했습니다';

  @override
  String get performedAction => 'performed action';

  @override
  String get commitRepo => 'committed to';

  @override
  String get renameRepo => '저장소 이름을 변경했습니다';

  @override
  String get starRepo => '저장소에 별표를 표시했습니다';

  @override
  String get watchRepo => 'started watching repository';

  @override
  String get reopenPR => 'PR을 재열었습니다';

  @override
  String get approvePR => 'PR을 승인했습니다';

  @override
  String get rejectPR => 'rejected pull request';

  @override
  String get publishRelease => '릴리스를 발행했습니다';

  @override
  String get deleteBranch => 'deleted branch';

  @override
  String get autoMergePR => 'PR을 자동 병합했습니다';

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
  String get inRepo => '에서';

  @override
  String get to => '으로';

  @override
  String get from => '에서';

  @override
  String get headBranch => '소스 브랜치';

  @override
  String get baseBranch => '대상 브랜치';

  @override
  String get pleaseFillAllFields => '모든 필수 항목을 입력하세요';

  @override
  String get settingsSaved => '설정이 저장되었습니다';

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
  String get preview => '미리보기';

  @override
  String get commitMessage => 'Commit Message';

  @override
  String get commit => '커밋';

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
  String get ok => '확인';

  @override
  String get sha => 'SHA';

  @override
  String get changedFiles => 'Changed Files';

  @override
  String get tags => '태그';

  @override
  String get noCommits => '커밋 없음';

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
  String get noTeams => '팀 없음';

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
  String get noMembers => '멤버 없음';

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
  String get public => '공개';

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
  String get noWikiPages => 'Wiki 페이지 없음';

  @override
  String get noWikiPagesDescription =>
      'This repository doesn\'t have any wiki pages yet.';

  @override
  String get createFirstWikiPage => 'Create First Page';

  @override
  String get lastCommit => 'Last commit';

  @override
  String get noContent => '내용 없음';

  @override
  String get saved => 'Saved';

  @override
  String get created => 'Created';

  @override
  String get createMilestone => '마일스톤 생성';

  @override
  String get editMilestone => '마일스톤 편집';

  @override
  String get deleteMilestone => '마일스톤 삭제';

  @override
  String get deleteMilestoneConfirm => '이 마일스톤을 삭제하시겠습니까?';

  @override
  String get milestoneDeleted => '마일스톤이 삭제되었습니다';

  @override
  String get milestoneTitle => '제목';

  @override
  String get milestoneDescription => 'Description';

  @override
  String get milestoneDescriptionHint => 'Describe this milestone';

  @override
  String get milestoneDueDate => '마감일';

  @override
  String get milestoneState => '상태';

  @override
  String get milestoneStateOpen => '열림';

  @override
  String get milestoneStateClosed => '닫힘';

  @override
  String get total => 'Total';

  @override
  String get clear => '지우기';

  @override
  String get webhooks => 'Webhooks';

  @override
  String get webhook => 'Webhook';

  @override
  String get noWebhooks => '웹훅 없음';

  @override
  String get createWebhook => '웹훅 생성';

  @override
  String get editWebhook => '웹훅 편집';

  @override
  String get deleteWebhook => '웹훅 삭제';

  @override
  String get deleteWebhookConfirm => '이 웹훅을 삭제하시겠습니까?';

  @override
  String get webhookDeleted => '웹훅이 삭제되었습니다';

  @override
  String get webhookUrl => 'URL';

  @override
  String get webhookUrlHint => 'https://example.com/webhook';

  @override
  String get webhookSecret => '비밀키';

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
  String get webhookActive => '활성';

  @override
  String get webhookInactive => '비활성';

  @override
  String get webhookType => '유형';

  @override
  String get webhookCreatedAt => '생성일';

  @override
  String get webhookUpdatedAt => '업데이트일';

  @override
  String get webhookLastDelivery => 'Last Delivery';

  @override
  String get webhookSelectAllEvents => 'Select All';

  @override
  String get webhookPushEvents => '푸시';

  @override
  String get webhookPullRequestEvents => 'Pull Request';

  @override
  String get webhookIssuesEvents => '이슈';

  @override
  String get webhookCreateEvents => '생성';

  @override
  String get webhookDeleteEvents => '삭제';

  @override
  String get webhookReleaseEvents => '릴리스';

  @override
  String get webhookWikiEvents => 'Wiki';

  @override
  String get webhookStarEvents => '별표';

  @override
  String get webhookForkEvents => '포크';

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
  String get createLabel => '라벨 생성';

  @override
  String get editLabel => '라벨 편집';

  @override
  String get deleteLabel => '라벨 삭제';

  @override
  String get deleteLabelConfirm => '이 라벨을 삭제하시겠습니까?';

  @override
  String get labelDeleted => '라벨이 삭제되었습니다';

  @override
  String get labelName => '이름';

  @override
  String get labelNameHint => '예: bug';

  @override
  String get labelDescription => '설명';

  @override
  String get labelDescriptionHint => '설명 (선택사항)';

  @override
  String get labelColor => '색상';

  @override
  String get labelColorHint => '16진수 색상 (예: #FF0000)';

  @override
  String get filesChanged => '변경된 파일';

  @override
  String get noFilesChanged => '변경된 파일 없음';

  @override
  String get viewDiff => '차이 보기';

  @override
  String get unifiedView => '통합 보기';

  @override
  String get splitView => '분할 보기';

  @override
  String get compareVersions => '버전 비교';

  @override
  String get baseRef => 'Base (older)';

  @override
  String get headRef => 'Head (newer)';

  @override
  String get compare => '비교';

  @override
  String get actions => 'Actions';

  @override
  String get noActions => '워크플로우 없음';

  @override
  String get run => 'Run';

  @override
  String get status => '상태';

  @override
  String get jobs => '작업';

  @override
  String get noJobs => '작업 없음';

  @override
  String get artifacts => '아티팩트';

  @override
  String get branch => '브랜치';

  @override
  String get author => '작성자';

  @override
  String get filterByActor => '실행자로 필터';

  @override
  String get filterByStatus => '상태로 필터';

  @override
  String get reviewChanges => '변경 검토';

  @override
  String get reviewBody => '리뷰 코멘트';

  @override
  String get reviews => '리뷰';

  @override
  String get approve => '승인';

  @override
  String get requestChanges => '변경 요청';

  @override
  String get comment => '댓글';

  @override
  String get blame => 'Blame';

  @override
  String get diffView => '차이 보기';

  @override
  String get pickColor => '색상 선택';

  @override
  String get sshKeys => 'SSH 키';

  @override
  String get allRepos => '모든 저장소';

  @override
  String get configuration => '설정';

  @override
  String get none => '없음';

  @override
  String get more => '더보기';

  @override
  String get units => '단위';

  @override
  String get permission => '권한';

  @override
  String get repoList => '저장소 목록';

  @override
  String get noChanges => '변경 없음';

  @override
  String get limited => '제한';

  @override
  String get unknownSection => 'Unknown section';

  @override
  String get deleteKey => '키 삭제';

  @override
  String get deleteKeyConfirm => '이 SSH 키를 삭제하시겠습니까?';

  @override
  String get keyDeleted => '키가 삭제되었습니다';

  @override
  String get addSshKey => 'SSH 키 추가';

  @override
  String get add => '추가';

  @override
  String get keyAdded => '키가 추가되었습니다';

  @override
  String get deleteCommentConfirm => '이 댓글을 삭제하시겠습니까?';

  @override
  String get requestReviewers => '리뷰어 요청';

  @override
  String get addReviewerHint => 'Enter reviewer username';

  @override
  String get subscribe => '구독';

  @override
  String get unsubscribe => '구독 취소';

  @override
  String get subscribed => 'Subscribed';

  @override
  String get unsubscribed => 'Unsubscribed';

  @override
  String get setDueDate => '마감일 설정';

  @override
  String get removeDueDate => '마감일 제거';

  @override
  String get topics => '토픽';

  @override
  String get noTopics => '토픽 없음';

  @override
  String get branchProtection => '브랜치 보호';

  @override
  String get protectBranch => '브랜치 보호';

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

  @override
  String get packages => '패키지';

  @override
  String get noPackages => '패키지를 찾을 수 없습니다';

  @override
  String get packageType => '유형';

  @override
  String get packageVersion => '버전';

  @override
  String get packageFiles => '파일';

  @override
  String get packageSize => '크기';

  @override
  String get packageCreator => '작성자';

  @override
  String get packageCreated => '생성일';

  @override
  String get packageRepository => '저장소';

  @override
  String get deletePackage => '패키지 삭제';

  @override
  String get deletePackageConfirm => '이 패키지 버전을 삭제하시겠습니까? 이 작업은 취소할 수 없습니다.';

  @override
  String get packageDeleted => '패키지 버전이 삭제되었습니다';

  @override
  String get allTypes => '전체';

  @override
  String get installation => '설치 방법';

  @override
  String get packageUrl => '패키지 URL';

  @override
  String get copy => '복사';

  @override
  String get totalSize => '총 크기';

  @override
  String get versions => '버전';

  @override
  String get noVersions => '버전 없음';

  @override
  String get createRelease => '릴리즈 생성';

  @override
  String get editRelease => '릴리즈 편집';

  @override
  String get deleteRelease => '릴리즈 삭제';

  @override
  String get deleteReleaseConfirm => '이 릴리즈를 삭제하시겠습니까? 이 작업은 취소할 수 없습니다.';

  @override
  String get releaseTagName => '태그 이름';

  @override
  String get releaseTagNameRequired => '태그 이름은 필수입니다';

  @override
  String get releaseTitle => '릴리즈 제목';

  @override
  String get releaseBody => '릴리즈 노트';

  @override
  String get targetCommitish => '대상';

  @override
  String get tagMessage => '태그 메시지';

  @override
  String get releaseCreated => '릴리즈가 생성되었습니다';

  @override
  String get releaseUpdated => '릴리즈가 업데이트되었습니다';

  @override
  String get releaseDeleted => '릴리즈가 삭제되었습니다';

  @override
  String get chooseTag => '태그 선택';

  @override
  String get defaultLabels => '빠른 선택';

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
  String get createTeam => '팀 생성';

  @override
  String get editTeam => '팀 편집';

  @override
  String get deleteTeam => '팀 삭제';

  @override
  String get deleteTeamConfirm => '이 팀을 삭제하시겠습니까?';

  @override
  String get teamName => '팀 이름';

  @override
  String get teamNameRequired => '팀 이름은 필수입니다';

  @override
  String get teamDescription => '설명';

  @override
  String get teamPermission => '권한';

  @override
  String get searchMembers => '사용자 검색';

  @override
  String get addMember => '멤버 추가';

  @override
  String get removeMember => '제거';

  @override
  String removeMemberConfirmParams(Object username) {
    return '$username을(를) 팀에서 제거하시겠습니까?';
  }

  @override
  String get teamCreated => '팀이 생성되었습니다';

  @override
  String get teamUpdated => '팀이 업데이트되었습니다';

  @override
  String get teamDeleted => '팀이 삭제되었습니다';

  @override
  String get memberAdded => '멤버가 추가되었습니다';

  @override
  String get memberRemoved => '멤버가 제거되었습니다';

  @override
  String get noSearchResults => '사용자를 찾을 수 없습니다';

  @override
  String get teamCanCreateOrgRepos => 'Can create org repos';

  @override
  String get teamIncludesAllRepos => 'Includes all repositories';

  @override
  String get collaborators => '협력자';

  @override
  String get noCollaborators => '없음';

  @override
  String get addCollaborator => '추가';

  @override
  String get removeCollaborator => '제거';

  @override
  String removeCollaboratorConfirmParams(Object username) {
    return '$username을(를) 제거하시겠습니까?';
  }

  @override
  String get collaboratorAdded => '추가됨';

  @override
  String get collaboratorRemoved => '제거됨';

  @override
  String get contentType => '콘텐츠 유형';

  @override
  String get active => '활성';

  @override
  String get emails => '이메일';

  @override
  String get addEmail => '이메일 추가';

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

  @override
  String get adminHooksTitle => 'System Hooks';

  @override
  String get adminCronTitle => 'Cron Tasks';

  @override
  String get adminRunnersTitle => 'Actions Runners';

  @override
  String get adminEmailsTitle => 'Emails';

  @override
  String get adminBadgesTitle => 'Badges';

  @override
  String get adminRunCron => 'Run Now';

  @override
  String get adminGetToken => 'Get Registration Token';

  @override
  String get adminNoHooks => 'No system hooks configured';

  @override
  String get adminNoCron => 'No cron tasks';

  @override
  String get adminNoRunners => 'No action runners';

  @override
  String get adminNoEmails => 'No emails';

  @override
  String get adminNoBadges => 'No badges';

  @override
  String get adminBadgeUsername => 'Username';

  @override
  String get adminBadgeDescription => 'Description';
}
