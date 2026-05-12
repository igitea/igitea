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
  String get users => 'Usuários';

  @override
  String get enterSearchQueryUsers =>
      'Digite uma consulta para encontrar usuários';

  @override
  String get noResults => 'Nenhum resultado encontrado';

  @override
  String get repositories => 'Repositórios';

  @override
  String get repositorySections => 'Seções do Repositório';

  @override
  String get issues => 'Problemas';

  @override
  String get pullRequests => 'Solicitações de pull';

  @override
  String get releases => 'Lançamentos';

  @override
  String get branches => 'Ramos';

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
  String get assignee => 'Responsável';

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
    return 'Entrou em $date';
  }

  @override
  String joinedOnParams(Object date) {
    return 'Entrou em $date';
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
    return '$count seguindo';
  }

  @override
  String followingCountParams(Object count) {
    return '$count seguindo';
  }

  @override
  String repositoryCount(Object count) {
    return '$count repositórios';
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
    return 'Última execução: $time';
  }

  @override
  String lastRunParams(Object time) {
    return 'Última execução: $time';
  }

  @override
  String nextRun(Object time) {
    return 'Próxima execução: $time';
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
    return 'Notificações não lidas: $count';
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
    return 'há $time';
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
  String get restoringSession => 'Restaurando sessão...';

  @override
  String get pleaseEnterServerUrl => 'Por favor, insira uma URL de servidor';

  @override
  String get pleaseEnterValidUrl => 'Por favor, insira uma URL válida';

  @override
  String get connectToGitea => 'Conecte-se à sua instância Gitea';

  @override
  String get usernamePassword => 'Nome de Usuário e Senha';

  @override
  String get serverUrl => 'URL do Servidor';

  @override
  String get enterUsername => 'Digite seu nome de usuário';

  @override
  String get pleaseEnterUsername => 'Por favor, digite seu nome de usuário';

  @override
  String get enterPassword => 'Digite sua senha';

  @override
  String get pleaseEnterPassword => 'Por favor, digite sua senha';

  @override
  String get pasteAccessToken => 'Cole seu token de acesso pessoal';

  @override
  String get pleaseEnterAccessToken => 'Por favor, insira um token de acesso';

  @override
  String get signInWithToken => 'Entrar com Token';

  @override
  String get welcomeToIgitea => 'Bem-vindo ao iGitea';

  @override
  String get signInToGetStarted => 'Entre para começar';

  @override
  String get quickActions => 'Ações rápidas';

  @override
  String get yourRepositories => 'Seus repositórios';

  @override
  String get noRepositoriesFound => 'Nenhum repositório encontrado';

  @override
  String helloParams(Object full_name) {
    return 'Olá, $full_name!';
  }

  @override
  String get user => 'Usuário';

  @override
  String get private => 'Privado';

  @override
  String get untitled => 'Sem título';

  @override
  String get enterSearchQueryRepos =>
      'Digite uma consulta para encontrar repositórios';

  @override
  String get enterSearchQueryIssues =>
      'Digite uma consulta para encontrar problemas';

  @override
  String get noIssuesFound => 'Nenhum problema encontrado.';

  @override
  String get failedToLoadProfile => 'Falha ao carregar perfil';

  @override
  String get unknownUser => 'Usuário Desconhecido';

  @override
  String get admin => 'Admin';

  @override
  String get repos => 'Repositórios';

  @override
  String get followers => 'Seguidores';

  @override
  String get following => 'Seguindo';

  @override
  String get follow => 'Seguir';

  @override
  String get unfollow => 'Deixar de seguir';

  @override
  String get signOutConfirmMessage => 'Tem certeza de que deseja sair?';

  @override
  String get chooseTheme => 'Escolher Tema';

  @override
  String get loadingSettings => 'Carregando configurações...';

  @override
  String get userManagementComingSoon => 'Gerenciamento de usuários em breve';

  @override
  String get maxResponseItems => 'Máx. Itens de Resposta';

  @override
  String get defaultPagingNum => 'Núm. de Paginação Padrão';

  @override
  String get defaultMaxBlobSize => 'Tamanho Máx. de Blob Padrão';

  @override
  String get defaultTheme => 'Tema Padrão';

  @override
  String get allowedReactions => 'Reações Permitidas';

  @override
  String get attachments => 'Anexos';

  @override
  String get enabled => 'Ativado';

  @override
  String get maxFiles => 'Máx. Arquivos';

  @override
  String get maxSize => 'Tamanho Máx.';

  @override
  String get allowedTypes => 'Tipos Permitidos';

  @override
  String get bytes => 'bytes';

  @override
  String get repository => 'Repositório';

  @override
  String get httpGitDisabled => 'HTTP Git Desativado';

  @override
  String get lfsDisabled => 'LFS Desativado';

  @override
  String get migrationsDisabled => 'Migrações Desativadas';

  @override
  String get mirrorsDisabled => 'Espelhos Desativados';

  @override
  String get starsDisabled => 'Estrelas Desativadas';

  @override
  String get timeTrackingDisabled => 'Controle de Tempo Desativado';

  @override
  String get yes => 'Sim';

  @override
  String get no => 'Não';

  @override
  String get schedule => 'Agendamento';

  @override
  String get next => 'Próximo';

  @override
  String get executions => 'Execuções';

  @override
  String get failedToLoadCronTasks => 'Falha ao carregar tarefas cron';

  @override
  String get noCronTasksFound => 'Nenhuma tarefa cron encontrada';

  @override
  String cronTriggeredParams(Object name) {
    return 'Cron \"$name\" acionado';
  }

  @override
  String get unknown => 'Desconhecido';

  @override
  String openedParams(Object time) {
    return 'aberto $time';
  }

  @override
  String get noDescriptionProvided => 'Nenhuma descrição fornecida.';

  @override
  String get failedToLoadComments => 'Falha ao carregar comentários';

  @override
  String get writeComment => 'Escreva um comentário...';

  @override
  String commentsCountParams(Object count) {
    return '$count comentários';
  }

  @override
  String updatedParams(Object time) {
    return 'Atualizado $time';
  }

  @override
  String commentsParams(Object count) {
    return 'Comentários ($count)';
  }

  @override
  String get files => 'arquivos';

  @override
  String get mergeable => 'Mesclável';

  @override
  String get merged => 'Mesclado';

  @override
  String get draft => 'Rascunho';

  @override
  String get failedToLoadRepo => 'Falha ao carregar repositório';

  @override
  String get copyUrl => 'Copiar URL';

  @override
  String get urlCopied => 'URL copiada';

  @override
  String get emptyDirectory => 'Diretório vazio';

  @override
  String get noIssues => 'Nenhum problema';

  @override
  String get noPullRequests => 'Nenhuma solicitação de pull';

  @override
  String get noReleases => 'Nenhum lançamento';

  @override
  String get noBranches => 'Nenhum ramo';

  @override
  String get preRelease => 'Pré-lançamento';

  @override
  String get archived => 'Arquivado';

  @override
  String get defaultBranch => 'Ramo padrão';

  @override
  String get copyCode => 'Copiar código';

  @override
  String get failedToLoadFile => 'Falha ao carregar arquivo';

  @override
  String get filePreviewNotAvailable =>
      'Visualização de arquivo não disponível';

  @override
  String get download => 'Baixar';

  @override
  String get failedToOpenDownloadUrl => 'Falha ao abrir URL de download';

  @override
  String get noNotifications => 'Nenhuma notificação';

  @override
  String get noTitle => 'Sem título';

  @override
  String get allNotificationsMarkedAsRead =>
      'Todas as notificações marcadas como lidas';

  @override
  String get createUser => 'Criar Usuário';

  @override
  String get editUser => 'Editar Usuário';

  @override
  String get deleteIssue => 'Excluir Issue';

  @override
  String get deleteIssueConfirm =>
      'Tem certeza de que deseja excluir este issue? Esta ação não pode ser desfeita.';

  @override
  String get issueDeleted => 'Issue excluído';

  @override
  String get deleteUser => 'Excluir Usuário';

  @override
  String deleteUserConfirmParams(Object username) {
    return 'Tem certeza de que deseja excluir o usuário \"$username\"? Esta ação não pode ser desfeita.';
  }

  @override
  String get userCreated => 'Usuário criado com sucesso';

  @override
  String get userUpdated => 'Usuário atualizado com sucesso';

  @override
  String get userDeleted => 'Usuário excluído com sucesso';

  @override
  String get noUsersFound => 'Nenhum usuário encontrado';

  @override
  String get pleaseEnterEmail => 'Por favor, insira um e-mail';

  @override
  String get fullName => 'Nome completo';

  @override
  String get mustChangePassword => 'Deve alterar a senha no primeiro login';

  @override
  String get pleaseEnterTitle => 'Por favor, insira um título';

  @override
  String get noActivity => 'Nenhuma atividade recente';

  @override
  String get createdRepo => 'repositório criado';

  @override
  String get pushedTag => 'tag enviada';

  @override
  String get deletedTag => 'tag excluída';

  @override
  String get createdIssue => 'problema criado';

  @override
  String get closedIssue => 'problema fechado';

  @override
  String get reopenedIssue => 'problema reaberto';

  @override
  String get createdPR => 'solicitação de pull criada';

  @override
  String get mergedPR => 'solicitação de pull mesclada';

  @override
  String get closedPR => 'solicitação de pull fechada';

  @override
  String get commentedOnIssue => 'comentou no problema';

  @override
  String get commentedOnPR => 'comentou na solicitação de pull';

  @override
  String get forkedRepo => 'repositório bifurcado';

  @override
  String get transferredRepo => 'repositório transferido';

  @override
  String get deletedRepo => 'repositório excluído';

  @override
  String get updatedWiki => 'wiki atualizado';

  @override
  String get performedAction => 'ação realizada';

  @override
  String get commitRepo => 'commit em';

  @override
  String get renameRepo => 'repositório renomeado';

  @override
  String get starRepo => 'repositório favoritado';

  @override
  String get watchRepo => 'começou a observar repositório';

  @override
  String get reopenPR => 'solicitação de pull reaberta';

  @override
  String get approvePR => 'solicitação de pull aprovada';

  @override
  String get rejectPR => 'solicitação de pull rejeitada';

  @override
  String get publishRelease => 'lançamento publicado';

  @override
  String get deleteBranch => 'ramo excluído';

  @override
  String get autoMergePR => 'solicitação de pull auto-mesclada';

  @override
  String get pullReviewDismissed => 'revisão de solicitação de pull descartada';

  @override
  String get pullRequestReady => 'solicitação de pull marcada como pronta';

  @override
  String get mirrorSyncPush => 'push sincronizado no espelho';

  @override
  String get mirrorSyncCreate => 'criação sincronizada no espelho';

  @override
  String get mirrorSyncDelete => 'exclusão sincronizada no espelho';

  @override
  String get inRepo => 'em';

  @override
  String get to => 'para';

  @override
  String get from => 'de';

  @override
  String get headBranch => 'Ramo fonte';

  @override
  String get baseBranch => 'Ramo base';

  @override
  String get pleaseFillAllFields => 'Preencha todos os campos obrigatórios';

  @override
  String get settingsSaved => 'Configurações salvas';

  @override
  String get privateRepo => 'Repositório privado';

  @override
  String get privateRepoDesc => 'Visível apenas para você e colaboradores';

  @override
  String get enableIssues => 'Ativar Problemas';

  @override
  String get enablePullRequests => 'Ativar Solicitações de Pull';

  @override
  String get enableWiki => 'Ativar Wiki';

  @override
  String get preview => 'Visualizar';

  @override
  String get commitMessage => 'Mensagem de Commit';

  @override
  String get commit => 'Commit';

  @override
  String get commitMessageHint => 'Descreva suas alterações (opcional)';

  @override
  String get cannotGetFileSha =>
      'Não foi possível obter o SHA do arquivo. Recarregue o arquivo.';

  @override
  String get failedToSaveFile => 'Falha ao salvar arquivo';

  @override
  String get fileSaved => 'Arquivo salvo com sucesso';

  @override
  String get discard => 'Descartar';

  @override
  String get message => 'Mensagem';

  @override
  String get ok => 'OK';

  @override
  String get sha => 'SHA';

  @override
  String get changedFiles => 'Arquivos Alterados';

  @override
  String get tags => 'Tags';

  @override
  String get noCommits => 'Nenhum commit';

  @override
  String get noTags => 'Nenhuma tag';

  @override
  String get protected => 'Protegido';

  @override
  String get latestCommit => 'Último Commit';

  @override
  String get permissions => 'Permissões';

  @override
  String get canPush => 'Pode Enviar';

  @override
  String get canMerge => 'Pode Mesclar';

  @override
  String get downloads => 'Downloads';

  @override
  String get tarball => 'Tarball';

  @override
  String get zipball => 'Zipball';

  @override
  String get downloadTarball => 'Baixar Tarball';

  @override
  String get downloadZipball => 'Baixar Zipball';

  @override
  String get url => 'URL';

  @override
  String get info => 'Info';

  @override
  String get teams => 'Equipes';

  @override
  String get noTeams => 'Nenhuma equipe';

  @override
  String get location => 'Localização';

  @override
  String get visibility => 'Visibilidade';

  @override
  String get assets => 'Recursos';

  @override
  String get publishedAt => 'Publicado Em';

  @override
  String get target => 'Destino';

  @override
  String get forked => 'Bifurcado';

  @override
  String get forkRepoConfirm =>
      'Isso criará uma bifurcação deste repositório em sua conta.';

  @override
  String get editIssue => 'Editar Problema';

  @override
  String get titleRequired => 'Título é obrigatório';

  @override
  String get selectMilestone => 'Selecionar marco';

  @override
  String get members => 'Membros';

  @override
  String get noMembers => 'Nenhum membro';

  @override
  String get editOrganization => 'Editar Organização';

  @override
  String get createOrganization => 'Criar Organização';

  @override
  String get createRepository => 'Criar Repositório';

  @override
  String get repositoryName => 'Nome do Repositório';

  @override
  String get repositoryNameHint => 'my-awesome-repo';

  @override
  String get repositoryNameRequired => 'Nome do repositório é obrigatório';

  @override
  String get descriptionHint => 'Breve descrição do seu repositório';

  @override
  String get public => 'Público';

  @override
  String get publicDescription =>
      'Qualquer pessoa na internet pode ver este repositório';

  @override
  String get privateDescription =>
      'Você escolhe quem pode ver e fazer commit neste repositório';

  @override
  String get initializeWithReadme => 'Inicializar com README';

  @override
  String get initializeWithReadmeDescription =>
      'Adicione um arquivo README para ajudar outros a entenderem seu projeto';

  @override
  String repoCreated(Object repoName) {
    return 'Repositório \'$repoName\' criado com sucesso';
  }

  @override
  String get complete => 'completo';

  @override
  String get wiki => 'Wiki';

  @override
  String get newWikiPage => 'Nova Página Wiki';

  @override
  String get editWikiPage => 'Editar Página Wiki';

  @override
  String get deleteWikiPage => 'Excluir Página Wiki';

  @override
  String get deleteWikiPageConfirm =>
      'Tem certeza de que deseja excluir esta página Wiki? Esta ação não pode ser desfeita.';

  @override
  String get wikiPageDeleted => 'Página Wiki excluída';

  @override
  String get wikiPageTitle => 'Título da Página';

  @override
  String get wikiPageTitleHint => 'e.g. Home';

  @override
  String get wikiPageContent => 'Conteúdo';

  @override
  String get wikiPageContentHint => 'Escreva em Markdown...';

  @override
  String get noWikiPages => 'Nenhuma página Wiki';

  @override
  String get noWikiPagesDescription =>
      'Este repositório ainda não tem páginas Wiki.';

  @override
  String get createFirstWikiPage => 'Criar Primeira Página';

  @override
  String get lastCommit => 'Último commit';

  @override
  String get noContent => 'Sem conteúdo';

  @override
  String get saved => 'Salvo';

  @override
  String get created => 'Criado';

  @override
  String get createMilestone => 'Criar Marco';

  @override
  String get editMilestone => 'Editar Marco';

  @override
  String get deleteMilestone => 'Excluir Marco';

  @override
  String get deleteMilestoneConfirm =>
      'Tem certeza de que deseja excluir este marco? Esta ação não pode ser desfeita.';

  @override
  String get milestoneDeleted => 'Marco excluído';

  @override
  String get milestoneTitle => 'Título';

  @override
  String get milestoneDescription => 'Descrição';

  @override
  String get milestoneDescriptionHint => 'Descreva este marco';

  @override
  String get milestoneDueDate => 'Data de Vencimento';

  @override
  String get milestoneState => 'Estado';

  @override
  String get milestoneStateOpen => 'Aberto';

  @override
  String get milestoneStateClosed => 'Fechado';

  @override
  String get total => 'Total';

  @override
  String get clear => 'Limpar';

  @override
  String get webhooks => 'Webhooks';

  @override
  String get webhook => 'Webhook';

  @override
  String get noWebhooks => 'Nenhum webhook';

  @override
  String get createWebhook => 'Criar Webhook';

  @override
  String get editWebhook => 'Editar Webhook';

  @override
  String get deleteWebhook => 'Excluir Webhook';

  @override
  String get deleteWebhookConfirm =>
      'Tem certeza de que deseja excluir este webhook? Esta ação não pode ser desfeita.';

  @override
  String get webhookDeleted => 'Webhook excluído';

  @override
  String get webhookUrl => 'URL';

  @override
  String get webhookUrlHint => 'https://example.com/webhook';

  @override
  String get webhookSecret => 'Segredo';

  @override
  String get webhookSecretHint => 'Token secreto opcional';

  @override
  String get webhookContentType => 'Tipo de Conteúdo';

  @override
  String get webhookContentTypeJson => 'application/json';

  @override
  String get webhookContentTypeForm => 'application/x-www-form-urlencoded';

  @override
  String get webhookEvents => 'Eventos';

  @override
  String get webhookEventsHint => 'Selecione eventos para acionar este webhook';

  @override
  String get webhookActive => 'Ativo';

  @override
  String get webhookInactive => 'Inativo';

  @override
  String get webhookType => 'Tipo';

  @override
  String get webhookCreatedAt => 'Criado';

  @override
  String get webhookUpdatedAt => 'Atualizado';

  @override
  String get webhookLastDelivery => 'Última Entrega';

  @override
  String get webhookSelectAllEvents => 'Selecionar Todos';

  @override
  String get webhookPushEvents => 'Push';

  @override
  String get webhookPullRequestEvents => 'Pull Requests';

  @override
  String get webhookIssuesEvents => 'Problemas';

  @override
  String get webhookCreateEvents => 'Criar';

  @override
  String get webhookDeleteEvents => 'Excluir';

  @override
  String get webhookReleaseEvents => 'Lançamentos';

  @override
  String get webhookWikiEvents => 'Wiki';

  @override
  String get webhookStarEvents => 'Estrela';

  @override
  String get webhookForkEvents => 'Bifurcação';

  @override
  String get loginWithOAuth2 => 'Entrar com OAuth2';

  @override
  String get oauth2 => 'OAuth2';

  @override
  String get oauth2Description => 'Autorizar via aplicativo OAuth2 do Gitea';

  @override
  String get oauth2ClientId => 'ID do Cliente';

  @override
  String get oauth2ClientSecret => 'Segredo do Cliente';

  @override
  String get oauth2RedirectUri => 'URI de Redirecionamento';

  @override
  String get oauth2RedirectUriHint => 'igitea://oauth/callback';

  @override
  String get oauth2Authorize => 'Abrir Página de Autorização';

  @override
  String get oauth2ExchangeCode => 'Trocar Código por Token';

  @override
  String get oauth2AuthorizationCode => 'Código de Autorização';

  @override
  String get oauth2AuthorizationCodeHint =>
      'Cole o código da URL de redirecionamento';

  @override
  String get oauth2TokenRefreshed => 'Token atualizado com sucesso';

  @override
  String get createLabel => 'Criar Etiqueta';

  @override
  String get editLabel => 'Editar Etiqueta';

  @override
  String get deleteLabel => 'Excluir Etiqueta';

  @override
  String get deleteLabelConfirm =>
      'Tem certeza de que deseja excluir esta etiqueta?';

  @override
  String get labelDeleted => 'Etiqueta excluída';

  @override
  String get labelName => 'Nome';

  @override
  String get labelNameHint => 'e.g. bug';

  @override
  String get labelDescription => 'Descrição';

  @override
  String get labelDescriptionHint => 'Descrição opcional';

  @override
  String get labelColor => 'Cor';

  @override
  String get labelColorHint => 'Hex color, e.g. #FF0000';

  @override
  String get filesChanged => 'Arquivos alterados';

  @override
  String get noFilesChanged => 'Nenhum arquivo alterado';

  @override
  String get viewDiff => 'Ver Diff';

  @override
  String get unifiedView => 'Visão unificada';

  @override
  String get splitView => 'Visão dividida';

  @override
  String get compareVersions => 'Comparar Versões';

  @override
  String get baseRef => 'Base (mais antiga)';

  @override
  String get headRef => 'Cabeça (mais nova)';

  @override
  String get compare => 'Comparar';

  @override
  String get actions => 'Actions';

  @override
  String get noActions => 'Nenhuma execução de workflow';

  @override
  String get run => 'Executar';

  @override
  String get status => 'Status';

  @override
  String get jobs => 'Trabalhos';

  @override
  String get noJobs => 'Nenhum trabalho';

  @override
  String get artifacts => 'Artefatos';

  @override
  String get branch => 'Ramo';

  @override
  String get author => 'Autor';

  @override
  String get filterByActor => 'Filtrar por ator';

  @override
  String get filterByStatus => 'Filtrar por status';

  @override
  String get reviewChanges => 'Revisar Alterações';

  @override
  String get reviewBody => 'Comentário de revisão';

  @override
  String get reviews => 'Revisões';

  @override
  String get approve => 'Aprovar';

  @override
  String get requestChanges => 'Solicitar Alterações';

  @override
  String get comment => 'Comentário';

  @override
  String get blame => 'Blame';

  @override
  String get diffView => 'Visão Diff';

  @override
  String get pickColor => 'Escolher Cor';

  @override
  String get sshKeys => 'Chaves SSH';

  @override
  String get allRepos => 'Todos os Repos';

  @override
  String get configuration => 'Configuração';

  @override
  String get none => 'Nenhum';

  @override
  String get more => 'Mais';

  @override
  String get units => 'Unidades';

  @override
  String get permission => 'Permissão';

  @override
  String get repoList => 'Repositórios';

  @override
  String get noChanges => 'Sem alterações';

  @override
  String get limited => 'Limitado';

  @override
  String get unknownSection => 'Seção desconhecida';

  @override
  String get deleteKey => 'Excluir Chave';

  @override
  String get deleteKeyConfirm =>
      'Tem certeza de que deseja excluir esta chave SSH?';

  @override
  String get keyDeleted => 'Chave excluída com sucesso';

  @override
  String get addSshKey => 'Adicionar Chave SSH';

  @override
  String get add => 'Adicionar';

  @override
  String get keyAdded => 'Chave adicionada com sucesso';

  @override
  String get deleteCommentConfirm =>
      'Tem certeza de que deseja excluir este comentário?';

  @override
  String get requestReviewers => 'Solicitar Revisores';

  @override
  String get addReviewerHint => 'Digite o nome do revisor';

  @override
  String get subscribe => 'Inscrever-se';

  @override
  String get unsubscribe => 'Cancelar inscrição';

  @override
  String get subscribed => 'Inscrito';

  @override
  String get unsubscribed => 'Desinscrito';

  @override
  String get setDueDate => 'Definir Data de Vencimento';

  @override
  String get removeDueDate => 'Remover Data de Vencimento';

  @override
  String get topics => 'Tópicos';

  @override
  String get noTopics => 'Sem tópicos';

  @override
  String get branchProtection => 'Proteção de Ramo';

  @override
  String get protectBranch => 'Proteger Ramo';

  @override
  String get https => 'HTTPS';

  @override
  String get ssh => 'SSH';

  @override
  String get teamAdminAccess => 'Acesso de Admin da Equipe';

  @override
  String get details => 'Detalhes';

  @override
  String get id => 'ID';

  @override
  String get searchRepositoriesHint => 'Pesquisar repositórios';

  @override
  String get publicKey => 'Chave Pública';

  @override
  String get failedToGetAccessToken => 'Falha ao obter token de acesso';

  @override
  String get fileNotFound => 'Arquivo não encontrado';

  @override
  String get noSshKeysFound => 'Nenhuma chave SSH encontrada';

  @override
  String get other => 'Outro';

  @override
  String get usernameRequired => 'Nome de usuário é obrigatório';

  @override
  String get myLaptopHint => 'Meu Notebook';

  @override
  String get sshPublicKeyHint => 'Cole sua chave pública SSH aqui';

  @override
  String get noChangesFoundForFile =>
      'Nenhuma alteração encontrada para este arquivo';

  @override
  String commitUpdateFile(Object fileName) {
    return 'Atualizar $fileName';
  }

  @override
  String get api => 'API';

  @override
  String get ui => 'UI';

  @override
  String get justNow => 'agora mesmo';

  @override
  String get packages => 'Pacotes';

  @override
  String get noPackages => 'Nenhum pacote encontrado';

  @override
  String get packageType => 'Tipo';

  @override
  String get packageVersion => 'Versão';

  @override
  String get packageFiles => 'Arquivos';

  @override
  String get packageSize => 'Tamanho';

  @override
  String get packageCreator => 'Criador';

  @override
  String get packageCreated => 'Criado';

  @override
  String get packageRepository => 'Repositório';

  @override
  String get deletePackage => 'Excluir Pacote';

  @override
  String get deletePackageConfirm =>
      'Tem certeza de que deseja excluir esta versão do pacote? Esta ação não pode ser desfeita.';

  @override
  String get packageDeleted => 'Versão do pacote excluída com sucesso';

  @override
  String get allTypes => 'Todos';

  @override
  String get installation => 'Instalação';

  @override
  String get packageUrl => 'URL do pacote';

  @override
  String get copy => 'Copiar';

  @override
  String get totalSize => 'Tamanho total';

  @override
  String get versions => 'Versões';

  @override
  String get noVersions => 'Sem versões';

  @override
  String get createRelease => 'Criar Release';

  @override
  String get editRelease => 'Editar Release';

  @override
  String get deleteRelease => 'Excluir Release';

  @override
  String get deleteReleaseConfirm =>
      'Tem certeza de que deseja excluir este release? Esta ação não pode ser desfeita.';

  @override
  String get releaseTagName => 'Nome da tag';

  @override
  String get releaseTagNameRequired => 'Nome da tag é obrigatório';

  @override
  String get releaseTitle => 'Título do release';

  @override
  String get releaseBody => 'Notas do release';

  @override
  String get targetCommitish => 'Alvo';

  @override
  String get tagMessage => 'Mensagem da tag';

  @override
  String get releaseCreated => 'Release criado com sucesso';

  @override
  String get releaseUpdated => 'Release atualizado com sucesso';

  @override
  String get releaseDeleted => 'Release excluído com sucesso';

  @override
  String get chooseTag => 'Escolher tag';

  @override
  String get defaultLabels => 'Seleção rápida';

  @override
  String get applyLabelSet => 'Aplicar conjunto de etiquetas';

  @override
  String get applyLabelSetDescription =>
      'Selecione um conjunto predefinido para criar todas as etiquetas de uma vez.';

  @override
  String applyAllLabels(Object count) {
    return 'Aplicar todas ($count etiquetas)';
  }

  @override
  String applyAllLabelsParams(Object count) {
    return 'Aplicar todas ($count etiquetas)';
  }

  @override
  String get creating => 'Criando...';

  @override
  String get addCustomLabel => 'Adicionar etiqueta personalizada';

  @override
  String get selectTemplate => 'Selecionar um modelo';

  @override
  String get createTeam => 'Criar equipe';

  @override
  String get editTeam => 'Editar equipe';

  @override
  String get deleteTeam => 'Excluir equipe';

  @override
  String get deleteTeamConfirm => 'Excluir esta equipe?';

  @override
  String get teamName => 'Nome';

  @override
  String get teamNameRequired => 'Nome obrigatório';

  @override
  String get teamDescription => 'Descrição';

  @override
  String get teamPermission => 'Permissão';

  @override
  String get searchMembers => 'Buscar usuários';

  @override
  String get addMember => 'Adicionar';

  @override
  String get removeMember => 'Remover';

  @override
  String removeMemberConfirmParams(Object username) {
    return 'Remover $username?';
  }

  @override
  String get teamCreated => 'Equipe criada';

  @override
  String get teamUpdated => 'Equipe atualizada';

  @override
  String get teamDeleted => 'Equipe excluída';

  @override
  String get memberAdded => 'Membro adicionado';

  @override
  String get memberRemoved => 'Membro removido';

  @override
  String get noSearchResults => 'Nenhum resultado';

  @override
  String get teamCanCreateOrgRepos => 'Pode criar repositórios de org';

  @override
  String get teamIncludesAllRepos => 'Inclui todos os repositórios';

  @override
  String get collaborators => 'Colaboradores';

  @override
  String get noCollaborators => 'Nenhum';

  @override
  String get addCollaborator => 'Adicionar';

  @override
  String get removeCollaborator => 'Remover';

  @override
  String removeCollaboratorConfirmParams(Object username) {
    return 'Remover $username?';
  }

  @override
  String get collaboratorAdded => 'Adicionado';

  @override
  String get collaboratorRemoved => 'Removido';

  @override
  String get contentType => 'Tipo de conteúdo';

  @override
  String get active => 'Ativo';

  @override
  String get emails => 'Emails';

  @override
  String get addEmail => 'Adicionar email';

  @override
  String get gpgKeys => 'Chaves GPG';

  @override
  String get addGpgKey => 'Adicionar chave GPG';

  @override
  String get gpgKeyHint => '-----BEGIN PGP PUBLIC KEY BLOCK-----';

  @override
  String get gpgKeyAdded => 'Chave GPG adicionada';

  @override
  String get gpgKeyDeleted => 'Chave GPG excluída';

  @override
  String get deleteGpgKey => 'Excluir chave GPG';

  @override
  String get deleteGpgKeyConfirm =>
      'Tem certeza de que deseja excluir esta chave GPG?';

  @override
  String get noGpgKeys => 'Nenhuma chave GPG';

  @override
  String get sign => 'Assinar';

  @override
  String get certify => 'Certificar';

  @override
  String get verified => 'Verificado';

  @override
  String get tagProtections => 'Proteção de tags';

  @override
  String get manageTagProtections => 'Gerenciar regras de proteção de tags';

  @override
  String get createTagProtection => 'Criar proteção de tag';

  @override
  String get namePattern => 'Padrão de nome';

  @override
  String get tagProtectionCreated => 'Proteção de tag criada';

  @override
  String get tagProtectionDeleted => 'Proteção de tag excluída';

  @override
  String get deleteTagProtection => 'Excluir proteção de tag';

  @override
  String get deleteTagProtectionConfirm =>
      'Tem certeza de que deseja excluir esta proteção de tag?';

  @override
  String get noTagProtections => 'Nenhuma proteção de tag';

  @override
  String get allowedUsers => 'Usuários permitidos';

  @override
  String get dependencies => 'Dependências';

  @override
  String get addDependency => 'Adicionar dependência';

  @override
  String get dependencyAdded => 'Dependência adicionada';

  @override
  String get dependencyRemoved => 'Dependência removida';

  @override
  String get removeDependency => 'Remover dependência';

  @override
  String get removeDependencyConfirm => 'Remover esta dependência?';

  @override
  String get noDependencies => 'Nenhuma dependência';

  @override
  String get blocks => 'Bloqueia';

  @override
  String get dependsOn => 'Depende de';

  @override
  String get issueNumberHint => 'Issue #';

  @override
  String get events => 'eventos';

  @override
  String get items => 'itens';

  @override
  String get commented => 'comentou';

  @override
  String get labelUpdated => 'Label atualizado';

  @override
  String get milestoneUpdated => 'Marco atualizado';

  @override
  String get assigneeUpdated => 'Responsável atualizado';

  @override
  String get reopened => 'Reaberto';

  @override
  String get stargazers => 'Stargazers';

  @override
  String get subscribers => 'Inscritos';

  @override
  String get noStargazers => 'Nenhum stargazer ainda';

  @override
  String get noSubscribers => 'Nenhum inscrito ainda';

  @override
  String get adminHooksTitle => 'Hooks do sistema';

  @override
  String get adminCronTitle => 'Tarefas Cron';

  @override
  String get adminRunnersTitle => 'Runners de Actions';

  @override
  String get adminEmailsTitle => 'E-mails';

  @override
  String get adminBadgesTitle => 'Distintivos';

  @override
  String get adminRunCron => 'Executar agora';

  @override
  String get adminGetToken => 'Obter token de registro';

  @override
  String get adminNoHooks => 'Nenhum hook do sistema configurado';

  @override
  String get adminNoCron => 'Nenhuma tarefa cron';

  @override
  String get adminNoRunners => 'Nenhum runner de actions';

  @override
  String get adminNoEmails => 'Nenhum e-mail';

  @override
  String get adminNoBadges => 'Nenhum distintivo';

  @override
  String get adminBadgeUsername => 'Nome de usuário';

  @override
  String get adminBadgeDescription => 'Descrição';

  @override
  String get oauthAppsTitle => 'Aplicativos OAuth';

  @override
  String get oauthNoApps => 'Nenhum aplicativo OAuth';

  @override
  String get oauthCreateApp => 'Criar app OAuth';

  @override
  String get oauthRedirectUri => 'URI de redirecionamento';

  @override
  String get oauthDeleteAppConfirm => 'Excluir aplicativo OAuth';

  @override
  String get name => 'Nome';

  @override
  String get confirmDelete => 'Confirmar exclusão';

  @override
  String get actionsSecretsTitle => 'Secrets do Actions';

  @override
  String get actionsVariablesTitle => 'Variáveis do Actions';

  @override
  String get actionsNoSecrets => 'Nenhum secret configurado';

  @override
  String get actionsNoVariables => 'Nenhuma variável configurada';

  @override
  String get actionsCreateSecret => 'Criar Secret';

  @override
  String get actionsCreateVariable => 'Criar Variable';

  @override
  String get actionsSecretName => 'Nome do Secret';

  @override
  String get actionsSecretValue => 'Valor do Secret';

  @override
  String get actionsVariableName => 'Nome da Variable';

  @override
  String get actionsVariableValue => 'Valor da Variable';

  @override
  String get actionsDeleteSecretConfirm => 'Excluir este secret?';

  @override
  String get actionsDeleteVariableConfirm => 'Excluir esta variável?';

  @override
  String get deleted => 'Excluído';

  @override
  String get overdue => 'Vencido';

  @override
  String get addTopic => 'Adicionar tópico';

  @override
  String get importRepository => 'Importar repositório';

  @override
  String get import => 'Importar';

  @override
  String get repoImported => 'Repositório importado';

  @override
  String get cloneUrl => 'URL de clonagem';

  @override
  String get repoOwner => 'Proprietário';

  @override
  String get gitService => 'Serviço Git';

  @override
  String get authentication => 'Autenticação';

  @override
  String get authUsername => 'Usuário de autenticação';

  @override
  String get authPassword => 'Senha de autenticação';

  @override
  String get authToken => 'Token de autenticação';

  @override
  String get migrationOptions => 'Opções';

  @override
  String get migrateData => 'Dados a importar';

  @override
  String get mirror => 'Espelho';

  @override
  String get mirrorInterval => 'Intervalo do espelho';

  @override
  String get requiredField => 'Este campo é obrigatório';

  @override
  String get personal => 'Pessoal';

  @override
  String get deleteOrganization => 'Excluir organização';

  @override
  String get deleteOrganizationConfirm =>
      'Tem certeza de que deseja excluir esta organização? Esta ação não pode ser desfeita.';

  @override
  String get organizationDeleted => 'Organização excluída';

  @override
  String get accessTokens => 'Tokens de acesso';

  @override
  String get createToken => 'Criar Token';

  @override
  String get tokenName => 'Nome do Token';

  @override
  String get tokenCreated => 'Token criado';

  @override
  String get tokenValueWarning =>
      'Copie este token agora. Você não poderá vê-lo novamente.';

  @override
  String get failedToCreateToken => 'Falha ao criar token';

  @override
  String get deleteToken => 'Excluir Token';

  @override
  String get deleteTokenConfirm => 'Tem certeza de que deseja excluir';

  @override
  String get tokenDeleted => 'Token excluído';

  @override
  String get noTokens => 'Nenhum token de acesso';

  @override
  String get scopes => 'Escopos';

  @override
  String get selectAll => 'Selecionar todos';

  @override
  String get deselectAll => 'Desmarcar todos';

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
  String get browseRepositories => 'Navegar pelos repositórios';

  @override
  String get viewIssues => 'Ver e gerenciar issues';

  @override
  String get recentActivitySubtitle => 'Ver atividade recente';

  @override
  String get yourStarredRepos => 'Seus repositórios favoritos';

  @override
  String get yourOrganizations => 'Suas organizações';

  @override
  String get loadMoreActivity => 'Carregar mais atividades';
}
