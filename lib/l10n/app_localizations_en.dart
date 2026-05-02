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
  String get repositorySections => 'Repository Sections';

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
  String get dueDate => 'Due';

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
  String get deleteComment => 'Delete Comment';

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
  String get repositoryName => 'Repository Name';

  @override
  String get repositoryNameHint => 'my-awesome-repo';

  @override
  String get repositoryNameRequired => 'Repository name is required';

  @override
  String get descriptionHint => 'Short description of your repository';

  @override
  String get public => 'Public';

  @override
  String get publicDescription =>
      'Anyone on the internet can see this repository';

  @override
  String get privateDescription =>
      'You choose who can see and commit to this repository';

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
  String get webhookUrl => 'URL';

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
  String get searchRepositoriesHint => 'Search for repositories';

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
  String get packages => 'Packages';

  @override
  String get noPackages => 'No packages found';

  @override
  String get packageType => 'Type';

  @override
  String get packageVersion => 'Version';

  @override
  String get packageFiles => 'Files';

  @override
  String get packageSize => 'Size';

  @override
  String get packageCreator => 'Creator';

  @override
  String get packageCreated => 'Created';

  @override
  String get packageRepository => 'Repository';

  @override
  String get deletePackage => 'Delete Package';

  @override
  String get deletePackageConfirm =>
      'Are you sure you want to delete this package version? This action cannot be undone.';

  @override
  String get packageDeleted => 'Package version deleted successfully';

  @override
  String get allTypes => 'All';

  @override
  String get installation => 'Installation';

  @override
  String get packageUrl => 'Package URL';

  @override
  String get copy => 'Copy';

  @override
  String get totalSize => 'Total Size';

  @override
  String get versions => 'Versions';

  @override
  String get noVersions => 'No versions';

  @override
  String get createRelease => 'Create Release';

  @override
  String get editRelease => 'Edit Release';

  @override
  String get deleteRelease => 'Delete Release';

  @override
  String get deleteReleaseConfirm =>
      'Are you sure you want to delete this release? This action cannot be undone.';

  @override
  String get releaseTagName => 'Tag name';

  @override
  String get releaseTagNameRequired => 'Tag name is required';

  @override
  String get releaseTitle => 'Release title';

  @override
  String get releaseBody => 'Release notes';

  @override
  String get targetCommitish => 'Target';

  @override
  String get tagMessage => 'Tag message';

  @override
  String get releaseCreated => 'Release created successfully';

  @override
  String get releaseUpdated => 'Release updated successfully';

  @override
  String get releaseDeleted => 'Release deleted successfully';

  @override
  String get chooseTag => 'Pick tag';

  @override
  String get defaultLabels => 'Quick pick';

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
  String get createTeam => 'Create Team';

  @override
  String get editTeam => 'Edit Team';

  @override
  String get deleteTeam => 'Delete Team';

  @override
  String get deleteTeamConfirm =>
      'Are you sure you want to delete this team? This action cannot be undone.';

  @override
  String get teamName => 'Team name';

  @override
  String get teamNameRequired => 'Team name is required';

  @override
  String get teamDescription => 'Description';

  @override
  String get teamPermission => 'Permission';

  @override
  String get searchMembers => 'Search users to add';

  @override
  String get addMember => 'Add Member';

  @override
  String get removeMember => 'Remove';

  @override
  String removeMemberConfirmParams(Object username) {
    return 'Remove $username from this team?';
  }

  @override
  String get teamCreated => 'Team created successfully';

  @override
  String get teamUpdated => 'Team updated successfully';

  @override
  String get teamDeleted => 'Team deleted successfully';

  @override
  String get memberAdded => 'Member added successfully';

  @override
  String get memberRemoved => 'Member removed successfully';

  @override
  String get noSearchResults => 'No users found';

  @override
  String get teamCanCreateOrgRepos => 'Can create org repos';

  @override
  String get teamIncludesAllRepos => 'Includes all repositories';

  @override
  String get collaborators => 'Collaborators';

  @override
  String get noCollaborators => 'No collaborators';

  @override
  String get addCollaborator => 'Add Collaborator';

  @override
  String get removeCollaborator => 'Remove';

  @override
  String removeCollaboratorConfirmParams(Object username) {
    return 'Remove $username from collaborators?';
  }

  @override
  String get collaboratorAdded => 'Collaborator added';

  @override
  String get collaboratorRemoved => 'Collaborator removed';

  @override
  String get contentType => 'Content Type';

  @override
  String get active => 'Active';
}
