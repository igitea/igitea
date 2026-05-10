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
  String get users => 'Utilisateurs';

  @override
  String get enterSearchQueryUsers =>
      'Saisissez une requête pour trouver des utilisateurs';

  @override
  String get noResults => 'Aucun résultat trouvé';

  @override
  String get repositories => 'Dépôts';

  @override
  String get repositorySections => 'Sections du dépôt';

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
  String get mergeConfirmMessage =>
      'Êtes-vous sûr de vouloir fusionner cette pull request ?';

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
  String get assignee => 'Responsable';

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
  String get bio => 'Biographie';

  @override
  String joinedOn(Object date) {
    return 'Inscrit le $date';
  }

  @override
  String joinedOnParams(Object date) {
    return 'Inscrit le $date';
  }

  @override
  String followerCount(Object count) {
    return '$count abonnés';
  }

  @override
  String followerCountParams(Object count) {
    return '$count abonnés';
  }

  @override
  String followingCount(Object count) {
    return '$count abonnements';
  }

  @override
  String followingCountParams(Object count) {
    return '$count abonnements';
  }

  @override
  String repositoryCount(Object count) {
    return '$count dépôts';
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
    return 'Dernière exécution : $time';
  }

  @override
  String lastRunParams(Object time) {
    return 'Dernière exécution : $time';
  }

  @override
  String nextRun(Object time) {
    return 'Prochaine exécution : $time';
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
    return 'Notifications non lues : $count';
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
    return 'il y a $time';
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
  String get deleteRepoConfirm =>
      'Êtes-vous sûr de vouloir supprimer ce dépôt ? Cette action est irréversible.';

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
  String get unsavedChangesMessage =>
      'Vous avez des modifications non enregistrées. Êtes-vous sûr de vouloir quitter ?';

  @override
  String get leave => 'Quitter';

  @override
  String get stay => 'Rester';

  @override
  String get restoringSession => 'Restauration de la session...';

  @override
  String get pleaseEnterServerUrl => 'Veuillez saisir une URL de serveur';

  @override
  String get pleaseEnterValidUrl => 'Veuillez saisir une URL valide';

  @override
  String get connectToGitea => 'Connectez-vous à votre instance Gitea';

  @override
  String get usernamePassword => 'Identifiant et Mot de passe';

  @override
  String get serverUrl => 'URL du serveur';

  @override
  String get enterUsername => 'Entrez votre nom d\'utilisateur';

  @override
  String get pleaseEnterUsername => 'Veuillez entrer votre nom d\'utilisateur';

  @override
  String get enterPassword => 'Entrez votre mot de passe';

  @override
  String get pleaseEnterPassword => 'Veuillez entrer votre mot de passe';

  @override
  String get pasteAccessToken => 'Collez votre jeton d\'accès personnel';

  @override
  String get pleaseEnterAccessToken => 'Veuillez entrer un jeton d\'accès';

  @override
  String get signInWithToken => 'Connexion avec Token';

  @override
  String get welcomeToIgitea => 'Bienvenue sur iGitea';

  @override
  String get signInToGetStarted => 'Connectez-vous pour commencer';

  @override
  String get quickActions => 'Actions rapides';

  @override
  String get yourRepositories => 'Vos dépôts';

  @override
  String get noRepositoriesFound => 'Aucun dépôt trouvé';

  @override
  String helloParams(Object full_name) {
    return 'Bonjour, $full_name!';
  }

  @override
  String get user => 'Utilisateur';

  @override
  String get private => 'Privé';

  @override
  String get untitled => 'Sans titre';

  @override
  String get enterSearchQueryRepos =>
      'Entrez une requête pour trouver des dépôts';

  @override
  String get enterSearchQueryIssues =>
      'Entrez une requête pour trouver des tickets';

  @override
  String get noIssuesFound => 'Aucun ticket trouvé.';

  @override
  String get failedToLoadProfile => 'Échec du chargement du profil';

  @override
  String get unknownUser => 'Utilisateur inconnu';

  @override
  String get admin => 'Admin';

  @override
  String get repos => 'Dépôts';

  @override
  String get followers => 'Abonnés';

  @override
  String get following => 'Abonnements';

  @override
  String get follow => 'Suivre';

  @override
  String get unfollow => 'Ne plus suivre';

  @override
  String get signOutConfirmMessage =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get chooseTheme => 'Choisir le thème';

  @override
  String get loadingSettings => 'Chargement des paramètres...';

  @override
  String get userManagementComingSoon =>
      'Gestion des utilisateurs bientôt disponible';

  @override
  String get maxResponseItems => 'Nombre max de réponses';

  @override
  String get defaultPagingNum => 'Nombre de pagination par défaut';

  @override
  String get defaultMaxBlobSize => 'Taille max de blob par défaut';

  @override
  String get defaultTheme => 'Thème par défaut';

  @override
  String get allowedReactions => 'Réactions autorisées';

  @override
  String get attachments => 'Pièces jointes';

  @override
  String get enabled => 'Activé';

  @override
  String get maxFiles => 'Fichiers max';

  @override
  String get maxSize => 'Taille max';

  @override
  String get allowedTypes => 'Types autorisés';

  @override
  String get bytes => 'bytes';

  @override
  String get repository => 'Dépôt';

  @override
  String get httpGitDisabled => 'HTTP Git désactivé';

  @override
  String get lfsDisabled => 'LFS désactivé';

  @override
  String get migrationsDisabled => 'Migrations désactivées';

  @override
  String get mirrorsDisabled => 'Miroirs désactivés';

  @override
  String get starsDisabled => 'Étoiles désactivées';

  @override
  String get timeTrackingDisabled => 'Suivi temporel désactivé';

  @override
  String get yes => 'Oui';

  @override
  String get no => 'Non';

  @override
  String get schedule => 'Schedule';

  @override
  String get next => 'Suivant';

  @override
  String get executions => 'Exécutions';

  @override
  String get failedToLoadCronTasks => 'Échec du chargement des tâches cron';

  @override
  String get noCronTasksFound => 'Aucune tâche cron trouvée';

  @override
  String cronTriggeredParams(Object name) {
    return 'Cron \"$name\" déclenché';
  }

  @override
  String get unknown => 'Inconnu';

  @override
  String openedParams(Object time) {
    return 'ouvert $time';
  }

  @override
  String get noDescriptionProvided => 'Aucune description fournie.';

  @override
  String get failedToLoadComments => 'Échec du chargement des commentaires';

  @override
  String get writeComment => 'Écrire un commentaire';

  @override
  String commentsCountParams(Object count) {
    return '$count commentaires';
  }

  @override
  String updatedParams(Object time) {
    return 'Mis à jour $time';
  }

  @override
  String commentsParams(Object count) {
    return 'Commentaires ($count)';
  }

  @override
  String get files => 'fichiers';

  @override
  String get mergeable => 'Fusionnable';

  @override
  String get merged => 'Fusionné';

  @override
  String get draft => 'Brouillon';

  @override
  String get failedToLoadRepo => 'Échec du chargement du dépôt';

  @override
  String get copyUrl => 'Copier l\'URL';

  @override
  String get urlCopied => 'URL copiée';

  @override
  String get emptyDirectory => 'Répertoire vide';

  @override
  String get noIssues => 'Aucune issue';

  @override
  String get noPullRequests => 'Aucune pull request';

  @override
  String get noReleases => 'Aucune version';

  @override
  String get noBranches => 'Aucune branche';

  @override
  String get preRelease => 'Pré-version';

  @override
  String get archived => 'Archivé';

  @override
  String get defaultBranch => 'Branche par défaut';

  @override
  String get copyCode => 'Copier le code';

  @override
  String get failedToLoadFile => 'Échec du chargement du fichier';

  @override
  String get filePreviewNotAvailable => 'Aperçu du fichier non disponible';

  @override
  String get download => 'Télécharger';

  @override
  String get failedToOpenDownloadUrl =>
      'Échec d\'ouverture de l\'URL de téléchargement';

  @override
  String get noNotifications => 'Aucune notification';

  @override
  String get noTitle => 'Pas de titre';

  @override
  String get allNotificationsMarkedAsRead =>
      'Toutes les notifications marquées comme lues';

  @override
  String get createUser => 'Créer un utilisateur';

  @override
  String get editUser => 'Modifier l\'utilisateur';

  @override
  String get deleteIssue => 'Supprimer l\'issue';

  @override
  String get deleteIssueConfirm =>
      'Êtes-vous sûr de vouloir supprimer cette issue ? Cette action est irréversible.';

  @override
  String get issueDeleted => 'Issue supprimée';

  @override
  String get deleteUser => 'Supprimer l\'utilisateur';

  @override
  String deleteUserConfirmParams(Object username) {
    return 'Êtes-vous sûr de vouloir supprimer l\'utilisateur \"$username\" ? Cette action est irréversible.';
  }

  @override
  String get userCreated => 'Utilisateur créé avec succès';

  @override
  String get userUpdated => 'Utilisateur mis à jour avec succès';

  @override
  String get userDeleted => 'Utilisateur supprimé avec succès';

  @override
  String get noUsersFound => 'Aucun utilisateur trouvé';

  @override
  String get pleaseEnterEmail => 'Veuillez entrer un e-mail';

  @override
  String get fullName => 'Nom complet';

  @override
  String get mustChangePassword =>
      'Doit changer le mot de passe à la première connexion';

  @override
  String get pleaseEnterTitle => 'Veuillez entrer un titre';

  @override
  String get noActivity => 'Aucune activité';

  @override
  String get createdRepo => 'dépôt créé';

  @override
  String get pushedTag => 'tag poussé';

  @override
  String get deletedTag => 'tag supprimé';

  @override
  String get createdIssue => 'ticket créé';

  @override
  String get closedIssue => 'ticket fermé';

  @override
  String get reopenedIssue => 'ticket rouvert';

  @override
  String get createdPR => 'pull request créée';

  @override
  String get mergedPR => 'pull request fusionnée';

  @override
  String get closedPR => 'pull request fermée';

  @override
  String get commentedOnIssue => 'a commenté le ticket';

  @override
  String get commentedOnPR => 'a commenté la pull request';

  @override
  String get forkedRepo => 'dépôt forké';

  @override
  String get transferredRepo => 'dépôt transféré';

  @override
  String get deletedRepo => 'dépôt supprimé';

  @override
  String get updatedWiki => 'wiki mis à jour';

  @override
  String get performedAction => 'action effectuée';

  @override
  String get commitRepo => 'a commit sur';

  @override
  String get renameRepo => 'dépôt renommé';

  @override
  String get starRepo => 'dépôt staré';

  @override
  String get watchRepo => 'a commencé à suivre';

  @override
  String get reopenPR => 'pull request rouverte';

  @override
  String get approvePR => 'pull request approuvée';

  @override
  String get rejectPR => 'pull request rejetée';

  @override
  String get publishRelease => 'version publiée';

  @override
  String get deleteBranch => 'branche supprimée';

  @override
  String get autoMergePR => 'pull request fusionnée automatiquement';

  @override
  String get pullReviewDismissed => 'review de pull request rejetée';

  @override
  String get pullRequestReady => 'pull request marquée comme prête';

  @override
  String get mirrorSyncPush => 'push synchronisé vers le miroir';

  @override
  String get mirrorSyncCreate => 'création synchronisée vers le miroir';

  @override
  String get mirrorSyncDelete => 'suppression synchronisée vers le miroir';

  @override
  String get inRepo => 'dans';

  @override
  String get to => 'vers';

  @override
  String get from => 'de';

  @override
  String get headBranch => 'Branche source';

  @override
  String get baseBranch => 'Branche cible';

  @override
  String get pleaseFillAllFields =>
      'Veuillez remplir tous les champs obligatoires';

  @override
  String get settingsSaved => 'Paramètres enregistrés';

  @override
  String get privateRepo => 'Dépôt privé';

  @override
  String get privateRepoDesc =>
      'Visible uniquement par vous et les collaborateurs';

  @override
  String get enableIssues => 'Activer les tickets';

  @override
  String get enablePullRequests => 'Activer les pull requests';

  @override
  String get enableWiki => 'Activer le Wiki';

  @override
  String get preview => 'Aperçu';

  @override
  String get commitMessage => 'Message de commit';

  @override
  String get commit => 'Commit';

  @override
  String get commitMessageHint => 'Décrivez vos modifications (optionnel)';

  @override
  String get cannotGetFileSha =>
      'Impossible d\'obtenir le SHA du fichier. Veuillez recharger le fichier.';

  @override
  String get failedToSaveFile => 'Échec de l\'enregistrement du fichier';

  @override
  String get fileSaved => 'Fichier enregistré avec succès';

  @override
  String get discard => 'Annuler';

  @override
  String get message => 'Message';

  @override
  String get ok => 'OK';

  @override
  String get sha => 'SHA';

  @override
  String get changedFiles => 'Fichiers modifiés';

  @override
  String get tags => 'Étiquettes';

  @override
  String get noCommits => 'Aucun commit';

  @override
  String get noTags => 'Aucun tag';

  @override
  String get protected => 'Protégé';

  @override
  String get latestCommit => 'Dernier commit';

  @override
  String get permissions => 'Permissions';

  @override
  String get canPush => 'Peut pousser';

  @override
  String get canMerge => 'Peut fusionner';

  @override
  String get downloads => 'Téléchargements';

  @override
  String get tarball => 'Tarball';

  @override
  String get zipball => 'Zipball';

  @override
  String get downloadTarball => 'Télécharger Tarball';

  @override
  String get downloadZipball => 'Télécharger Zipball';

  @override
  String get url => 'URL';

  @override
  String get info => 'Infos';

  @override
  String get teams => 'Équipes';

  @override
  String get noTeams => 'Aucune équipe';

  @override
  String get location => 'Emplacement';

  @override
  String get visibility => 'Visibilité';

  @override
  String get assets => 'Actifs';

  @override
  String get publishedAt => 'Publié le';

  @override
  String get target => 'Cible';

  @override
  String get forked => 'Forké';

  @override
  String get forkRepoConfirm =>
      'Cela créera un fork de ce dépôt dans votre compte.';

  @override
  String get editIssue => 'Modifier le ticket';

  @override
  String get titleRequired => 'Le titre est requis';

  @override
  String get selectMilestone => 'Sélectionner un jalon';

  @override
  String get members => 'Membres';

  @override
  String get noMembers => 'Aucun membre';

  @override
  String get editOrganization => 'Modifier l\'organisation';

  @override
  String get createOrganization => 'Créer une organisation';

  @override
  String get createRepository => 'Créer un dépôt';

  @override
  String get repositoryName => 'Nom du dépôt';

  @override
  String get repositoryNameHint => 'my-awesome-repo';

  @override
  String get repositoryNameRequired => 'Le nom du dépôt est requis';

  @override
  String get descriptionHint => 'Brève description de votre dépôt';

  @override
  String get public => 'Public';

  @override
  String get publicDescription =>
      'Tout le monde sur Internet peut voir ce dépôt';

  @override
  String get privateDescription =>
      'Vous choisissez qui peut voir et contribuer à ce dépôt';

  @override
  String get initializeWithReadme => 'Initialiser avec README';

  @override
  String get initializeWithReadmeDescription =>
      'Ajoutez un fichier README pour aider les autres à comprendre votre projet';

  @override
  String repoCreated(Object repoName) {
    return 'Dépôt \'$repoName\' créé avec succès';
  }

  @override
  String get complete => 'terminé';

  @override
  String get wiki => 'Wiki';

  @override
  String get newWikiPage => 'Nouvelle page Wiki';

  @override
  String get editWikiPage => 'Modifier la page Wiki';

  @override
  String get deleteWikiPage => 'Supprimer la page Wiki';

  @override
  String get deleteWikiPageConfirm =>
      'Êtes-vous sûr de vouloir supprimer cette page Wiki ? Cette action est irréversible.';

  @override
  String get wikiPageDeleted => 'Page Wiki supprimée';

  @override
  String get wikiPageTitle => 'Titre de la page';

  @override
  String get wikiPageTitleHint => 'e.g. Home';

  @override
  String get wikiPageContent => 'Contenu';

  @override
  String get wikiPageContentHint => 'Write in Markdown...';

  @override
  String get noWikiPages => 'Aucune page Wiki';

  @override
  String get noWikiPagesDescription =>
      'Ce dépôt n\'a pas encore de pages Wiki.';

  @override
  String get createFirstWikiPage => 'Créer la première page';

  @override
  String get lastCommit => 'Dernier commit';

  @override
  String get noContent => 'Pas de contenu';

  @override
  String get saved => 'Enregistré';

  @override
  String get created => 'Créé';

  @override
  String get createMilestone => 'Créer un jalon';

  @override
  String get editMilestone => 'Modifier le jalon';

  @override
  String get deleteMilestone => 'Supprimer le jalon';

  @override
  String get deleteMilestoneConfirm =>
      'Êtes-vous sûr de vouloir supprimer ce jalon ? Cette action est irréversible.';

  @override
  String get milestoneDeleted => 'Jalon supprimé';

  @override
  String get milestoneTitle => 'Titre';

  @override
  String get milestoneDescription => 'Description';

  @override
  String get milestoneDescriptionHint => 'Décrivez ce jalon';

  @override
  String get milestoneDueDate => 'Date d\'échéance';

  @override
  String get milestoneState => 'État';

  @override
  String get milestoneStateOpen => 'Ouvert';

  @override
  String get milestoneStateClosed => 'Fermé';

  @override
  String get total => 'Total';

  @override
  String get clear => 'Effacer';

  @override
  String get webhooks => 'Webhooks';

  @override
  String get webhook => 'Webhook';

  @override
  String get noWebhooks => 'Aucun webhook';

  @override
  String get createWebhook => 'Créer un webhook';

  @override
  String get editWebhook => 'Modifier le webhook';

  @override
  String get deleteWebhook => 'Supprimer le webhook';

  @override
  String get deleteWebhookConfirm =>
      'Êtes-vous sûr de vouloir supprimer ce webhook ? Cette action est irréversible.';

  @override
  String get webhookDeleted => 'Webhook supprimé';

  @override
  String get webhookUrl => 'URL';

  @override
  String get webhookUrlHint => 'https://example.com/webhook';

  @override
  String get webhookSecret => 'Secret';

  @override
  String get webhookSecretHint => 'Jeton secret optionnel';

  @override
  String get webhookContentType => 'Type de contenu';

  @override
  String get webhookContentTypeJson => 'application/json';

  @override
  String get webhookContentTypeForm => 'application/x-www-form-urlencoded';

  @override
  String get webhookEvents => 'Événements';

  @override
  String get webhookEventsHint =>
      'Sélectionnez les événements déclenchant ce webhook';

  @override
  String get webhookActive => 'Actif';

  @override
  String get webhookInactive => 'Inactif';

  @override
  String get webhookType => 'Type';

  @override
  String get webhookCreatedAt => 'Créé';

  @override
  String get webhookUpdatedAt => 'Mis à jour';

  @override
  String get webhookLastDelivery => 'Dernière livraison';

  @override
  String get webhookSelectAllEvents => 'Tout sélectionner';

  @override
  String get webhookPushEvents => 'Push';

  @override
  String get webhookPullRequestEvents => 'Pull Requests';

  @override
  String get webhookIssuesEvents => 'Tickets';

  @override
  String get webhookCreateEvents => 'Création';

  @override
  String get webhookDeleteEvents => 'Suppression';

  @override
  String get webhookReleaseEvents => 'Versions';

  @override
  String get webhookWikiEvents => 'Wiki';

  @override
  String get webhookStarEvents => 'Étoile';

  @override
  String get webhookForkEvents => 'Fork';

  @override
  String get loginWithOAuth2 => 'Connexion avec OAuth2';

  @override
  String get oauth2 => 'OAuth2';

  @override
  String get oauth2Description => 'Autoriser via l\'application OAuth2 Gitea';

  @override
  String get oauth2ClientId => 'ID client';

  @override
  String get oauth2ClientSecret => 'Secret client';

  @override
  String get oauth2RedirectUri => 'URI de redirection';

  @override
  String get oauth2RedirectUriHint => 'igitea://oauth/callback';

  @override
  String get oauth2Authorize => 'Ouvrir la page d\'autorisation';

  @override
  String get oauth2ExchangeCode => 'Échanger le code pour un jeton';

  @override
  String get oauth2AuthorizationCode => 'Code d\'autorisation';

  @override
  String get oauth2AuthorizationCodeHint =>
      'Collez le code depuis l\'URL de redirection';

  @override
  String get oauth2TokenRefreshed => 'Jeton actualisé avec succès';

  @override
  String get createLabel => 'Créer une étiquette';

  @override
  String get editLabel => 'Modifier l\'étiquette';

  @override
  String get deleteLabel => 'Supprimer l\'étiquette';

  @override
  String get deleteLabelConfirm =>
      'Êtes-vous sûr de vouloir supprimer cette étiquette ?';

  @override
  String get labelDeleted => 'Étiquette supprimée';

  @override
  String get labelName => 'Nom';

  @override
  String get labelNameHint => 'ex: bug';

  @override
  String get labelDescription => 'Description';

  @override
  String get labelDescriptionHint => 'Description optionnelle';

  @override
  String get labelColor => 'Couleur';

  @override
  String get labelColorHint => 'Hex color, e.g. #FF0000';

  @override
  String get filesChanged => 'Fichiers modifiés';

  @override
  String get noFilesChanged => 'Aucun fichier modifié';

  @override
  String get viewDiff => 'Voir le diff';

  @override
  String get unifiedView => 'Vue unifiée';

  @override
  String get splitView => 'Vue divisée';

  @override
  String get compareVersions => 'Comparer les versions';

  @override
  String get baseRef => 'Base (plus ancien)';

  @override
  String get headRef => 'Tête (plus récent)';

  @override
  String get compare => 'Comparer';

  @override
  String get actions => 'Actions';

  @override
  String get noActions => 'Aucun workflow';

  @override
  String get run => 'Exécuter';

  @override
  String get status => 'Statut';

  @override
  String get jobs => 'Tâches';

  @override
  String get noJobs => 'Aucun job';

  @override
  String get artifacts => 'Artefacts';

  @override
  String get branch => 'Branche';

  @override
  String get author => 'Auteur';

  @override
  String get filterByActor => 'Filtrer par acteur';

  @override
  String get filterByStatus => 'Filtrer par statut';

  @override
  String get reviewChanges => 'Revoir les modifications';

  @override
  String get reviewBody => 'Commentaire de review';

  @override
  String get reviews => 'Relectures';

  @override
  String get approve => 'Approuver';

  @override
  String get requestChanges => 'Demander des modifications';

  @override
  String get comment => 'Commentaire';

  @override
  String get blame => 'Blâme';

  @override
  String get diffView => 'Vue Diff';

  @override
  String get pickColor => 'Choisir une couleur';

  @override
  String get sshKeys => 'Clés SSH';

  @override
  String get allRepos => 'Tous les dépôts';

  @override
  String get configuration => 'Configuration';

  @override
  String get none => 'Aucun';

  @override
  String get more => 'Plus';

  @override
  String get units => 'Unités';

  @override
  String get permission => 'Permission';

  @override
  String get repoList => 'Liste des dépôts';

  @override
  String get noChanges => 'Aucun changement';

  @override
  String get limited => 'Limité';

  @override
  String get unknownSection => 'Section inconnue';

  @override
  String get deleteKey => 'Supprimer la clé';

  @override
  String get deleteKeyConfirm =>
      'Êtes-vous sûr de vouloir supprimer cette clé SSH ?';

  @override
  String get keyDeleted => 'Clé supprimée avec succès';

  @override
  String get addSshKey => 'Ajouter une clé SSH';

  @override
  String get add => 'Ajouter';

  @override
  String get keyAdded => 'Clé ajoutée avec succès';

  @override
  String get deleteCommentConfirm =>
      'Êtes-vous sûr de vouloir supprimer ce commentaire ?';

  @override
  String get requestReviewers => 'Demander des relecteurs';

  @override
  String get addReviewerHint => 'Entrez le nom du relecteur';

  @override
  String get subscribe => 'S\'abonner';

  @override
  String get unsubscribe => 'Se désabonner';

  @override
  String get subscribed => 'Abonné';

  @override
  String get unsubscribed => 'Désabonné';

  @override
  String get setDueDate => 'Définir la date d\'échéance';

  @override
  String get removeDueDate => 'Supprimer la date d\'échéance';

  @override
  String get topics => 'Sujets';

  @override
  String get noTopics => 'Aucun sujet';

  @override
  String get branchProtection => 'Protection de branche';

  @override
  String get protectBranch => 'Protéger la branche';

  @override
  String get https => 'HTTPS';

  @override
  String get ssh => 'SSH';

  @override
  String get teamAdminAccess => 'Accès admin d\'équipe';

  @override
  String get details => 'Détails';

  @override
  String get id => 'ID';

  @override
  String get searchRepositoriesHint => 'Rechercher des dépôts';

  @override
  String get publicKey => 'Clé publique';

  @override
  String get failedToGetAccessToken => 'Échec d\'obtention du jeton d\'accès';

  @override
  String get fileNotFound => 'Fichier non trouvé';

  @override
  String get noSshKeysFound => 'Aucune clé SSH trouvée';

  @override
  String get other => 'Autre';

  @override
  String get usernameRequired => 'Nom d\'utilisateur requis';

  @override
  String get myLaptopHint => 'Mon ordinateur';

  @override
  String get sshPublicKeyHint => 'Collez votre clé publique SSH ici';

  @override
  String get noChangesFoundForFile =>
      'Aucune modification trouvée pour ce fichier';

  @override
  String commitUpdateFile(Object fileName) {
    return 'Mettre à jour $fileName';
  }

  @override
  String get api => 'API';

  @override
  String get ui => 'UI';

  @override
  String get justNow => 'à l\'instant';

  @override
  String get packages => 'Paquets';

  @override
  String get noPackages => 'Aucun paquet trouvé';

  @override
  String get packageType => 'Type';

  @override
  String get packageVersion => 'Version';

  @override
  String get packageFiles => 'Fichiers';

  @override
  String get packageSize => 'Taille';

  @override
  String get packageCreator => 'Créateur';

  @override
  String get packageCreated => 'Créé';

  @override
  String get packageRepository => 'Dépôt';

  @override
  String get deletePackage => 'Supprimer le Paquet';

  @override
  String get deletePackageConfirm =>
      'Êtes-vous sûr de vouloir supprimer cette version du paquet ? Cette action est irréversible.';

  @override
  String get packageDeleted => 'Version du paquet supprimée avec succès';

  @override
  String get allTypes => 'Tous';

  @override
  String get installation => 'Installation';

  @override
  String get packageUrl => 'URL du paquet';

  @override
  String get copy => 'Copier';

  @override
  String get totalSize => 'Taille totale';

  @override
  String get versions => 'Versions';

  @override
  String get noVersions => 'Aucune version';

  @override
  String get createRelease => 'Créer une Release';

  @override
  String get editRelease => 'Modifier la Release';

  @override
  String get deleteRelease => 'Supprimer la Release';

  @override
  String get deleteReleaseConfirm =>
      'Êtes-vous sûr de vouloir supprimer cette release ? Cette action est irréversible.';

  @override
  String get releaseTagName => 'Nom du tag';

  @override
  String get releaseTagNameRequired => 'Le nom du tag est requis';

  @override
  String get releaseTitle => 'Titre de la release';

  @override
  String get releaseBody => 'Notes de release';

  @override
  String get targetCommitish => 'Cible';

  @override
  String get tagMessage => 'Message du tag';

  @override
  String get releaseCreated => 'Release créée avec succès';

  @override
  String get releaseUpdated => 'Release mise à jour avec succès';

  @override
  String get releaseDeleted => 'Release supprimée avec succès';

  @override
  String get chooseTag => 'Choisir un tag';

  @override
  String get defaultLabels => 'Sélection rapide';

  @override
  String get applyLabelSet => 'Appliquer le jeu d\'étiquettes';

  @override
  String get applyLabelSetDescription =>
      'Sélectionnez un jeu d\'étiquettes prédéfini pour créer toutes les étiquettes en une fois.';

  @override
  String applyAllLabels(Object count) {
    return 'Tout appliquer ($count étiquettes)';
  }

  @override
  String applyAllLabelsParams(Object count) {
    return 'Tout appliquer ($count étiquettes)';
  }

  @override
  String get creating => 'Création...';

  @override
  String get addCustomLabel => 'Ajouter une étiquette personnalisée';

  @override
  String get selectTemplate => 'Sélectionner un modèle';

  @override
  String get createTeam => 'Créer équipe';

  @override
  String get editTeam => 'Modifier équipe';

  @override
  String get deleteTeam => 'Supprimer équipe';

  @override
  String get deleteTeamConfirm => 'Supprimer cette équipe ?';

  @override
  String get teamName => 'Nom';

  @override
  String get teamNameRequired => 'Nom requis';

  @override
  String get teamDescription => 'Description';

  @override
  String get teamPermission => 'Permission';

  @override
  String get searchMembers => 'Rechercher';

  @override
  String get addMember => 'Ajouter';

  @override
  String get removeMember => 'Retirer';

  @override
  String removeMemberConfirmParams(Object username) {
    return 'Retirer $username ?';
  }

  @override
  String get teamCreated => 'Équipe créée';

  @override
  String get teamUpdated => 'Équipe mise à jour';

  @override
  String get teamDeleted => 'Équipe supprimée';

  @override
  String get memberAdded => 'Membre ajouté';

  @override
  String get memberRemoved => 'Membre retiré';

  @override
  String get noSearchResults => 'Aucun résultat';

  @override
  String get teamCanCreateOrgRepos => 'Peut créer des dépôts d\'organisation';

  @override
  String get teamIncludesAllRepos => 'Inclut tous les dépôts';

  @override
  String get collaborators => 'Collaborateurs';

  @override
  String get noCollaborators => 'Aucun';

  @override
  String get addCollaborator => 'Ajouter';

  @override
  String get removeCollaborator => 'Retirer';

  @override
  String removeCollaboratorConfirmParams(Object username) {
    return 'Retirer $username ?';
  }

  @override
  String get collaboratorAdded => 'Ajouté';

  @override
  String get collaboratorRemoved => 'Retiré';

  @override
  String get contentType => 'Type de contenu';

  @override
  String get active => 'Actif';

  @override
  String get emails => 'Emails';

  @override
  String get addEmail => 'Ajouter email';

  @override
  String get gpgKeys => 'Clés GPG';

  @override
  String get addGpgKey => 'Ajouter une clé GPG';

  @override
  String get gpgKeyHint => '-----BEGIN PGP PUBLIC KEY BLOCK-----';

  @override
  String get gpgKeyAdded => 'Clé GPG ajoutée';

  @override
  String get gpgKeyDeleted => 'Clé GPG supprimée';

  @override
  String get deleteGpgKey => 'Supprimer la clé GPG';

  @override
  String get deleteGpgKeyConfirm =>
      'Êtes-vous sûr de vouloir supprimer cette clé GPG ?';

  @override
  String get noGpgKeys => 'Aucune clé GPG';

  @override
  String get sign => 'Signer';

  @override
  String get certify => 'Certifier';

  @override
  String get verified => 'Vérifié';

  @override
  String get tagProtections => 'Protection des tags';

  @override
  String get manageTagProtections => 'Gérer les règles de protection des tags';

  @override
  String get createTagProtection => 'Créer une protection de tag';

  @override
  String get namePattern => 'Modèle de nom';

  @override
  String get tagProtectionCreated => 'Protection de tag créée';

  @override
  String get tagProtectionDeleted => 'Protection de tag supprimée';

  @override
  String get deleteTagProtection => 'Supprimer la protection de tag';

  @override
  String get deleteTagProtectionConfirm =>
      'Êtes-vous sûr de vouloir supprimer cette protection de tag ?';

  @override
  String get noTagProtections => 'Aucune protection de tag';

  @override
  String get allowedUsers => 'Utilisateurs autorisés';

  @override
  String get dependencies => 'Dépendances';

  @override
  String get addDependency => 'Ajouter une dépendance';

  @override
  String get dependencyAdded => 'Dépendance ajoutée';

  @override
  String get dependencyRemoved => 'Dépendance supprimée';

  @override
  String get removeDependency => 'Supprimer la dépendance';

  @override
  String get removeDependencyConfirm => 'Supprimer cette dépendance ?';

  @override
  String get noDependencies => 'Aucune dépendance';

  @override
  String get blocks => 'Bloque';

  @override
  String get dependsOn => 'Dépend de';

  @override
  String get issueNumberHint => 'Issue n°';

  @override
  String get events => 'événements';

  @override
  String get items => 'éléments';

  @override
  String get commented => 'a commenté';

  @override
  String get labelUpdated => 'Label mis à jour';

  @override
  String get milestoneUpdated => 'Jalon mis à jour';

  @override
  String get assigneeUpdated => 'Assigné mis à jour';

  @override
  String get reopened => 'Rouvert';

  @override
  String get stargazers => 'Stargazers';

  @override
  String get subscribers => 'Abonnés';

  @override
  String get noStargazers => 'Pas encore de stargazers';

  @override
  String get noSubscribers => 'Pas encore d\'abonnés';

  @override
  String get adminHooksTitle => 'Hooks système';

  @override
  String get adminCronTitle => 'Tâches Cron';

  @override
  String get adminRunnersTitle => 'Runners Actions';

  @override
  String get adminEmailsTitle => 'E-mails';

  @override
  String get adminBadgesTitle => 'Badges';

  @override
  String get adminRunCron => 'Exécuter maintenant';

  @override
  String get adminGetToken => 'Obtenir le jeton d\'inscription';

  @override
  String get adminNoHooks => 'Aucun hook système configuré';

  @override
  String get adminNoCron => 'Aucune tâche cron';

  @override
  String get adminNoRunners => 'Aucun runner d\'actions';

  @override
  String get adminNoEmails => 'Aucun email';

  @override
  String get adminNoBadges => 'Aucun badge';

  @override
  String get adminBadgeUsername => 'Nom d\'utilisateur';

  @override
  String get adminBadgeDescription => 'Description';

  @override
  String get oauthAppsTitle => 'Applications OAuth';

  @override
  String get oauthNoApps => 'Aucune application OAuth';

  @override
  String get oauthCreateApp => 'Créer une application OAuth';

  @override
  String get oauthRedirectUri => 'URI de redirection';

  @override
  String get oauthDeleteAppConfirm => 'Supprimer l\'application OAuth';

  @override
  String get name => 'Nom';

  @override
  String get confirmDelete => 'Confirmer la suppression';

  @override
  String get actionsSecretsTitle => 'Secrets Actions';

  @override
  String get actionsVariablesTitle => 'Variables Actions';

  @override
  String get actionsNoSecrets => 'Aucun secret configuré';

  @override
  String get actionsNoVariables => 'Aucune variable configurée';

  @override
  String get actionsCreateSecret => 'Créer un Secret';

  @override
  String get actionsCreateVariable => 'Créer une Variable';

  @override
  String get actionsSecretName => 'Nom du Secret';

  @override
  String get actionsSecretValue => 'Valeur du Secret';

  @override
  String get actionsVariableName => 'Nom de la Variable';

  @override
  String get actionsVariableValue => 'Valeur de la Variable';

  @override
  String get actionsDeleteSecretConfirm => 'Supprimer ce secret ?';

  @override
  String get actionsDeleteVariableConfirm => 'Supprimer cette variable ?';

  @override
  String get deleted => 'Supprimé';

  @override
  String get overdue => 'En retard';

  @override
  String get addTopic => 'Ajouter un sujet';

  @override
  String get importRepository => 'Importer un dépôt';

  @override
  String get import => 'Importer';

  @override
  String get repoImported => 'Dépôt importé';

  @override
  String get cloneUrl => 'URL de clonage';

  @override
  String get repoOwner => 'Propriétaire';

  @override
  String get gitService => 'Service Git';

  @override
  String get authentication => 'Authentification';

  @override
  String get authUsername => 'Nom d\'utilisateur d\'authentification';

  @override
  String get authPassword => 'Mot de passe d\'authentification';

  @override
  String get authToken => 'Jeton d\'authentification';

  @override
  String get migrationOptions => 'Options';

  @override
  String get migrateData => 'Données à importer';

  @override
  String get mirror => 'Miroir';

  @override
  String get mirrorInterval => 'Intervalle de miroir';

  @override
  String get requiredField => 'Ce champ est obligatoire';

  @override
  String get personal => 'Personnel';

  @override
  String get deleteOrganization => 'Supprimer l\'organisation';

  @override
  String get deleteOrganizationConfirm =>
      'Êtes-vous sûr de vouloir supprimer cette organisation ? Cette action est irréversible.';

  @override
  String get organizationDeleted => 'Organisation supprimée';

  @override
  String get accessTokens => 'Jetons d\'accès';

  @override
  String get createToken => 'Créer un jeton';

  @override
  String get tokenName => 'Nom du jeton';

  @override
  String get tokenCreated => 'Jeton créé';

  @override
  String get tokenValueWarning =>
      'Copiez ce jeton maintenant. Vous ne pourrez plus le voir ensuite.';

  @override
  String get failedToCreateToken => 'Échec de la création du jeton';

  @override
  String get deleteToken => 'Supprimer le jeton';

  @override
  String get deleteTokenConfirm => 'Êtes-vous sûr de vouloir supprimer';

  @override
  String get tokenDeleted => 'Jeton supprimé';

  @override
  String get noTokens => 'Aucun jeton d\'accès';

  @override
  String get scopes => 'Portées';

  @override
  String get selectAll => 'Tout sélectionner';

  @override
  String get deselectAll => 'Tout désélectionner';

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
