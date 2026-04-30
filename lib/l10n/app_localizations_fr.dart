// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'iGitea';

  @override
  String get language => 'Langue';

  @override
  String get settings => 'Paramètres';

  @override
  String get profile => 'Profil';

  @override
  String get search => 'Rechercher';

  @override
  String get notifications => 'Notifications';

  @override
  String get dashboard => 'Tableau de bord';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get signIn => 'Se connecter';

  @override
  String get username => 'Nom d\'utilisateur';

  @override
  String get password => 'Mot de passe';

  @override
  String get login => 'Connexion';

  @override
  String get loginWithToken => 'Connexion par token';

  @override
  String get token => 'Token';

  @override
  String get cancel => 'Annuler';

  @override
  String get confirm => 'Confirmer';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get create => 'Créer';

  @override
  String get close => 'Fermer';

  @override
  String get reopen => 'Rouvrir';

  @override
  String get merge => 'Fusionner';

  @override
  String get submit => 'Soumettre';

  @override
  String get retry => 'Réessayer';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Erreur';

  @override
  String get noData => 'Aucune donnée';

  @override
  String get searchRepos => 'Rechercher des dépôts';

  @override
  String get searchIssues => 'Rechercher des tickets';

  @override
  String get noResults => 'Aucun résultat trouvé';

  @override
  String get repositories => 'Dépôts';

  @override
  String get repositorySections => 'Repository Sections';

  @override
  String get issues => 'Tickets';

  @override
  String get pullRequests => 'Pull requests';

  @override
  String get releases => 'Versions';

  @override
  String get branches => 'Branches';

  @override
  String get code => 'Code';

  @override
  String get stars => 'Étoiles';

  @override
  String get forks => 'Fourches';

  @override
  String get watchers => 'Observateurs';

  @override
  String get open => 'Ouvert';

  @override
  String get closed => 'Fermé';

  @override
  String get all => 'Tout';

  @override
  String get mergePullRequest => 'Fusionner la pull request';

  @override
  String get mergeConfirmMessage => 'Êtes-vous sûr de vouloir fusionner cette pull request ?';

  @override
  String issueNumber(Object issueNumber) {
    return 'Ticket #$issueNumber';
  }

  @override
  String pullRequestNumber(Object pullRequestNumber) {
    return 'PR #$pullRequestNumber';
  }

  @override
  String get comments => 'Commentaires';

  @override
  String get addComment => 'Ajouter un commentaire...';

  @override
  String get sendComment => 'Envoyer';

  @override
  String get noComments => 'Pas encore de commentaires';

  @override
  String get labels => 'Étiquettes';

  @override
  String get milestones => 'Jalons';

  @override
  String get assignees => 'Responsables';

  @override
  String get assignee => 'Assignee';

  @override
  String get participants => 'Participants';

  @override
  String get timeline => 'Chronologie';

  @override
  String get theme => 'Thème';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeSystem => 'Système';

  @override
  String get account => 'Compte';

  @override
  String get accountInfo => 'Informations du compte';

  @override
  String get email => 'E-mail';

  @override
  String get website => 'Site web';

  @override
  String get bio => 'Bio';

  @override
  String joinedOn(Object date) {
    return 'Joined on $date';
  }

  @override
  String joinedOnParams(Object date) {
    return 'Inscrit le $date';
  }

  @override
  String followerCount(Object count) {
    return '$count followers';
  }

  @override
  String followerCountParams(Object count) {
    return '$count abonnés';
  }

  @override
  String followingCount(Object count) {
    return '$count following';
  }

  @override
  String followingCountParams(Object count) {
    return '$count abonnements';
  }

  @override
  String repositoryCount(Object count) {
    return '$count repositories';
  }

  @override
  String repositoryCountParams(Object count) {
    return '$count dépôts';
  }

  @override
  String get starredRepos => 'Dépôts starés';

  @override
  String get organisations => 'Organisations';

  @override
  String get adminPanel => 'Panneau d\'administration';

  @override
  String get userManagement => 'Gestion des utilisateurs';

  @override
  String get serverSettings => 'Paramètres du serveur';

  @override
  String get cronTasks => 'Tâches cron';

  @override
  String get apiSettings => 'Paramètres API';

  @override
  String get uiSettings => 'Paramètres de l\'interface';

  @override
  String get attachmentSettings => 'Paramètres des pièces jointes';

  @override
  String get repoSettings => 'Paramètres du dépôt';

  @override
  String get runNow => 'Exécuter maintenant';

  @override
  String lastRun(Object time) {
    return 'Last run: $time';
  }

  @override
  String lastRunParams(Object time) {
    return 'Dernière exécution : $time';
  }

  @override
  String nextRun(Object time) {
    return 'Next run: $time';
  }

  @override
  String nextRunParams(Object time) {
    return 'Prochaine exécution : $time';
  }

  @override
  String get recentActivity => 'Activité récente';

  @override
  String get myIssues => 'Mes tickets';

  @override
  String get myRepos => 'Mes dépôts';

  @override
  String get myStars => 'Mes étoiles';

  @override
  String get feed => 'Fil';

  @override
  String get markAllRead => 'Tout marquer comme lu';

  @override
  String get markRead => 'Marquer comme lu';

  @override
  String unreadNotifications(Object count) {
    return 'Unread notifications: $count';
  }

  @override
  String unreadNotificationsParams(Object count) {
    return 'Notifications non lues : $count';
  }

  @override
  String get noUnreadNotifications => 'Aucune notification non lue';

  @override
  String get readMore => 'Lire la suite';

  @override
  String ago(Object time) {
    return '$time ago';
  }

  @override
  String agoParams(Object time) {
    return 'il y a $time';
  }

  @override
  String get fileBrowser => 'Explorateur de fichiers';

  @override
  String get readme => 'README';

  @override
  String get commits => 'Commits';

  @override
  String get commitHistory => 'Historique des commits';

  @override
  String get viewFile => 'Voir le fichier';

  @override
  String get downloadFile => 'Télécharger le fichier';

  @override
  String get copyPath => 'Copier le chemin';

  @override
  String get fileName => 'Nom du fichier';

  @override
  String get fileSize => 'Taille du fichier';

  @override
  String get lastModified => 'Dernière modification';

  @override
  String get openInBrowser => 'Ouvrir dans le navigateur';

  @override
  String get signInRequired => 'Connexion requise';

  @override
  String get signInMessage => 'Veuillez vous connecter pour continuer';

  @override
  String get loginFailed => 'Échec de la connexion';

  @override
  String get networkError => 'Erreur réseau';

  @override
  String get unknownError => 'Une erreur inconnue s\'est produite';

  @override
  String get refresh => 'Actualiser';

  @override
  String get copyToClipboard => 'Copier dans le presse-papiers';

  @override
  String get copied => 'Copié !';

  @override
  String get filterIssues => 'Filtrer les tickets';

  @override
  String get newIssue => 'Nouveau ticket';

  @override
  String get newPullRequest => 'Nouvelle pull request';

  @override
  String get title => 'Titre';

  @override
  String get description => 'Description';

  @override
  String get body => 'Corps';

  @override
  String get state => 'État';

  @override
  String get priority => 'Priorité';

  @override
  String get milestone => 'Jalon';

  @override
  String get createdAt => 'Créé le';

  @override
  String get updatedAt => 'Mis à jour le';

  @override
  String get dueDate => 'Date d\'échéance';

  @override
  String get noMilestones => 'Aucun jalon';

  @override
  String get noLabels => 'Aucune étiquette';

  @override
  String get openIssue => 'Ouvrir le ticket';

  @override
  String get closeIssue => 'Fermer le ticket';

  @override
  String get reopenIssue => 'Rouvrir le ticket';

  @override
  String get deleteComment => 'Supprimer le commentaire';

  @override
  String get editComment => 'Modifier le commentaire';

  @override
  String get deleteRepo => 'Supprimer le dépôt';

  @override
  String get deleteRepoConfirm => 'Êtes-vous sûr de vouloir supprimer ce dépôt ? Cette action est irréversible.';

  @override
  String get generalSettings => 'Paramètres généraux';

  @override
  String get appearance => 'Apparence';

  @override
  String get languageSelector => 'Langue';

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get systemDefault => 'Par défaut du système';

  @override
  String get followSystem => 'Suivre le système';

  @override
  String get unsavedChanges => 'Modifications non enregistrées';

  @override
  String get unsavedChangesMessage => 'Vous avez des modifications non enregistrées. Êtes-vous sûr de vouloir quitter ?';

  @override
  String get leave => 'Quitter';

  @override
  String get stay => 'Rester';

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
  String get enterSearchQueryRepos => 'Enter a search query to find repositories';

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
  String get publicDescription => 'Anyone on the internet can see this repository';

  @override
  String get privateDescription => 'You choose who can see and commit to this repository';

  @override
  String get initializeWithReadme => 'Initialize with README';

  @override
  String get initializeWithReadmeDescription => 'Add a README file to help others understand your project';

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
  String get deleteWikiPageConfirm => 'Are you sure you want to delete this wiki page? This action cannot be undone.';

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
  String get noWikiPagesDescription => 'This repository doesn\'t have any wiki pages yet.';

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
  String get deleteMilestoneConfirm => 'Are you sure you want to delete this milestone? This action cannot be undone.';

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
  String get deleteWebhookConfirm => 'Are you sure you want to delete this webhook? This action cannot be undone.';

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
  String get oauth2AuthorizationCodeHint => 'Paste the code from the redirect URL';

  @override
  String get oauth2TokenRefreshed => 'Token refreshed successfully';

  @override
  String get createLabel => 'Create Label';

  @override
  String get editLabel => 'Edit Label';

  @override
  String get deleteLabel => 'Delete Label';

  @override
  String get deleteLabelConfirm => 'Are you sure you want to delete this label?';

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
}
