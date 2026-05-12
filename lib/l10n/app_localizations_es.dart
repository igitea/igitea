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
  String get users => 'Usuarios';

  @override
  String get enterSearchQueryUsers =>
      'Ingrese una consulta para buscar usuarios';

  @override
  String get noResults => 'No se encontraron resultados';

  @override
  String get repositories => 'Repositorios';

  @override
  String get repositorySections => 'Secciones del repositorio';

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
  String get assignee => 'Asignado';

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
    return '$count seguidores';
  }

  @override
  String followerCountParams(Object count) {
    return '$count seguidores';
  }

  @override
  String followingCount(Object count) {
    return '$count siguiendo';
  }

  @override
  String followingCountParams(Object count) {
    return '$count siguiendo';
  }

  @override
  String repositoryCount(Object count) {
    return '$count repositorios';
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
    return 'Última ejecución: $time';
  }

  @override
  String lastRunParams(Object time) {
    return 'Última ejecución: $time';
  }

  @override
  String nextRun(Object time) {
    return 'Próxima ejecución: $time';
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
    return 'Notificaciones no leídas: $count';
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
    return 'hace $time';
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
  String get restoringSession => 'Restaurando sesión...';

  @override
  String get pleaseEnterServerUrl => 'Ingrese una URL de servidor';

  @override
  String get pleaseEnterValidUrl => 'Ingrese una URL válida';

  @override
  String get connectToGitea => 'Conectarse a su instancia Gitea';

  @override
  String get usernamePassword => 'Usuario y Contraseña';

  @override
  String get serverUrl => 'URL del servidor';

  @override
  String get enterUsername => 'Ingrese su nombre de usuario';

  @override
  String get pleaseEnterUsername => 'Por favor ingrese su nombre de usuario';

  @override
  String get enterPassword => 'Ingrese su contraseña';

  @override
  String get pleaseEnterPassword => 'Por favor ingrese su contraseña';

  @override
  String get pasteAccessToken => 'Pegue su token de acceso personal';

  @override
  String get pleaseEnterAccessToken => 'Por favor ingrese un token de acceso';

  @override
  String get signInWithToken => 'Iniciar sesión con Token';

  @override
  String get welcomeToIgitea => 'Bienvenido a iGitea';

  @override
  String get signInToGetStarted => 'Inicie sesión para comenzar';

  @override
  String get quickActions => 'Acciones rápidas';

  @override
  String get yourRepositories => 'Sus repositorios';

  @override
  String get noRepositoriesFound => 'No se encontraron repositorios';

  @override
  String helloParams(Object full_name) {
    return '¡Hola, $full_name!';
  }

  @override
  String get user => 'Usuario';

  @override
  String get private => 'Privado';

  @override
  String get untitled => 'Sin título';

  @override
  String get enterSearchQueryRepos =>
      'Ingrese una consulta para buscar repositorios';

  @override
  String get enterSearchQueryIssues =>
      'Ingrese una consulta para buscar incidencias';

  @override
  String get noIssuesFound => 'No se encontraron incidencias.';

  @override
  String get failedToLoadProfile => 'Error al cargar el perfil';

  @override
  String get unknownUser => 'Usuario desconocido';

  @override
  String get admin => 'Admin';

  @override
  String get repos => 'Repositorios';

  @override
  String get followers => 'Seguidores';

  @override
  String get following => 'Siguiendo';

  @override
  String get follow => 'Seguir';

  @override
  String get unfollow => 'Dejar de seguir';

  @override
  String get signOutConfirmMessage =>
      '¿Está seguro de que desea cerrar sesión?';

  @override
  String get chooseTheme => 'Elegir tema';

  @override
  String get loadingSettings => 'Cargando configuración...';

  @override
  String get userManagementComingSoon => 'Gestión de usuarios próximamente';

  @override
  String get maxResponseItems => 'Máx. elementos de respuesta';

  @override
  String get defaultPagingNum => 'Núm. de paginación predet.';

  @override
  String get defaultMaxBlobSize => 'Tamaño máx. de blob predet.';

  @override
  String get defaultTheme => 'Tema predeterminado';

  @override
  String get allowedReactions => 'Reacciones permitidas';

  @override
  String get attachments => 'Archivos adjuntos';

  @override
  String get enabled => 'Habilitado';

  @override
  String get maxFiles => 'Máx. archivos';

  @override
  String get maxSize => 'Tamaño máx.';

  @override
  String get allowedTypes => 'Tipos permitidos';

  @override
  String get bytes => 'bytes';

  @override
  String get repository => 'Repositorio';

  @override
  String get httpGitDisabled => 'HTTP Git deshabilitado';

  @override
  String get lfsDisabled => 'LFS deshabilitado';

  @override
  String get migrationsDisabled => 'Migraciones deshabilitadas';

  @override
  String get mirrorsDisabled => 'Espejos deshabilitados';

  @override
  String get starsDisabled => 'Estrellas deshabilitadas';

  @override
  String get timeTrackingDisabled => 'Seguimiento de tiempo deshabilitado';

  @override
  String get yes => 'Sí';

  @override
  String get no => 'No';

  @override
  String get schedule => 'Schedule';

  @override
  String get next => 'Siguiente';

  @override
  String get executions => 'Ejecuciones';

  @override
  String get failedToLoadCronTasks => 'Error al cargar tareas cron';

  @override
  String get noCronTasksFound => 'No se encontraron tareas cron';

  @override
  String cronTriggeredParams(Object name) {
    return 'Cron \"$name\" ejecutado';
  }

  @override
  String get unknown => 'Desconocido';

  @override
  String openedParams(Object time) {
    return 'abierto $time';
  }

  @override
  String get noDescriptionProvided => 'No se proporcionó descripción.';

  @override
  String get failedToLoadComments => 'Error al cargar comentarios';

  @override
  String get writeComment => 'Escribir comentario';

  @override
  String commentsCountParams(Object count) {
    return '$count comentarios';
  }

  @override
  String updatedParams(Object time) {
    return 'Actualizado $time';
  }

  @override
  String commentsParams(Object count) {
    return 'Comentarios ($count)';
  }

  @override
  String get files => 'archivos';

  @override
  String get mergeable => 'Fusionable';

  @override
  String get merged => 'Fusionado';

  @override
  String get draft => 'Borrador';

  @override
  String get failedToLoadRepo => 'Error al cargar el repositorio';

  @override
  String get copyUrl => 'Copiar URL';

  @override
  String get urlCopied => 'URL copiada';

  @override
  String get emptyDirectory => 'Directorio vacío';

  @override
  String get noIssues => 'Sin issues';

  @override
  String get noPullRequests => 'No hay solicitudes de extracción';

  @override
  String get noReleases => 'No hay versiones';

  @override
  String get noBranches => 'No hay ramas';

  @override
  String get preRelease => 'Pre-lanzamiento';

  @override
  String get archived => 'Archivado';

  @override
  String get defaultBranch => 'Rama por defecto';

  @override
  String get copyCode => 'Copiar código';

  @override
  String get failedToLoadFile => 'Error al cargar el archivo';

  @override
  String get filePreviewNotAvailable => 'Vista previa no disponible';

  @override
  String get download => 'Descargar';

  @override
  String get failedToOpenDownloadUrl => 'Error al abrir la URL de descarga';

  @override
  String get noNotifications => 'Sin notificaciones';

  @override
  String get noTitle => 'Sin título';

  @override
  String get allNotificationsMarkedAsRead =>
      'Todas las notificaciones marcadas como leídas';

  @override
  String get createUser => 'Crear usuario';

  @override
  String get editUser => 'Editar usuario';

  @override
  String get deleteIssue => 'Eliminar Issue';

  @override
  String get deleteIssueConfirm =>
      '¿Está seguro de que desea eliminar este issue? Esta acción no se puede deshacer.';

  @override
  String get issueDeleted => 'Issue eliminado';

  @override
  String get deleteUser => 'Eliminar usuario';

  @override
  String deleteUserConfirmParams(Object username) {
    return '¿Está seguro de que desea eliminar al usuario \"$username\"? Esta acción no se puede deshacer.';
  }

  @override
  String get userCreated => 'Usuario creado exitosamente';

  @override
  String get userUpdated => 'Usuario actualizado exitosamente';

  @override
  String get userDeleted => 'Usuario eliminado exitosamente';

  @override
  String get noUsersFound => 'No se encontraron usuarios';

  @override
  String get pleaseEnterEmail => 'Por favor ingrese un correo electrónico';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get mustChangePassword =>
      'Debe cambiar la contraseña al iniciar sesión por primera vez';

  @override
  String get pleaseEnterTitle => 'Por favor ingrese un título';

  @override
  String get noActivity => 'Sin actividad';

  @override
  String get createdRepo => 'repositorio creado';

  @override
  String get pushedTag => 'etiqueta enviada';

  @override
  String get deletedTag => 'etiqueta eliminada';

  @override
  String get createdIssue => 'incidencia creada';

  @override
  String get closedIssue => 'incidencia cerrada';

  @override
  String get reopenedIssue => 'incidencia reabierta';

  @override
  String get createdPR => 'solicitud de extracción creada';

  @override
  String get mergedPR => 'solicitud de extracción fusionada';

  @override
  String get closedPR => 'solicitud de extracción cerrada';

  @override
  String get commentedOnIssue => 'comentó en la incidencia';

  @override
  String get commentedOnPR => 'comentó en la solicitud de extracción';

  @override
  String get forkedRepo => 'repositorio bifurcado';

  @override
  String get transferredRepo => 'repositorio transferido';

  @override
  String get deletedRepo => 'repositorio eliminado';

  @override
  String get updatedWiki => 'wiki actualizada';

  @override
  String get performedAction => 'acción realizada';

  @override
  String get commitRepo => 'commit en';

  @override
  String get renameRepo => 'repositorio renombrado';

  @override
  String get starRepo => 'repositorio destacado';

  @override
  String get watchRepo => 'comenzó a observar el repositorio';

  @override
  String get reopenPR => 'solicitud de extracción reabierta';

  @override
  String get approvePR => 'solicitud de extracción aprobada';

  @override
  String get rejectPR => 'solicitud de extracción rechazada';

  @override
  String get publishRelease => 'versión publicada';

  @override
  String get deleteBranch => 'rama eliminada';

  @override
  String get autoMergePR => 'solicitud de extracción auto-fusionada';

  @override
  String get pullReviewDismissed =>
      'revisión de solicitud de extracción descartada';

  @override
  String get pullRequestReady =>
      'solicitud de extracción marcada como lista para revisión';

  @override
  String get mirrorSyncPush => 'push sincronizado con el espejo';

  @override
  String get mirrorSyncCreate => 'creación sincronizada con el espejo';

  @override
  String get mirrorSyncDelete => 'eliminación sincronizada con el espejo';

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
  String get privateRepo => 'Repositorio privado';

  @override
  String get privateRepoDesc => 'Solo visible para usted y los colaboradores';

  @override
  String get enableIssues => 'Habilitar incidencias';

  @override
  String get enablePullRequests => 'Habilitar solicitudes de extracción';

  @override
  String get enableWiki => 'Habilitar Wiki';

  @override
  String get preview => 'Vista previa';

  @override
  String get commitMessage => 'Mensaje de commit';

  @override
  String get commit => 'Commit';

  @override
  String get commitMessageHint => 'Describa sus cambios (opcional)';

  @override
  String get cannotGetFileSha =>
      'No se puede obtener el SHA del archivo. Recargue el archivo.';

  @override
  String get failedToSaveFile => 'Error al guardar el archivo';

  @override
  String get fileSaved => 'Archivo guardado exitosamente';

  @override
  String get discard => 'Descartar';

  @override
  String get message => 'Mensaje';

  @override
  String get ok => 'OK';

  @override
  String get sha => 'SHA';

  @override
  String get changedFiles => 'Archivos cambiados';

  @override
  String get tags => 'Etiquetas';

  @override
  String get noCommits => 'Sin commits';

  @override
  String get noTags => 'Sin etiquetas';

  @override
  String get protected => 'Protegido';

  @override
  String get latestCommit => 'Último commit';

  @override
  String get permissions => 'Permisos';

  @override
  String get canPush => 'Puede enviar';

  @override
  String get canMerge => 'Puede fusionar';

  @override
  String get downloads => 'Descargas';

  @override
  String get tarball => 'Tarball';

  @override
  String get zipball => 'Zipball';

  @override
  String get downloadTarball => 'Descargar Tarball';

  @override
  String get downloadZipball => 'Descargar Zipball';

  @override
  String get url => 'URL';

  @override
  String get info => 'Información';

  @override
  String get teams => 'Equipos';

  @override
  String get noTeams => 'Sin equipos';

  @override
  String get location => 'Ubicación';

  @override
  String get visibility => 'Visibilidad';

  @override
  String get assets => 'Recursos';

  @override
  String get publishedAt => 'Publicado el';

  @override
  String get target => 'Destino';

  @override
  String get forked => 'Bifurcado';

  @override
  String get forkRepoConfirm =>
      'Esto creará una bifurcación de este repositorio en su cuenta.';

  @override
  String get editIssue => 'Editar incidencia';

  @override
  String get titleRequired => 'El título es obligatorio';

  @override
  String get selectMilestone => 'Seleccionar hito';

  @override
  String get members => 'Miembros';

  @override
  String get noMembers => 'Sin miembros';

  @override
  String get editOrganization => 'Editar organización';

  @override
  String get createOrganization => 'Crear organización';

  @override
  String get createRepository => 'Crear repositorio';

  @override
  String get repositoryName => 'Nombre del repositorio';

  @override
  String get repositoryNameHint => 'my-awesome-repo';

  @override
  String get repositoryNameRequired =>
      'El nombre del repositorio es obligatorio';

  @override
  String get descriptionHint => 'Breve descripción de su repositorio';

  @override
  String get public => 'Público';

  @override
  String get publicDescription =>
      'Cualquier persona en internet puede ver este repositorio';

  @override
  String get privateDescription =>
      'Usted elige quién puede ver y hacer commit a este repositorio';

  @override
  String get initializeWithReadme => 'Inicializar con README';

  @override
  String get initializeWithReadmeDescription =>
      'Agregue un archivo README para ayudar a otros a entender su proyecto';

  @override
  String repoCreated(Object repoName) {
    return 'Repositorio \'$repoName\' creado exitosamente';
  }

  @override
  String get complete => 'completado';

  @override
  String get wiki => 'Wiki';

  @override
  String get newWikiPage => 'Nueva página Wiki';

  @override
  String get editWikiPage => 'Editar página Wiki';

  @override
  String get deleteWikiPage => 'Eliminar página Wiki';

  @override
  String get deleteWikiPageConfirm =>
      '¿Está seguro de que desea eliminar esta página Wiki? Esta acción no se puede deshacer.';

  @override
  String get wikiPageDeleted => 'Página Wiki eliminada';

  @override
  String get wikiPageTitle => 'Título de la página';

  @override
  String get wikiPageTitleHint => 'e.g. Home';

  @override
  String get wikiPageContent => 'Contenido';

  @override
  String get wikiPageContentHint => 'Escriba en Markdown...';

  @override
  String get noWikiPages => 'Sin páginas Wiki';

  @override
  String get noWikiPagesDescription =>
      'Este repositorio aún no tiene páginas Wiki.';

  @override
  String get createFirstWikiPage => 'Crear primera página';

  @override
  String get lastCommit => 'Último commit';

  @override
  String get noContent => 'Sin contenido';

  @override
  String get saved => 'Guardado';

  @override
  String get created => 'Creado';

  @override
  String get createMilestone => 'Crear hito';

  @override
  String get editMilestone => 'Editar hito';

  @override
  String get deleteMilestone => 'Eliminar hito';

  @override
  String get deleteMilestoneConfirm =>
      '¿Está seguro de que desea eliminar este hito? Esta acción no se puede deshacer.';

  @override
  String get milestoneDeleted => 'Hito eliminado';

  @override
  String get milestoneTitle => 'Título';

  @override
  String get milestoneDescription => 'Descripción';

  @override
  String get milestoneDescriptionHint => 'Describa este hito';

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
      '¿Está seguro de que desea eliminar este webhook? Esta acción no se puede deshacer.';

  @override
  String get webhookDeleted => 'Webhook eliminado';

  @override
  String get webhookUrl => 'URL';

  @override
  String get webhookUrlHint => 'https://example.com/webhook';

  @override
  String get webhookSecret => 'Secreto';

  @override
  String get webhookSecretHint => 'Token secreto opcional';

  @override
  String get webhookContentType => 'Tipo de contenido';

  @override
  String get webhookContentTypeJson => 'application/json';

  @override
  String get webhookContentTypeForm => 'application/x-www-form-urlencoded';

  @override
  String get webhookEvents => 'Eventos';

  @override
  String get webhookEventsHint =>
      'Seleccione eventos para activar este webhook';

  @override
  String get webhookActive => 'Activo';

  @override
  String get webhookInactive => 'Inactivo';

  @override
  String get webhookType => 'Tipo';

  @override
  String get webhookCreatedAt => 'Creado';

  @override
  String get webhookUpdatedAt => 'Actualizado';

  @override
  String get webhookLastDelivery => 'Última entrega';

  @override
  String get webhookSelectAllEvents => 'Seleccionar todo';

  @override
  String get webhookPushEvents => 'Push';

  @override
  String get webhookPullRequestEvents => 'Pull Requests';

  @override
  String get webhookIssuesEvents => 'Issues';

  @override
  String get webhookCreateEvents => 'Crear';

  @override
  String get webhookDeleteEvents => 'Eliminar';

  @override
  String get webhookReleaseEvents => 'Releases';

  @override
  String get webhookWikiEvents => 'Wiki';

  @override
  String get webhookStarEvents => 'Estrella';

  @override
  String get webhookForkEvents => 'Fork';

  @override
  String get loginWithOAuth2 => 'Iniciar sesión con OAuth2';

  @override
  String get oauth2 => 'OAuth2';

  @override
  String get oauth2Description =>
      'Autorizar mediante la aplicación OAuth2 de Gitea';

  @override
  String get oauth2ClientId => 'ID de cliente';

  @override
  String get oauth2ClientSecret => 'Secreto de cliente';

  @override
  String get oauth2RedirectUri => 'URI de redirección';

  @override
  String get oauth2RedirectUriHint => 'igitea://oauth/callback';

  @override
  String get oauth2Authorize => 'Abrir página de autorización';

  @override
  String get oauth2ExchangeCode => 'Intercambiar código por token';

  @override
  String get oauth2AuthorizationCode => 'Código de autorización';

  @override
  String get oauth2AuthorizationCodeHint =>
      'Pegue el código de la URL de redirección';

  @override
  String get oauth2TokenRefreshed => 'Token actualizado exitosamente';

  @override
  String get createLabel => 'Crear etiqueta';

  @override
  String get editLabel => 'Editar etiqueta';

  @override
  String get deleteLabel => 'Eliminar etiqueta';

  @override
  String get deleteLabelConfirm =>
      '¿Está seguro de que desea eliminar esta etiqueta?';

  @override
  String get labelDeleted => 'Etiqueta eliminada';

  @override
  String get labelName => 'Nombre';

  @override
  String get labelNameHint => 'ej. bug';

  @override
  String get labelDescription => 'Descripción';

  @override
  String get labelDescriptionHint => 'Descripción opcional';

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
  String get unifiedView => 'Vista unificada';

  @override
  String get splitView => 'Vista dividida';

  @override
  String get compareVersions => 'Comparar versiones';

  @override
  String get baseRef => 'Base (anterior)';

  @override
  String get headRef => 'Head (nuevo)';

  @override
  String get compare => 'Comparar';

  @override
  String get actions => 'Actions';

  @override
  String get noActions => 'Sin flujos de trabajo';

  @override
  String get run => 'Ejecutar';

  @override
  String get status => 'Estado';

  @override
  String get jobs => 'Trabajos';

  @override
  String get noJobs => 'Sin trabajos';

  @override
  String get artifacts => 'Artefactos';

  @override
  String get branch => 'Rama';

  @override
  String get author => 'Autor';

  @override
  String get filterByActor => 'Filtrar por actor';

  @override
  String get filterByStatus => 'Filtrar por estado';

  @override
  String get reviewChanges => 'Revisar cambios';

  @override
  String get reviewBody => 'Comentario de revisión';

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
  String get diffView => 'Vista Diff';

  @override
  String get pickColor => 'Elegir color';

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
  String get unknownSection => 'Sección desconocida';

  @override
  String get deleteKey => 'Eliminar clave';

  @override
  String get deleteKeyConfirm =>
      '¿Está seguro de que desea eliminar esta clave SSH?';

  @override
  String get keyDeleted => 'Clave eliminada exitosamente';

  @override
  String get addSshKey => 'Agregar clave SSH';

  @override
  String get add => 'Añadir';

  @override
  String get keyAdded => 'Clave agregada exitosamente';

  @override
  String get deleteCommentConfirm =>
      '¿Está seguro de que desea eliminar este comentario?';

  @override
  String get requestReviewers => 'Solicitar revisores';

  @override
  String get addReviewerHint => 'Ingrese el nombre del revisor';

  @override
  String get subscribe => 'Suscribirse';

  @override
  String get unsubscribe => 'Cancelar suscripción';

  @override
  String get subscribed => 'Suscrito';

  @override
  String get unsubscribed => 'Desuscrito';

  @override
  String get setDueDate => 'Establecer fecha de vencimiento';

  @override
  String get removeDueDate => 'Eliminar fecha de vencimiento';

  @override
  String get topics => 'Temas';

  @override
  String get noTopics => 'Sin temas';

  @override
  String get branchProtection => 'Protección de rama';

  @override
  String get protectBranch => 'Proteger rama';

  @override
  String get https => 'HTTPS';

  @override
  String get ssh => 'SSH';

  @override
  String get teamAdminAccess => 'Acceso de administrador del equipo';

  @override
  String get details => 'Detalles';

  @override
  String get id => 'ID';

  @override
  String get searchRepositoriesHint => 'Buscar repositorios';

  @override
  String get publicKey => 'Clave pública';

  @override
  String get failedToGetAccessToken => 'Error al obtener el token de acceso';

  @override
  String get fileNotFound => 'Archivo no encontrado';

  @override
  String get noSshKeysFound => 'No se encontraron claves SSH';

  @override
  String get other => 'Otro';

  @override
  String get usernameRequired => 'El nombre de usuario es obligatorio';

  @override
  String get myLaptopHint => 'Mi portátil';

  @override
  String get sshPublicKeyHint => 'Pegue su clave pública SSH aquí';

  @override
  String get noChangesFoundForFile =>
      'No se encontraron cambios para este archivo';

  @override
  String commitUpdateFile(Object fileName) {
    return 'Actualizar $fileName';
  }

  @override
  String get api => 'API';

  @override
  String get ui => 'UI';

  @override
  String get justNow => 'ahora mismo';

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

  @override
  String get applyLabelSet => 'Aplicar conjunto de etiquetas';

  @override
  String get applyLabelSetDescription =>
      'Seleccione un conjunto predefinido para crear todas las etiquetas de una vez.';

  @override
  String applyAllLabels(Object count) {
    return 'Aplicar todas ($count etiquetas)';
  }

  @override
  String applyAllLabelsParams(Object count) {
    return 'Aplicar todas ($count etiquetas)';
  }

  @override
  String get creating => 'Creando...';

  @override
  String get addCustomLabel => 'Agregar etiqueta personalizada';

  @override
  String get selectTemplate => 'Seleccionar una plantilla';

  @override
  String get createTeam => 'Crear equipo';

  @override
  String get editTeam => 'Editar equipo';

  @override
  String get deleteTeam => 'Eliminar equipo';

  @override
  String get deleteTeamConfirm => '¿Eliminar este equipo?';

  @override
  String get teamName => 'Nombre';

  @override
  String get teamNameRequired => 'Nombre requerido';

  @override
  String get teamDescription => 'Descripción';

  @override
  String get teamPermission => 'Permiso';

  @override
  String get searchMembers => 'Buscar usuarios';

  @override
  String get addMember => 'Añadir';

  @override
  String get removeMember => 'Eliminar';

  @override
  String removeMemberConfirmParams(Object username) {
    return '¿Eliminar a $username?';
  }

  @override
  String get teamCreated => 'Equipo creado';

  @override
  String get teamUpdated => 'Equipo actualizado';

  @override
  String get teamDeleted => 'Equipo eliminado';

  @override
  String get memberAdded => 'Miembro añadido';

  @override
  String get memberRemoved => 'Miembro eliminado';

  @override
  String get noSearchResults => 'Sin resultados';

  @override
  String get teamCanCreateOrgRepos => 'Puede crear repositorios de org';

  @override
  String get teamIncludesAllRepos => 'Incluye todos los repositorios';

  @override
  String get collaborators => 'Colaboradores';

  @override
  String get noCollaborators => 'Sin colaboradores';

  @override
  String get addCollaborator => 'Añadir';

  @override
  String get removeCollaborator => 'Eliminar';

  @override
  String removeCollaboratorConfirmParams(Object username) {
    return '¿Eliminar a $username?';
  }

  @override
  String get collaboratorAdded => 'Añadido';

  @override
  String get collaboratorRemoved => 'Eliminado';

  @override
  String get contentType => 'Tipo de contenido';

  @override
  String get active => 'Activo';

  @override
  String get emails => 'Correos';

  @override
  String get addEmail => 'Añadir correo';

  @override
  String get gpgKeys => 'Claves GPG';

  @override
  String get addGpgKey => 'Agregar clave GPG';

  @override
  String get gpgKeyHint => '-----BEGIN PGP PUBLIC KEY BLOCK-----';

  @override
  String get gpgKeyAdded => 'Clave GPG agregada';

  @override
  String get gpgKeyDeleted => 'Clave GPG eliminada';

  @override
  String get deleteGpgKey => 'Eliminar clave GPG';

  @override
  String get deleteGpgKeyConfirm =>
      '¿Está seguro de que desea eliminar esta clave GPG?';

  @override
  String get noGpgKeys => 'No hay claves GPG';

  @override
  String get sign => 'Firmar';

  @override
  String get certify => 'Certificar';

  @override
  String get verified => 'Verificado';

  @override
  String get tagProtections => 'Protección de etiquetas';

  @override
  String get manageTagProtections =>
      'Administrar reglas de protección de etiquetas';

  @override
  String get createTagProtection => 'Crear protección de etiqueta';

  @override
  String get namePattern => 'Patrón de nombre';

  @override
  String get tagProtectionCreated => 'Protección de etiqueta creada';

  @override
  String get tagProtectionDeleted => 'Protección de etiqueta eliminada';

  @override
  String get deleteTagProtection => 'Eliminar protección de etiqueta';

  @override
  String get deleteTagProtectionConfirm =>
      '¿Está seguro de que desea eliminar esta protección de etiqueta?';

  @override
  String get noTagProtections => 'No hay protecciones de etiquetas';

  @override
  String get allowedUsers => 'Usuarios permitidos';

  @override
  String get dependencies => 'Dependencias';

  @override
  String get addDependency => 'Agregar dependencia';

  @override
  String get dependencyAdded => 'Dependencia agregada';

  @override
  String get dependencyRemoved => 'Dependencia eliminada';

  @override
  String get removeDependency => 'Eliminar dependencia';

  @override
  String get removeDependencyConfirm => '¿Eliminar esta dependencia?';

  @override
  String get noDependencies => 'No hay dependencias';

  @override
  String get blocks => 'Bloquea';

  @override
  String get dependsOn => 'Depende de';

  @override
  String get issueNumberHint => 'Issue #';

  @override
  String get events => 'eventos';

  @override
  String get items => 'elementos';

  @override
  String get commented => 'comentó';

  @override
  String get labelUpdated => 'Etiqueta actualizada';

  @override
  String get milestoneUpdated => 'Hito actualizado';

  @override
  String get assigneeUpdated => 'Asignado actualizado';

  @override
  String get reopened => 'Reabierto';

  @override
  String get stargazers => 'Stargazers';

  @override
  String get subscribers => 'Suscriptores';

  @override
  String get noStargazers => 'Aún no hay stargazers';

  @override
  String get noSubscribers => 'Aún no hay suscriptores';

  @override
  String get adminHooksTitle => 'Hooks del sistema';

  @override
  String get adminCronTitle => 'Tareas Cron';

  @override
  String get adminRunnersTitle => 'Runners de Actions';

  @override
  String get adminEmailsTitle => 'Correos electrónicos';

  @override
  String get adminBadgesTitle => 'Insignias';

  @override
  String get adminRunCron => 'Ejecutar ahora';

  @override
  String get adminGetToken => 'Obtener token de registro';

  @override
  String get adminNoHooks => 'No hay hooks del sistema configurados';

  @override
  String get adminNoCron => 'No hay tareas cron';

  @override
  String get adminNoRunners => 'No hay runners de acciones';

  @override
  String get adminNoEmails => 'No hay correos electrónicos';

  @override
  String get adminNoBadges => 'No hay insignias';

  @override
  String get adminBadgeUsername => 'Usuario';

  @override
  String get adminBadgeDescription => 'Descripción';

  @override
  String get oauthAppsTitle => 'Aplicaciones OAuth';

  @override
  String get oauthNoApps => 'No hay aplicaciones OAuth';

  @override
  String get oauthCreateApp => 'Crear aplicación OAuth';

  @override
  String get oauthRedirectUri => 'URI de redirección';

  @override
  String get oauthDeleteAppConfirm => 'Eliminar aplicación OAuth';

  @override
  String get name => 'Nombre';

  @override
  String get confirmDelete => 'Confirmar eliminación';

  @override
  String get actionsSecretsTitle => 'Secrets de Actions';

  @override
  String get actionsVariablesTitle => 'Variables de Actions';

  @override
  String get actionsNoSecrets => 'No hay secrets configurados';

  @override
  String get actionsNoVariables => 'No hay variables configuradas';

  @override
  String get actionsCreateSecret => 'Crear Secret';

  @override
  String get actionsCreateVariable => 'Crear Variable';

  @override
  String get actionsSecretName => 'Nombre del Secret';

  @override
  String get actionsSecretValue => 'Valor del Secret';

  @override
  String get actionsVariableName => 'Nombre de la Variable';

  @override
  String get actionsVariableValue => 'Valor de la Variable';

  @override
  String get actionsDeleteSecretConfirm => '¿Eliminar este secret?';

  @override
  String get actionsDeleteVariableConfirm => '¿Eliminar esta variable?';

  @override
  String get deleted => 'Eliminado';

  @override
  String get overdue => 'Vencido';

  @override
  String get addTopic => 'Agregar tema';

  @override
  String get importRepository => 'Importar repositorio';

  @override
  String get import => 'Importar';

  @override
  String get repoImported => 'Repositorio importado';

  @override
  String get cloneUrl => 'URL de clonación';

  @override
  String get repoOwner => 'Propietario';

  @override
  String get gitService => 'Servicio Git';

  @override
  String get authentication => 'Autenticación';

  @override
  String get authUsername => 'Usuario de autenticación';

  @override
  String get authPassword => 'Contraseña de autenticación';

  @override
  String get authToken => 'Token de autenticación';

  @override
  String get migrationOptions => 'Opciones';

  @override
  String get migrateData => 'Datos a importar';

  @override
  String get mirror => 'Espejo';

  @override
  String get mirrorInterval => 'Intervalo de espejo';

  @override
  String get requiredField => 'Este campo es obligatorio';

  @override
  String get personal => 'Personal';

  @override
  String get deleteOrganization => 'Eliminar organización';

  @override
  String get deleteOrganizationConfirm =>
      '¿Está seguro de que desea eliminar esta organización? Esta acción no se puede deshacer.';

  @override
  String get organizationDeleted => 'Organización eliminada';

  @override
  String get accessTokens => 'Tokens de acceso';

  @override
  String get createToken => 'Crear Token';

  @override
  String get tokenName => 'Nombre del Token';

  @override
  String get tokenCreated => 'Token creado';

  @override
  String get tokenValueWarning =>
      'Asegúrese de copiar este token ahora. No podrá verlo de nuevo.';

  @override
  String get failedToCreateToken => 'Error al crear el token';

  @override
  String get deleteToken => 'Eliminar Token';

  @override
  String get deleteTokenConfirm => '¿Está seguro de que desea eliminar';

  @override
  String get tokenDeleted => 'Token eliminado';

  @override
  String get noTokens => 'No hay tokens de acceso';

  @override
  String get scopes => 'Ámbitos';

  @override
  String get selectAll => 'Seleccionar todo';

  @override
  String get deselectAll => 'Deseleccionar todo';

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
  String get browseRepositories => 'Explorar repositorios';

  @override
  String get viewIssues => 'Ver y gestionar issues';

  @override
  String get recentActivitySubtitle => 'Ver actividad reciente';

  @override
  String get yourStarredRepos => 'Tus repositorios destacados';

  @override
  String get yourOrganizations => 'Tus organizaciones';

  @override
  String get loadMoreActivity => 'Cargar más actividad';
}
