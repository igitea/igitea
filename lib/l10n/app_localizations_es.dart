// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'iGitea';

  @override
  String get language => 'Idioma';

  @override
  String get settings => 'Configuración';

  @override
  String get profile => 'Perfil';

  @override
  String get search => 'Buscar';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get dashboard => 'Panel';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get username => 'Nombre de usuario';

  @override
  String get password => 'Contraseña';

  @override
  String get login => 'Iniciar sesión';

  @override
  String get loginWithToken => 'Iniciar sesión con token';

  @override
  String get token => 'Token';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get edit => 'Editar';

  @override
  String get create => 'Crear';

  @override
  String get close => 'Cerrar';

  @override
  String get reopen => 'Reabrir';

  @override
  String get merge => 'Fusionar';

  @override
  String get submit => 'Enviar';

  @override
  String get retry => 'Reintentar';

  @override
  String get loading => 'Cargando...';

  @override
  String get error => 'Error';

  @override
  String get noData => 'Sin datos';

  @override
  String get searchRepos => 'Buscar repositorios';

  @override
  String get searchIssues => 'Buscar incidencias';

  @override
  String get noResults => 'No se encontraron resultados';

  @override
  String get repositories => 'Repositorios';

  @override
  String get repositorySections => 'Repository Sections';

  @override
  String get issues => 'Incidencias';

  @override
  String get pullRequests => 'Solicitudes de extracción';

  @override
  String get releases => 'Versiones';

  @override
  String get branches => 'Ramas';

  @override
  String get code => 'Código';

  @override
  String get stars => 'Estrellas';

  @override
  String get forks => 'Bifurcaciones';

  @override
  String get watchers => 'Observadores';

  @override
  String get open => 'Abierto';

  @override
  String get closed => 'Cerrado';

  @override
  String get all => 'Todos';

  @override
  String get mergePullRequest => 'Fusionar solicitud de extracción';

  @override
  String get mergeConfirmMessage =>
      '¿Está seguro de que desea fusionar esta solicitud de extracción?';

  @override
  String issueNumber(Object issueNumber) {
    return 'Incidencia #$issueNumber';
  }

  @override
  String pullRequestNumber(Object pullRequestNumber) {
    return 'PR #$pullRequestNumber';
  }

  @override
  String get comments => 'Comentarios';

  @override
  String get addComment => 'Añadir un comentario...';

  @override
  String get sendComment => 'Enviar';

  @override
  String get noComments => 'Sin comentarios todavía';

  @override
  String get labels => 'Etiquetas';

  @override
  String get milestones => 'Hitos';

  @override
  String get assignees => 'Asignados';

  @override
  String get assignee => 'Assignee';

  @override
  String get participants => 'Participantes';

  @override
  String get timeline => 'Cronología';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get account => 'Cuenta';

  @override
  String get accountInfo => 'Información de la cuenta';

  @override
  String get email => 'Correo electrónico';

  @override
  String get website => 'Sitio web';

  @override
  String get bio => 'Biografía';

  @override
  String joinedOn(Object date) {
    return 'Se unió el $date';
  }

  @override
  String joinedOnParams(Object date) {
    return 'Se unió el $date';
  }

  @override
  String followerCount(Object count) {
    return '$count followers';
  }

  @override
  String followerCountParams(Object count) {
    return '$count seguidores';
  }

  @override
  String followingCount(Object count) {
    return '$count following';
  }

  @override
  String followingCountParams(Object count) {
    return '$count siguiendo';
  }

  @override
  String repositoryCount(Object count) {
    return '$count repositories';
  }

  @override
  String repositoryCountParams(Object count) {
    return '$count repositorios';
  }

  @override
  String get starredRepos => 'Repositorios destacados';

  @override
  String get organisations => 'Organizaciones';

  @override
  String get adminPanel => 'Panel de administración';

  @override
  String get userManagement => 'Gestión de usuarios';

  @override
  String get serverSettings => 'Configuración del servidor';

  @override
  String get cronTasks => 'Tareas cron';

  @override
  String get apiSettings => 'Configuración de API';

  @override
  String get uiSettings => 'Configuración de interfaz';

  @override
  String get attachmentSettings => 'Configuración de adjuntos';

  @override
  String get repoSettings => 'Configuración del repositorio';

  @override
  String get runNow => 'Ejecutar ahora';

  @override
  String lastRun(Object time) {
    return 'Last run: $time';
  }

  @override
  String lastRunParams(Object time) {
    return 'Última ejecución: $time';
  }

  @override
  String nextRun(Object time) {
    return 'Next run: $time';
  }

  @override
  String nextRunParams(Object time) {
    return 'Próxima ejecución: $time';
  }

  @override
  String get recentActivity => 'Actividad reciente';

  @override
  String get myIssues => 'Mis incidencias';

  @override
  String get myRepos => 'Mis repositorios';

  @override
  String get myStars => 'Mis estrellas';

  @override
  String get feed => 'Actividad';

  @override
  String get markAllRead => 'Marcar todo como leído';

  @override
  String get markRead => 'Marcar como leído';

  @override
  String unreadNotifications(Object count) {
    return 'Unread notifications: $count';
  }

  @override
  String unreadNotificationsParams(Object count) {
    return 'Notificaciones no leídas: $count';
  }

  @override
  String get noUnreadNotifications => 'Sin notificaciones no leídas';

  @override
  String get readMore => 'Leer más';

  @override
  String ago(Object time) {
    return '$time ago';
  }

  @override
  String agoParams(Object time) {
    return 'hace $time';
  }

  @override
  String get fileBrowser => 'Explorador de archivos';

  @override
  String get readme => 'README';

  @override
  String get commits => 'Confirmaciones';

  @override
  String get commitHistory => 'Historial de confirmaciones';

  @override
  String get viewFile => 'Ver archivo';

  @override
  String get downloadFile => 'Descargar archivo';

  @override
  String get copyPath => 'Copiar ruta';

  @override
  String get fileName => 'Nombre del archivo';

  @override
  String get fileSize => 'Tamaño del archivo';

  @override
  String get lastModified => 'Última modificación';

  @override
  String get openInBrowser => 'Abrir en el navegador';

  @override
  String get signInRequired => 'Inicio de sesión requerido';

  @override
  String get signInMessage => 'Por favor, inicie sesión para continuar';

  @override
  String get loginFailed => 'Error de inicio de sesión';

  @override
  String get networkError => 'Error de red';

  @override
  String get unknownError => 'Se produjo un error desconocido';

  @override
  String get refresh => 'Actualizar';

  @override
  String get copyToClipboard => 'Copiar al portapapeles';

  @override
  String get copied => '¡Copiado!';

  @override
  String get filterIssues => 'Filtrar incidencias';

  @override
  String get newIssue => 'Nueva incidencia';

  @override
  String get newPullRequest => 'Nueva solicitud de extracción';

  @override
  String get title => 'Título';

  @override
  String get description => 'Descripción';

  @override
  String get body => 'Cuerpo';

  @override
  String get state => 'Estado';

  @override
  String get priority => 'Prioridad';

  @override
  String get milestone => 'Hito';

  @override
  String get createdAt => 'Creado el';

  @override
  String get updatedAt => 'Actualizado el';

  @override
  String get dueDate => 'Fecha de vencimiento';

  @override
  String get noMilestones => 'Sin hitos';

  @override
  String get noLabels => 'Sin etiquetas';

  @override
  String get openIssue => 'Abrir incidencia';

  @override
  String get closeIssue => 'Cerrar incidencia';

  @override
  String get reopenIssue => 'Reabrir incidencia';

  @override
  String get deleteComment => 'Eliminar comentario';

  @override
  String get editComment => 'Editar comentario';

  @override
  String get deleteRepo => 'Eliminar repositorio';

  @override
  String get deleteRepoConfirm =>
      '¿Está seguro de que desea eliminar este repositorio? Esta acción no se puede deshacer.';

  @override
  String get generalSettings => 'Configuración general';

  @override
  String get appearance => 'Apariencia';

  @override
  String get languageSelector => 'Idioma';

  @override
  String get selectLanguage => 'Seleccionar idioma';

  @override
  String get systemDefault => 'Predeterminado del sistema';

  @override
  String get followSystem => 'Seguir sistema';

  @override
  String get unsavedChanges => 'Cambios sin guardar';

  @override
  String get unsavedChangesMessage =>
      'Tiene cambios sin guardar. ¿Está seguro de que desea abandonar esta página?';

  @override
  String get leave => 'Abandonar';

  @override
  String get stay => 'Permanecer';

  @override
  String get restoringSession => 'Restoring session...';

  @override
  String get pleaseEnterServerUrl => 'Ingrese una URL de servidor';

  @override
  String get pleaseEnterValidUrl => 'Ingrese una URL válida';

  @override
  String get connectToGitea => 'Conectarse a su instancia Gitea';

  @override
  String get usernamePassword => 'Username & Password';

  @override
  String get serverUrl => 'URL del servidor';

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
  String get signInWithToken => 'Iniciar sesión con Token';

  @override
  String get welcomeToIgitea => 'Welcome to iGitea';

  @override
  String get signInToGetStarted => 'Sign in to get started';

  @override
  String get quickActions => 'Acciones rápidas';

  @override
  String get yourRepositories => 'Your Repositories';

  @override
  String get noRepositoriesFound => 'No se encontraron repositorios';

  @override
  String helloParams(Object full_name) {
    return 'Hello, $full_name!';
  }

  @override
  String get user => 'User';

  @override
  String get private => 'Privado';

  @override
  String get untitled => 'Sin título';

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
  String get followers => 'Seguidores';

  @override
  String get following => 'Siguiendo';

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
  String get repository => 'Repositorio';

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
  String get yes => 'Sí';

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
  String get unknown => 'Desconocido';

  @override
  String openedParams(Object time) {
    return 'opened $time';
  }

  @override
  String get noDescriptionProvided => 'No description provided.';

  @override
  String get failedToLoadComments => 'Failed to load comments';

  @override
  String get writeComment => 'Escribir comentario';

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
  String get draft => 'Borrador';

  @override
  String get failedToLoadRepo => 'Failed to load repository';

  @override
  String get copyUrl => 'Copy URL';

  @override
  String get urlCopied => 'URL copied';

  @override
  String get emptyDirectory => 'Empty directory';

  @override
  String get noIssues => 'Sin issues';

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
  String get defaultBranch => 'Rama por defecto';

  @override
  String get copyCode => 'Copy code';

  @override
  String get failedToLoadFile => 'Failed to load file';

  @override
  String get filePreviewNotAvailable => 'File preview not available';

  @override
  String get download => 'Descargar';

  @override
  String get failedToOpenDownloadUrl => 'Failed to open download URL';

  @override
  String get noNotifications => 'Sin notificaciones';

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
  String get noActivity => 'Sin actividad';

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
  String get inRepo => 'en';

  @override
  String get to => 'a';

  @override
  String get from => 'de';

  @override
  String get headBranch => 'Rama fuente';

  @override
  String get baseBranch => 'Rama destino';

  @override
  String get pleaseFillAllFields => 'Complete todos los campos obligatorios';

  @override
  String get settingsSaved => 'Ajustes guardados';

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
  String get preview => 'Vista previa';

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
  String get tags => 'Etiquetas';

  @override
  String get noCommits => 'Sin commits';

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
  String get noTeams => 'Sin equipos';

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
  String get noMembers => 'Sin miembros';

  @override
  String get editOrganization => 'Edit Organization';

  @override
  String get createOrganization => 'Create Organization';

  @override
  String get createRepository => 'Create Repository';

  @override
  String get repositoryName => 'Nombre del repositorio';

  @override
  String get repositoryNameHint => 'my-awesome-repo';

  @override
  String get repositoryNameRequired => 'Repository name is required';

  @override
  String get descriptionHint => 'Short description of your repository';

  @override
  String get public => 'Público';

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
  String get noWikiPages => 'Sin páginas Wiki';

  @override
  String get noWikiPagesDescription =>
      'This repository doesn\'t have any wiki pages yet.';

  @override
  String get createFirstWikiPage => 'Create First Page';

  @override
  String get lastCommit => 'Last commit';

  @override
  String get noContent => 'Sin contenido';

  @override
  String get saved => 'Saved';

  @override
  String get created => 'Created';

  @override
  String get createMilestone => 'Crear hito';

  @override
  String get editMilestone => 'Editar hito';

  @override
  String get deleteMilestone => 'Eliminar hito';

  @override
  String get deleteMilestoneConfirm =>
      'Are you sure you want to delete this milestone? This action cannot be undone.';

  @override
  String get milestoneDeleted => 'Milestone deleted';

  @override
  String get milestoneTitle => 'Título';

  @override
  String get milestoneDescription => 'Description';

  @override
  String get milestoneDescriptionHint => 'Describe this milestone';

  @override
  String get milestoneDueDate => 'Fecha de vencimiento';

  @override
  String get milestoneState => 'Estado';

  @override
  String get milestoneStateOpen => 'Abierto';

  @override
  String get milestoneStateClosed => 'Cerrado';

  @override
  String get total => 'Total';

  @override
  String get clear => 'Limpiar';

  @override
  String get webhooks => 'Webhooks';

  @override
  String get webhook => 'Webhook';

  @override
  String get noWebhooks => 'Sin webhooks';

  @override
  String get createWebhook => 'Crear Webhook';

  @override
  String get editWebhook => 'Editar Webhook';

  @override
  String get deleteWebhook => 'Eliminar Webhook';

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
  String get webhookActive => 'Activo';

  @override
  String get webhookInactive => 'Inactivo';

  @override
  String get webhookType => 'Tipo';

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
  String get createLabel => 'Crear etiqueta';

  @override
  String get editLabel => 'Editar etiqueta';

  @override
  String get deleteLabel => 'Eliminar etiqueta';

  @override
  String get deleteLabelConfirm =>
      'Are you sure you want to delete this label?';

  @override
  String get labelDeleted => 'Label deleted';

  @override
  String get labelName => 'Nombre';

  @override
  String get labelNameHint => 'ej. bug';

  @override
  String get labelDescription => 'Description';

  @override
  String get labelDescriptionHint => 'Optional description';

  @override
  String get labelColor => 'Color';

  @override
  String get labelColorHint => 'Hex color, e.g. #FF0000';

  @override
  String get filesChanged => 'Archivos cambiados';

  @override
  String get noFilesChanged => 'Sin archivos cambiados';

  @override
  String get viewDiff => 'Ver Diff';

  @override
  String get unifiedView => 'Unified view';

  @override
  String get splitView => 'Split view';

  @override
  String get compareVersions => 'Comparar versiones';

  @override
  String get baseRef => 'Base (older)';

  @override
  String get headRef => 'Head (newer)';

  @override
  String get compare => 'Comparar';

  @override
  String get actions => 'Actions';

  @override
  String get noActions => 'Sin flujos de trabajo';

  @override
  String get run => 'Run';

  @override
  String get status => 'Estado';

  @override
  String get jobs => 'Trabajos';

  @override
  String get noJobs => 'Sin trabajos';

  @override
  String get artifacts => 'Artifacts';

  @override
  String get branch => 'Rama';

  @override
  String get author => 'Autor';

  @override
  String get filterByActor => 'Filtrar por actor';

  @override
  String get filterByStatus => 'Filtrar por estado';

  @override
  String get reviewChanges => 'Review Changes';

  @override
  String get reviewBody => 'Review comment';

  @override
  String get reviews => 'Revisiones';

  @override
  String get approve => 'Aprobar';

  @override
  String get requestChanges => 'Solicitar cambios';

  @override
  String get comment => 'Comentario';

  @override
  String get blame => 'Blame';

  @override
  String get diffView => 'Diff View';

  @override
  String get pickColor => 'Pick Color';

  @override
  String get sshKeys => 'Claves SSH';

  @override
  String get allRepos => 'Todos los repositorios';

  @override
  String get configuration => 'Configuración';

  @override
  String get none => 'Ninguno';

  @override
  String get more => 'Más';

  @override
  String get units => 'Unidades';

  @override
  String get permission => 'Permiso';

  @override
  String get repoList => 'Lista de repositorios';

  @override
  String get noChanges => 'Sin cambios';

  @override
  String get limited => 'Limitado';

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
  String get add => 'Añadir';

  @override
  String get keyAdded => 'Key added successfully';

  @override
  String get deleteCommentConfirm =>
      'Are you sure you want to delete this comment?';

  @override
  String get requestReviewers => 'Solicitar revisores';

  @override
  String get addReviewerHint => 'Enter reviewer username';

  @override
  String get subscribe => 'Suscribirse';

  @override
  String get unsubscribe => 'Cancelar suscripción';

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
  String get searchRepositoriesHint => 'Buscar repositorios';

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
  String get packages => 'Paquetes';

  @override
  String get noPackages => 'No se encontraron paquetes';

  @override
  String get packageType => 'Tipo';

  @override
  String get packageVersion => 'Versión';

  @override
  String get packageFiles => 'Archivos';

  @override
  String get packageSize => 'Tamaño';

  @override
  String get packageCreator => 'Creador';

  @override
  String get packageCreated => 'Creado';

  @override
  String get packageRepository => 'Repositorio';

  @override
  String get deletePackage => 'Eliminar Paquete';

  @override
  String get deletePackageConfirm =>
      '¿Está seguro de que desea eliminar esta versión del paquete? Esta acción no se puede deshacer.';

  @override
  String get packageDeleted => 'Versión del paquete eliminada exitosamente';

  @override
  String get allTypes => 'Todos';

  @override
  String get installation => 'Instalación';

  @override
  String get packageUrl => 'URL del paquete';

  @override
  String get copy => 'Copiar';

  @override
  String get totalSize => 'Tamaño total';

  @override
  String get versions => 'Versiones';

  @override
  String get noVersions => 'Sin versiones';

  @override
  String get createRelease => 'Crear Release';

  @override
  String get editRelease => 'Editar Release';

  @override
  String get deleteRelease => 'Eliminar Release';

  @override
  String get deleteReleaseConfirm =>
      '¿Está seguro de que desea eliminar este release? Esta acción no se puede deshacer.';

  @override
  String get releaseTagName => 'Nombre de etiqueta';

  @override
  String get releaseTagNameRequired => 'El nombre de etiqueta es obligatorio';

  @override
  String get releaseTitle => 'Título del release';

  @override
  String get releaseBody => 'Notas del release';

  @override
  String get targetCommitish => 'Destino';

  @override
  String get tagMessage => 'Mensaje de etiqueta';

  @override
  String get releaseCreated => 'Release creado exitosamente';

  @override
  String get releaseUpdated => 'Release actualizado exitosamente';

  @override
  String get releaseDeleted => 'Release eliminado exitosamente';

  @override
  String get chooseTag => 'Elegir etiqueta';

  @override
  String get defaultLabels => 'Selección rápida';
}
