// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'iGitea';

  @override
  String get language => 'Idioma';

  @override
  String get settings => 'Configurações';

  @override
  String get profile => 'Perfil';

  @override
  String get search => 'Pesquisar';

  @override
  String get notifications => 'Notificações';

  @override
  String get dashboard => 'Painel';

  @override
  String get signOut => 'Sair';

  @override
  String get signIn => 'Entrar';

  @override
  String get username => 'Nome de usuário';

  @override
  String get password => 'Senha';

  @override
  String get login => 'Entrar';

  @override
  String get loginWithToken => 'Entrar com token';

  @override
  String get token => 'Token';

  @override
  String get cancel => 'Cancelar';

  @override
  String get confirm => 'Confirmar';

  @override
  String get save => 'Salvar';

  @override
  String get delete => 'Excluir';

  @override
  String get edit => 'Editar';

  @override
  String get create => 'Criar';

  @override
  String get close => 'Fechar';

  @override
  String get reopen => 'Reabrir';

  @override
  String get merge => 'Mesclar';

  @override
  String get submit => 'Enviar';

  @override
  String get retry => 'Tentar novamente';

  @override
  String get loading => 'Carregando...';

  @override
  String get error => 'Erro';

  @override
  String get noData => 'Sem dados';

  @override
  String get searchRepos => 'Pesquisar repositórios';

  @override
  String get searchIssues => 'Pesquisar problemas';

  @override
  String get noResults => 'Nenhum resultado encontrado';

  @override
  String get repositories => 'Repositórios';

  @override
  String get repositorySections => 'Repository Sections';

  @override
  String get issues => 'Problemas';

  @override
  String get pullRequests => 'Solicitações de pull';

  @override
  String get releases => 'Lançamentos';

  @override
  String get branches => 'Branches';

  @override
  String get code => 'Código';

  @override
  String get stars => 'Estrelas';

  @override
  String get forks => 'Forks';

  @override
  String get watchers => 'Observadores';

  @override
  String get open => 'Aberto';

  @override
  String get closed => 'Fechado';

  @override
  String get all => 'Todos';

  @override
  String get mergePullRequest => 'Mesclar solicitação de pull';

  @override
  String get mergeConfirmMessage =>
      'Tem certeza de que deseja mesclar esta solicitação de pull?';

  @override
  String issueNumber(Object issueNumber) {
    return 'Problema #$issueNumber';
  }

  @override
  String pullRequestNumber(Object pullRequestNumber) {
    return 'PR #$pullRequestNumber';
  }

  @override
  String get comments => 'Comentários';

  @override
  String get addComment => 'Adicionar um comentário...';

  @override
  String get sendComment => 'Enviar';

  @override
  String get noComments => 'Nenhum comentário ainda';

  @override
  String get labels => 'Etiquetas';

  @override
  String get milestones => 'Marcos';

  @override
  String get assignees => 'Responsáveis';

  @override
  String get assignee => 'Assignee';

  @override
  String get participants => 'Participantes';

  @override
  String get timeline => 'Linha do tempo';

  @override
  String get theme => 'Tema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Escuro';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get account => 'Conta';

  @override
  String get accountInfo => 'Informações da conta';

  @override
  String get email => 'E-mail';

  @override
  String get website => 'Website';

  @override
  String get bio => 'Biografia';

  @override
  String joinedOn(Object date) {
    return 'Joined on $date';
  }

  @override
  String joinedOnParams(Object date) {
    return 'Entrou em $date';
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
    return '$count seguindo';
  }

  @override
  String repositoryCount(Object count) {
    return '$count repositories';
  }

  @override
  String repositoryCountParams(Object count) {
    return '$count repositórios';
  }

  @override
  String get starredRepos => 'Repositórios favoritados';

  @override
  String get organisations => 'Organizações';

  @override
  String get adminPanel => 'Painel de administração';

  @override
  String get userManagement => 'Gerenciamento de usuários';

  @override
  String get serverSettings => 'Configurações do servidor';

  @override
  String get cronTasks => 'Tarefas cron';

  @override
  String get apiSettings => 'Configurações da API';

  @override
  String get uiSettings => 'Configurações da interface';

  @override
  String get attachmentSettings => 'Configurações de anexos';

  @override
  String get repoSettings => 'Configurações do repositório';

  @override
  String get runNow => 'Executar agora';

  @override
  String lastRun(Object time) {
    return 'Last run: $time';
  }

  @override
  String lastRunParams(Object time) {
    return 'Última execução: $time';
  }

  @override
  String nextRun(Object time) {
    return 'Next run: $time';
  }

  @override
  String nextRunParams(Object time) {
    return 'Próxima execução: $time';
  }

  @override
  String get recentActivity => 'Atividade recente';

  @override
  String get myIssues => 'Meus problemas';

  @override
  String get myRepos => 'Meus repositórios';

  @override
  String get myStars => 'Minhas estrelas';

  @override
  String get feed => 'Feed';

  @override
  String get markAllRead => 'Marcar tudo como lido';

  @override
  String get markRead => 'Marcar como lido';

  @override
  String unreadNotifications(Object count) {
    return 'Unread notifications: $count';
  }

  @override
  String unreadNotificationsParams(Object count) {
    return 'Notificações não lidas: $count';
  }

  @override
  String get noUnreadNotifications => 'Nenhuma notificação não lida';

  @override
  String get readMore => 'Ler mais';

  @override
  String ago(Object time) {
    return '$time ago';
  }

  @override
  String agoParams(Object time) {
    return 'há $time';
  }

  @override
  String get fileBrowser => 'Navegador de arquivos';

  @override
  String get readme => 'README';

  @override
  String get commits => 'Commits';

  @override
  String get commitHistory => 'Histórico de commits';

  @override
  String get viewFile => 'Ver arquivo';

  @override
  String get downloadFile => 'Baixar arquivo';

  @override
  String get copyPath => 'Copiar caminho';

  @override
  String get fileName => 'Nome do arquivo';

  @override
  String get fileSize => 'Tamanho do arquivo';

  @override
  String get lastModified => 'Última modificação';

  @override
  String get openInBrowser => 'Abrir no navegador';

  @override
  String get signInRequired => 'Login necessário';

  @override
  String get signInMessage => 'Por favor, entre para continuar';

  @override
  String get loginFailed => 'Falha no login';

  @override
  String get networkError => 'Erro de rede';

  @override
  String get unknownError => 'Ocorreu um erro desconhecido';

  @override
  String get refresh => 'Atualizar';

  @override
  String get copyToClipboard => 'Copiar para a área de transferência';

  @override
  String get copied => 'Copiado!';

  @override
  String get filterIssues => 'Filtrar problemas';

  @override
  String get newIssue => 'Novo problema';

  @override
  String get newPullRequest => 'Nova solicitação de pull';

  @override
  String get title => 'Título';

  @override
  String get description => 'Descrição';

  @override
  String get body => 'Corpo';

  @override
  String get state => 'Estado';

  @override
  String get priority => 'Prioridade';

  @override
  String get milestone => 'Marco';

  @override
  String get createdAt => 'Criado em';

  @override
  String get updatedAt => 'Atualizado em';

  @override
  String get dueDate => 'Data de vencimento';

  @override
  String get noMilestones => 'Sem marcos';

  @override
  String get noLabels => 'Sem etiquetas';

  @override
  String get openIssue => 'Abrir problema';

  @override
  String get closeIssue => 'Fechar problema';

  @override
  String get reopenIssue => 'Reabrir problema';

  @override
  String get deleteComment => 'Excluir comentário';

  @override
  String get editComment => 'Editar comentário';

  @override
  String get deleteRepo => 'Excluir repositório';

  @override
  String get deleteRepoConfirm =>
      'Tem certeza de que deseja excluir este repositório? Esta ação não pode ser desfeita.';

  @override
  String get generalSettings => 'Configurações gerais';

  @override
  String get appearance => 'Aparência';

  @override
  String get languageSelector => 'Idioma';

  @override
  String get selectLanguage => 'Selecionar idioma';

  @override
  String get systemDefault => 'Padrão do sistema';

  @override
  String get followSystem => 'Seguir sistema';

  @override
  String get unsavedChanges => 'Alterações não salvas';

  @override
  String get unsavedChangesMessage =>
      'Você tem alterações não salvas. Tem certeza de que deseja sair?';

  @override
  String get leave => 'Sair';

  @override
  String get stay => 'Ficar';

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
}
