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
  String get users => '사용자';

  @override
  String get enterSearchQueryUsers => '검색어를 입력하여 사용자 찾기';

  @override
  String get noResults => '결과 없음';

  @override
  String get repositories => '저장소';

  @override
  String get repositorySections => '저장소 섹션';

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
  String get assignee => '담당자';

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
    return '$count 팔로워';
  }

  @override
  String followerCountParams(Object count) {
    return '$count 팔로워';
  }

  @override
  String followingCount(Object count) {
    return '$count 팔로잉';
  }

  @override
  String followingCountParams(Object count) {
    return '$count 팔로잉';
  }

  @override
  String repositoryCount(Object count) {
    return '$count 리포지토리';
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
    return '마지막 실행: $time';
  }

  @override
  String lastRunParams(Object time) {
    return '마지막 실행: $time';
  }

  @override
  String nextRun(Object time) {
    return '다음 실행: $time';
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
    return '읽지 않은 알림: $count';
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
    return '$time 전';
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
  String get restoringSession => '세션 복원 중...';

  @override
  String get pleaseEnterServerUrl => '서버 URL을 입력하세요';

  @override
  String get pleaseEnterValidUrl => '유효한 URL을 입력하세요';

  @override
  String get connectToGitea => 'Gitea 인스턴스에 연결';

  @override
  String get usernamePassword => '사용자 이름 및 비밀번호';

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
  String get pasteAccessToken => '개인 액세스 토큰 붙여넣기';

  @override
  String get pleaseEnterAccessToken => '액세스 토큰을 입력하세요';

  @override
  String get signInWithToken => '토큰으로 로그인';

  @override
  String get welcomeToIgitea => 'iGitea에 오신 것을 환영합니다';

  @override
  String get signInToGetStarted => '시작하려면 로그인하세요';

  @override
  String get quickActions => '빠른 작업';

  @override
  String get yourRepositories => '내 저장소';

  @override
  String get noRepositoriesFound => '저장소를 찾을 수 없습니다';

  @override
  String helloParams(Object full_name) {
    return '안녕하세요, $full_name님!';
  }

  @override
  String get user => '사용자';

  @override
  String get private => '비공개';

  @override
  String get untitled => '제목 없음';

  @override
  String get enterSearchQueryRepos => '검색어를 입력하세요';

  @override
  String get enterSearchQueryIssues => '검색어를 입력하여 이슈 찾기';

  @override
  String get noIssuesFound => '이슈를 찾을 수 없습니다.';

  @override
  String get failedToLoadProfile => '프로필을 불러오지 못했습니다';

  @override
  String get unknownUser => '알 수 없는 사용자';

  @override
  String get admin => '관리자';

  @override
  String get repos => '저장소';

  @override
  String get followers => '팔로워';

  @override
  String get following => '팔로잉';

  @override
  String get follow => '팔로우';

  @override
  String get unfollow => '언팔로우';

  @override
  String get signOutConfirmMessage => '로그아웃하시겠습니까?';

  @override
  String get chooseTheme => '테마 선택';

  @override
  String get loadingSettings => '설정 로딩 중...';

  @override
  String get userManagementComingSoon => '사용자 관리 기능 준비 중';

  @override
  String get maxResponseItems => '최대 응답 항목';

  @override
  String get defaultPagingNum => '기본 페이지 수';

  @override
  String get defaultMaxBlobSize => '기본 최대 Blob 크기';

  @override
  String get defaultTheme => '기본 테마';

  @override
  String get allowedReactions => '허용된 반응';

  @override
  String get attachments => '첨부 파일';

  @override
  String get enabled => '활성화됨';

  @override
  String get maxFiles => '최대 파일 수';

  @override
  String get maxSize => '최대 크기';

  @override
  String get allowedTypes => '허용된 유형';

  @override
  String get bytes => '바이트';

  @override
  String get repository => '저장소';

  @override
  String get httpGitDisabled => 'HTTP Git 비활성화';

  @override
  String get lfsDisabled => 'LFS 비활성화';

  @override
  String get migrationsDisabled => '마이그레이션 비활성화';

  @override
  String get mirrorsDisabled => '미러 비활성화';

  @override
  String get starsDisabled => '별표 비활성화';

  @override
  String get timeTrackingDisabled => '시간 추적 비활성화';

  @override
  String get yes => '예';

  @override
  String get no => '아니오';

  @override
  String get schedule => '일정';

  @override
  String get next => '다음';

  @override
  String get executions => '실행';

  @override
  String get failedToLoadCronTasks => 'Cron 작업 로드 실패';

  @override
  String get noCronTasksFound => 'Cron 작업을 찾을 수 없음';

  @override
  String cronTriggeredParams(Object name) {
    return 'Cron \"$name\" 실행됨';
  }

  @override
  String get unknown => '알 수 없음';

  @override
  String openedParams(Object time) {
    return '$time에 열림';
  }

  @override
  String get noDescriptionProvided => '설명이 제공되지 않았습니다';

  @override
  String get failedToLoadComments => '댓글 로드 실패';

  @override
  String get writeComment => '댓글 작성';

  @override
  String commentsCountParams(Object count) {
    return '$count개 댓글';
  }

  @override
  String updatedParams(Object time) {
    return '$time에 업데이트됨';
  }

  @override
  String commentsParams(Object count) {
    return '댓글 ($count)';
  }

  @override
  String get files => '파일';

  @override
  String get mergeable => '병합 가능';

  @override
  String get merged => '병합됨';

  @override
  String get draft => '초안';

  @override
  String get failedToLoadRepo => '저장소 로드 실패';

  @override
  String get copyUrl => 'URL 복사';

  @override
  String get urlCopied => 'URL 복사됨';

  @override
  String get emptyDirectory => '빈 디렉터리';

  @override
  String get noIssues => '이슈 없음';

  @override
  String get noPullRequests => '풀 요청 없음';

  @override
  String get noReleases => '릴리스 없음';

  @override
  String get noBranches => '브랜치 없음';

  @override
  String get preRelease => '사전 릴리스';

  @override
  String get archived => '보관됨';

  @override
  String get defaultBranch => '기본 브랜치';

  @override
  String get copyCode => '코드 복사';

  @override
  String get failedToLoadFile => '파일 로드 실패';

  @override
  String get filePreviewNotAvailable => '파일 미리보기 불가';

  @override
  String get download => '다운로드';

  @override
  String get failedToOpenDownloadUrl => '다운로드 URL을 열지 못함';

  @override
  String get noNotifications => '알림 없음';

  @override
  String get noTitle => '제목 없음';

  @override
  String get allNotificationsMarkedAsRead => '모든 알림을 읽음으로 표시';

  @override
  String get createUser => '사용자 생성';

  @override
  String get editUser => '사용자 편집';

  @override
  String get deleteIssue => '이슈 삭제';

  @override
  String get deleteIssueConfirm => '이 이슈를 삭제하시겠습니까? 이 작업은 취소할 수 없습니다.';

  @override
  String get issueDeleted => '이슈가 삭제되었습니다';

  @override
  String get deleteUser => '사용자 삭제';

  @override
  String deleteUserConfirmParams(Object username) {
    return '사용자 \"$username\"을(를) 삭제하시겠습니까? 이 작업은 취소할 수 없습니다.';
  }

  @override
  String get userCreated => '사용자가 생성되었습니다';

  @override
  String get userUpdated => '사용자가 업데이트되었습니다';

  @override
  String get userDeleted => '사용자가 삭제되었습니다';

  @override
  String get noUsersFound => '사용자를 찾을 수 없음';

  @override
  String get pleaseEnterEmail => '이메일을 입력하세요';

  @override
  String get fullName => '전체 이름';

  @override
  String get mustChangePassword => '첫 로그인 시 비밀번호 변경 필요';

  @override
  String get pleaseEnterTitle => '제목을 입력하세요';

  @override
  String get noActivity => '활동 없음';

  @override
  String get createdRepo => '저장소를 생성했습니다';

  @override
  String get pushedTag => '태그를 푸시했습니다';

  @override
  String get deletedTag => '태그를 삭제했습니다';

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
  String get transferredRepo => '저장소를 이전했습니다';

  @override
  String get deletedRepo => '저장소를 삭제했습니다';

  @override
  String get updatedWiki => 'Wiki를 업데이트했습니다';

  @override
  String get performedAction => '작업을 수행했습니다';

  @override
  String get commitRepo => '커밋했습니다';

  @override
  String get renameRepo => '저장소 이름을 변경했습니다';

  @override
  String get starRepo => '저장소에 별표를 표시했습니다';

  @override
  String get watchRepo => '워치를 시작했습니다';

  @override
  String get reopenPR => 'PR을 재열었습니다';

  @override
  String get approvePR => 'PR을 승인했습니다';

  @override
  String get rejectPR => 'PR을 거절했습니다';

  @override
  String get publishRelease => '릴리스를 발행했습니다';

  @override
  String get deleteBranch => '브랜치를 삭제했습니다';

  @override
  String get autoMergePR => 'PR을 자동 병합했습니다';

  @override
  String get pullReviewDismissed => 'PR 리뷰를 기각했습니다';

  @override
  String get pullRequestReady => 'PR을 리뷰 준비됨으로 표시';

  @override
  String get mirrorSyncPush => '푸시를 미러에 동기화';

  @override
  String get mirrorSyncCreate => '생성을 미러에 동기화';

  @override
  String get mirrorSyncDelete => '삭제를 미러에 동기화';

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
  String get privateRepo => '비공개 저장소';

  @override
  String get privateRepoDesc => '귀하와 협력자만 볼 수 있습니다';

  @override
  String get enableIssues => '이슈 활성화';

  @override
  String get enablePullRequests => '풀 요청 활성화';

  @override
  String get enableWiki => 'Wiki 활성화';

  @override
  String get preview => '미리보기';

  @override
  String get commitMessage => '커밋 메시지';

  @override
  String get commit => '커밋';

  @override
  String get commitMessageHint => '변경 사항 설명 (선택사항)';

  @override
  String get cannotGetFileSha => '파일 SHA를 가져올 수 없습니다. 파일을 다시 로드하세요.';

  @override
  String get failedToSaveFile => '파일 저장 실패';

  @override
  String get fileSaved => '파일이 저장되었습니다';

  @override
  String get discard => '취소';

  @override
  String get message => '메시지';

  @override
  String get ok => '확인';

  @override
  String get sha => 'SHA';

  @override
  String get changedFiles => '변경된 파일';

  @override
  String get tags => '태그';

  @override
  String get noCommits => '커밋 없음';

  @override
  String get noTags => '태그 없음';

  @override
  String get protected => '보호됨';

  @override
  String get latestCommit => '최신 커밋';

  @override
  String get permissions => '권한';

  @override
  String get canPush => '푸시 가능';

  @override
  String get canMerge => '병합 가능';

  @override
  String get downloads => '다운로드';

  @override
  String get tarball => 'Tarball';

  @override
  String get zipball => 'Zipball';

  @override
  String get downloadTarball => 'Tarball 다운로드';

  @override
  String get downloadZipball => 'Zipball 다운로드';

  @override
  String get url => 'URL';

  @override
  String get info => '정보';

  @override
  String get teams => '팀';

  @override
  String get noTeams => '팀 없음';

  @override
  String get location => '위치';

  @override
  String get visibility => '공개 범위';

  @override
  String get assets => '자산';

  @override
  String get publishedAt => '게시일';

  @override
  String get target => '대상';

  @override
  String get forked => '포크됨';

  @override
  String get forkRepoConfirm => '귀하의 계정에 이 저장소의 포크가 생성됩니다.';

  @override
  String get editIssue => '이슈 편집';

  @override
  String get titleRequired => '제목은 필수입니다';

  @override
  String get selectMilestone => '마일스톤 선택';

  @override
  String get members => '멤버';

  @override
  String get noMembers => '멤버 없음';

  @override
  String get editOrganization => '조직 편집';

  @override
  String get createOrganization => '조직 생성';

  @override
  String get createRepository => '저장소 생성';

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
  String get initializeWithReadme => 'README로 초기화';

  @override
  String get initializeWithReadmeDescription => 'README 파일을 추가하여 프로젝트 이해를 돕습니다';

  @override
  String repoCreated(Object repoName) {
    return '저장소 \'$repoName\'이(가) 생성되었습니다';
  }

  @override
  String get complete => '완료';

  @override
  String get wiki => 'Wiki';

  @override
  String get newWikiPage => '새 Wiki 페이지';

  @override
  String get editWikiPage => 'Wiki 페이지 편집';

  @override
  String get deleteWikiPage => 'Wiki 페이지 삭제';

  @override
  String get deleteWikiPageConfirm => '이 Wiki 페이지를 삭제하시겠습니까? 이 작업은 취소할 수 없습니다.';

  @override
  String get wikiPageDeleted => 'Wiki 페이지가 삭제되었습니다';

  @override
  String get wikiPageTitle => '페이지 제목';

  @override
  String get wikiPageTitleHint => 'e.g. Home';

  @override
  String get wikiPageContent => '내용';

  @override
  String get wikiPageContentHint => 'Markdown으로 작성...';

  @override
  String get noWikiPages => 'Wiki 페이지 없음';

  @override
  String get noWikiPagesDescription => '이 저장소에 Wiki 페이지가 아직 없습니다.';

  @override
  String get createFirstWikiPage => '첫 페이지 만들기';

  @override
  String get lastCommit => '마지막 커밋';

  @override
  String get noContent => '내용 없음';

  @override
  String get saved => '저장됨';

  @override
  String get created => '생성됨';

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
  String get milestoneDescription => '설명';

  @override
  String get milestoneDescriptionHint => '이 마일스톤 설명';

  @override
  String get milestoneDueDate => '마감일';

  @override
  String get milestoneState => '상태';

  @override
  String get milestoneStateOpen => '열림';

  @override
  String get milestoneStateClosed => '닫힘';

  @override
  String get total => '합계';

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
  String get webhookSecretHint => '선택적 시크릿 토큰';

  @override
  String get webhookContentType => '콘텐츠 유형';

  @override
  String get webhookContentTypeJson => 'application/json';

  @override
  String get webhookContentTypeForm => 'application/x-www-form-urlencoded';

  @override
  String get webhookEvents => '이벤트';

  @override
  String get webhookEventsHint => '이 Webhook을 트리거할 이벤트 선택';

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
  String get webhookLastDelivery => '마지막 전달';

  @override
  String get webhookSelectAllEvents => '모두 선택';

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
  String get loginWithOAuth2 => 'OAuth2로 로그인';

  @override
  String get oauth2 => 'OAuth2';

  @override
  String get oauth2Description => 'Gitea OAuth2 애플리케이션으로 인증';

  @override
  String get oauth2ClientId => '클라이언트 ID';

  @override
  String get oauth2ClientSecret => '클라이언트 시크릿';

  @override
  String get oauth2RedirectUri => '리디렉션 URI';

  @override
  String get oauth2RedirectUriHint => 'igitea://oauth/callback';

  @override
  String get oauth2Authorize => '인증 페이지 열기';

  @override
  String get oauth2ExchangeCode => '코드를 토큰으로 교환';

  @override
  String get oauth2AuthorizationCode => '인증 코드';

  @override
  String get oauth2AuthorizationCodeHint => '리디렉션 URL에서 코드를 붙여넣기';

  @override
  String get oauth2TokenRefreshed => '토큰이 갱신되었습니다';

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
  String get baseRef => '베이스(이전)';

  @override
  String get headRef => '헤드(최신)';

  @override
  String get compare => '비교';

  @override
  String get actions => 'Actions';

  @override
  String get noActions => '워크플로우 없음';

  @override
  String get run => '실행';

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
  String get unknownSection => '알 수 없는 섹션';

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
  String get addReviewerHint => '리뷰어 사용자명 입력';

  @override
  String get subscribe => '구독';

  @override
  String get unsubscribe => '구독 취소';

  @override
  String get subscribed => '구독 중';

  @override
  String get unsubscribed => '구독 취소됨';

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
  String get teamAdminAccess => '팀 관리자 액세스';

  @override
  String get details => '세부정보';

  @override
  String get id => 'ID';

  @override
  String get searchRepositoriesHint => '저장소 검색';

  @override
  String get publicKey => '공개 키';

  @override
  String get failedToGetAccessToken => '액세스 토큰을 가져오지 못했습니다';

  @override
  String get fileNotFound => '파일을 찾을 수 없음';

  @override
  String get noSshKeysFound => 'SSH 키를 찾을 수 없음';

  @override
  String get other => '기타';

  @override
  String get usernameRequired => '사용자 이름은 필수입니다';

  @override
  String get myLaptopHint => '내 노트북';

  @override
  String get sshPublicKeyHint => 'SSH 공개 키를 여기에 붙여넣기';

  @override
  String get noChangesFoundForFile => '이 파일에 대한 변경 사항이 없습니다';

  @override
  String commitUpdateFile(Object fileName) {
    return '$fileName 업데이트';
  }

  @override
  String get api => 'API';

  @override
  String get ui => 'UI';

  @override
  String get justNow => '방금';

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
  String get applyLabelSet => '라벨 세트 적용';

  @override
  String get applyLabelSetDescription =>
      '미리 정의된 라벨 세트를 선택하여 한 번에 모든 라벨을 생성합니다.';

  @override
  String applyAllLabels(Object count) {
    return '모두 적용 ($count 라벨)';
  }

  @override
  String applyAllLabelsParams(Object count) {
    return '모두 적용 ($count 라벨)';
  }

  @override
  String get creating => '생성 중...';

  @override
  String get addCustomLabel => '사용자 정의 라벨 추가';

  @override
  String get selectTemplate => '템플릿 선택';

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
  String get teamCanCreateOrgRepos => '조직 저장소 생성 가능';

  @override
  String get teamIncludesAllRepos => '모든 저장소 포함';

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
  String get gpgKeys => 'GPG 키';

  @override
  String get addGpgKey => 'GPG 키 추가';

  @override
  String get gpgKeyHint => '-----BEGIN PGP PUBLIC KEY BLOCK-----';

  @override
  String get gpgKeyAdded => 'GPG 키가 추가되었습니다';

  @override
  String get gpgKeyDeleted => 'GPG 키가 삭제되었습니다';

  @override
  String get deleteGpgKey => 'GPG 키 삭제';

  @override
  String get deleteGpgKeyConfirm => '이 GPG 키를 삭제하시겠습니까?';

  @override
  String get noGpgKeys => 'GPG 키 없음';

  @override
  String get sign => '서명';

  @override
  String get certify => '인증';

  @override
  String get verified => '확인됨';

  @override
  String get tagProtections => '태그 보호';

  @override
  String get manageTagProtections => '태그 보호 규칙 관리';

  @override
  String get createTagProtection => '태그 보호 생성';

  @override
  String get namePattern => '이름 패턴';

  @override
  String get tagProtectionCreated => '태그 보호가 생성되었습니다';

  @override
  String get tagProtectionDeleted => '태그 보호가 삭제되었습니다';

  @override
  String get deleteTagProtection => '태그 보호 삭제';

  @override
  String get deleteTagProtectionConfirm => '이 태그 보호를 삭제하시겠습니까?';

  @override
  String get noTagProtections => '태그 보호 없음';

  @override
  String get allowedUsers => '허용된 사용자';

  @override
  String get dependencies => '종속성';

  @override
  String get addDependency => '종속성 추가';

  @override
  String get dependencyAdded => '종속성이 추가되었습니다';

  @override
  String get dependencyRemoved => '종속성이 제거되었습니다';

  @override
  String get removeDependency => '종속성 제거';

  @override
  String get removeDependencyConfirm => '이 종속성을 제거하시겠습니까?';

  @override
  String get noDependencies => '종속성 없음';

  @override
  String get blocks => '차단';

  @override
  String get dependsOn => '종속 대상';

  @override
  String get issueNumberHint => '이슈 #';

  @override
  String get events => '이벤트';

  @override
  String get items => '항목';

  @override
  String get commented => '댓글 작성됨';

  @override
  String get labelUpdated => '라벨이 업데이트되었습니다';

  @override
  String get milestoneUpdated => '마일스톤이 업데이트되었습니다';

  @override
  String get assigneeUpdated => '담당자가 업데이트되었습니다';

  @override
  String get reopened => '다시 열림';

  @override
  String get stargazers => '스타 사용자';

  @override
  String get subscribers => '구독자';

  @override
  String get noStargazers => '아직 스타 사용자가 없습니다';

  @override
  String get noSubscribers => '아직 구독자가 없습니다';

  @override
  String get adminHooksTitle => '시스템 훅';

  @override
  String get adminCronTitle => 'Cron 작업';

  @override
  String get adminRunnersTitle => 'Actions 러너';

  @override
  String get adminEmailsTitle => '이메일';

  @override
  String get adminBadgesTitle => '배지';

  @override
  String get adminRunCron => '지금 실행';

  @override
  String get adminGetToken => '등록 토큰 가져오기';

  @override
  String get adminNoHooks => '시스템 훅이 구성되지 않음';

  @override
  String get adminNoCron => 'Cron 작업 없음';

  @override
  String get adminNoRunners => 'Actions 러너 없음';

  @override
  String get adminNoEmails => '이메일 없음';

  @override
  String get adminNoBadges => '배지 없음';

  @override
  String get adminBadgeUsername => '사용자 이름';

  @override
  String get adminBadgeDescription => '설명';

  @override
  String get oauthAppsTitle => 'OAuth 애플리케이션';

  @override
  String get oauthNoApps => 'OAuth 애플리케이션 없음';

  @override
  String get oauthCreateApp => 'OAuth 앱 생성';

  @override
  String get oauthRedirectUri => '리디렉션 URI';

  @override
  String get oauthDeleteAppConfirm => 'OAuth 애플리케이션 삭제';

  @override
  String get name => '이름';

  @override
  String get confirmDelete => '삭제 확인';

  @override
  String get actionsSecretsTitle => 'Actions Secrets';

  @override
  String get actionsVariablesTitle => 'Actions Variables';

  @override
  String get actionsNoSecrets => 'Secrets 구성 없음';

  @override
  String get actionsNoVariables => 'Variables 구성 없음';

  @override
  String get actionsCreateSecret => 'Secret 생성';

  @override
  String get actionsCreateVariable => 'Variable 생성';

  @override
  String get actionsSecretName => 'Secret 이름';

  @override
  String get actionsSecretValue => 'Secret 값';

  @override
  String get actionsVariableName => 'Variable 이름';

  @override
  String get actionsVariableValue => 'Variable 값';

  @override
  String get actionsDeleteSecretConfirm => '이 Secret을 삭제하시겠습니까?';

  @override
  String get actionsDeleteVariableConfirm => '이 Variable을 삭제하시겠습니까?';

  @override
  String get deleted => '삭제됨';

  @override
  String get overdue => '기한 초과';

  @override
  String get addTopic => '토픽 추가';

  @override
  String get importRepository => '저장소 가져오기';

  @override
  String get import => '가져오기';

  @override
  String get repoImported => '저장소를 가져왔습니다';

  @override
  String get cloneUrl => '복제 URL';

  @override
  String get repoOwner => '소유자';

  @override
  String get gitService => 'Git 서비스';

  @override
  String get authentication => '인증';

  @override
  String get authUsername => '인증 사용자 이름';

  @override
  String get authPassword => '인증 비밀번호';

  @override
  String get authToken => '인증 토큰';

  @override
  String get migrationOptions => '옵션';

  @override
  String get migrateData => '가져올 데이터';

  @override
  String get mirror => '미러';

  @override
  String get mirrorInterval => '미러 간격';

  @override
  String get requiredField => '이 필드는 필수입니다';

  @override
  String get personal => '개인';

  @override
  String get deleteOrganization => '조직 삭제';

  @override
  String get deleteOrganizationConfirm => '이 조직을 삭제하시겠습니까? 이 작업은 취소할 수 없습니다.';

  @override
  String get organizationDeleted => '조직이 삭제되었습니다';

  @override
  String get accessTokens => '액세스 토큰';

  @override
  String get createToken => '토큰 생성';

  @override
  String get tokenName => '토큰 이름';

  @override
  String get tokenCreated => '토큰이 생성되었습니다';

  @override
  String get tokenValueWarning => '지금 이 토큰을 복사하세요. 이후에는 다시 볼 수 없습니다.';

  @override
  String get failedToCreateToken => '토큰 생성 실패';

  @override
  String get deleteToken => '토큰 삭제';

  @override
  String get deleteTokenConfirm => '삭제하시겠습니까?';

  @override
  String get tokenDeleted => '토큰이 삭제되었습니다';

  @override
  String get noTokens => '액세스 토큰 없음';

  @override
  String get scopes => '범위';

  @override
  String get selectAll => '전체 선택';

  @override
  String get deselectAll => '전체 해제';

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

  @override
  String get browseRepositories => '저장소 둘러보기';

  @override
  String get viewIssues => 'Issue 보기 및 관리';

  @override
  String get recentActivitySubtitle => '최근 활동 보기';

  @override
  String get yourStarredRepos => '별표 표시한 저장소';

  @override
  String get yourOrganizations => '내 조직';

  @override
  String get loadMoreActivity => '더 불러오기';
}
