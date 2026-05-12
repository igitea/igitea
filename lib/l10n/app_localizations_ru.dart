// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'iGitea';

  @override
  String get language => 'Язык';

  @override
  String get settings => 'Настройки';

  @override
  String get profile => 'Профиль';

  @override
  String get search => 'Поиск';

  @override
  String get notifications => 'Уведомления';

  @override
  String get dashboard => 'Панель управления';

  @override
  String get signOut => 'Выйти';

  @override
  String get signIn => 'Войти';

  @override
  String get username => 'Имя пользователя';

  @override
  String get password => 'Пароль';

  @override
  String get login => 'Войти';

  @override
  String get loginWithToken => 'Войти по токену';

  @override
  String get token => 'Токен';

  @override
  String get cancel => 'Отмена';

  @override
  String get confirm => 'Подтвердить';

  @override
  String get save => 'Сохранить';

  @override
  String get delete => 'Удалить';

  @override
  String get edit => 'Редактировать';

  @override
  String get create => 'Создать';

  @override
  String get close => 'Закрыть';

  @override
  String get reopen => 'Открыть повторно';

  @override
  String get merge => 'Слить';

  @override
  String get submit => 'Отправить';

  @override
  String get retry => 'Повторить';

  @override
  String get loading => 'Загрузка...';

  @override
  String get error => 'Ошибка';

  @override
  String get noData => 'Нет данных';

  @override
  String get searchRepos => 'Поиск репозиториев';

  @override
  String get searchIssues => 'Поиск задач';

  @override
  String get users => 'Пользователи';

  @override
  String get enterSearchQueryUsers =>
      'Введите поисковый запрос для поиска пользователей';

  @override
  String get noResults => 'Результаты не найдены';

  @override
  String get repositories => 'Репозитории';

  @override
  String get repositorySections => 'Разделы репозитория';

  @override
  String get issues => 'Задачи';

  @override
  String get pullRequests => 'Pull-запросы';

  @override
  String get releases => 'Релизы';

  @override
  String get branches => 'Ветки';

  @override
  String get code => 'Код';

  @override
  String get stars => 'Звёзды';

  @override
  String get forks => 'Форки';

  @override
  String get watchers => 'Наблюдатели';

  @override
  String get open => 'Открыто';

  @override
  String get closed => 'Закрыто';

  @override
  String get all => 'Все';

  @override
  String get mergePullRequest => 'Слить pull-запрос';

  @override
  String get mergeConfirmMessage =>
      'Вы уверены, что хотите слить этот pull-запрос?';

  @override
  String issueNumber(Object issueNumber) {
    return 'Задача #$issueNumber';
  }

  @override
  String pullRequestNumber(Object pullRequestNumber) {
    return 'PR #$pullRequestNumber';
  }

  @override
  String get comments => 'Комментарии';

  @override
  String get addComment => 'Добавить комментарий...';

  @override
  String get sendComment => 'Отправить';

  @override
  String get noComments => 'Пока нет комментариев';

  @override
  String get labels => 'Метки';

  @override
  String get milestones => 'Вехи';

  @override
  String get assignees => 'Исполнители';

  @override
  String get assignee => 'Назначенный';

  @override
  String get participants => 'Участники';

  @override
  String get timeline => 'Хронология';

  @override
  String get theme => 'Тема';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String get themeSystem => 'Системная';

  @override
  String get account => 'Аккаунт';

  @override
  String get accountInfo => 'Информация об аккаунте';

  @override
  String get email => 'Эл. почта';

  @override
  String get website => 'Веб-сайт';

  @override
  String get bio => 'О себе';

  @override
  String joinedOn(Object date) {
    return 'Присоединился $date';
  }

  @override
  String joinedOnParams(Object date) {
    return 'Присоединился $date';
  }

  @override
  String followerCount(Object count) {
    return '$count подписчиков';
  }

  @override
  String followerCountParams(Object count) {
    return '$count подписчиков';
  }

  @override
  String followingCount(Object count) {
    return '$count подписок';
  }

  @override
  String followingCountParams(Object count) {
    return '$count подписок';
  }

  @override
  String repositoryCount(Object count) {
    return '$count репозиториев';
  }

  @override
  String repositoryCountParams(Object count) {
    return '$count репозиториев';
  }

  @override
  String get starredRepos => 'Репозитории со звёздами';

  @override
  String get organisations => 'Организации';

  @override
  String get adminPanel => 'Панель администратора';

  @override
  String get userManagement => 'Управление пользователями';

  @override
  String get serverSettings => 'Настройки сервера';

  @override
  String get cronTasks => 'Cron-задачи';

  @override
  String get apiSettings => 'Настройки API';

  @override
  String get uiSettings => 'Настройки интерфейса';

  @override
  String get attachmentSettings => 'Настройки вложений';

  @override
  String get repoSettings => 'Настройки репозитория';

  @override
  String get runNow => 'Выполнить сейчас';

  @override
  String lastRun(Object time) {
    return 'Последний запуск: $time';
  }

  @override
  String lastRunParams(Object time) {
    return 'Последний запуск: $time';
  }

  @override
  String nextRun(Object time) {
    return 'Следующий запуск: $time';
  }

  @override
  String nextRunParams(Object time) {
    return 'Следующий запуск: $time';
  }

  @override
  String get recentActivity => 'Недавняя активность';

  @override
  String get myIssues => 'Мои задачи';

  @override
  String get myRepos => 'Мои репозитории';

  @override
  String get myStars => 'Мои звёзды';

  @override
  String get feed => 'Лента';

  @override
  String get markAllRead => 'Отметить всё как прочитанное';

  @override
  String get markRead => 'Отметить как прочитанное';

  @override
  String unreadNotifications(Object count) {
    return 'Непрочитанных уведомлений: $count';
  }

  @override
  String unreadNotificationsParams(Object count) {
    return 'Непрочитанные уведомления: $count';
  }

  @override
  String get noUnreadNotifications => 'Нет непрочитанных уведомлений';

  @override
  String get readMore => 'Читать далее';

  @override
  String ago(Object time) {
    return '$time назад';
  }

  @override
  String agoParams(Object time) {
    return '$time назад';
  }

  @override
  String get fileBrowser => 'Проводник файлов';

  @override
  String get readme => 'README';

  @override
  String get commits => 'Коммиты';

  @override
  String get commitHistory => 'История коммитов';

  @override
  String get viewFile => 'Просмотреть файл';

  @override
  String get downloadFile => 'Скачать файл';

  @override
  String get copyPath => 'Копировать путь';

  @override
  String get fileName => 'Имя файла';

  @override
  String get fileSize => 'Размер файла';

  @override
  String get lastModified => 'Последнее изменение';

  @override
  String get openInBrowser => 'Открыть в браузере';

  @override
  String get signInRequired => 'Требуется вход';

  @override
  String get signInMessage => 'Пожалуйста, войдите, чтобы продолжить';

  @override
  String get loginFailed => 'Ошибка входа';

  @override
  String get networkError => 'Ошибка сети';

  @override
  String get unknownError => 'Произошла неизвестная ошибка';

  @override
  String get refresh => 'Обновить';

  @override
  String get copyToClipboard => 'Копировать в буфер обмена';

  @override
  String get copied => 'Скопировано!';

  @override
  String get filterIssues => 'Фильтровать задачи';

  @override
  String get newIssue => 'Новая задача';

  @override
  String get newPullRequest => 'Новый pull-запрос';

  @override
  String get title => 'Заголовок';

  @override
  String get description => 'Описание';

  @override
  String get body => 'Содержание';

  @override
  String get state => 'Статус';

  @override
  String get priority => 'Приоритет';

  @override
  String get milestone => 'Веха';

  @override
  String get createdAt => 'Создано';

  @override
  String get updatedAt => 'Обновлено';

  @override
  String get dueDate => 'Срок';

  @override
  String get noMilestones => 'Нет вех';

  @override
  String get noLabels => 'Нет меток';

  @override
  String get openIssue => 'Открыть задачу';

  @override
  String get closeIssue => 'Закрыть задачу';

  @override
  String get reopenIssue => 'Открыть задачу повторно';

  @override
  String get deleteComment => 'Удалить комментарий';

  @override
  String get editComment => 'Редактировать комментарий';

  @override
  String get deleteRepo => 'Удалить репозиторий';

  @override
  String get deleteRepoConfirm =>
      'Вы уверены, что хотите удалить этот репозиторий? Это действие нельзя отменить.';

  @override
  String get generalSettings => 'Общие настройки';

  @override
  String get appearance => 'Внешний вид';

  @override
  String get languageSelector => 'Язык';

  @override
  String get selectLanguage => 'Выбрать язык';

  @override
  String get systemDefault => 'По умолчанию системы';

  @override
  String get followSystem => 'Использовать системный';

  @override
  String get unsavedChanges => 'Несохранённые изменения';

  @override
  String get unsavedChangesMessage =>
      'У вас есть несохранённые изменения. Вы уверены, что хотите уйти?';

  @override
  String get leave => 'Уйти';

  @override
  String get stay => 'Остаться';

  @override
  String get restoringSession => 'Восстановление сеанса...';

  @override
  String get pleaseEnterServerUrl => 'Пожалуйста, введите URL сервера';

  @override
  String get pleaseEnterValidUrl => 'Пожалуйста, введите действительный URL';

  @override
  String get connectToGitea => 'Подключитесь к вашему экземпляру Gitea';

  @override
  String get usernamePassword => 'Имя пользователя и пароль';

  @override
  String get serverUrl => 'URL сервера';

  @override
  String get enterUsername => 'Введите имя пользователя';

  @override
  String get pleaseEnterUsername => 'Пожалуйста, введите имя пользователя';

  @override
  String get enterPassword => 'Введите пароль';

  @override
  String get pleaseEnterPassword => 'Пожалуйста, введите пароль';

  @override
  String get pasteAccessToken => 'Вставьте ваш личный токен доступа';

  @override
  String get pleaseEnterAccessToken => 'Пожалуйста, введите токен доступа';

  @override
  String get signInWithToken => 'Войти по токену';

  @override
  String get welcomeToIgitea => 'Добро пожаловать в iGitea';

  @override
  String get signInToGetStarted => 'Войдите, чтобы начать';

  @override
  String get quickActions => 'Быстрые действия';

  @override
  String get yourRepositories => 'Ваши репозитории';

  @override
  String get noRepositoriesFound => 'Репозитории не найдены';

  @override
  String helloParams(Object full_name) {
    return 'Здравствуйте, $full_name!';
  }

  @override
  String get user => 'Пользователь';

  @override
  String get private => 'Приватный';

  @override
  String get untitled => 'Без названия';

  @override
  String get enterSearchQueryRepos =>
      'Введите поисковый запрос для поиска репозиториев';

  @override
  String get enterSearchQueryIssues =>
      'Введите поисковый запрос для поиска задач';

  @override
  String get noIssuesFound => 'Задачи не найдены.';

  @override
  String get failedToLoadProfile => 'Не удалось загрузить профиль';

  @override
  String get unknownUser => 'Неизвестный пользователь';

  @override
  String get admin => 'Admin';

  @override
  String get repos => 'Репозитории';

  @override
  String get followers => 'Подписчики';

  @override
  String get following => 'Подписки';

  @override
  String get follow => 'Подписаться';

  @override
  String get unfollow => 'Отписаться';

  @override
  String get signOutConfirmMessage => 'Вы уверены, что хотите выйти?';

  @override
  String get chooseTheme => 'Выбрать тему';

  @override
  String get loadingSettings => 'Загрузка настроек...';

  @override
  String get userManagementComingSoon =>
      'Управление пользователями скоро появится';

  @override
  String get maxResponseItems => 'Макс. элементов ответа';

  @override
  String get defaultPagingNum => 'Кол-во страниц по умолч.';

  @override
  String get defaultMaxBlobSize => 'Макс. размер Blob по умолч.';

  @override
  String get defaultTheme => 'Тема по умолчанию';

  @override
  String get allowedReactions => 'Разрешённые реакции';

  @override
  String get attachments => 'Вложения';

  @override
  String get enabled => 'Включено';

  @override
  String get maxFiles => 'Макс. файлов';

  @override
  String get maxSize => 'Макс. размер';

  @override
  String get allowedTypes => 'Разрешённые типы';

  @override
  String get bytes => 'байт';

  @override
  String get repository => 'Репозиторий';

  @override
  String get httpGitDisabled => 'HTTP Git отключён';

  @override
  String get lfsDisabled => 'LFS отключён';

  @override
  String get migrationsDisabled => 'Миграции отключены';

  @override
  String get mirrorsDisabled => 'Зеркала отключены';

  @override
  String get starsDisabled => 'Звёзды отключены';

  @override
  String get timeTrackingDisabled => 'Отслеживание времени отключено';

  @override
  String get yes => 'Да';

  @override
  String get no => 'Нет';

  @override
  String get schedule => 'Расписание';

  @override
  String get next => 'Далее';

  @override
  String get executions => 'Выполнения';

  @override
  String get failedToLoadCronTasks => 'Не удалось загрузить задачи cron';

  @override
  String get noCronTasksFound => 'Задачи cron не найдены';

  @override
  String cronTriggeredParams(Object name) {
    return 'Cron \"$name\" запущен';
  }

  @override
  String get unknown => 'Неизвестно';

  @override
  String openedParams(Object time) {
    return 'открыто $time';
  }

  @override
  String get noDescriptionProvided => 'Описание не предоставлено.';

  @override
  String get failedToLoadComments => 'Не удалось загрузить комментарии';

  @override
  String get writeComment => 'Напишите комментарий...';

  @override
  String commentsCountParams(Object count) {
    return '$count комментариев';
  }

  @override
  String updatedParams(Object time) {
    return 'Обновлено $time';
  }

  @override
  String commentsParams(Object count) {
    return 'Комментарии ($count)';
  }

  @override
  String get files => 'файлы';

  @override
  String get mergeable => 'Сливаемо';

  @override
  String get merged => 'Слито';

  @override
  String get draft => 'Черновик';

  @override
  String get failedToLoadRepo => 'Не удалось загрузить репозиторий';

  @override
  String get copyUrl => 'Копировать URL';

  @override
  String get urlCopied => 'URL скопирован';

  @override
  String get emptyDirectory => 'Пустая директория';

  @override
  String get noIssues => 'Нет задач';

  @override
  String get noPullRequests => 'Нет pull-запросов';

  @override
  String get noReleases => 'Нет релизов';

  @override
  String get noBranches => 'Нет веток';

  @override
  String get preRelease => 'Пре-релиз';

  @override
  String get archived => 'В архиве';

  @override
  String get defaultBranch => 'Ветка по умолчанию';

  @override
  String get copyCode => 'Копировать код';

  @override
  String get failedToLoadFile => 'Не удалось загрузить файл';

  @override
  String get filePreviewNotAvailable => 'Предпросмотр недоступен';

  @override
  String get download => 'Скачать';

  @override
  String get failedToOpenDownloadUrl => 'Не удалось открыть URL загрузки';

  @override
  String get noNotifications => 'Нет уведомлений';

  @override
  String get noTitle => 'Без заголовка';

  @override
  String get allNotificationsMarkedAsRead =>
      'Все уведомления отмечены как прочитанные';

  @override
  String get createUser => 'Создать пользователя';

  @override
  String get editUser => 'Редактировать пользователя';

  @override
  String get deleteIssue => 'Удалить Issue';

  @override
  String get deleteIssueConfirm =>
      'Вы уверены, что хотите удалить этот Issue? Это действие нельзя отменить.';

  @override
  String get issueDeleted => 'Issue удалён';

  @override
  String get deleteUser => 'Удалить пользователя';

  @override
  String deleteUserConfirmParams(Object username) {
    return 'Вы уверены, что хотите удалить пользователя \"$username\"? Это действие нельзя отменить.';
  }

  @override
  String get userCreated => 'Пользователь успешно создан';

  @override
  String get userUpdated => 'Пользователь успешно обновлён';

  @override
  String get userDeleted => 'Пользователь успешно удалён';

  @override
  String get noUsersFound => 'Пользователи не найдены';

  @override
  String get pleaseEnterEmail => 'Пожалуйста, введите email';

  @override
  String get fullName => 'Полное имя';

  @override
  String get mustChangePassword => 'Должен сменить пароль при первом входе';

  @override
  String get pleaseEnterTitle => 'Пожалуйста, введите заголовок';

  @override
  String get noActivity => 'Нет недавней активности';

  @override
  String get createdRepo => 'создал репозиторий';

  @override
  String get pushedTag => 'отправил тег';

  @override
  String get deletedTag => 'удалил тег';

  @override
  String get createdIssue => 'создал задачу';

  @override
  String get closedIssue => 'закрыл задачу';

  @override
  String get reopenedIssue => 'открыл задачу повторно';

  @override
  String get createdPR => 'создал pull-запрос';

  @override
  String get mergedPR => 'слил pull-запрос';

  @override
  String get closedPR => 'закрыл pull-запрос';

  @override
  String get commentedOnIssue => 'прокомментировал задачу';

  @override
  String get commentedOnPR => 'прокомментировал pull-запрос';

  @override
  String get forkedRepo => 'форкнул репозиторий';

  @override
  String get transferredRepo => 'передал репозиторий';

  @override
  String get deletedRepo => 'удалил репозиторий';

  @override
  String get updatedWiki => 'обновил wiki';

  @override
  String get performedAction => 'выполнил действие';

  @override
  String get commitRepo => 'закоммитил в';

  @override
  String get renameRepo => 'переименовал репозиторий';

  @override
  String get starRepo => 'отметил репозиторий звездой';

  @override
  String get watchRepo => 'начал следить за репозиторием';

  @override
  String get reopenPR => 'повторно открыл pull-запрос';

  @override
  String get approvePR => 'одобрил pull-запрос';

  @override
  String get rejectPR => 'отклонил pull-запрос';

  @override
  String get publishRelease => 'опубликовал релиз';

  @override
  String get deleteBranch => 'удалил ветку';

  @override
  String get autoMergePR => 'авто-слил pull-запрос';

  @override
  String get pullReviewDismissed => 'отклонил ревью pull-запроса';

  @override
  String get pullRequestReady => 'отметил pull-запрос как готовый к ревью';

  @override
  String get mirrorSyncPush => 'синхронизировал push с зеркалом';

  @override
  String get mirrorSyncCreate => 'синхронизировал создание с зеркалом';

  @override
  String get mirrorSyncDelete => 'синхронизировал удаление с зеркалом';

  @override
  String get inRepo => 'в';

  @override
  String get to => 'в';

  @override
  String get from => 'из';

  @override
  String get headBranch => 'Исходная ветка';

  @override
  String get baseBranch => 'Целевая ветка';

  @override
  String get pleaseFillAllFields => 'Заполните все обязательные поля';

  @override
  String get settingsSaved => 'Настройки сохранены';

  @override
  String get privateRepo => 'Приватный репозиторий';

  @override
  String get privateRepoDesc => 'Виден только вам и сотрудникам';

  @override
  String get enableIssues => 'Включить задачи';

  @override
  String get enablePullRequests => 'Включить pull-запросы';

  @override
  String get enableWiki => 'Включить Wiki';

  @override
  String get preview => 'Предпросмотр';

  @override
  String get commitMessage => 'Сообщение коммита';

  @override
  String get commit => 'Коммит';

  @override
  String get commitMessageHint => 'Опишите изменения (опционально)';

  @override
  String get cannotGetFileSha =>
      'Не удалось получить SHA файла. Перезагрузите файл.';

  @override
  String get failedToSaveFile => 'Не удалось сохранить файл';

  @override
  String get fileSaved => 'Файл сохранён';

  @override
  String get discard => 'Отменить';

  @override
  String get message => 'Сообщение';

  @override
  String get ok => 'OK';

  @override
  String get sha => 'SHA';

  @override
  String get changedFiles => 'Изменённые файлы';

  @override
  String get tags => 'Теги';

  @override
  String get noCommits => 'Нет коммитов';

  @override
  String get noTags => 'Нет тегов';

  @override
  String get protected => 'Защищено';

  @override
  String get latestCommit => 'Последний коммит';

  @override
  String get permissions => 'Разрешения';

  @override
  String get canPush => 'Может пушить';

  @override
  String get canMerge => 'Может сливать';

  @override
  String get downloads => 'Загрузки';

  @override
  String get tarball => 'Tarball';

  @override
  String get zipball => 'Zipball';

  @override
  String get downloadTarball => 'Скачать Tarball';

  @override
  String get downloadZipball => 'Скачать Zipball';

  @override
  String get url => 'URL';

  @override
  String get info => 'Информация';

  @override
  String get teams => 'Команды';

  @override
  String get noTeams => 'Нет команд';

  @override
  String get location => 'Местоположение';

  @override
  String get visibility => 'Видимость';

  @override
  String get assets => 'Ресурсы';

  @override
  String get publishedAt => 'Опубликовано';

  @override
  String get target => 'Цель';

  @override
  String get forked => 'Форкнут';

  @override
  String get forkRepoConfirm =>
      'Это создаст форк этого репозитория в вашем аккаунте.';

  @override
  String get editIssue => 'Редактировать задачу';

  @override
  String get titleRequired => 'Заголовок обязателен';

  @override
  String get selectMilestone => 'Выбрать веху';

  @override
  String get members => 'Участники';

  @override
  String get noMembers => 'Нет участников';

  @override
  String get editOrganization => 'Редактировать организацию';

  @override
  String get createOrganization => 'Создать организацию';

  @override
  String get createRepository => 'Создать репозиторий';

  @override
  String get repositoryName => 'Имя репозитория';

  @override
  String get repositoryNameHint => 'my-awesome-repo';

  @override
  String get repositoryNameRequired => 'Имя репозитория обязательно';

  @override
  String get descriptionHint => 'Краткое описание вашего репозитория';

  @override
  String get public => 'Публичный';

  @override
  String get publicDescription =>
      'Любой в интернете может видеть этот репозиторий';

  @override
  String get privateDescription =>
      'Вы выбираете, кто может видеть и коммитить в этот репозиторий';

  @override
  String get initializeWithReadme => 'Инициализировать с README';

  @override
  String get initializeWithReadmeDescription =>
      'Добавить файл README, чтобы помочь другим понять ваш проект';

  @override
  String repoCreated(Object repoName) {
    return 'Репозиторий \'$repoName\' успешно создан';
  }

  @override
  String get complete => 'завершено';

  @override
  String get wiki => 'Wiki';

  @override
  String get newWikiPage => 'Новая страница Wiki';

  @override
  String get editWikiPage => 'Редактировать страницу Wiki';

  @override
  String get deleteWikiPage => 'Удалить страницу Wiki';

  @override
  String get deleteWikiPageConfirm =>
      'Вы уверены, что хотите удалить эту страницу Wiki? Это действие нельзя отменить.';

  @override
  String get wikiPageDeleted => 'Страница Wiki удалена';

  @override
  String get wikiPageTitle => 'Заголовок страницы';

  @override
  String get wikiPageTitleHint => 'e.g. Home';

  @override
  String get wikiPageContent => 'Содержимое';

  @override
  String get wikiPageContentHint => 'Пишите в Markdown...';

  @override
  String get noWikiPages => 'Нет страниц Wiki';

  @override
  String get noWikiPagesDescription =>
      'У этого репозитория ещё нет страниц Wiki.';

  @override
  String get createFirstWikiPage => 'Создать первую страницу';

  @override
  String get lastCommit => 'Последний коммит';

  @override
  String get noContent => 'Нет содержимого';

  @override
  String get saved => 'Сохранено';

  @override
  String get created => 'Создано';

  @override
  String get createMilestone => 'Создать веху';

  @override
  String get editMilestone => 'Редактировать веху';

  @override
  String get deleteMilestone => 'Удалить веху';

  @override
  String get deleteMilestoneConfirm =>
      'Вы уверены, что хотите удалить эту веху? Это действие нельзя отменить.';

  @override
  String get milestoneDeleted => 'Веха удалена';

  @override
  String get milestoneTitle => 'Заголовок';

  @override
  String get milestoneDescription => 'Описание';

  @override
  String get milestoneDescriptionHint => 'Опишите эту веху';

  @override
  String get milestoneDueDate => 'Дата завершения';

  @override
  String get milestoneState => 'Состояние';

  @override
  String get milestoneStateOpen => 'Открыто';

  @override
  String get milestoneStateClosed => 'Закрыто';

  @override
  String get total => 'Всего';

  @override
  String get clear => 'Очистить';

  @override
  String get webhooks => 'Вебхуки';

  @override
  String get webhook => 'Вебхук';

  @override
  String get noWebhooks => 'Нет вебхуков';

  @override
  String get createWebhook => 'Создать вебхук';

  @override
  String get editWebhook => 'Редактировать вебхук';

  @override
  String get deleteWebhook => 'Удалить вебхук';

  @override
  String get deleteWebhookConfirm =>
      'Вы уверены, что хотите удалить этот вебхук? Это действие нельзя отменить.';

  @override
  String get webhookDeleted => 'Вебхук удалён';

  @override
  String get webhookUrl => 'URL';

  @override
  String get webhookUrlHint => 'https://example.com/webhook';

  @override
  String get webhookSecret => 'Секрет';

  @override
  String get webhookSecretHint => 'Опциональный секретный токен';

  @override
  String get webhookContentType => 'Тип содержимого';

  @override
  String get webhookContentTypeJson => 'application/json';

  @override
  String get webhookContentTypeForm => 'application/x-www-form-urlencoded';

  @override
  String get webhookEvents => 'События';

  @override
  String get webhookEventsHint => 'Выберите события для запуска этого вебхука';

  @override
  String get webhookActive => 'Активен';

  @override
  String get webhookInactive => 'Неактивен';

  @override
  String get webhookType => 'Тип';

  @override
  String get webhookCreatedAt => 'Создан';

  @override
  String get webhookUpdatedAt => 'Обновлён';

  @override
  String get webhookLastDelivery => 'Последняя доставка';

  @override
  String get webhookSelectAllEvents => 'Выбрать все';

  @override
  String get webhookPushEvents => 'Push';

  @override
  String get webhookPullRequestEvents => 'Pull Requests';

  @override
  String get webhookIssuesEvents => 'Задачи';

  @override
  String get webhookCreateEvents => 'Создание';

  @override
  String get webhookDeleteEvents => 'Удаление';

  @override
  String get webhookReleaseEvents => 'Релизы';

  @override
  String get webhookWikiEvents => 'Wiki';

  @override
  String get webhookStarEvents => 'Звезда';

  @override
  String get webhookForkEvents => 'Форк';

  @override
  String get loginWithOAuth2 => 'Войти через OAuth2';

  @override
  String get oauth2 => 'OAuth2';

  @override
  String get oauth2Description =>
      'Авторизоваться через приложение Gitea OAuth2';

  @override
  String get oauth2ClientId => 'ID клиента';

  @override
  String get oauth2ClientSecret => 'Секрет клиента';

  @override
  String get oauth2RedirectUri => 'URI перенаправления';

  @override
  String get oauth2RedirectUriHint => 'igitea://oauth/callback';

  @override
  String get oauth2Authorize => 'Открыть страницу авторизации';

  @override
  String get oauth2ExchangeCode => 'Обменять код на токен';

  @override
  String get oauth2AuthorizationCode => 'Код авторизации';

  @override
  String get oauth2AuthorizationCodeHint =>
      'Вставьте код из URL перенаправления';

  @override
  String get oauth2TokenRefreshed => 'Токен успешно обновлён';

  @override
  String get createLabel => 'Создать метку';

  @override
  String get editLabel => 'Редактировать метку';

  @override
  String get deleteLabel => 'Удалить метку';

  @override
  String get deleteLabelConfirm => 'Вы уверены, что хотите удалить эту метку?';

  @override
  String get labelDeleted => 'Метка удалена';

  @override
  String get labelName => 'Название';

  @override
  String get labelNameHint => 'e.g. bug';

  @override
  String get labelDescription => 'Описание';

  @override
  String get labelDescriptionHint => 'Опциональное описание';

  @override
  String get labelColor => 'Цвет';

  @override
  String get labelColorHint => 'Hex color, e.g. #FF0000';

  @override
  String get filesChanged => 'Изменённые файлы';

  @override
  String get noFilesChanged => 'Файлы не изменены';

  @override
  String get viewDiff => 'Показать diff';

  @override
  String get unifiedView => 'Объединённый вид';

  @override
  String get splitView => 'Разделённый вид';

  @override
  String get compareVersions => 'Сравнить версии';

  @override
  String get baseRef => 'База (старая)';

  @override
  String get headRef => 'Голова (новая)';

  @override
  String get compare => 'Сравнить';

  @override
  String get actions => 'Actions';

  @override
  String get noActions => 'Нет запусков workflow';

  @override
  String get run => 'Запустить';

  @override
  String get status => 'Статус';

  @override
  String get jobs => 'Задачи';

  @override
  String get noJobs => 'Нет задач';

  @override
  String get artifacts => 'Артефакты';

  @override
  String get branch => 'Ветка';

  @override
  String get author => 'Автор';

  @override
  String get filterByActor => 'Фильтр по участнику';

  @override
  String get filterByStatus => 'Фильтр по статусу';

  @override
  String get reviewChanges => 'Просмотреть изменения';

  @override
  String get reviewBody => 'Комментарий ревью';

  @override
  String get reviews => 'Ревью';

  @override
  String get approve => 'Одобрить';

  @override
  String get requestChanges => 'Запросить изменения';

  @override
  String get comment => 'Комментарий';

  @override
  String get blame => 'Blame';

  @override
  String get diffView => 'Просмотр Diff';

  @override
  String get pickColor => 'Выбрать цвет';

  @override
  String get sshKeys => 'SSH ключи';

  @override
  String get allRepos => 'Все репозитории';

  @override
  String get configuration => 'Конфигурация';

  @override
  String get none => 'Нет';

  @override
  String get more => 'Больше';

  @override
  String get units => 'Единицы';

  @override
  String get permission => 'Разрешение';

  @override
  String get repoList => 'Репозитории';

  @override
  String get noChanges => 'Без изменений';

  @override
  String get limited => 'Ограничено';

  @override
  String get unknownSection => 'Неизвестный раздел';

  @override
  String get deleteKey => 'Удалить ключ';

  @override
  String get deleteKeyConfirm =>
      'Вы уверены, что хотите удалить этот SSH-ключ?';

  @override
  String get keyDeleted => 'Ключ успешно удалён';

  @override
  String get addSshKey => 'Добавить SSH-ключ';

  @override
  String get add => 'Добавить';

  @override
  String get keyAdded => 'Ключ успешно добавлен';

  @override
  String get deleteCommentConfirm =>
      'Вы уверены, что хотите удалить этот комментарий?';

  @override
  String get requestReviewers => 'Запросить ревьюеров';

  @override
  String get addReviewerHint => 'Введите имя ревьюера';

  @override
  String get subscribe => 'Подписаться';

  @override
  String get unsubscribe => 'Отписаться';

  @override
  String get subscribed => 'Подписан';

  @override
  String get unsubscribed => 'Отписан';

  @override
  String get setDueDate => 'Установить срок';

  @override
  String get removeDueDate => 'Удалить срок';

  @override
  String get topics => 'Темы';

  @override
  String get noTopics => 'Нет тем';

  @override
  String get branchProtection => 'Защита ветки';

  @override
  String get protectBranch => 'Защитить ветку';

  @override
  String get https => 'HTTPS';

  @override
  String get ssh => 'SSH';

  @override
  String get teamAdminAccess => 'Доступ администратора команды';

  @override
  String get details => 'Детали';

  @override
  String get id => 'ID';

  @override
  String get searchRepositoriesHint => 'Поиск репозиториев';

  @override
  String get publicKey => 'Открытый ключ';

  @override
  String get failedToGetAccessToken => 'Не удалось получить токен доступа';

  @override
  String get fileNotFound => 'Файл не найден';

  @override
  String get noSshKeysFound => 'SSH-ключи не найдены';

  @override
  String get other => 'Другое';

  @override
  String get usernameRequired => 'Имя пользователя обязательно';

  @override
  String get myLaptopHint => 'Мой ноутбук';

  @override
  String get sshPublicKeyHint => 'Вставьте ваш открытый SSH-ключ здесь';

  @override
  String get noChangesFoundForFile => 'Изменений для этого файла не найдено';

  @override
  String commitUpdateFile(Object fileName) {
    return 'Обновить $fileName';
  }

  @override
  String get api => 'API';

  @override
  String get ui => 'UI';

  @override
  String get justNow => 'только что';

  @override
  String get packages => 'Пакеты';

  @override
  String get noPackages => 'Пакеты не найдены';

  @override
  String get packageType => 'Тип';

  @override
  String get packageVersion => 'Версия';

  @override
  String get packageFiles => 'Файлы';

  @override
  String get packageSize => 'Размер';

  @override
  String get packageCreator => 'Создатель';

  @override
  String get packageCreated => 'Создан';

  @override
  String get packageRepository => 'Репозиторий';

  @override
  String get deletePackage => 'Удалить пакет';

  @override
  String get deletePackageConfirm =>
      'Вы уверены, что хотите удалить эту версию пакета? Это действие нельзя отменить.';

  @override
  String get packageDeleted => 'Версия пакета успешно удалена';

  @override
  String get allTypes => 'Все';

  @override
  String get installation => 'Установка';

  @override
  String get packageUrl => 'URL пакета';

  @override
  String get copy => 'Копировать';

  @override
  String get totalSize => 'Общий размер';

  @override
  String get versions => 'Версии';

  @override
  String get noVersions => 'Нет версий';

  @override
  String get createRelease => 'Создать релиз';

  @override
  String get editRelease => 'Редактировать релиз';

  @override
  String get deleteRelease => 'Удалить релиз';

  @override
  String get deleteReleaseConfirm =>
      'Вы уверены, что хотите удалить этот релиз? Это действие нельзя отменить.';

  @override
  String get releaseTagName => 'Имя тега';

  @override
  String get releaseTagNameRequired => 'Имя тега обязательно';

  @override
  String get releaseTitle => 'Название релиза';

  @override
  String get releaseBody => 'Примечания к релизу';

  @override
  String get targetCommitish => 'Цель';

  @override
  String get tagMessage => 'Сообщение тега';

  @override
  String get releaseCreated => 'Релиз успешно создан';

  @override
  String get releaseUpdated => 'Релиз успешно обновлен';

  @override
  String get releaseDeleted => 'Релиз успешно удален';

  @override
  String get chooseTag => 'Выбрать тег';

  @override
  String get defaultLabels => 'Быстрый выбор';

  @override
  String get applyLabelSet => 'Применить набор меток';

  @override
  String get applyLabelSetDescription =>
      'Выберите предопределённый набор меток для создания всех меток сразу.';

  @override
  String applyAllLabels(Object count) {
    return 'Применить все ($count меток)';
  }

  @override
  String applyAllLabelsParams(Object count) {
    return 'Применить все ($count меток)';
  }

  @override
  String get creating => 'Создание...';

  @override
  String get addCustomLabel => 'Добавить пользовательскую метку';

  @override
  String get selectTemplate => 'Выбрать шаблон';

  @override
  String get createTeam => 'Создать команду';

  @override
  String get editTeam => 'Редактировать';

  @override
  String get deleteTeam => 'Удалить';

  @override
  String get deleteTeamConfirm => 'Удалить команду?';

  @override
  String get teamName => 'Название';

  @override
  String get teamNameRequired => 'Название обязательно';

  @override
  String get teamDescription => 'Описание';

  @override
  String get teamPermission => 'Права';

  @override
  String get searchMembers => 'Поиск';

  @override
  String get addMember => 'Добавить';

  @override
  String get removeMember => 'Удалить';

  @override
  String removeMemberConfirmParams(Object username) {
    return 'Удалить $username?';
  }

  @override
  String get teamCreated => 'Команда создана';

  @override
  String get teamUpdated => 'Команда обновлена';

  @override
  String get teamDeleted => 'Команда удалена';

  @override
  String get memberAdded => 'Участник добавлен';

  @override
  String get memberRemoved => 'Участник удален';

  @override
  String get noSearchResults => 'Нет результатов';

  @override
  String get teamCanCreateOrgRepos => 'Может создавать репозитории организации';

  @override
  String get teamIncludesAllRepos => 'Включает все репозитории';

  @override
  String get collaborators => 'Сотрудники';

  @override
  String get noCollaborators => 'Нет';

  @override
  String get addCollaborator => 'Добавить';

  @override
  String get removeCollaborator => 'Удалить';

  @override
  String removeCollaboratorConfirmParams(Object username) {
    return 'Удалить $username?';
  }

  @override
  String get collaboratorAdded => 'Добавлен';

  @override
  String get collaboratorRemoved => 'Удален';

  @override
  String get contentType => 'Тип содержимого';

  @override
  String get active => 'Активен';

  @override
  String get emails => 'Эл. почта';

  @override
  String get addEmail => 'Добавить';

  @override
  String get gpgKeys => 'GPG-ключи';

  @override
  String get addGpgKey => 'Добавить GPG-ключ';

  @override
  String get gpgKeyHint => '-----BEGIN PGP PUBLIC KEY BLOCK-----';

  @override
  String get gpgKeyAdded => 'GPG-ключ добавлен';

  @override
  String get gpgKeyDeleted => 'GPG-ключ удалён';

  @override
  String get deleteGpgKey => 'Удалить GPG-ключ';

  @override
  String get deleteGpgKeyConfirm =>
      'Вы уверены, что хотите удалить этот GPG-ключ?';

  @override
  String get noGpgKeys => 'Нет GPG-ключей';

  @override
  String get sign => 'Подписать';

  @override
  String get certify => 'Заверить';

  @override
  String get verified => 'Подтверждено';

  @override
  String get tagProtections => 'Защита тегов';

  @override
  String get manageTagProtections => 'Управление правилами защиты тегов';

  @override
  String get createTagProtection => 'Создать защиту тега';

  @override
  String get namePattern => 'Шаблон имени';

  @override
  String get tagProtectionCreated => 'Защита тега создана';

  @override
  String get tagProtectionDeleted => 'Защита тега удалена';

  @override
  String get deleteTagProtection => 'Удалить защиту тега';

  @override
  String get deleteTagProtectionConfirm =>
      'Вы уверены, что хотите удалить эту защиту тега?';

  @override
  String get noTagProtections => 'Нет защит тегов';

  @override
  String get allowedUsers => 'Разрешённые пользователи';

  @override
  String get dependencies => 'Зависимости';

  @override
  String get addDependency => 'Добавить зависимость';

  @override
  String get dependencyAdded => 'Зависимость добавлена';

  @override
  String get dependencyRemoved => 'Зависимость удалена';

  @override
  String get removeDependency => 'Удалить зависимость';

  @override
  String get removeDependencyConfirm => 'Удалить эту зависимость?';

  @override
  String get noDependencies => 'Нет зависимостей';

  @override
  String get blocks => 'Блокирует';

  @override
  String get dependsOn => 'Зависит от';

  @override
  String get issueNumberHint => 'Issue №';

  @override
  String get events => 'события';

  @override
  String get items => 'элементы';

  @override
  String get commented => 'прокомментировал';

  @override
  String get labelUpdated => 'Метка обновлена';

  @override
  String get milestoneUpdated => 'Веха обновлена';

  @override
  String get assigneeUpdated => 'Назначенный обновлён';

  @override
  String get reopened => 'Переоткрыт';

  @override
  String get stargazers => 'Звёзды';

  @override
  String get subscribers => 'Подписчики';

  @override
  String get noStargazers => 'Пока нет stargazers';

  @override
  String get noSubscribers => 'Пока нет подписчиков';

  @override
  String get adminHooksTitle => 'Системные хуки';

  @override
  String get adminCronTitle => 'Задачи Cron';

  @override
  String get adminRunnersTitle => 'Раннеры Actions';

  @override
  String get adminEmailsTitle => 'Эл. письма';

  @override
  String get adminBadgesTitle => 'Значки';

  @override
  String get adminRunCron => 'Запустить сейчас';

  @override
  String get adminGetToken => 'Получить токен регистрации';

  @override
  String get adminNoHooks => 'Системные хуки не настроены';

  @override
  String get adminNoCron => 'Нет задач Cron';

  @override
  String get adminNoRunners => 'Нет раннеров действий';

  @override
  String get adminNoEmails => 'Нет писем';

  @override
  String get adminNoBadges => 'Нет значков';

  @override
  String get adminBadgeUsername => 'Имя пользователя';

  @override
  String get adminBadgeDescription => 'Описание';

  @override
  String get oauthAppsTitle => 'Приложения OAuth';

  @override
  String get oauthNoApps => 'Нет приложений OAuth';

  @override
  String get oauthCreateApp => 'Создать приложение OAuth';

  @override
  String get oauthRedirectUri => 'URI перенаправления';

  @override
  String get oauthDeleteAppConfirm => 'Удалить приложение OAuth';

  @override
  String get name => 'Имя';

  @override
  String get confirmDelete => 'Подтвердить удаление';

  @override
  String get actionsSecretsTitle => 'Секреты Actions';

  @override
  String get actionsVariablesTitle => 'Переменные Actions';

  @override
  String get actionsNoSecrets => 'Secrets не настроены';

  @override
  String get actionsNoVariables => 'Variables не настроены';

  @override
  String get actionsCreateSecret => 'Создать Secret';

  @override
  String get actionsCreateVariable => 'Создать Variable';

  @override
  String get actionsSecretName => 'Имя Secret';

  @override
  String get actionsSecretValue => 'Значение Secret';

  @override
  String get actionsVariableName => 'Имя Variable';

  @override
  String get actionsVariableValue => 'Значение Variable';

  @override
  String get actionsDeleteSecretConfirm => 'Удалить этот Secret?';

  @override
  String get actionsDeleteVariableConfirm => 'Удалить эту Variable?';

  @override
  String get deleted => 'Удалено';

  @override
  String get overdue => 'Просрочено';

  @override
  String get addTopic => 'Добавить тему';

  @override
  String get importRepository => 'Импортировать репозиторий';

  @override
  String get import => 'Импорт';

  @override
  String get repoImported => 'Репозиторий импортирован';

  @override
  String get cloneUrl => 'URL клонирования';

  @override
  String get repoOwner => 'Владелец';

  @override
  String get gitService => 'Сервис Git';

  @override
  String get authentication => 'Аутентификация';

  @override
  String get authUsername => 'Имя пользователя аутентификации';

  @override
  String get authPassword => 'Пароль аутентификации';

  @override
  String get authToken => 'Токен аутентификации';

  @override
  String get migrationOptions => 'Параметры';

  @override
  String get migrateData => 'Данные для импорта';

  @override
  String get mirror => 'Зеркало';

  @override
  String get mirrorInterval => 'Интервал зеркалирования';

  @override
  String get requiredField => 'Это поле обязательно';

  @override
  String get personal => 'Личный';

  @override
  String get deleteOrganization => 'Удалить организацию';

  @override
  String get deleteOrganizationConfirm =>
      'Вы уверены, что хотите удалить эту организацию? Это действие нельзя отменить.';

  @override
  String get organizationDeleted => 'Организация удалена';

  @override
  String get accessTokens => 'Токены доступа';

  @override
  String get createToken => 'Создать токен';

  @override
  String get tokenName => 'Имя токена';

  @override
  String get tokenCreated => 'Токен создан';

  @override
  String get tokenValueWarning =>
      'Скопируйте этот токен сейчас. Вы больше не сможете его увидеть.';

  @override
  String get failedToCreateToken => 'Не удалось создать токен';

  @override
  String get deleteToken => 'Удалить токен';

  @override
  String get deleteTokenConfirm => 'Вы уверены, что хотите удалить';

  @override
  String get tokenDeleted => 'Токен удалён';

  @override
  String get noTokens => 'Нет токенов доступа';

  @override
  String get scopes => 'Области';

  @override
  String get selectAll => 'Выбрать всё';

  @override
  String get deselectAll => 'Отменить выбор';

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
  String get browseRepositories => 'Просмотр репозиториев';

  @override
  String get viewIssues => 'Просмотр и управление Issue';

  @override
  String get recentActivitySubtitle => 'Просмотр последних действий';

  @override
  String get yourStarredRepos => 'Избранные репозитории';

  @override
  String get yourOrganizations => 'Ваши организации';

  @override
  String get loadMoreActivity => 'Загрузить ещё';
}
