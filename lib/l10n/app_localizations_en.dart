// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'iGitea';

  @override
  String get language => 'Language';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get search => 'Search';

  @override
  String get notifications => 'Notifications';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signIn => 'Sign In';

  @override
  String get username => 'Username';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get loginWithToken => 'Login with Token';

  @override
  String get token => 'Token';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get create => 'Create';

  @override
  String get close => 'Close';

  @override
  String get reopen => 'Reopen';

  @override
  String get merge => 'Merge';

  @override
  String get submit => 'Submit';

  @override
  String get retry => 'Retry';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get noData => 'No data';

  @override
  String get searchRepos => 'Search repositories';

  @override
  String get searchIssues => 'Search issues';

  @override
  String get noResults => 'No results found';

  @override
  String get repositories => 'Repositories';

  @override
  String get issues => 'Issues';

  @override
  String get pullRequests => 'Pull Requests';

  @override
  String get releases => 'Releases';

  @override
  String get branches => 'Branches';

  @override
  String get code => 'Code';

  @override
  String get stars => 'Stars';

  @override
  String get forks => 'Forks';

  @override
  String get watchers => 'Watchers';

  @override
  String get open => 'Open';

  @override
  String get closed => 'Closed';

  @override
  String get all => 'All';

  @override
  String get mergePullRequest => 'Merge Pull Request';

  @override
  String get mergeConfirmMessage =>
      'Are you sure you want to merge this pull request?';

  @override
  String issueNumber(Object issueNumber) {
    return 'Issue #$issueNumber';
  }

  @override
  String pullRequestNumber(Object pullRequestNumber) {
    return 'PR #$pullRequestNumber';
  }

  @override
  String get comments => 'Comments';

  @override
  String get addComment => 'Add a comment...';

  @override
  String get sendComment => 'Send';

  @override
  String get noComments => 'No comments yet';

  @override
  String get labels => 'Labels';

  @override
  String get milestones => 'Milestones';

  @override
  String get assignees => 'Assignees';

  @override
  String get assignee => 'Assignee';

  @override
  String get participants => 'Participants';

  @override
  String get timeline => 'Timeline';

  @override
  String get theme => 'Theme';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System';

  @override
  String get account => 'Account';

  @override
  String get accountInfo => 'Account Info';

  @override
  String get email => 'Email';

  @override
  String get website => 'Website';

  @override
  String get bio => 'Bio';

  @override
  String joinedOn(Object date) {
    return 'Joined on $date';
  }

  @override
  String joinedOnParams(Object date) {
    return 'Joined on $date';
  }

  @override
  String followerCount(Object count) {
    return '$count followers';
  }

  @override
  String followerCountParams(Object count) {
    return '$count followers';
  }

  @override
  String followingCount(Object count) {
    return '$count following';
  }

  @override
  String followingCountParams(Object count) {
    return '$count following';
  }

  @override
  String repositoryCount(Object count) {
    return '$count repositories';
  }

  @override
  String repositoryCountParams(Object count) {
    return '$count repositories';
  }

  @override
  String get starredRepos => 'Starred Repositories';

  @override
  String get organisations => 'Organisations';

  @override
  String get adminPanel => 'Admin Panel';

  @override
  String get userManagement => 'User Management';

  @override
  String get serverSettings => 'Server Settings';

  @override
  String get cronTasks => 'Cron Tasks';

  @override
  String get apiSettings => 'API Settings';

  @override
  String get uiSettings => 'UI Settings';

  @override
  String get attachmentSettings => 'Attachment Settings';

  @override
  String get repoSettings => 'Repository Settings';

  @override
  String get runNow => 'Run Now';

  @override
  String lastRun(Object time) {
    return 'Last run: $time';
  }

  @override
  String lastRunParams(Object time) {
    return 'Last run: $time';
  }

  @override
  String nextRun(Object time) {
    return 'Next run: $time';
  }

  @override
  String nextRunParams(Object time) {
    return 'Next run: $time';
  }

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get myIssues => 'My Issues';

  @override
  String get myRepos => 'My Repos';

  @override
  String get myStars => 'My Stars';

  @override
  String get feed => 'Feed';

  @override
  String get markAllRead => 'Mark all as read';

  @override
  String get markRead => 'Mark as read';

  @override
  String unreadNotifications(Object count) {
    return 'Unread notifications: $count';
  }

  @override
  String unreadNotificationsParams(Object count) {
    return 'Unread notifications: $count';
  }

  @override
  String get noUnreadNotifications => 'No unread notifications';

  @override
  String get readMore => 'Read more';

  @override
  String ago(Object time) {
    return '$time ago';
  }

  @override
  String agoParams(Object time) {
    return '$time ago';
  }

  @override
  String get fileBrowser => 'File Browser';

  @override
  String get readme => 'README';

  @override
  String get commits => 'Commits';

  @override
  String get commitHistory => 'Commit History';

  @override
  String get viewFile => 'View File';

  @override
  String get downloadFile => 'Download File';

  @override
  String get copyPath => 'Copy Path';

  @override
  String get fileName => 'File name';

  @override
  String get fileSize => 'File size';

  @override
  String get lastModified => 'Last modified';

  @override
  String get openInBrowser => 'Open in Browser';

  @override
  String get signInRequired => 'Sign in required';

  @override
  String get signInMessage => 'Please sign in to continue';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get networkError => 'Network error';

  @override
  String get unknownError => 'Unknown error occurred';

  @override
  String get refresh => 'Refresh';

  @override
  String get copyToClipboard => 'Copy to clipboard';

  @override
  String get copied => 'Copied!';

  @override
  String get filterIssues => 'Filter issues';

  @override
  String get newIssue => 'New Issue';

  @override
  String get newPullRequest => 'New Pull Request';

  @override
  String get title => 'Title';

  @override
  String get description => 'Description';

  @override
  String get body => 'Body';

  @override
  String get state => 'State';

  @override
  String get priority => 'Priority';

  @override
  String get milestone => 'Milestone';

  @override
  String get createdAt => 'Created at';

  @override
  String get updatedAt => 'Updated at';

  @override
  String get dueDate => 'Due date';

  @override
  String get noMilestones => 'No milestones';

  @override
  String get noLabels => 'No labels';

  @override
  String get openIssue => 'Open issue';

  @override
  String get closeIssue => 'Close issue';

  @override
  String get reopenIssue => 'Reopen issue';

  @override
  String get deleteComment => 'Delete comment';

  @override
  String get editComment => 'Edit comment';

  @override
  String get deleteRepo => 'Delete repository';

  @override
  String get deleteRepoConfirm =>
      'Are you sure you want to delete this repository? This action cannot be undone.';

  @override
  String get generalSettings => 'General Settings';

  @override
  String get appearance => 'Appearance';

  @override
  String get languageSelector => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get systemDefault => 'System default';

  @override
  String get followSystem => 'Follow system';

  @override
  String get unsavedChanges => 'Unsaved changes';

  @override
  String get unsavedChangesMessage =>
      'You have unsaved changes. Are you sure you want to leave?';

  @override
  String get leave => 'Leave';

  @override
  String get stay => 'Stay';

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
}
