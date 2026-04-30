import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ja'),
    Locale('ko'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
    Locale('zh', 'TW')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'iGitea'**
  String get appTitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @loginWithToken.
  ///
  /// In en, this message translates to:
  /// **'Login with Token'**
  String get loginWithToken;

  /// No description provided for @token.
  ///
  /// In en, this message translates to:
  /// **'Token'**
  String get token;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @create.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get create;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @reopen.
  ///
  /// In en, this message translates to:
  /// **'Reopen'**
  String get reopen;

  /// No description provided for @merge.
  ///
  /// In en, this message translates to:
  /// **'Merge'**
  String get merge;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @searchRepos.
  ///
  /// In en, this message translates to:
  /// **'Search repositories'**
  String get searchRepos;

  /// No description provided for @searchIssues.
  ///
  /// In en, this message translates to:
  /// **'Search issues'**
  String get searchIssues;

  /// No description provided for @noResults.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResults;

  /// No description provided for @repositories.
  ///
  /// In en, this message translates to:
  /// **'Repositories'**
  String get repositories;

  /// No description provided for @repositorySections.
  ///
  /// In en, this message translates to:
  /// **'Repository Sections'**
  String get repositorySections;

  /// No description provided for @issues.
  ///
  /// In en, this message translates to:
  /// **'Issues'**
  String get issues;

  /// No description provided for @pullRequests.
  ///
  /// In en, this message translates to:
  /// **'Pull Requests'**
  String get pullRequests;

  /// No description provided for @releases.
  ///
  /// In en, this message translates to:
  /// **'Releases'**
  String get releases;

  /// No description provided for @branches.
  ///
  /// In en, this message translates to:
  /// **'Branches'**
  String get branches;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get code;

  /// No description provided for @stars.
  ///
  /// In en, this message translates to:
  /// **'Stars'**
  String get stars;

  /// No description provided for @forks.
  ///
  /// In en, this message translates to:
  /// **'Forks'**
  String get forks;

  /// No description provided for @watchers.
  ///
  /// In en, this message translates to:
  /// **'Watchers'**
  String get watchers;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @closed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get closed;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @mergePullRequest.
  ///
  /// In en, this message translates to:
  /// **'Merge Pull Request'**
  String get mergePullRequest;

  /// No description provided for @mergeConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to merge this pull request?'**
  String get mergeConfirmMessage;

  /// No description provided for @issueNumber.
  ///
  /// In en, this message translates to:
  /// **'Issue #{issueNumber}'**
  String issueNumber(Object issueNumber);

  /// No description provided for @pullRequestNumber.
  ///
  /// In en, this message translates to:
  /// **'PR #{pullRequestNumber}'**
  String pullRequestNumber(Object pullRequestNumber);

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @addComment.
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get addComment;

  /// No description provided for @sendComment.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sendComment;

  /// No description provided for @noComments.
  ///
  /// In en, this message translates to:
  /// **'No comments yet'**
  String get noComments;

  /// No description provided for @labels.
  ///
  /// In en, this message translates to:
  /// **'Labels'**
  String get labels;

  /// No description provided for @milestones.
  ///
  /// In en, this message translates to:
  /// **'Milestones'**
  String get milestones;

  /// No description provided for @assignees.
  ///
  /// In en, this message translates to:
  /// **'Assignees'**
  String get assignees;

  /// No description provided for @assignee.
  ///
  /// In en, this message translates to:
  /// **'Assignee'**
  String get assignee;

  /// No description provided for @participants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get participants;

  /// No description provided for @timeline.
  ///
  /// In en, this message translates to:
  /// **'Timeline'**
  String get timeline;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @accountInfo.
  ///
  /// In en, this message translates to:
  /// **'Account Info'**
  String get accountInfo;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @bio.
  ///
  /// In en, this message translates to:
  /// **'Bio'**
  String get bio;

  /// No description provided for @joinedOn.
  ///
  /// In en, this message translates to:
  /// **'Joined on {date}'**
  String joinedOn(Object date);

  /// No description provided for @joinedOnParams.
  ///
  /// In en, this message translates to:
  /// **'Joined on {date}'**
  String joinedOnParams(Object date);

  /// No description provided for @followerCount.
  ///
  /// In en, this message translates to:
  /// **'{count} followers'**
  String followerCount(Object count);

  /// No description provided for @followerCountParams.
  ///
  /// In en, this message translates to:
  /// **'{count} followers'**
  String followerCountParams(Object count);

  /// No description provided for @followingCount.
  ///
  /// In en, this message translates to:
  /// **'{count} following'**
  String followingCount(Object count);

  /// No description provided for @followingCountParams.
  ///
  /// In en, this message translates to:
  /// **'{count} following'**
  String followingCountParams(Object count);

  /// No description provided for @repositoryCount.
  ///
  /// In en, this message translates to:
  /// **'{count} repositories'**
  String repositoryCount(Object count);

  /// No description provided for @repositoryCountParams.
  ///
  /// In en, this message translates to:
  /// **'{count} repositories'**
  String repositoryCountParams(Object count);

  /// No description provided for @starredRepos.
  ///
  /// In en, this message translates to:
  /// **'Starred Repositories'**
  String get starredRepos;

  /// No description provided for @organisations.
  ///
  /// In en, this message translates to:
  /// **'Organisations'**
  String get organisations;

  /// No description provided for @adminPanel.
  ///
  /// In en, this message translates to:
  /// **'Admin Panel'**
  String get adminPanel;

  /// No description provided for @userManagement.
  ///
  /// In en, this message translates to:
  /// **'User Management'**
  String get userManagement;

  /// No description provided for @serverSettings.
  ///
  /// In en, this message translates to:
  /// **'Server Settings'**
  String get serverSettings;

  /// No description provided for @cronTasks.
  ///
  /// In en, this message translates to:
  /// **'Cron Tasks'**
  String get cronTasks;

  /// No description provided for @apiSettings.
  ///
  /// In en, this message translates to:
  /// **'API Settings'**
  String get apiSettings;

  /// No description provided for @uiSettings.
  ///
  /// In en, this message translates to:
  /// **'UI Settings'**
  String get uiSettings;

  /// No description provided for @attachmentSettings.
  ///
  /// In en, this message translates to:
  /// **'Attachment Settings'**
  String get attachmentSettings;

  /// No description provided for @repoSettings.
  ///
  /// In en, this message translates to:
  /// **'Repository Settings'**
  String get repoSettings;

  /// No description provided for @runNow.
  ///
  /// In en, this message translates to:
  /// **'Run Now'**
  String get runNow;

  /// No description provided for @lastRun.
  ///
  /// In en, this message translates to:
  /// **'Last run: {time}'**
  String lastRun(Object time);

  /// No description provided for @lastRunParams.
  ///
  /// In en, this message translates to:
  /// **'Last run: {time}'**
  String lastRunParams(Object time);

  /// No description provided for @nextRun.
  ///
  /// In en, this message translates to:
  /// **'Next run: {time}'**
  String nextRun(Object time);

  /// No description provided for @nextRunParams.
  ///
  /// In en, this message translates to:
  /// **'Next run: {time}'**
  String nextRunParams(Object time);

  /// No description provided for @recentActivity.
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// No description provided for @myIssues.
  ///
  /// In en, this message translates to:
  /// **'My Issues'**
  String get myIssues;

  /// No description provided for @myRepos.
  ///
  /// In en, this message translates to:
  /// **'My Repos'**
  String get myRepos;

  /// No description provided for @myStars.
  ///
  /// In en, this message translates to:
  /// **'My Stars'**
  String get myStars;

  /// No description provided for @feed.
  ///
  /// In en, this message translates to:
  /// **'Feed'**
  String get feed;

  /// No description provided for @markAllRead.
  ///
  /// In en, this message translates to:
  /// **'Mark all as read'**
  String get markAllRead;

  /// No description provided for @markRead.
  ///
  /// In en, this message translates to:
  /// **'Mark as read'**
  String get markRead;

  /// No description provided for @unreadNotifications.
  ///
  /// In en, this message translates to:
  /// **'Unread notifications: {count}'**
  String unreadNotifications(Object count);

  /// No description provided for @unreadNotificationsParams.
  ///
  /// In en, this message translates to:
  /// **'Unread notifications: {count}'**
  String unreadNotificationsParams(Object count);

  /// No description provided for @noUnreadNotifications.
  ///
  /// In en, this message translates to:
  /// **'No unread notifications'**
  String get noUnreadNotifications;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @ago.
  ///
  /// In en, this message translates to:
  /// **'{time} ago'**
  String ago(Object time);

  /// No description provided for @agoParams.
  ///
  /// In en, this message translates to:
  /// **'{time} ago'**
  String agoParams(Object time);

  /// No description provided for @fileBrowser.
  ///
  /// In en, this message translates to:
  /// **'File Browser'**
  String get fileBrowser;

  /// No description provided for @readme.
  ///
  /// In en, this message translates to:
  /// **'README'**
  String get readme;

  /// No description provided for @commits.
  ///
  /// In en, this message translates to:
  /// **'Commits'**
  String get commits;

  /// No description provided for @commitHistory.
  ///
  /// In en, this message translates to:
  /// **'Commit History'**
  String get commitHistory;

  /// No description provided for @viewFile.
  ///
  /// In en, this message translates to:
  /// **'View File'**
  String get viewFile;

  /// No description provided for @downloadFile.
  ///
  /// In en, this message translates to:
  /// **'Download File'**
  String get downloadFile;

  /// No description provided for @copyPath.
  ///
  /// In en, this message translates to:
  /// **'Copy Path'**
  String get copyPath;

  /// No description provided for @fileName.
  ///
  /// In en, this message translates to:
  /// **'File name'**
  String get fileName;

  /// No description provided for @fileSize.
  ///
  /// In en, this message translates to:
  /// **'File size'**
  String get fileSize;

  /// No description provided for @lastModified.
  ///
  /// In en, this message translates to:
  /// **'Last modified'**
  String get lastModified;

  /// No description provided for @openInBrowser.
  ///
  /// In en, this message translates to:
  /// **'Open in Browser'**
  String get openInBrowser;

  /// No description provided for @signInRequired.
  ///
  /// In en, this message translates to:
  /// **'Sign in required'**
  String get signInRequired;

  /// No description provided for @signInMessage.
  ///
  /// In en, this message translates to:
  /// **'Please sign in to continue'**
  String get signInMessage;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @networkError.
  ///
  /// In en, this message translates to:
  /// **'Network error'**
  String get networkError;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error occurred'**
  String get unknownError;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @copyToClipboard.
  ///
  /// In en, this message translates to:
  /// **'Copy to clipboard'**
  String get copyToClipboard;

  /// No description provided for @copied.
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get copied;

  /// No description provided for @filterIssues.
  ///
  /// In en, this message translates to:
  /// **'Filter issues'**
  String get filterIssues;

  /// No description provided for @newIssue.
  ///
  /// In en, this message translates to:
  /// **'New Issue'**
  String get newIssue;

  /// No description provided for @newPullRequest.
  ///
  /// In en, this message translates to:
  /// **'New Pull Request'**
  String get newPullRequest;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @body.
  ///
  /// In en, this message translates to:
  /// **'Body'**
  String get body;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @milestone.
  ///
  /// In en, this message translates to:
  /// **'Milestone'**
  String get milestone;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get createdAt;

  /// No description provided for @updatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated at'**
  String get updatedAt;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due'**
  String get dueDate;

  /// No description provided for @noMilestones.
  ///
  /// In en, this message translates to:
  /// **'No milestones'**
  String get noMilestones;

  /// No description provided for @noLabels.
  ///
  /// In en, this message translates to:
  /// **'No labels'**
  String get noLabels;

  /// No description provided for @openIssue.
  ///
  /// In en, this message translates to:
  /// **'Open issue'**
  String get openIssue;

  /// No description provided for @closeIssue.
  ///
  /// In en, this message translates to:
  /// **'Close issue'**
  String get closeIssue;

  /// No description provided for @reopenIssue.
  ///
  /// In en, this message translates to:
  /// **'Reopen issue'**
  String get reopenIssue;

  /// No description provided for @deleteComment.
  ///
  /// In en, this message translates to:
  /// **'Delete comment'**
  String get deleteComment;

  /// No description provided for @editComment.
  ///
  /// In en, this message translates to:
  /// **'Edit comment'**
  String get editComment;

  /// No description provided for @deleteRepo.
  ///
  /// In en, this message translates to:
  /// **'Delete repository'**
  String get deleteRepo;

  /// No description provided for @deleteRepoConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this repository? This action cannot be undone.'**
  String get deleteRepoConfirm;

  /// No description provided for @generalSettings.
  ///
  /// In en, this message translates to:
  /// **'General Settings'**
  String get generalSettings;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @languageSelector.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSelector;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @systemDefault.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemDefault;

  /// No description provided for @followSystem.
  ///
  /// In en, this message translates to:
  /// **'Follow system'**
  String get followSystem;

  /// No description provided for @unsavedChanges.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get unsavedChanges;

  /// No description provided for @unsavedChangesMessage.
  ///
  /// In en, this message translates to:
  /// **'You have unsaved changes. Are you sure you want to leave?'**
  String get unsavedChangesMessage;

  /// No description provided for @leave.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get leave;

  /// No description provided for @stay.
  ///
  /// In en, this message translates to:
  /// **'Stay'**
  String get stay;

  /// No description provided for @restoringSession.
  ///
  /// In en, this message translates to:
  /// **'Restoring session...'**
  String get restoringSession;

  /// No description provided for @pleaseEnterServerUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a server URL'**
  String get pleaseEnterServerUrl;

  /// No description provided for @pleaseEnterValidUrl.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid URL'**
  String get pleaseEnterValidUrl;

  /// No description provided for @connectToGitea.
  ///
  /// In en, this message translates to:
  /// **'Connect to your Gitea instance'**
  String get connectToGitea;

  /// No description provided for @usernamePassword.
  ///
  /// In en, this message translates to:
  /// **'Username & Password'**
  String get usernamePassword;

  /// No description provided for @serverUrl.
  ///
  /// In en, this message translates to:
  /// **'Server URL'**
  String get serverUrl;

  /// No description provided for @enterUsername.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get enterUsername;

  /// No description provided for @pleaseEnterUsername.
  ///
  /// In en, this message translates to:
  /// **'Please enter your username'**
  String get pleaseEnterUsername;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @pasteAccessToken.
  ///
  /// In en, this message translates to:
  /// **'Paste your personal access token'**
  String get pasteAccessToken;

  /// No description provided for @pleaseEnterAccessToken.
  ///
  /// In en, this message translates to:
  /// **'Please enter an access token'**
  String get pleaseEnterAccessToken;

  /// No description provided for @signInWithToken.
  ///
  /// In en, this message translates to:
  /// **'Sign In with Token'**
  String get signInWithToken;

  /// No description provided for @welcomeToIgitea.
  ///
  /// In en, this message translates to:
  /// **'Welcome to iGitea'**
  String get welcomeToIgitea;

  /// No description provided for @signInToGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Sign in to get started'**
  String get signInToGetStarted;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @yourRepositories.
  ///
  /// In en, this message translates to:
  /// **'Your Repositories'**
  String get yourRepositories;

  /// No description provided for @noRepositoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No repositories found.'**
  String get noRepositoriesFound;

  /// No description provided for @helloParams.
  ///
  /// In en, this message translates to:
  /// **'Hello, {full_name}!'**
  String helloParams(Object full_name);

  /// No description provided for @user.
  ///
  /// In en, this message translates to:
  /// **'User'**
  String get user;

  /// No description provided for @private.
  ///
  /// In en, this message translates to:
  /// **'Private'**
  String get private;

  /// No description provided for @untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get untitled;

  /// No description provided for @enterSearchQueryRepos.
  ///
  /// In en, this message translates to:
  /// **'Enter a search query to find repositories'**
  String get enterSearchQueryRepos;

  /// No description provided for @enterSearchQueryIssues.
  ///
  /// In en, this message translates to:
  /// **'Enter a search query to find issues'**
  String get enterSearchQueryIssues;

  /// No description provided for @noIssuesFound.
  ///
  /// In en, this message translates to:
  /// **'No issues found.'**
  String get noIssuesFound;

  /// No description provided for @failedToLoadProfile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load profile'**
  String get failedToLoadProfile;

  /// No description provided for @unknownUser.
  ///
  /// In en, this message translates to:
  /// **'Unknown User'**
  String get unknownUser;

  /// No description provided for @admin.
  ///
  /// In en, this message translates to:
  /// **'Admin'**
  String get admin;

  /// No description provided for @repos.
  ///
  /// In en, this message translates to:
  /// **'Repos'**
  String get repos;

  /// No description provided for @followers.
  ///
  /// In en, this message translates to:
  /// **'Followers'**
  String get followers;

  /// No description provided for @following.
  ///
  /// In en, this message translates to:
  /// **'Following'**
  String get following;

  /// No description provided for @signOutConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to sign out?'**
  String get signOutConfirmMessage;

  /// No description provided for @chooseTheme.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme'**
  String get chooseTheme;

  /// No description provided for @loadingSettings.
  ///
  /// In en, this message translates to:
  /// **'Loading settings...'**
  String get loadingSettings;

  /// No description provided for @userManagementComingSoon.
  ///
  /// In en, this message translates to:
  /// **'User management coming soon'**
  String get userManagementComingSoon;

  /// No description provided for @maxResponseItems.
  ///
  /// In en, this message translates to:
  /// **'Max Response Items'**
  String get maxResponseItems;

  /// No description provided for @defaultPagingNum.
  ///
  /// In en, this message translates to:
  /// **'Default Paging Num'**
  String get defaultPagingNum;

  /// No description provided for @defaultMaxBlobSize.
  ///
  /// In en, this message translates to:
  /// **'Default Max Blob Size'**
  String get defaultMaxBlobSize;

  /// No description provided for @defaultTheme.
  ///
  /// In en, this message translates to:
  /// **'Default Theme'**
  String get defaultTheme;

  /// No description provided for @allowedReactions.
  ///
  /// In en, this message translates to:
  /// **'Allowed Reactions'**
  String get allowedReactions;

  /// No description provided for @attachments.
  ///
  /// In en, this message translates to:
  /// **'Attachments'**
  String get attachments;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @maxFiles.
  ///
  /// In en, this message translates to:
  /// **'Max Files'**
  String get maxFiles;

  /// No description provided for @maxSize.
  ///
  /// In en, this message translates to:
  /// **'Max Size'**
  String get maxSize;

  /// No description provided for @allowedTypes.
  ///
  /// In en, this message translates to:
  /// **'Allowed Types'**
  String get allowedTypes;

  /// No description provided for @bytes.
  ///
  /// In en, this message translates to:
  /// **'bytes'**
  String get bytes;

  /// No description provided for @repository.
  ///
  /// In en, this message translates to:
  /// **'Repository'**
  String get repository;

  /// No description provided for @httpGitDisabled.
  ///
  /// In en, this message translates to:
  /// **'HTTP Git Disabled'**
  String get httpGitDisabled;

  /// No description provided for @lfsDisabled.
  ///
  /// In en, this message translates to:
  /// **'LFS Disabled'**
  String get lfsDisabled;

  /// No description provided for @migrationsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Migrations Disabled'**
  String get migrationsDisabled;

  /// No description provided for @mirrorsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Mirrors Disabled'**
  String get mirrorsDisabled;

  /// No description provided for @starsDisabled.
  ///
  /// In en, this message translates to:
  /// **'Stars Disabled'**
  String get starsDisabled;

  /// No description provided for @timeTrackingDisabled.
  ///
  /// In en, this message translates to:
  /// **'Time Tracking Disabled'**
  String get timeTrackingDisabled;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @executions.
  ///
  /// In en, this message translates to:
  /// **'Executions'**
  String get executions;

  /// No description provided for @failedToLoadCronTasks.
  ///
  /// In en, this message translates to:
  /// **'Failed to load cron tasks'**
  String get failedToLoadCronTasks;

  /// No description provided for @noCronTasksFound.
  ///
  /// In en, this message translates to:
  /// **'No cron tasks found'**
  String get noCronTasksFound;

  /// No description provided for @cronTriggeredParams.
  ///
  /// In en, this message translates to:
  /// **'Cron \"{name}\" triggered'**
  String cronTriggeredParams(Object name);

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @openedParams.
  ///
  /// In en, this message translates to:
  /// **'opened {time}'**
  String openedParams(Object time);

  /// No description provided for @noDescriptionProvided.
  ///
  /// In en, this message translates to:
  /// **'No description provided.'**
  String get noDescriptionProvided;

  /// No description provided for @failedToLoadComments.
  ///
  /// In en, this message translates to:
  /// **'Failed to load comments'**
  String get failedToLoadComments;

  /// No description provided for @writeComment.
  ///
  /// In en, this message translates to:
  /// **'Write a comment...'**
  String get writeComment;

  /// No description provided for @commentsCountParams.
  ///
  /// In en, this message translates to:
  /// **'{count} comments'**
  String commentsCountParams(Object count);

  /// No description provided for @updatedParams.
  ///
  /// In en, this message translates to:
  /// **'Updated {time}'**
  String updatedParams(Object time);

  /// No description provided for @commentsParams.
  ///
  /// In en, this message translates to:
  /// **'Comments ({count})'**
  String commentsParams(Object count);

  /// No description provided for @files.
  ///
  /// In en, this message translates to:
  /// **'files'**
  String get files;

  /// No description provided for @mergeable.
  ///
  /// In en, this message translates to:
  /// **'Mergeable'**
  String get mergeable;

  /// No description provided for @merged.
  ///
  /// In en, this message translates to:
  /// **'Merged'**
  String get merged;

  /// No description provided for @draft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get draft;

  /// No description provided for @failedToLoadRepo.
  ///
  /// In en, this message translates to:
  /// **'Failed to load repository'**
  String get failedToLoadRepo;

  /// No description provided for @copyUrl.
  ///
  /// In en, this message translates to:
  /// **'Copy URL'**
  String get copyUrl;

  /// No description provided for @urlCopied.
  ///
  /// In en, this message translates to:
  /// **'URL copied'**
  String get urlCopied;

  /// No description provided for @emptyDirectory.
  ///
  /// In en, this message translates to:
  /// **'Empty directory'**
  String get emptyDirectory;

  /// No description provided for @noIssues.
  ///
  /// In en, this message translates to:
  /// **'No issues'**
  String get noIssues;

  /// No description provided for @noPullRequests.
  ///
  /// In en, this message translates to:
  /// **'No pull requests'**
  String get noPullRequests;

  /// No description provided for @noReleases.
  ///
  /// In en, this message translates to:
  /// **'No releases'**
  String get noReleases;

  /// No description provided for @noBranches.
  ///
  /// In en, this message translates to:
  /// **'No branches'**
  String get noBranches;

  /// No description provided for @preRelease.
  ///
  /// In en, this message translates to:
  /// **'Pre-release'**
  String get preRelease;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @defaultBranch.
  ///
  /// In en, this message translates to:
  /// **'Default branch'**
  String get defaultBranch;

  /// No description provided for @copyCode.
  ///
  /// In en, this message translates to:
  /// **'Copy code'**
  String get copyCode;

  /// No description provided for @failedToLoadFile.
  ///
  /// In en, this message translates to:
  /// **'Failed to load file'**
  String get failedToLoadFile;

  /// No description provided for @filePreviewNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'File preview not available'**
  String get filePreviewNotAvailable;

  /// No description provided for @download.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get download;

  /// No description provided for @failedToOpenDownloadUrl.
  ///
  /// In en, this message translates to:
  /// **'Failed to open download URL'**
  String get failedToOpenDownloadUrl;

  /// No description provided for @noNotifications.
  ///
  /// In en, this message translates to:
  /// **'No notifications'**
  String get noNotifications;

  /// No description provided for @noTitle.
  ///
  /// In en, this message translates to:
  /// **'No title'**
  String get noTitle;

  /// No description provided for @allNotificationsMarkedAsRead.
  ///
  /// In en, this message translates to:
  /// **'All notifications marked as read'**
  String get allNotificationsMarkedAsRead;

  /// No description provided for @createUser.
  ///
  /// In en, this message translates to:
  /// **'Create User'**
  String get createUser;

  /// No description provided for @editUser.
  ///
  /// In en, this message translates to:
  /// **'Edit User'**
  String get editUser;

  /// No description provided for @deleteUser.
  ///
  /// In en, this message translates to:
  /// **'Delete User'**
  String get deleteUser;

  /// No description provided for @deleteUserConfirmParams.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete user \"{username}\"? This action cannot be undone.'**
  String deleteUserConfirmParams(Object username);

  /// No description provided for @userCreated.
  ///
  /// In en, this message translates to:
  /// **'User created successfully'**
  String get userCreated;

  /// No description provided for @userUpdated.
  ///
  /// In en, this message translates to:
  /// **'User updated successfully'**
  String get userUpdated;

  /// No description provided for @userDeleted.
  ///
  /// In en, this message translates to:
  /// **'User deleted successfully'**
  String get userDeleted;

  /// No description provided for @noUsersFound.
  ///
  /// In en, this message translates to:
  /// **'No users found'**
  String get noUsersFound;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter an email'**
  String get pleaseEnterEmail;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullName;

  /// No description provided for @mustChangePassword.
  ///
  /// In en, this message translates to:
  /// **'Must change password on first login'**
  String get mustChangePassword;

  /// No description provided for @pleaseEnterTitle.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get pleaseEnterTitle;

  /// No description provided for @noActivity.
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noActivity;

  /// No description provided for @createdRepo.
  ///
  /// In en, this message translates to:
  /// **'created repository'**
  String get createdRepo;

  /// No description provided for @pushedTag.
  ///
  /// In en, this message translates to:
  /// **'pushed tag'**
  String get pushedTag;

  /// No description provided for @deletedTag.
  ///
  /// In en, this message translates to:
  /// **'deleted tag'**
  String get deletedTag;

  /// No description provided for @createdIssue.
  ///
  /// In en, this message translates to:
  /// **'created issue'**
  String get createdIssue;

  /// No description provided for @closedIssue.
  ///
  /// In en, this message translates to:
  /// **'closed issue'**
  String get closedIssue;

  /// No description provided for @reopenedIssue.
  ///
  /// In en, this message translates to:
  /// **'reopened issue'**
  String get reopenedIssue;

  /// No description provided for @createdPR.
  ///
  /// In en, this message translates to:
  /// **'created pull request'**
  String get createdPR;

  /// No description provided for @mergedPR.
  ///
  /// In en, this message translates to:
  /// **'merged pull request'**
  String get mergedPR;

  /// No description provided for @closedPR.
  ///
  /// In en, this message translates to:
  /// **'closed pull request'**
  String get closedPR;

  /// No description provided for @commentedOnIssue.
  ///
  /// In en, this message translates to:
  /// **'commented on issue'**
  String get commentedOnIssue;

  /// No description provided for @commentedOnPR.
  ///
  /// In en, this message translates to:
  /// **'commented on pull request'**
  String get commentedOnPR;

  /// No description provided for @forkedRepo.
  ///
  /// In en, this message translates to:
  /// **'forked repository'**
  String get forkedRepo;

  /// No description provided for @transferredRepo.
  ///
  /// In en, this message translates to:
  /// **'transferred repository'**
  String get transferredRepo;

  /// No description provided for @deletedRepo.
  ///
  /// In en, this message translates to:
  /// **'deleted repository'**
  String get deletedRepo;

  /// No description provided for @updatedWiki.
  ///
  /// In en, this message translates to:
  /// **'updated wiki'**
  String get updatedWiki;

  /// No description provided for @performedAction.
  ///
  /// In en, this message translates to:
  /// **'performed action'**
  String get performedAction;

  /// No description provided for @inRepo.
  ///
  /// In en, this message translates to:
  /// **'in'**
  String get inRepo;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'to'**
  String get to;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'from'**
  String get from;

  /// No description provided for @headBranch.
  ///
  /// In en, this message translates to:
  /// **'Head branch'**
  String get headBranch;

  /// No description provided for @baseBranch.
  ///
  /// In en, this message translates to:
  /// **'Base branch'**
  String get baseBranch;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all required fields'**
  String get pleaseFillAllFields;

  /// No description provided for @settingsSaved.
  ///
  /// In en, this message translates to:
  /// **'Settings saved'**
  String get settingsSaved;

  /// No description provided for @privateRepo.
  ///
  /// In en, this message translates to:
  /// **'Private repository'**
  String get privateRepo;

  /// No description provided for @privateRepoDesc.
  ///
  /// In en, this message translates to:
  /// **'Only visible to you and collaborators'**
  String get privateRepoDesc;

  /// No description provided for @enableIssues.
  ///
  /// In en, this message translates to:
  /// **'Enable Issues'**
  String get enableIssues;

  /// No description provided for @enablePullRequests.
  ///
  /// In en, this message translates to:
  /// **'Enable Pull Requests'**
  String get enablePullRequests;

  /// No description provided for @enableWiki.
  ///
  /// In en, this message translates to:
  /// **'Enable Wiki'**
  String get enableWiki;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @commitMessage.
  ///
  /// In en, this message translates to:
  /// **'Commit Message'**
  String get commitMessage;

  /// No description provided for @commit.
  ///
  /// In en, this message translates to:
  /// **'Commit'**
  String get commit;

  /// No description provided for @commitMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your changes (optional)'**
  String get commitMessageHint;

  /// No description provided for @cannotGetFileSha.
  ///
  /// In en, this message translates to:
  /// **'Cannot get file SHA. Please reload the file.'**
  String get cannotGetFileSha;

  /// No description provided for @failedToSaveFile.
  ///
  /// In en, this message translates to:
  /// **'Failed to save file'**
  String get failedToSaveFile;

  /// No description provided for @fileSaved.
  ///
  /// In en, this message translates to:
  /// **'File saved successfully'**
  String get fileSaved;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @sha.
  ///
  /// In en, this message translates to:
  /// **'SHA'**
  String get sha;

  /// No description provided for @changedFiles.
  ///
  /// In en, this message translates to:
  /// **'Changed Files'**
  String get changedFiles;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @noCommits.
  ///
  /// In en, this message translates to:
  /// **'No commits'**
  String get noCommits;

  /// No description provided for @noTags.
  ///
  /// In en, this message translates to:
  /// **'No tags'**
  String get noTags;

  /// No description provided for @protected.
  ///
  /// In en, this message translates to:
  /// **'Protected'**
  String get protected;

  /// No description provided for @latestCommit.
  ///
  /// In en, this message translates to:
  /// **'Latest Commit'**
  String get latestCommit;

  /// No description provided for @permissions.
  ///
  /// In en, this message translates to:
  /// **'Permissions'**
  String get permissions;

  /// No description provided for @canPush.
  ///
  /// In en, this message translates to:
  /// **'Can Push'**
  String get canPush;

  /// No description provided for @canMerge.
  ///
  /// In en, this message translates to:
  /// **'Can Merge'**
  String get canMerge;

  /// No description provided for @downloads.
  ///
  /// In en, this message translates to:
  /// **'Downloads'**
  String get downloads;

  /// No description provided for @tarball.
  ///
  /// In en, this message translates to:
  /// **'Tarball'**
  String get tarball;

  /// No description provided for @zipball.
  ///
  /// In en, this message translates to:
  /// **'Zipball'**
  String get zipball;

  /// No description provided for @downloadTarball.
  ///
  /// In en, this message translates to:
  /// **'Download Tarball'**
  String get downloadTarball;

  /// No description provided for @downloadZipball.
  ///
  /// In en, this message translates to:
  /// **'Download Zipball'**
  String get downloadZipball;

  /// No description provided for @url.
  ///
  /// In en, this message translates to:
  /// **'URL'**
  String get url;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @teams.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get teams;

  /// No description provided for @noTeams.
  ///
  /// In en, this message translates to:
  /// **'No teams'**
  String get noTeams;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @visibility.
  ///
  /// In en, this message translates to:
  /// **'Visibility'**
  String get visibility;

  /// No description provided for @assets.
  ///
  /// In en, this message translates to:
  /// **'Assets'**
  String get assets;

  /// No description provided for @publishedAt.
  ///
  /// In en, this message translates to:
  /// **'Published At'**
  String get publishedAt;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @forked.
  ///
  /// In en, this message translates to:
  /// **'Forked'**
  String get forked;

  /// No description provided for @editIssue.
  ///
  /// In en, this message translates to:
  /// **'Edit Issue'**
  String get editIssue;

  /// No description provided for @titleRequired.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get titleRequired;

  /// No description provided for @selectMilestone.
  ///
  /// In en, this message translates to:
  /// **'Select milestone'**
  String get selectMilestone;

  /// No description provided for @members.
  ///
  /// In en, this message translates to:
  /// **'Members'**
  String get members;

  /// No description provided for @noMembers.
  ///
  /// In en, this message translates to:
  /// **'No members'**
  String get noMembers;

  /// No description provided for @editOrganization.
  ///
  /// In en, this message translates to:
  /// **'Edit Organization'**
  String get editOrganization;

  /// No description provided for @createOrganization.
  ///
  /// In en, this message translates to:
  /// **'Create Organization'**
  String get createOrganization;

  /// No description provided for @createRepository.
  ///
  /// In en, this message translates to:
  /// **'Create Repository'**
  String get createRepository;

  /// No description provided for @repositoryName.
  ///
  /// In en, this message translates to:
  /// **'Repository Name'**
  String get repositoryName;

  /// No description provided for @repositoryNameHint.
  ///
  /// In en, this message translates to:
  /// **'my-awesome-repo'**
  String get repositoryNameHint;

  /// No description provided for @repositoryNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Repository name is required'**
  String get repositoryNameRequired;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Short description of your repository'**
  String get descriptionHint;

  /// No description provided for @public.
  ///
  /// In en, this message translates to:
  /// **'Public'**
  String get public;

  /// No description provided for @publicDescription.
  ///
  /// In en, this message translates to:
  /// **'Anyone on the internet can see this repository'**
  String get publicDescription;

  /// No description provided for @privateDescription.
  ///
  /// In en, this message translates to:
  /// **'You choose who can see and commit to this repository'**
  String get privateDescription;

  /// No description provided for @initializeWithReadme.
  ///
  /// In en, this message translates to:
  /// **'Initialize with README'**
  String get initializeWithReadme;

  /// No description provided for @initializeWithReadmeDescription.
  ///
  /// In en, this message translates to:
  /// **'Add a README file to help others understand your project'**
  String get initializeWithReadmeDescription;

  /// No description provided for @repoCreated.
  ///
  /// In en, this message translates to:
  /// **'Repository \'{repoName}\' created successfully'**
  String repoCreated(Object repoName);

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'complete'**
  String get complete;

  /// No description provided for @wiki.
  ///
  /// In en, this message translates to:
  /// **'Wiki'**
  String get wiki;

  /// No description provided for @newWikiPage.
  ///
  /// In en, this message translates to:
  /// **'New Wiki Page'**
  String get newWikiPage;

  /// No description provided for @editWikiPage.
  ///
  /// In en, this message translates to:
  /// **'Edit Wiki Page'**
  String get editWikiPage;

  /// No description provided for @deleteWikiPage.
  ///
  /// In en, this message translates to:
  /// **'Delete Wiki Page'**
  String get deleteWikiPage;

  /// No description provided for @deleteWikiPageConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this wiki page? This action cannot be undone.'**
  String get deleteWikiPageConfirm;

  /// No description provided for @wikiPageDeleted.
  ///
  /// In en, this message translates to:
  /// **'Wiki page deleted'**
  String get wikiPageDeleted;

  /// No description provided for @wikiPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Page Title'**
  String get wikiPageTitle;

  /// No description provided for @wikiPageTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Home'**
  String get wikiPageTitleHint;

  /// No description provided for @wikiPageContent.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get wikiPageContent;

  /// No description provided for @wikiPageContentHint.
  ///
  /// In en, this message translates to:
  /// **'Write in Markdown...'**
  String get wikiPageContentHint;

  /// No description provided for @noWikiPages.
  ///
  /// In en, this message translates to:
  /// **'No wiki pages'**
  String get noWikiPages;

  /// No description provided for @noWikiPagesDescription.
  ///
  /// In en, this message translates to:
  /// **'This repository doesn\'t have any wiki pages yet.'**
  String get noWikiPagesDescription;

  /// No description provided for @createFirstWikiPage.
  ///
  /// In en, this message translates to:
  /// **'Create First Page'**
  String get createFirstWikiPage;

  /// No description provided for @lastCommit.
  ///
  /// In en, this message translates to:
  /// **'Last commit'**
  String get lastCommit;

  /// No description provided for @noContent.
  ///
  /// In en, this message translates to:
  /// **'No content'**
  String get noContent;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @created.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get created;

  /// No description provided for @createMilestone.
  ///
  /// In en, this message translates to:
  /// **'Create Milestone'**
  String get createMilestone;

  /// No description provided for @editMilestone.
  ///
  /// In en, this message translates to:
  /// **'Edit Milestone'**
  String get editMilestone;

  /// No description provided for @deleteMilestone.
  ///
  /// In en, this message translates to:
  /// **'Delete Milestone'**
  String get deleteMilestone;

  /// No description provided for @deleteMilestoneConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this milestone? This action cannot be undone.'**
  String get deleteMilestoneConfirm;

  /// No description provided for @milestoneDeleted.
  ///
  /// In en, this message translates to:
  /// **'Milestone deleted'**
  String get milestoneDeleted;

  /// No description provided for @milestoneTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get milestoneTitle;

  /// No description provided for @milestoneDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get milestoneDescription;

  /// No description provided for @milestoneDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe this milestone'**
  String get milestoneDescriptionHint;

  /// No description provided for @milestoneDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get milestoneDueDate;

  /// No description provided for @milestoneState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get milestoneState;

  /// No description provided for @milestoneStateOpen.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get milestoneStateOpen;

  /// No description provided for @milestoneStateClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get milestoneStateClosed;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @webhooks.
  ///
  /// In en, this message translates to:
  /// **'Webhooks'**
  String get webhooks;

  /// No description provided for @webhook.
  ///
  /// In en, this message translates to:
  /// **'Webhook'**
  String get webhook;

  /// No description provided for @noWebhooks.
  ///
  /// In en, this message translates to:
  /// **'No webhooks'**
  String get noWebhooks;

  /// No description provided for @createWebhook.
  ///
  /// In en, this message translates to:
  /// **'Create Webhook'**
  String get createWebhook;

  /// No description provided for @editWebhook.
  ///
  /// In en, this message translates to:
  /// **'Edit Webhook'**
  String get editWebhook;

  /// No description provided for @deleteWebhook.
  ///
  /// In en, this message translates to:
  /// **'Delete Webhook'**
  String get deleteWebhook;

  /// No description provided for @deleteWebhookConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this webhook? This action cannot be undone.'**
  String get deleteWebhookConfirm;

  /// No description provided for @webhookDeleted.
  ///
  /// In en, this message translates to:
  /// **'Webhook deleted'**
  String get webhookDeleted;

  /// No description provided for @webhookUrl.
  ///
  /// In en, this message translates to:
  /// **'Payload URL'**
  String get webhookUrl;

  /// No description provided for @webhookUrlHint.
  ///
  /// In en, this message translates to:
  /// **'https://example.com/webhook'**
  String get webhookUrlHint;

  /// No description provided for @webhookSecret.
  ///
  /// In en, this message translates to:
  /// **'Secret'**
  String get webhookSecret;

  /// No description provided for @webhookSecretHint.
  ///
  /// In en, this message translates to:
  /// **'Optional secret token'**
  String get webhookSecretHint;

  /// No description provided for @webhookContentType.
  ///
  /// In en, this message translates to:
  /// **'Content Type'**
  String get webhookContentType;

  /// No description provided for @webhookContentTypeJson.
  ///
  /// In en, this message translates to:
  /// **'application/json'**
  String get webhookContentTypeJson;

  /// No description provided for @webhookContentTypeForm.
  ///
  /// In en, this message translates to:
  /// **'application/x-www-form-urlencoded'**
  String get webhookContentTypeForm;

  /// No description provided for @webhookEvents.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get webhookEvents;

  /// No description provided for @webhookEventsHint.
  ///
  /// In en, this message translates to:
  /// **'Select events to trigger this webhook'**
  String get webhookEventsHint;

  /// No description provided for @webhookActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get webhookActive;

  /// No description provided for @webhookInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get webhookInactive;

  /// No description provided for @webhookType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get webhookType;

  /// No description provided for @webhookCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get webhookCreatedAt;

  /// No description provided for @webhookUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'Updated'**
  String get webhookUpdatedAt;

  /// No description provided for @webhookLastDelivery.
  ///
  /// In en, this message translates to:
  /// **'Last Delivery'**
  String get webhookLastDelivery;

  /// No description provided for @webhookSelectAllEvents.
  ///
  /// In en, this message translates to:
  /// **'Select All'**
  String get webhookSelectAllEvents;

  /// No description provided for @webhookPushEvents.
  ///
  /// In en, this message translates to:
  /// **'Push'**
  String get webhookPushEvents;

  /// No description provided for @webhookPullRequestEvents.
  ///
  /// In en, this message translates to:
  /// **'Pull Requests'**
  String get webhookPullRequestEvents;

  /// No description provided for @webhookIssuesEvents.
  ///
  /// In en, this message translates to:
  /// **'Issues'**
  String get webhookIssuesEvents;

  /// No description provided for @webhookCreateEvents.
  ///
  /// In en, this message translates to:
  /// **'Create'**
  String get webhookCreateEvents;

  /// No description provided for @webhookDeleteEvents.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get webhookDeleteEvents;

  /// No description provided for @webhookReleaseEvents.
  ///
  /// In en, this message translates to:
  /// **'Releases'**
  String get webhookReleaseEvents;

  /// No description provided for @webhookWikiEvents.
  ///
  /// In en, this message translates to:
  /// **'Wiki'**
  String get webhookWikiEvents;

  /// No description provided for @webhookStarEvents.
  ///
  /// In en, this message translates to:
  /// **'Star'**
  String get webhookStarEvents;

  /// No description provided for @webhookForkEvents.
  ///
  /// In en, this message translates to:
  /// **'Fork'**
  String get webhookForkEvents;

  /// No description provided for @loginWithOAuth2.
  ///
  /// In en, this message translates to:
  /// **'Login with OAuth2'**
  String get loginWithOAuth2;

  /// No description provided for @oauth2.
  ///
  /// In en, this message translates to:
  /// **'OAuth2'**
  String get oauth2;

  /// No description provided for @oauth2Description.
  ///
  /// In en, this message translates to:
  /// **'Authorize via Gitea OAuth2 application'**
  String get oauth2Description;

  /// No description provided for @oauth2ClientId.
  ///
  /// In en, this message translates to:
  /// **'Client ID'**
  String get oauth2ClientId;

  /// No description provided for @oauth2ClientSecret.
  ///
  /// In en, this message translates to:
  /// **'Client Secret'**
  String get oauth2ClientSecret;

  /// No description provided for @oauth2RedirectUri.
  ///
  /// In en, this message translates to:
  /// **'Redirect URI'**
  String get oauth2RedirectUri;

  /// No description provided for @oauth2RedirectUriHint.
  ///
  /// In en, this message translates to:
  /// **'igitea://oauth/callback'**
  String get oauth2RedirectUriHint;

  /// No description provided for @oauth2Authorize.
  ///
  /// In en, this message translates to:
  /// **'Open Authorization Page'**
  String get oauth2Authorize;

  /// No description provided for @oauth2ExchangeCode.
  ///
  /// In en, this message translates to:
  /// **'Exchange Code for Token'**
  String get oauth2ExchangeCode;

  /// No description provided for @oauth2AuthorizationCode.
  ///
  /// In en, this message translates to:
  /// **'Authorization Code'**
  String get oauth2AuthorizationCode;

  /// No description provided for @oauth2AuthorizationCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Paste the code from the redirect URL'**
  String get oauth2AuthorizationCodeHint;

  /// No description provided for @oauth2TokenRefreshed.
  ///
  /// In en, this message translates to:
  /// **'Token refreshed successfully'**
  String get oauth2TokenRefreshed;

  /// No description provided for @createLabel.
  ///
  /// In en, this message translates to:
  /// **'Create Label'**
  String get createLabel;

  /// No description provided for @editLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit Label'**
  String get editLabel;

  /// No description provided for @deleteLabel.
  ///
  /// In en, this message translates to:
  /// **'Delete Label'**
  String get deleteLabel;

  /// No description provided for @deleteLabelConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this label?'**
  String get deleteLabelConfirm;

  /// No description provided for @labelDeleted.
  ///
  /// In en, this message translates to:
  /// **'Label deleted'**
  String get labelDeleted;

  /// No description provided for @labelName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get labelName;

  /// No description provided for @labelNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. bug'**
  String get labelNameHint;

  /// No description provided for @labelDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get labelDescription;

  /// No description provided for @labelDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Optional description'**
  String get labelDescriptionHint;

  /// No description provided for @labelColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get labelColor;

  /// No description provided for @labelColorHint.
  ///
  /// In en, this message translates to:
  /// **'Hex color, e.g. #FF0000'**
  String get labelColorHint;

  /// No description provided for @filesChanged.
  ///
  /// In en, this message translates to:
  /// **'Files Changed'**
  String get filesChanged;

  /// No description provided for @noFilesChanged.
  ///
  /// In en, this message translates to:
  /// **'No files changed'**
  String get noFilesChanged;

  /// No description provided for @viewDiff.
  ///
  /// In en, this message translates to:
  /// **'View Diff'**
  String get viewDiff;

  /// No description provided for @unifiedView.
  ///
  /// In en, this message translates to:
  /// **'Unified view'**
  String get unifiedView;

  /// No description provided for @splitView.
  ///
  /// In en, this message translates to:
  /// **'Split view'**
  String get splitView;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr', 'ja', 'ko', 'pt', 'ru', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'zh': {
  switch (locale.countryCode) {
    case 'TW': return AppLocalizationsZhTw();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
    case 'ja': return AppLocalizationsJa();
    case 'ko': return AppLocalizationsKo();
    case 'pt': return AppLocalizationsPt();
    case 'ru': return AppLocalizationsRu();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
