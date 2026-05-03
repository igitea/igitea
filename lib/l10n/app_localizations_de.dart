// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'iGitea';

  @override
  String get language => 'Sprache';

  @override
  String get settings => 'Einstellungen';

  @override
  String get profile => 'Profil';

  @override
  String get search => 'Suchen';

  @override
  String get notifications => 'Benachrichtigungen';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get signOut => 'Abmelden';

  @override
  String get signIn => 'Anmelden';

  @override
  String get username => 'Benutzername';

  @override
  String get password => 'Passwort';

  @override
  String get login => 'Anmelden';

  @override
  String get loginWithToken => 'Mit Token anmelden';

  @override
  String get token => 'Token';

  @override
  String get cancel => 'Abbrechen';

  @override
  String get confirm => 'Bestätigen';

  @override
  String get save => 'Speichern';

  @override
  String get delete => 'Löschen';

  @override
  String get edit => 'Bearbeiten';

  @override
  String get create => 'Erstellen';

  @override
  String get close => 'Schließen';

  @override
  String get reopen => 'Erneut öffnen';

  @override
  String get merge => 'Zusammenführen';

  @override
  String get submit => 'Absenden';

  @override
  String get retry => 'Wiederholen';

  @override
  String get loading => 'Wird geladen...';

  @override
  String get error => 'Fehler';

  @override
  String get noData => 'Keine Daten';

  @override
  String get searchRepos => 'Repositories suchen';

  @override
  String get searchIssues => 'Issues suchen';

  @override
  String get users => 'Users';

  @override
  String get enterSearchQueryUsers => 'Enter a search query to find users';

  @override
  String get noResults => 'Keine Ergebnisse gefunden';

  @override
  String get repositories => 'Repositorys';

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
  String get stars => 'Sterne';

  @override
  String get forks => 'Forks';

  @override
  String get watchers => 'Beobachter';

  @override
  String get open => 'Offen';

  @override
  String get closed => 'Geschlossen';

  @override
  String get all => 'Alle';

  @override
  String get mergePullRequest => 'Pull Request zusammenführen';

  @override
  String get mergeConfirmMessage =>
      'Sind Sie sicher, dass Sie diesen Pull Request zusammenführen möchten?';

  @override
  String issueNumber(Object issueNumber) {
    return 'Issue #$issueNumber';
  }

  @override
  String pullRequestNumber(Object pullRequestNumber) {
    return 'PR #$pullRequestNumber';
  }

  @override
  String get comments => 'Kommentare';

  @override
  String get addComment => 'Kommentar hinzufügen...';

  @override
  String get sendComment => 'Senden';

  @override
  String get noComments => 'Noch keine Kommentare';

  @override
  String get labels => 'Labels';

  @override
  String get milestones => 'Meilensteine';

  @override
  String get assignees => 'Zugewiesen';

  @override
  String get assignee => 'Assignee';

  @override
  String get participants => 'Teilnehmer';

  @override
  String get timeline => 'Zeitachse';

  @override
  String get theme => 'Design';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String get themeSystem => 'System';

  @override
  String get account => 'Konto';

  @override
  String get accountInfo => 'Kontoinformationen';

  @override
  String get email => 'E-Mail';

  @override
  String get website => 'Webseite';

  @override
  String get bio => 'Biografie';

  @override
  String joinedOn(Object date) {
    return 'Beigetreten am $date';
  }

  @override
  String joinedOnParams(Object date) {
    return 'Beigetreten am $date';
  }

  @override
  String followerCount(Object count) {
    return '$count followers';
  }

  @override
  String followerCountParams(Object count) {
    return '$count Follower';
  }

  @override
  String followingCount(Object count) {
    return '$count following';
  }

  @override
  String followingCountParams(Object count) {
    return '$count Following';
  }

  @override
  String repositoryCount(Object count) {
    return '$count repositories';
  }

  @override
  String repositoryCountParams(Object count) {
    return '$count Repositories';
  }

  @override
  String get starredRepos => 'Starred Repositories';

  @override
  String get organisations => 'Organisationen';

  @override
  String get adminPanel => 'Admin-Panel';

  @override
  String get userManagement => 'Benutzerverwaltung';

  @override
  String get serverSettings => 'Servereinstellungen';

  @override
  String get cronTasks => 'Cron-Aufgaben';

  @override
  String get apiSettings => 'API-Einstellungen';

  @override
  String get uiSettings => 'UI-Einstellungen';

  @override
  String get attachmentSettings => 'Anhangseinstellungen';

  @override
  String get repoSettings => 'Repository-Einstellungen';

  @override
  String get runNow => 'Jetzt ausführen';

  @override
  String lastRun(Object time) {
    return 'Last run: $time';
  }

  @override
  String lastRunParams(Object time) {
    return 'Letzte Ausführung: $time';
  }

  @override
  String nextRun(Object time) {
    return 'Next run: $time';
  }

  @override
  String nextRunParams(Object time) {
    return 'Nächste Ausführung: $time';
  }

  @override
  String get recentActivity => 'Neueste Aktivität';

  @override
  String get myIssues => 'Meine Issues';

  @override
  String get myRepos => 'Meine Repositories';

  @override
  String get myStars => 'Meine Sterne';

  @override
  String get feed => 'Feed';

  @override
  String get markAllRead => 'Alle als gelesen markieren';

  @override
  String get markRead => 'Als gelesen markieren';

  @override
  String unreadNotifications(Object count) {
    return 'Unread notifications: $count';
  }

  @override
  String unreadNotificationsParams(Object count) {
    return 'Ungelesene Benachrichtigungen: $count';
  }

  @override
  String get noUnreadNotifications => 'Keine ungelesenen Benachrichtigungen';

  @override
  String get readMore => 'Mehr lesen';

  @override
  String ago(Object time) {
    return '$time ago';
  }

  @override
  String agoParams(Object time) {
    return 'vor $time';
  }

  @override
  String get fileBrowser => 'Dateibrowser';

  @override
  String get readme => 'README';

  @override
  String get commits => 'Commits';

  @override
  String get commitHistory => 'Commit-Verlauf';

  @override
  String get viewFile => 'Datei anzeigen';

  @override
  String get downloadFile => 'Datei herunterladen';

  @override
  String get copyPath => 'Pfad kopieren';

  @override
  String get fileName => 'Dateiname';

  @override
  String get fileSize => 'Dateigröße';

  @override
  String get lastModified => 'Zuletzt geändert';

  @override
  String get openInBrowser => 'Im Browser öffnen';

  @override
  String get signInRequired => 'Anmeldung erforderlich';

  @override
  String get signInMessage => 'Bitte melden Sie sich an, um fortzufahren';

  @override
  String get loginFailed => 'Anmeldung fehlgeschlagen';

  @override
  String get networkError => 'Netzwerkfehler';

  @override
  String get unknownError => 'Ein unbekannter Fehler ist aufgetreten';

  @override
  String get refresh => 'Aktualisieren';

  @override
  String get copyToClipboard => 'In die Zwischenablage kopieren';

  @override
  String get copied => 'Kopiert!';

  @override
  String get filterIssues => 'Issues filtern';

  @override
  String get newIssue => 'Neues Issue';

  @override
  String get newPullRequest => 'Neuer Pull Request';

  @override
  String get title => 'Titel';

  @override
  String get description => 'Beschreibung';

  @override
  String get body => 'Inhalt';

  @override
  String get state => 'Status';

  @override
  String get priority => 'Priorität';

  @override
  String get milestone => 'Meilenstein';

  @override
  String get createdAt => 'Erstellt am';

  @override
  String get updatedAt => 'Aktualisiert am';

  @override
  String get dueDate => 'Fälligkeitsdatum';

  @override
  String get noMilestones => 'Keine Meilensteine';

  @override
  String get noLabels => 'Keine Labels';

  @override
  String get openIssue => 'Issue öffnen';

  @override
  String get closeIssue => 'Issue schließen';

  @override
  String get reopenIssue => 'Issue erneut öffnen';

  @override
  String get deleteComment => 'Kommentar löschen';

  @override
  String get editComment => 'Kommentar bearbeiten';

  @override
  String get deleteRepo => 'Repository löschen';

  @override
  String get deleteRepoConfirm =>
      'Sind Sie sicher, dass Sie dieses Repository löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get generalSettings => 'Allgemeine Einstellungen';

  @override
  String get appearance => 'Erscheinungsbild';

  @override
  String get languageSelector => 'Sprache';

  @override
  String get selectLanguage => 'Sprache auswählen';

  @override
  String get systemDefault => 'Systemstandard';

  @override
  String get followSystem => 'System folgen';

  @override
  String get unsavedChanges => 'Ungespeicherte Änderungen';

  @override
  String get unsavedChangesMessage =>
      'Sie haben ungespeicherte Änderungen. Sind Sie sicher, dass Sie die Seite verlassen möchten?';

  @override
  String get leave => 'Verlassen';

  @override
  String get stay => 'Bleiben';

  @override
  String get restoringSession => 'Restoring session...';

  @override
  String get pleaseEnterServerUrl => 'Bitte geben Sie eine Server-URL ein';

  @override
  String get pleaseEnterValidUrl => 'Bitte geben Sie eine gültige URL ein';

  @override
  String get connectToGitea => 'Mit Ihrer Gitea-Instanz verbinden';

  @override
  String get usernamePassword => 'Username & Password';

  @override
  String get serverUrl => 'Server-URL';

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
  String get signInWithToken => 'Mit Token anmelden';

  @override
  String get welcomeToIgitea => 'Welcome to iGitea';

  @override
  String get signInToGetStarted => 'Sign in to get started';

  @override
  String get quickActions => 'Schnellaktionen';

  @override
  String get yourRepositories => 'Ihre Repositorys';

  @override
  String get noRepositoriesFound => 'Keine Repositorys gefunden';

  @override
  String helloParams(Object full_name) {
    return 'Hello, $full_name!';
  }

  @override
  String get user => 'User';

  @override
  String get private => 'Privat';

  @override
  String get untitled => 'Unbenannt';

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
  String get repos => 'Repositorys';

  @override
  String get followers => 'Follower';

  @override
  String get following => 'Folge ich';

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
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

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
  String get unknown => 'Unbekannt';

  @override
  String openedParams(Object time) {
    return 'opened $time';
  }

  @override
  String get noDescriptionProvided => 'No description provided.';

  @override
  String get failedToLoadComments => 'Failed to load comments';

  @override
  String get writeComment => 'Kommentar schreiben';

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
  String get draft => 'Entwurf';

  @override
  String get failedToLoadRepo => 'Failed to load repository';

  @override
  String get copyUrl => 'Copy URL';

  @override
  String get urlCopied => 'URL copied';

  @override
  String get emptyDirectory => 'Empty directory';

  @override
  String get noIssues => 'Keine Issues';

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
  String get defaultBranch => 'Standard-Branch';

  @override
  String get copyCode => 'Copy code';

  @override
  String get failedToLoadFile => 'Failed to load file';

  @override
  String get filePreviewNotAvailable => 'File preview not available';

  @override
  String get download => 'Herunterladen';

  @override
  String get failedToOpenDownloadUrl => 'Failed to open download URL';

  @override
  String get noNotifications => 'Keine Benachrichtigungen';

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
  String get noActivity => 'Keine Aktivität';

  @override
  String get createdRepo => 'Repository erstellt';

  @override
  String get pushedTag => 'pushed tag';

  @override
  String get deletedTag => 'deleted tag';

  @override
  String get createdIssue => 'Issue erstellt';

  @override
  String get closedIssue => 'Issue geschlossen';

  @override
  String get reopenedIssue => 'reopened issue';

  @override
  String get createdPR => 'PR erstellt';

  @override
  String get mergedPR => 'PR gemergt';

  @override
  String get closedPR => 'PR geschlossen';

  @override
  String get commentedOnIssue => 'Issue kommentiert';

  @override
  String get commentedOnPR => 'PR kommentiert';

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
  String get to => 'nach';

  @override
  String get from => 'von';

  @override
  String get headBranch => 'Quell-Branch';

  @override
  String get baseBranch => 'Ziel-Branch';

  @override
  String get pleaseFillAllFields => 'Bitte füllen Sie alle Pflichtfelder aus';

  @override
  String get settingsSaved => 'Einstellungen gespeichert';

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
  String get preview => 'Vorschau';

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
  String get noCommits => 'Keine Commits';

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
  String get noTeams => 'Keine Teams';

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
  String get noMembers => 'Keine Mitglieder';

  @override
  String get editOrganization => 'Edit Organization';

  @override
  String get createOrganization => 'Create Organization';

  @override
  String get createRepository => 'Create Repository';

  @override
  String get repositoryName => 'Repository-Name';

  @override
  String get repositoryNameHint => 'my-awesome-repo';

  @override
  String get repositoryNameRequired => 'Repository name is required';

  @override
  String get descriptionHint => 'Short description of your repository';

  @override
  String get public => 'Öffentlich';

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
  String get noWikiPages => 'Keine Wiki-Seiten';

  @override
  String get noWikiPagesDescription =>
      'This repository doesn\'t have any wiki pages yet.';

  @override
  String get createFirstWikiPage => 'Create First Page';

  @override
  String get lastCommit => 'Last commit';

  @override
  String get noContent => 'Kein Inhalt';

  @override
  String get saved => 'Saved';

  @override
  String get created => 'Created';

  @override
  String get createMilestone => 'Meilenstein erstellen';

  @override
  String get editMilestone => 'Meilenstein bearbeiten';

  @override
  String get deleteMilestone => 'Meilenstein löschen';

  @override
  String get deleteMilestoneConfirm =>
      'Are you sure you want to delete this milestone? This action cannot be undone.';

  @override
  String get milestoneDeleted => 'Milestone deleted';

  @override
  String get milestoneTitle => 'Titel';

  @override
  String get milestoneDescription => 'Description';

  @override
  String get milestoneDescriptionHint => 'Describe this milestone';

  @override
  String get milestoneDueDate => 'Fälligkeitsdatum';

  @override
  String get milestoneState => 'Status';

  @override
  String get milestoneStateOpen => 'Offen';

  @override
  String get milestoneStateClosed => 'Geschlossen';

  @override
  String get total => 'Total';

  @override
  String get clear => 'Löschen';

  @override
  String get webhooks => 'Webhooks';

  @override
  String get webhook => 'Webhook';

  @override
  String get noWebhooks => 'Keine Webhooks';

  @override
  String get createWebhook => 'Webhook erstellen';

  @override
  String get editWebhook => 'Webhook bearbeiten';

  @override
  String get deleteWebhook => 'Webhook löschen';

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
  String get webhookActive => 'Aktiv';

  @override
  String get webhookInactive => 'Inaktiv';

  @override
  String get webhookType => 'Typ';

  @override
  String get webhookCreatedAt => 'Erstellt am';

  @override
  String get webhookUpdatedAt => 'Aktualisiert am';

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
  String get createLabel => 'Label erstellen';

  @override
  String get editLabel => 'Label bearbeiten';

  @override
  String get deleteLabel => 'Label löschen';

  @override
  String get deleteLabelConfirm =>
      'Are you sure you want to delete this label?';

  @override
  String get labelDeleted => 'Label deleted';

  @override
  String get labelName => 'Name';

  @override
  String get labelNameHint => 'z.B. bug';

  @override
  String get labelDescription => 'Description';

  @override
  String get labelDescriptionHint => 'Optional description';

  @override
  String get labelColor => 'Farbe';

  @override
  String get labelColorHint => 'Hex-Farbe, z.B. #FF0000';

  @override
  String get filesChanged => 'Geänderte Dateien';

  @override
  String get noFilesChanged => 'Keine Dateien geändert';

  @override
  String get viewDiff => 'Diff anzeigen';

  @override
  String get unifiedView => 'Unified view';

  @override
  String get splitView => 'Split view';

  @override
  String get compareVersions => 'Versionen vergleichen';

  @override
  String get baseRef => 'Base (older)';

  @override
  String get headRef => 'Head (newer)';

  @override
  String get compare => 'Vergleichen';

  @override
  String get actions => 'Actions';

  @override
  String get noActions => 'Keine Workflows';

  @override
  String get run => 'Run';

  @override
  String get status => 'Status';

  @override
  String get jobs => 'Jobs';

  @override
  String get noJobs => 'Keine Jobs';

  @override
  String get artifacts => 'Artifacts';

  @override
  String get branch => 'Branch';

  @override
  String get author => 'Autor';

  @override
  String get filterByActor => 'Nach Akteur filtern';

  @override
  String get filterByStatus => 'Nach Status filtern';

  @override
  String get reviewChanges => 'Review Changes';

  @override
  String get reviewBody => 'Review comment';

  @override
  String get reviews => 'Reviews';

  @override
  String get approve => 'Genehmigen';

  @override
  String get requestChanges => 'Änderungen anfordern';

  @override
  String get comment => 'Kommentar';

  @override
  String get blame => 'Blame';

  @override
  String get diffView => 'Diff View';

  @override
  String get pickColor => 'Farbe auswählen';

  @override
  String get sshKeys => 'SSH-Schlüssel';

  @override
  String get allRepos => 'Alle Repositorys';

  @override
  String get configuration => 'Konfiguration';

  @override
  String get none => 'Keine';

  @override
  String get more => 'Mehr';

  @override
  String get units => 'Einheiten';

  @override
  String get permission => 'Berechtigung';

  @override
  String get repoList => 'Repository-Liste';

  @override
  String get noChanges => 'Keine Änderungen';

  @override
  String get limited => 'Eingeschränkt';

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
  String get add => 'Hinzufügen';

  @override
  String get keyAdded => 'Key added successfully';

  @override
  String get deleteCommentConfirm =>
      'Are you sure you want to delete this comment?';

  @override
  String get requestReviewers => 'Reviewer anfordern';

  @override
  String get addReviewerHint => 'Enter reviewer username';

  @override
  String get subscribe => 'Abonnieren';

  @override
  String get unsubscribe => 'Abo kündigen';

  @override
  String get subscribed => 'Subscribed';

  @override
  String get unsubscribed => 'Unsubscribed';

  @override
  String get setDueDate => 'Fälligkeitsdatum setzen';

  @override
  String get removeDueDate => 'Remove Due Date';

  @override
  String get topics => 'Themen';

  @override
  String get noTopics => 'No topics';

  @override
  String get branchProtection => 'Branch-Schutz';

  @override
  String get protectBranch => 'Branch schützen';

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
  String get searchRepositoriesHint => 'Repositorys durchsuchen';

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
  String get packages => 'Pakete';

  @override
  String get noPackages => 'Keine Pakete gefunden';

  @override
  String get packageType => 'Typ';

  @override
  String get packageVersion => 'Version';

  @override
  String get packageFiles => 'Dateien';

  @override
  String get packageSize => 'Größe';

  @override
  String get packageCreator => 'Ersteller';

  @override
  String get packageCreated => 'Erstellt';

  @override
  String get packageRepository => 'Repository';

  @override
  String get deletePackage => 'Paket löschen';

  @override
  String get deletePackageConfirm =>
      'Möchten Sie diese Paketversion wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get packageDeleted => 'Paketversion erfolgreich gelöscht';

  @override
  String get allTypes => 'Alle';

  @override
  String get installation => 'Installation';

  @override
  String get packageUrl => 'Paket-URL';

  @override
  String get copy => 'Kopieren';

  @override
  String get totalSize => 'Gesamtgröße';

  @override
  String get versions => 'Versionen';

  @override
  String get noVersions => 'Keine Versionen';

  @override
  String get createRelease => 'Release erstellen';

  @override
  String get editRelease => 'Release bearbeiten';

  @override
  String get deleteRelease => 'Release löschen';

  @override
  String get deleteReleaseConfirm =>
      'Möchten Sie dieses Release wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get releaseTagName => 'Tag-Name';

  @override
  String get releaseTagNameRequired => 'Tag-Name ist erforderlich';

  @override
  String get releaseTitle => 'Release-Titel';

  @override
  String get releaseBody => 'Release-Notizen';

  @override
  String get targetCommitish => 'Ziel';

  @override
  String get tagMessage => 'Tag-Nachricht';

  @override
  String get releaseCreated => 'Release erfolgreich erstellt';

  @override
  String get releaseUpdated => 'Release erfolgreich aktualisiert';

  @override
  String get releaseDeleted => 'Release erfolgreich gelöscht';

  @override
  String get chooseTag => 'Tag wählen';

  @override
  String get defaultLabels => 'Schnellauswahl';

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
  String get createTeam => 'Team erstellen';

  @override
  String get editTeam => 'Team bearbeiten';

  @override
  String get deleteTeam => 'Team löschen';

  @override
  String get deleteTeamConfirm => 'Team löschen?';

  @override
  String get teamName => 'Name';

  @override
  String get teamNameRequired => 'Name erforderlich';

  @override
  String get teamDescription => 'Beschreibung';

  @override
  String get teamPermission => 'Berechtigung';

  @override
  String get searchMembers => 'Benutzer suchen';

  @override
  String get addMember => 'Hinzufügen';

  @override
  String get removeMember => 'Entfernen';

  @override
  String removeMemberConfirmParams(Object username) {
    return '$username entfernen?';
  }

  @override
  String get teamCreated => 'Team erstellt';

  @override
  String get teamUpdated => 'Team aktualisiert';

  @override
  String get teamDeleted => 'Team gelöscht';

  @override
  String get memberAdded => 'Mitglied hinzugefügt';

  @override
  String get memberRemoved => 'Mitglied entfernt';

  @override
  String get noSearchResults => 'Keine Ergebnisse';

  @override
  String get teamCanCreateOrgRepos => 'Can create org repos';

  @override
  String get teamIncludesAllRepos => 'Includes all repositories';

  @override
  String get collaborators => 'Mitwirkende';

  @override
  String get noCollaborators => 'Keine';

  @override
  String get addCollaborator => 'Hinzufügen';

  @override
  String get removeCollaborator => 'Entfernen';

  @override
  String removeCollaboratorConfirmParams(Object username) {
    return '$username entfernen?';
  }

  @override
  String get collaboratorAdded => 'Hinzugefügt';

  @override
  String get collaboratorRemoved => 'Entfernt';

  @override
  String get contentType => 'Inhaltstyp';

  @override
  String get active => 'Aktiv';

  @override
  String get emails => 'E-Mails';

  @override
  String get addEmail => 'E-Mail hinzufügen';

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
