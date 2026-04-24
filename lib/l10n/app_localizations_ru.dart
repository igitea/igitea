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
  String get noResults => 'Результаты не найдены';

  @override
  String get repositories => 'Репозитории';

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
  String get assignee => 'Assignee';

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
    return 'Joined on $date';
  }

  @override
  String joinedOnParams(Object date) {
    return 'Присоединился $date';
  }

  @override
  String followerCount(Object count) {
    return '$count followers';
  }

  @override
  String followerCountParams(Object count) {
    return '$count подписчиков';
  }

  @override
  String followingCount(Object count) {
    return '$count following';
  }

  @override
  String followingCountParams(Object count) {
    return '$count подписок';
  }

  @override
  String repositoryCount(Object count) {
    return '$count repositories';
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
    return 'Last run: $time';
  }

  @override
  String lastRunParams(Object time) {
    return 'Последний запуск: $time';
  }

  @override
  String nextRun(Object time) {
    return 'Next run: $time';
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
    return 'Unread notifications: $count';
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
    return '$time ago';
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

  @override
  String get pleaseEnterTitle => 'Please enter a title';
}
