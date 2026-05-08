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
  String get users => 'Benutzer';

  @override
  String get enterSearchQueryUsers =>
      'Suchbegriff eingeben, um Benutzer zu finden';

  @override
  String get noResults => 'Keine Ergebnisse gefunden';

  @override
  String get repositories => 'Repositorys';

  @override
  String get repositorySections => 'Repository-Abschnitte';

  @override
  String get issues => 'Issues';

  @override
  String get pullRequests => 'Pull Requests';

  @override
  String get releases => 'Veröffentlichungen';

  @override
  String get branches => 'Zweige';

  @override
  String get code => 'Code';

  @override
  String get stars => 'Sterne';

  @override
  String get forks => 'Abspaltungen';

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
  String get labels => 'Kennzeichnungen';

  @override
  String get milestones => 'Meilensteine';

  @override
  String get assignees => 'Zugewiesen';

  @override
  String get assignee => 'Zuständiger';

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
    return '$count Follower';
  }

  @override
  String followerCountParams(Object count) {
    return '$count Follower';
  }

  @override
  String followingCount(Object count) {
    return '$count Gefolgte';
  }

  @override
  String followingCountParams(Object count) {
    return '$count Following';
  }

  @override
  String repositoryCount(Object count) {
    return '$count Repositorien';
  }

  @override
  String repositoryCountParams(Object count) {
    return '$count Repositories';
  }

  @override
  String get starredRepos => 'Favorisierte Repositorien';

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
    return 'Letzte Ausführung: $time';
  }

  @override
  String lastRunParams(Object time) {
    return 'Letzte Ausführung: $time';
  }

  @override
  String nextRun(Object time) {
    return 'Nächste Ausführung: $time';
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
  String get feed => 'Aktivitäten';

  @override
  String get markAllRead => 'Alle als gelesen markieren';

  @override
  String get markRead => 'Als gelesen markieren';

  @override
  String unreadNotifications(Object count) {
    return 'Ungelesene Benachrichtigungen: $count';
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
    return 'vor $time';
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
  String get restoringSession => 'Sitzung wird wiederhergestellt...';

  @override
  String get pleaseEnterServerUrl => 'Bitte geben Sie eine Server-URL ein';

  @override
  String get pleaseEnterValidUrl => 'Bitte geben Sie eine gültige URL ein';

  @override
  String get connectToGitea => 'Mit Ihrer Gitea-Instanz verbinden';

  @override
  String get usernamePassword => 'Benutzername & Passwort';

  @override
  String get serverUrl => 'Server-URL';

  @override
  String get enterUsername => 'Benutzernamen eingeben';

  @override
  String get pleaseEnterUsername => 'Bitte geben Sie Ihren Benutzernamen ein';

  @override
  String get enterPassword => 'Passwort eingeben';

  @override
  String get pleaseEnterPassword => 'Bitte geben Sie Ihr Passwort ein';

  @override
  String get pasteAccessToken => 'Persönlichen Zugriffstoken einfügen';

  @override
  String get pleaseEnterAccessToken =>
      'Bitte geben Sie einen Zugriffstoken ein';

  @override
  String get signInWithToken => 'Mit Token anmelden';

  @override
  String get welcomeToIgitea => 'Willkommen bei iGitea';

  @override
  String get signInToGetStarted => 'Melden Sie sich an, um zu beginnen';

  @override
  String get quickActions => 'Schnellaktionen';

  @override
  String get yourRepositories => 'Ihre Repositorys';

  @override
  String get noRepositoriesFound => 'Keine Repositorys gefunden';

  @override
  String helloParams(Object full_name) {
    return 'Hallo, $full_name!';
  }

  @override
  String get user => 'Benutzer';

  @override
  String get private => 'Privat';

  @override
  String get untitled => 'Unbenannt';

  @override
  String get enterSearchQueryRepos =>
      'Suchbegriff eingeben, um Repositorien zu finden';

  @override
  String get enterSearchQueryIssues =>
      'Suchbegriff eingeben, um Issues zu finden';

  @override
  String get noIssuesFound => 'Keine Issues gefunden.';

  @override
  String get failedToLoadProfile => 'Profil konnte nicht geladen werden';

  @override
  String get unknownUser => 'Unbekannter Benutzer';

  @override
  String get admin => 'Admin';

  @override
  String get repos => 'Repositorys';

  @override
  String get followers => 'Follower';

  @override
  String get following => 'Folge ich';

  @override
  String get follow => 'Folgen';

  @override
  String get unfollow => 'Entfolgen';

  @override
  String get signOutConfirmMessage =>
      'Sind Sie sicher, dass Sie sich abmelden möchten?';

  @override
  String get chooseTheme => 'Design auswählen';

  @override
  String get loadingSettings => 'Einstellungen werden geladen...';

  @override
  String get userManagementComingSoon =>
      'Benutzerverwaltung demnächst verfügbar';

  @override
  String get maxResponseItems => 'Maximale Antwort-Elemente';

  @override
  String get defaultPagingNum => 'Standard-Seitenzahl';

  @override
  String get defaultMaxBlobSize => 'Standard Max Blob-Größe';

  @override
  String get defaultTheme => 'Standard-Design';

  @override
  String get allowedReactions => 'Erlaubte Reaktionen';

  @override
  String get attachments => 'Anhänge';

  @override
  String get enabled => 'Aktiviert';

  @override
  String get maxFiles => 'Max. Dateien';

  @override
  String get maxSize => 'Max. Größe';

  @override
  String get allowedTypes => 'Erlaubte Typen';

  @override
  String get bytes => 'bytes';

  @override
  String get repository => 'Repository';

  @override
  String get httpGitDisabled => 'HTTP Git deaktiviert';

  @override
  String get lfsDisabled => 'LFS deaktiviert';

  @override
  String get migrationsDisabled => 'Migrationen deaktiviert';

  @override
  String get mirrorsDisabled => 'Spiegel deaktiviert';

  @override
  String get starsDisabled => 'Sterne deaktiviert';

  @override
  String get timeTrackingDisabled => 'Zeiterfassung deaktiviert';

  @override
  String get yes => 'Ja';

  @override
  String get no => 'Nein';

  @override
  String get schedule => 'Schedule';

  @override
  String get next => 'Nächstes';

  @override
  String get executions => 'Ausführungen';

  @override
  String get failedToLoadCronTasks =>
      'Cron-Aufgaben konnten nicht geladen werden';

  @override
  String get noCronTasksFound => 'Keine Cron-Aufgaben gefunden';

  @override
  String cronTriggeredParams(Object name) {
    return 'Cron \"$name\" ausgelöst';
  }

  @override
  String get unknown => 'Unbekannt';

  @override
  String openedParams(Object time) {
    return 'geöffnet $time';
  }

  @override
  String get noDescriptionProvided => 'Keine Beschreibung vorhanden.';

  @override
  String get failedToLoadComments => 'Kommentare konnten nicht geladen werden';

  @override
  String get writeComment => 'Kommentar schreiben';

  @override
  String commentsCountParams(Object count) {
    return '$count Kommentare';
  }

  @override
  String updatedParams(Object time) {
    return 'Aktualisiert $time';
  }

  @override
  String commentsParams(Object count) {
    return 'Kommentare ($count)';
  }

  @override
  String get files => 'Dateien';

  @override
  String get mergeable => 'Zusammenführbar';

  @override
  String get merged => 'Zusammengeführt';

  @override
  String get draft => 'Entwurf';

  @override
  String get failedToLoadRepo => 'Repository konnte nicht geladen werden';

  @override
  String get copyUrl => 'URL kopieren';

  @override
  String get urlCopied => 'URL kopiert';

  @override
  String get emptyDirectory => 'Leeres Verzeichnis';

  @override
  String get noIssues => 'Keine Issues';

  @override
  String get noPullRequests => 'Keine Pull Requests';

  @override
  String get noReleases => 'Keine Veröffentlichungen';

  @override
  String get noBranches => 'Keine Zweige';

  @override
  String get preRelease => 'Vorabversion';

  @override
  String get archived => 'Archiviert';

  @override
  String get defaultBranch => 'Standard-Branch';

  @override
  String get copyCode => 'Code kopieren';

  @override
  String get failedToLoadFile => 'Datei konnte nicht geladen werden';

  @override
  String get filePreviewNotAvailable => 'Dateivorschau nicht verfügbar';

  @override
  String get download => 'Herunterladen';

  @override
  String get failedToOpenDownloadUrl =>
      'Download-URL konnte nicht geöffnet werden';

  @override
  String get noNotifications => 'Keine Benachrichtigungen';

  @override
  String get noTitle => 'Kein Titel';

  @override
  String get allNotificationsMarkedAsRead =>
      'Alle Benachrichtigungen als gelesen markiert';

  @override
  String get createUser => 'Benutzer erstellen';

  @override
  String get editUser => 'Benutzer bearbeiten';

  @override
  String get deleteIssue => 'Issue löschen';

  @override
  String get deleteIssueConfirm =>
      'Möchten Sie diesen Issue wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get issueDeleted => 'Issue gelöscht';

  @override
  String get deleteUser => 'Benutzer löschen';

  @override
  String deleteUserConfirmParams(Object username) {
    return 'Sind Sie sicher, dass Sie den Benutzer \"$username\" löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';
  }

  @override
  String get userCreated => 'Benutzer erfolgreich erstellt';

  @override
  String get userUpdated => 'Benutzer erfolgreich aktualisiert';

  @override
  String get userDeleted => 'Benutzer erfolgreich gelöscht';

  @override
  String get noUsersFound => 'Keine Benutzer gefunden';

  @override
  String get pleaseEnterEmail => 'Bitte geben Sie eine E-Mail-Adresse ein';

  @override
  String get fullName => 'Vollständiger Name';

  @override
  String get mustChangePassword =>
      'Muss bei der ersten Anmeldung das Passwort ändern';

  @override
  String get pleaseEnterTitle => 'Bitte geben Sie einen Titel ein';

  @override
  String get noActivity => 'Keine Aktivität';

  @override
  String get createdRepo => 'Repository erstellt';

  @override
  String get pushedTag => 'Tag gepusht';

  @override
  String get deletedTag => 'Tag gelöscht';

  @override
  String get createdIssue => 'Issue erstellt';

  @override
  String get closedIssue => 'Issue geschlossen';

  @override
  String get reopenedIssue => 'Issue wiedereröffnet';

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
  String get forkedRepo => 'Repositorium geforkt';

  @override
  String get transferredRepo => 'Repositorium übertragen';

  @override
  String get deletedRepo => 'Repositorium gelöscht';

  @override
  String get updatedWiki => 'Wiki aktualisiert';

  @override
  String get performedAction => 'Aktion ausgeführt';

  @override
  String get commitRepo => 'Commit in';

  @override
  String get renameRepo => 'Repositorium umbenannt';

  @override
  String get starRepo => 'Repositorium mit Stern markiert';

  @override
  String get watchRepo => 'Beobachtung gestartet';

  @override
  String get reopenPR => 'PR wiedereröffnet';

  @override
  String get approvePR => 'PR genehmigt';

  @override
  String get rejectPR => 'PR abgelehnt';

  @override
  String get publishRelease => 'Veröffentlichung veröffentlicht';

  @override
  String get deleteBranch => 'Zweig gelöscht';

  @override
  String get autoMergePR => 'PR automatisch zusammengeführt';

  @override
  String get pullReviewDismissed => 'PR-Überprüfung verworfen';

  @override
  String get pullRequestReady => 'PR als bereit zur Überprüfung markiert';

  @override
  String get mirrorSyncPush => 'Push zum Spiegel synchronisiert';

  @override
  String get mirrorSyncCreate => 'Erstellung zum Spiegel synchronisiert';

  @override
  String get mirrorSyncDelete => 'Löschung zum Spiegel synchronisiert';

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
  String get privateRepo => 'Privates Repositorium';

  @override
  String get privateRepoDesc => 'Nur für Sie und Mitarbeiter sichtbar';

  @override
  String get enableIssues => 'Issues aktivieren';

  @override
  String get enablePullRequests => 'Pull Requests aktivieren';

  @override
  String get enableWiki => 'Wiki aktivieren';

  @override
  String get preview => 'Vorschau';

  @override
  String get commitMessage => 'Commit-Nachricht';

  @override
  String get commit => 'Commit';

  @override
  String get commitMessageHint => 'Beschreiben Sie Ihre Änderungen (optional)';

  @override
  String get cannotGetFileSha =>
      'Datei-SHA konnte nicht abgerufen werden. Bitte laden Sie die Datei neu.';

  @override
  String get failedToSaveFile => 'Datei konnte nicht gespeichert werden';

  @override
  String get fileSaved => 'Datei erfolgreich gespeichert';

  @override
  String get discard => 'Verwerfen';

  @override
  String get message => 'Nachricht';

  @override
  String get ok => 'OK';

  @override
  String get sha => 'SHA';

  @override
  String get changedFiles => 'Geänderte Dateien';

  @override
  String get tags => 'Schlagwörter';

  @override
  String get noCommits => 'Keine Commits';

  @override
  String get noTags => 'Keine Schlagwörter';

  @override
  String get protected => 'Geschützt';

  @override
  String get latestCommit => 'Letzter Commit';

  @override
  String get permissions => 'Berechtigungen';

  @override
  String get canPush => 'Kann pushen';

  @override
  String get canMerge => 'Kann zusammenführen';

  @override
  String get downloads => 'Downloads';

  @override
  String get tarball => 'Tarball';

  @override
  String get zipball => 'Zipball';

  @override
  String get downloadTarball => 'Tarball herunterladen';

  @override
  String get downloadZipball => 'Zipball herunterladen';

  @override
  String get url => 'URL';

  @override
  String get info => 'Info';

  @override
  String get teams => 'Teams';

  @override
  String get noTeams => 'Keine Teams';

  @override
  String get location => 'Standort';

  @override
  String get visibility => 'Sichtbarkeit';

  @override
  String get assets => 'Anlagen';

  @override
  String get publishedAt => 'Veröffentlicht am';

  @override
  String get target => 'Ziel';

  @override
  String get forked => 'Abgespalten';

  @override
  String get forkRepoConfirm =>
      'Dies erstellt eine Abspaltung dieses Repositoriums in Ihrem Konto.';

  @override
  String get editIssue => 'Issue bearbeiten';

  @override
  String get titleRequired => 'Titel ist erforderlich';

  @override
  String get selectMilestone => 'Meilenstein auswählen';

  @override
  String get members => 'Mitglieder';

  @override
  String get noMembers => 'Keine Mitglieder';

  @override
  String get editOrganization => 'Organisation bearbeiten';

  @override
  String get createOrganization => 'Organisation erstellen';

  @override
  String get createRepository => 'Repositorium erstellen';

  @override
  String get repositoryName => 'Repository-Name';

  @override
  String get repositoryNameHint => 'my-awesome-repo';

  @override
  String get repositoryNameRequired => 'Repositoriumsname ist erforderlich';

  @override
  String get descriptionHint => 'Kurze Beschreibung Ihres Repositoriums';

  @override
  String get public => 'Öffentlich';

  @override
  String get publicDescription =>
      'Jeder im Internet kann dieses Repositorium sehen';

  @override
  String get privateDescription =>
      'Sie wählen, wer dieses Repositorium sehen und daran committen kann';

  @override
  String get initializeWithReadme => 'Mit README initialisieren';

  @override
  String get initializeWithReadmeDescription =>
      'Eine README-Datei hinzufügen, um anderen das Projekt zu erklären';

  @override
  String repoCreated(Object repoName) {
    return 'Repositorium \'$repoName\' erfolgreich erstellt';
  }

  @override
  String get complete => 'abgeschlossen';

  @override
  String get wiki => 'Wiki';

  @override
  String get newWikiPage => 'Neue Wiki-Seite';

  @override
  String get editWikiPage => 'Wiki-Seite bearbeiten';

  @override
  String get deleteWikiPage => 'Wiki-Seite löschen';

  @override
  String get deleteWikiPageConfirm =>
      'Sind Sie sicher, dass Sie diese Wiki-Seite löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get wikiPageDeleted => 'Wiki-Seite gelöscht';

  @override
  String get wikiPageTitle => 'Seitentitel';

  @override
  String get wikiPageTitleHint => 'e.g. Home';

  @override
  String get wikiPageContent => 'Inhalt';

  @override
  String get wikiPageContentHint => 'In Markdown schreiben...';

  @override
  String get noWikiPages => 'Keine Wiki-Seiten';

  @override
  String get noWikiPagesDescription =>
      'Dieses Repositorium hat noch keine Wiki-Seiten.';

  @override
  String get createFirstWikiPage => 'Erste Seite erstellen';

  @override
  String get lastCommit => 'Letzter Commit';

  @override
  String get noContent => 'Kein Inhalt';

  @override
  String get saved => 'Gespeichert';

  @override
  String get created => 'Erstellt';

  @override
  String get createMilestone => 'Meilenstein erstellen';

  @override
  String get editMilestone => 'Meilenstein bearbeiten';

  @override
  String get deleteMilestone => 'Meilenstein löschen';

  @override
  String get deleteMilestoneConfirm =>
      'Sind Sie sicher, dass Sie diesen Meilenstein löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get milestoneDeleted => 'Meilenstein gelöscht';

  @override
  String get milestoneTitle => 'Titel';

  @override
  String get milestoneDescription => 'Beschreibung';

  @override
  String get milestoneDescriptionHint => 'Beschreiben Sie diesen Meilenstein';

  @override
  String get milestoneDueDate => 'Fälligkeitsdatum';

  @override
  String get milestoneState => 'Status';

  @override
  String get milestoneStateOpen => 'Offen';

  @override
  String get milestoneStateClosed => 'Geschlossen';

  @override
  String get total => 'Gesamt';

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
      'Sind Sie sicher, dass Sie diesen Webhook löschen möchten? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get webhookDeleted => 'Webhook gelöscht';

  @override
  String get webhookUrl => 'URL';

  @override
  String get webhookUrlHint => 'https://example.com/webhook';

  @override
  String get webhookSecret => 'Geheimnis';

  @override
  String get webhookSecretHint => 'Optionaler geheimer Token';

  @override
  String get webhookContentType => 'Inhaltstyp';

  @override
  String get webhookContentTypeJson => 'application/json';

  @override
  String get webhookContentTypeForm => 'application/x-www-form-urlencoded';

  @override
  String get webhookEvents => 'Ereignisse';

  @override
  String get webhookEventsHint =>
      'Ereignisse auswählen, die diesen Webhook auslösen';

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
  String get webhookLastDelivery => 'Letzte Zustellung';

  @override
  String get webhookSelectAllEvents => 'Alle auswählen';

  @override
  String get webhookPushEvents => 'Push-Ereignisse';

  @override
  String get webhookPullRequestEvents => 'Pull-Request-Ereignisse';

  @override
  String get webhookIssuesEvents => 'Issue-Ereignisse';

  @override
  String get webhookCreateEvents => 'Erstellen';

  @override
  String get webhookDeleteEvents => 'Löschen';

  @override
  String get webhookReleaseEvents => 'Veröffentlichungen';

  @override
  String get webhookWikiEvents => 'Wiki-Ereignisse';

  @override
  String get webhookStarEvents => 'Stern';

  @override
  String get webhookForkEvents => 'Abspaltung';

  @override
  String get loginWithOAuth2 => 'Mit OAuth2 anmelden';

  @override
  String get oauth2 => 'OAuth2';

  @override
  String get oauth2Description =>
      'Über die Gitea OAuth2-Anwendung autorisieren';

  @override
  String get oauth2ClientId => 'Client-ID';

  @override
  String get oauth2ClientSecret => 'Client-Geheimnis';

  @override
  String get oauth2RedirectUri => 'Weiterleitungs-URI';

  @override
  String get oauth2RedirectUriHint => 'igitea://oauth/callback';

  @override
  String get oauth2Authorize => 'Autorisierungsseite öffnen';

  @override
  String get oauth2ExchangeCode => 'Code gegen Token eintauschen';

  @override
  String get oauth2AuthorizationCode => 'Autorisierungscode';

  @override
  String get oauth2AuthorizationCodeHint =>
      'Fügen Sie den Code aus der Weiterleitungs-URL ein';

  @override
  String get oauth2TokenRefreshed => 'Token erfolgreich aktualisiert';

  @override
  String get createLabel => 'Label erstellen';

  @override
  String get editLabel => 'Label bearbeiten';

  @override
  String get deleteLabel => 'Label löschen';

  @override
  String get deleteLabelConfirm =>
      'Sind Sie sicher, dass Sie dieses Label löschen möchten?';

  @override
  String get labelDeleted => 'Label gelöscht';

  @override
  String get labelName => 'Name';

  @override
  String get labelNameHint => 'z.B. bug';

  @override
  String get labelDescription => 'Beschreibung';

  @override
  String get labelDescriptionHint => 'Optionale Beschreibung';

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
  String get unifiedView => 'Einheitliche Ansicht';

  @override
  String get splitView => 'Geteilte Ansicht';

  @override
  String get compareVersions => 'Versionen vergleichen';

  @override
  String get baseRef => 'Basis (älter)';

  @override
  String get headRef => 'Kopf (neuer)';

  @override
  String get compare => 'Vergleichen';

  @override
  String get actions => 'Aktionen';

  @override
  String get noActions => 'Keine Workflows';

  @override
  String get run => 'Ausführen';

  @override
  String get status => 'Status';

  @override
  String get jobs => 'Aufträge';

  @override
  String get noJobs => 'Keine Jobs';

  @override
  String get artifacts => 'Artefakte';

  @override
  String get branch => 'Zweig';

  @override
  String get author => 'Autor';

  @override
  String get filterByActor => 'Nach Akteur filtern';

  @override
  String get filterByStatus => 'Nach Status filtern';

  @override
  String get reviewChanges => 'Änderungen überprüfen';

  @override
  String get reviewBody => 'Überprüfungskommentar';

  @override
  String get reviews => 'Überprüfungen';

  @override
  String get approve => 'Genehmigen';

  @override
  String get requestChanges => 'Änderungen anfordern';

  @override
  String get comment => 'Kommentar';

  @override
  String get blame => 'Schuldzuweisung';

  @override
  String get diffView => 'Diff-Ansicht';

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
  String get unknownSection => 'Unbekannter Abschnitt';

  @override
  String get deleteKey => 'Schlüssel löschen';

  @override
  String get deleteKeyConfirm =>
      'Sind Sie sicher, dass Sie diesen SSH-Schlüssel löschen möchten?';

  @override
  String get keyDeleted => 'Schlüssel erfolgreich gelöscht';

  @override
  String get addSshKey => 'SSH-Schlüssel hinzufügen';

  @override
  String get add => 'Hinzufügen';

  @override
  String get keyAdded => 'Schlüssel erfolgreich hinzugefügt';

  @override
  String get deleteCommentConfirm =>
      'Sind Sie sicher, dass Sie diesen Kommentar löschen möchten?';

  @override
  String get requestReviewers => 'Reviewer anfordern';

  @override
  String get addReviewerHint => 'Reviewer-Benutzernamen eingeben';

  @override
  String get subscribe => 'Abonnieren';

  @override
  String get unsubscribe => 'Abo kündigen';

  @override
  String get subscribed => 'Abonniert';

  @override
  String get unsubscribed => 'Abonnement beendet';

  @override
  String get setDueDate => 'Fälligkeitsdatum setzen';

  @override
  String get removeDueDate => 'Fälligkeitsdatum entfernen';

  @override
  String get topics => 'Themen';

  @override
  String get noTopics => 'Keine Themen';

  @override
  String get branchProtection => 'Branch-Schutz';

  @override
  String get protectBranch => 'Branch schützen';

  @override
  String get https => 'HTTPS';

  @override
  String get ssh => 'SSH';

  @override
  String get teamAdminAccess => 'Team-Admin-Zugriff';

  @override
  String get details => 'Details';

  @override
  String get id => 'ID';

  @override
  String get searchRepositoriesHint => 'Repositorys durchsuchen';

  @override
  String get publicKey => 'Öffentlicher Schlüssel';

  @override
  String get failedToGetAccessToken =>
      'Zugriffstoken konnte nicht abgerufen werden';

  @override
  String get fileNotFound => 'Datei nicht gefunden';

  @override
  String get noSshKeysFound => 'Keine SSH-Schlüssel gefunden';

  @override
  String get other => 'Andere';

  @override
  String get usernameRequired => 'Benutzername ist erforderlich';

  @override
  String get myLaptopHint => 'Mein Laptop';

  @override
  String get sshPublicKeyHint =>
      'Fügen Sie Ihren öffentlichen SSH-Schlüssel hier ein';

  @override
  String get noChangesFoundForFile =>
      'Keine Änderungen für diese Datei gefunden';

  @override
  String commitUpdateFile(Object fileName) {
    return '$fileName aktualisieren';
  }

  @override
  String get api => 'API';

  @override
  String get ui => 'UI';

  @override
  String get justNow => 'gerade eben';

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
  String get packageRepository => 'Repositorium';

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
  String get applyLabelSet => 'Labelset anwenden';

  @override
  String get applyLabelSetDescription =>
      'Wählen Sie ein vordefiniertes Labelset aus, um alle Labels auf einmal zu erstellen.';

  @override
  String applyAllLabels(Object count) {
    return 'Alle anwenden ($count Labels)';
  }

  @override
  String applyAllLabelsParams(Object count) {
    return 'Alle anwenden ($count Labels)';
  }

  @override
  String get creating => 'Erstelle...';

  @override
  String get addCustomLabel => 'Benutzerdefiniertes Label hinzufügen';

  @override
  String get selectTemplate => 'Vorlage auswählen';

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
  String get teamCanCreateOrgRepos => 'Kann Org-Repos erstellen';

  @override
  String get teamIncludesAllRepos => 'Enthält alle Repositorien';

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
  String get gpgKeys => 'GPG-Schlüssel';

  @override
  String get addGpgKey => 'GPG-Schlüssel hinzufügen';

  @override
  String get gpgKeyHint => '-----BEGIN PGP PUBLIC KEY BLOCK-----';

  @override
  String get gpgKeyAdded => 'GPG-Schlüssel hinzugefügt';

  @override
  String get gpgKeyDeleted => 'GPG-Schlüssel gelöscht';

  @override
  String get deleteGpgKey => 'GPG-Schlüssel löschen';

  @override
  String get deleteGpgKeyConfirm =>
      'Möchten Sie diesen GPG-Schlüssel wirklich löschen?';

  @override
  String get noGpgKeys => 'Keine GPG-Schlüssel';

  @override
  String get sign => 'Signieren';

  @override
  String get certify => 'Zertifizieren';

  @override
  String get verified => 'Verifiziert';

  @override
  String get tagProtections => 'Tag-Schutz';

  @override
  String get manageTagProtections => 'Tag-Schutzregeln verwalten';

  @override
  String get createTagProtection => 'Tag-Schutz erstellen';

  @override
  String get namePattern => 'Namensmuster';

  @override
  String get tagProtectionCreated => 'Tag-Schutz erstellt';

  @override
  String get tagProtectionDeleted => 'Tag-Schutz gelöscht';

  @override
  String get deleteTagProtection => 'Tag-Schutz löschen';

  @override
  String get deleteTagProtectionConfirm =>
      'Möchten Sie diesen Tag-Schutz wirklich löschen?';

  @override
  String get noTagProtections => 'Keine Tag-Schutzregeln';

  @override
  String get allowedUsers => 'Erlaubte Benutzer';

  @override
  String get dependencies => 'Abhängigkeiten';

  @override
  String get addDependency => 'Abhängigkeit hinzufügen';

  @override
  String get dependencyAdded => 'Abhängigkeit hinzugefügt';

  @override
  String get dependencyRemoved => 'Abhängigkeit entfernt';

  @override
  String get removeDependency => 'Abhängigkeit entfernen';

  @override
  String get removeDependencyConfirm => 'Diese Abhängigkeit entfernen?';

  @override
  String get noDependencies => 'Keine Abhängigkeiten';

  @override
  String get blocks => 'Blockiert';

  @override
  String get dependsOn => 'Hängt ab von';

  @override
  String get issueNumberHint => 'Issue #';

  @override
  String get events => 'Ereignisse';

  @override
  String get items => 'Elemente';

  @override
  String get commented => 'kommentiert';

  @override
  String get labelUpdated => 'Label aktualisiert';

  @override
  String get milestoneUpdated => 'Meilenstein aktualisiert';

  @override
  String get assigneeUpdated => 'Zuständiger aktualisiert';

  @override
  String get reopened => 'Wieder geöffnet';

  @override
  String get stargazers => 'Stargazer';

  @override
  String get subscribers => 'Abonnenten';

  @override
  String get noStargazers => 'Noch keine Stargazers';

  @override
  String get noSubscribers => 'Noch keine Abonnenten';

  @override
  String get adminHooksTitle => 'System-Hooks';

  @override
  String get adminCronTitle => 'Cron-Aufgaben';

  @override
  String get adminRunnersTitle => 'Actions-Runner';

  @override
  String get adminEmailsTitle => 'E-Mails';

  @override
  String get adminBadgesTitle => 'Abzeichen';

  @override
  String get adminRunCron => 'Jetzt ausführen';

  @override
  String get adminGetToken => 'Registrierungs-Token abrufen';

  @override
  String get adminNoHooks => 'Keine System-Hooks konfiguriert';

  @override
  String get adminNoCron => 'Keine Cron-Aufgaben';

  @override
  String get adminNoRunners => 'Keine Actions-Runner';

  @override
  String get adminNoEmails => 'Keine E-Mails';

  @override
  String get adminNoBadges => 'Keine Badges';

  @override
  String get adminBadgeUsername => 'Benutzername';

  @override
  String get adminBadgeDescription => 'Beschreibung';

  @override
  String get oauthAppsTitle => 'OAuth-Anwendungen';

  @override
  String get oauthNoApps => 'Keine OAuth-Anwendungen';

  @override
  String get oauthCreateApp => 'OAuth-App erstellen';

  @override
  String get oauthRedirectUri => 'Weiterleitungs-URI';

  @override
  String get oauthDeleteAppConfirm => 'OAuth-Anwendung löschen';

  @override
  String get name => 'Name';

  @override
  String get confirmDelete => 'Löschen bestätigen';

  @override
  String get actionsSecretsTitle => 'Actions-Geheimnisse';

  @override
  String get actionsVariablesTitle => 'Actions-Variablen';

  @override
  String get actionsNoSecrets => 'Keine Secrets konfiguriert';

  @override
  String get actionsNoVariables => 'Keine Variablen konfiguriert';

  @override
  String get actionsCreateSecret => 'Secret erstellen';

  @override
  String get actionsCreateVariable => 'Variable erstellen';

  @override
  String get actionsSecretName => 'Secret-Name';

  @override
  String get actionsSecretValue => 'Secret-Wert';

  @override
  String get actionsVariableName => 'Variablen-Name';

  @override
  String get actionsVariableValue => 'Variablen-Wert';

  @override
  String get actionsDeleteSecretConfirm => 'Dieses Secret löschen?';

  @override
  String get actionsDeleteVariableConfirm => 'Diese Variable löschen?';

  @override
  String get deleted => 'Gelöscht';

  @override
  String get overdue => 'Überfällig';

  @override
  String get addTopic => 'Thema hinzufügen';

  @override
  String get importRepository => 'Repository importieren';

  @override
  String get import => 'Importieren';

  @override
  String get repoImported => 'Repository importiert';

  @override
  String get cloneUrl => 'Clone-URL';

  @override
  String get repoOwner => 'Besitzer';

  @override
  String get gitService => 'Git-Dienst';

  @override
  String get authentication => 'Authentifizierung';

  @override
  String get authUsername => 'Auth-Benutzername';

  @override
  String get authPassword => 'Auth-Passwort';

  @override
  String get authToken => 'Auth-Token';

  @override
  String get migrationOptions => 'Optionen';

  @override
  String get migrateData => 'Zu importierende Daten';

  @override
  String get mirror => 'Spiegel';

  @override
  String get mirrorInterval => 'Spiegelintervall';

  @override
  String get requiredField => 'Dieses Feld ist erforderlich';

  @override
  String get personal => 'Persönlich';

  @override
  String get deleteOrganization => 'Organisation löschen';

  @override
  String get deleteOrganizationConfirm =>
      'Möchten Sie diese Organisation wirklich löschen? Diese Aktion kann nicht rückgängig gemacht werden.';

  @override
  String get organizationDeleted => 'Organisation gelöscht';

  @override
  String get accessTokens => 'Zugriffstoken';

  @override
  String get createToken => 'Token erstellen';

  @override
  String get tokenName => 'Token-Name';

  @override
  String get tokenCreated => 'Token erstellt';

  @override
  String get tokenValueWarning =>
      'Kopieren Sie dieses Token jetzt. Sie können es später nicht mehr einsehen.';

  @override
  String get failedToCreateToken => 'Token-Erstellung fehlgeschlagen';

  @override
  String get deleteToken => 'Token löschen';

  @override
  String get deleteTokenConfirm => 'Möchten Sie wirklich löschen';

  @override
  String get tokenDeleted => 'Token gelöscht';

  @override
  String get noTokens => 'Keine Zugriffstoken';

  @override
  String get scopes => 'Berechtigungen';

  @override
  String get selectAll => 'Alle auswählen';

  @override
  String get deselectAll => 'Auswahl aufheben';
}
