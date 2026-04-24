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
    return 'Joined on $date';
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
  String get defaultBranch => 'Default';

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
}
