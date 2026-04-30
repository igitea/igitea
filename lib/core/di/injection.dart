import '../../data/datasources/remote/api_client.dart';
import '../../data/datasources/remote/gitea_api_service.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../data/repositories/issue_repository_impl.dart';
import '../../data/repositories/misc_repository_impl.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../data/repositories/organization_repository_impl.dart';
import '../../data/repositories/package_repository_impl.dart';
import '../../data/repositories/repo_repository_impl.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/admin_repository.dart';
import '../../domain/repositories/issue_repository.dart';
import '../../domain/repositories/misc_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/repositories/organization_repository.dart';
import '../../domain/repositories/package_repository.dart';
import '../../domain/repositories/repo_repository.dart';
import '../../domain/repositories/user_repository.dart';
import '../../domain/usecases/admin_usecases.dart';
import '../../domain/usecases/auth_usecases.dart';
import '../../domain/usecases/issue_usecases.dart';
import '../../domain/usecases/misc_usecases.dart';
import '../../domain/usecases/notification_usecases.dart';
import '../../domain/usecases/organization_usecases.dart';
import '../../domain/usecases/package_usecases.dart';
import '../../domain/usecases/repo_usecases.dart';
import '../../domain/usecases/user_usecases.dart';
import '../../presentation/state/admin_notifier.dart';
import '../../presentation/state/auth_notifier.dart';
import '../../presentation/state/issue_notifier.dart';
import '../../presentation/state/notification_notifier.dart';
import '../../presentation/state/organization_notifier.dart';
import '../../presentation/state/repo_notifier.dart';
import '../../presentation/state/theme_notifier.dart';
import '../../presentation/state/user_notifier.dart';

class Injection {
  static late ApiClient apiClient;
  static late GiteaApiService apiService;

  static late UserRepository userRepository;
  static late RepoRepository repoRepository;
  static late IssueRepository issueRepository;
  static late OrganizationRepository organizationRepository;
  static late NotificationRepository notificationRepository;
  static late PackageRepository packageRepository;
  static late AdminRepository adminRepository;
  static late MiscRepository miscRepository;

  static late LoginUseCase loginUseCase;
  static late GetSettingsUseCase getSettingsUseCase;
  static late GetCurrentUserUseCase getCurrentUserUseCase;
  static late GetUserUseCase getUserUseCase;
  static late ListUserReposUseCase listUserReposUseCase;
  static late ListCurrentUserReposUseCase listCurrentUserReposUseCase;
  static late ListFollowersUseCase listFollowersUseCase;
  static late ListFollowingUseCase listFollowingUseCase;
  static late GetUserActivitiesUseCase getUserActivitiesUseCase;
  static late ListStarredReposUseCase listStarredReposUseCase;
  static late GetRepoUseCase getRepoUseCase;
  static late SearchReposUseCase searchReposUseCase;
  static late ListBranchesUseCase listBranchesUseCase;
  static late ListTagsUseCase listTagsUseCase;
  static late ListCommitsUseCase listCommitsUseCase;
  static late GetCommitUseCase getCommitUseCase;
  static late GetTagUseCase getTagUseCase;
  static late ListReleasesUseCase listReleasesUseCase;
  static late GetRepoContentsUseCase getRepoContentsUseCase;
  static late ListPullRequestsUseCase listPullRequestsUseCase;
  static late GetPullRequestUseCase getPullRequestUseCase;
  static late StarRepoUseCase starRepoUseCase;
  static late UnstarRepoUseCase unstarRepoUseCase;
  static late CheckStarredUseCase checkStarredUseCase;
  static late MergePullRequestUseCase mergePullRequestUseCase;
  static late CreatePullRequestUseCase createPullRequestUseCase;
  static late EditRepoUseCase editRepoUseCase;
  static late DeleteRepoUseCase deleteRepoUseCase;
  static late UpdateFileUseCase updateFileUseCase;
  static late CreateForkUseCase createForkUseCase;
  static late CreateRepoUseCase createRepoUseCase;
  static late ListWikiPagesUseCase listWikiPagesUseCase;
  static late GetWikiPageUseCase getWikiPageUseCase;
  static late CreateWikiPageUseCase createWikiPageUseCase;
  static late EditWikiPageUseCase editWikiPageUseCase;
  static late DeleteWikiPageUseCase deleteWikiPageUseCase;
  static late ListIssuesUseCase listIssuesUseCase;
  static late GetIssueUseCase getIssueUseCase;
  static late CreateIssueUseCase createIssueUseCase;
  static late EditIssueUseCase editIssueUseCase;
  static late ListCommentsUseCase listCommentsUseCase;
  static late CreateCommentUseCase createCommentUseCase;
  static late SearchIssuesUseCase searchIssuesUseCase;
  static late ListLabelsUseCase listLabelsUseCase;
  static late CreateLabelUseCase createLabelUseCase;
  static late ListMilestonesUseCase listMilestonesUseCase;
  static late CreateMilestoneUseCase createMilestoneUseCase;
  static late GetOrgUseCase getOrgUseCase;
  static late ListCurrentUserOrgsUseCase listCurrentUserOrgsUseCase;
  static late ListOrgReposUseCase listOrgReposUseCase;
  static late ListOrgTeamsUseCase listOrgTeamsUseCase;
  static late GetTeamUseCase getTeamUseCase;
  static late ListTeamMembersUseCase listTeamMembersUseCase;
  static late ListTeamReposUseCase listTeamReposUseCase;
  static late EditOrgUseCase editOrgUseCase;
  static late CreateOrgUseCase createOrgUseCase;
  static late ListNotificationsUseCase listNotificationsUseCase;
  static late ListRepoNotificationsUseCase listRepoNotificationsUseCase;
  static late MarkNotificationsReadUseCase markNotificationsReadUseCase;
  static late CheckNewNotificationsUseCase checkNewNotificationsUseCase;
  static late MarkThreadReadUseCase markThreadReadUseCase;
  static late ListPackagesUseCase listPackagesUseCase;
  static late GetPackageUseCase getPackageUseCase;
  static late SearchUsersUseCase searchUsersUseCase;
  static late CreateUserUseCase createUserUseCase;
  static late DeleteUserUseCase deleteUserUseCase;
  static late ListCronTasksUseCase listCronTasksUseCase;
  static late EditUserUseCase editUserUseCase;
  static late RunCronTaskUseCase runCronTaskUseCase;
  static late GetGitignoreTemplatesUseCase getGitignoreTemplatesUseCase;
  static late RenderMarkdownUseCase renderMarkdownUseCase;
  static late GetNodeInfoUseCase getNodeInfoUseCase;
  static late GetGeneralAPISettingsUseCase getGeneralAPISettingsUseCase;
  static late GetGeneralUISettingsUseCase getGeneralUISettingsUseCase;
  static late GetGeneralAttachmentSettingsUseCase getGeneralAttachmentSettingsUseCase;
  static late GetGeneralRepoSettingsUseCase getGeneralRepoSettingsUseCase;

  static late AuthNotifier authNotifier;
  static late UserNotifier userNotifier;
  static late RepoNotifier repoNotifier;
  static late IssueNotifier issueNotifier;
  static late OrgNotifier organizationNotifier;
  static late NotificationNotifier notificationNotifier;
  static late ThemeNotifier themeNotifier;
  static late AdminNotifier adminNotifier;

  static bool _initialized = false;

  static void _initRepositories() {
    userRepository = UserRepositoryImpl(apiService: apiService);
    repoRepository = RepoRepositoryImpl(apiService: apiService);
    issueRepository = IssueRepositoryImpl(apiService: apiService);
    organizationRepository = OrganizationRepositoryImpl(apiService: apiService);
    notificationRepository = NotificationRepositoryImpl(apiService: apiService);
    packageRepository = PackageRepositoryImpl(apiService: apiService);
    adminRepository = AdminRepositoryImpl(apiService: apiService);
    miscRepository = MiscRepositoryImpl(apiService: apiService);
  }

  static void _initUseCases() {
    loginUseCase = LoginUseCase(repository: userRepository);
    getSettingsUseCase = GetSettingsUseCase(repository: miscRepository);
    getCurrentUserUseCase = GetCurrentUserUseCase(repository: userRepository);
    getUserUseCase = GetUserUseCase(repository: userRepository);
    listUserReposUseCase = ListUserReposUseCase(repository: userRepository);
    listCurrentUserReposUseCase = ListCurrentUserReposUseCase(
      repository: userRepository,
    );
    listFollowersUseCase = ListFollowersUseCase(repository: userRepository);
    listFollowingUseCase = ListFollowingUseCase(repository: userRepository);
    getUserActivitiesUseCase = GetUserActivitiesUseCase(repository: userRepository);
    listStarredReposUseCase = ListStarredReposUseCase(repository: userRepository);
    getRepoUseCase = GetRepoUseCase(repository: repoRepository);
    searchReposUseCase = SearchReposUseCase(repository: repoRepository);
    listBranchesUseCase = ListBranchesUseCase(repository: repoRepository);
    listTagsUseCase = ListTagsUseCase(repository: repoRepository);
    listCommitsUseCase = ListCommitsUseCase(repository: repoRepository);
    getCommitUseCase = GetCommitUseCase(repository: repoRepository);
    getTagUseCase = GetTagUseCase(repository: repoRepository);
    listReleasesUseCase = ListReleasesUseCase(repository: repoRepository);
    getRepoContentsUseCase = GetRepoContentsUseCase(repository: repoRepository);
    listPullRequestsUseCase = ListPullRequestsUseCase(repository: repoRepository);
    getPullRequestUseCase = GetPullRequestUseCase(repository: repoRepository);
    starRepoUseCase = StarRepoUseCase(repository: repoRepository);
    unstarRepoUseCase = UnstarRepoUseCase(repository: repoRepository);
    checkStarredUseCase = CheckStarredUseCase(repository: repoRepository);
    mergePullRequestUseCase = MergePullRequestUseCase(repository: repoRepository);
    createPullRequestUseCase = CreatePullRequestUseCase(repository: repoRepository);
    editRepoUseCase = EditRepoUseCase(repository: repoRepository);
    deleteRepoUseCase = DeleteRepoUseCase(repository: repoRepository);
    updateFileUseCase = UpdateFileUseCase(repository: repoRepository);
    createForkUseCase = CreateForkUseCase(repository: repoRepository);
    createRepoUseCase = CreateRepoUseCase(repository: repoRepository);
    listWikiPagesUseCase = ListWikiPagesUseCase(repository: repoRepository);
    getWikiPageUseCase = GetWikiPageUseCase(repository: repoRepository);
    createWikiPageUseCase = CreateWikiPageUseCase(repository: repoRepository);
    editWikiPageUseCase = EditWikiPageUseCase(repository: repoRepository);
    deleteWikiPageUseCase = DeleteWikiPageUseCase(repository: repoRepository);
    listIssuesUseCase = ListIssuesUseCase(repository: issueRepository);
    getIssueUseCase = GetIssueUseCase(repository: issueRepository);
    createIssueUseCase = CreateIssueUseCase(repository: issueRepository);
    editIssueUseCase = EditIssueUseCase(repository: issueRepository);
    listCommentsUseCase = ListCommentsUseCase(repository: issueRepository);
    createCommentUseCase = CreateCommentUseCase(repository: issueRepository);
    searchIssuesUseCase = SearchIssuesUseCase(repository: issueRepository);
    listLabelsUseCase = ListLabelsUseCase(repository: issueRepository);
    createLabelUseCase = CreateLabelUseCase(repository: issueRepository);
    listMilestonesUseCase = ListMilestonesUseCase(repository: issueRepository);
    createMilestoneUseCase = CreateMilestoneUseCase(
      repository: issueRepository,
    );
    getOrgUseCase = GetOrgUseCase(repository: organizationRepository);
    listCurrentUserOrgsUseCase = ListCurrentUserOrgsUseCase(
      repository: organizationRepository,
    );
    listOrgReposUseCase = ListOrgReposUseCase(
      repository: organizationRepository,
    );
    listOrgTeamsUseCase = ListOrgTeamsUseCase(
      repository: organizationRepository,
    );
    getTeamUseCase = GetTeamUseCase(repository: organizationRepository);
    listTeamMembersUseCase = ListTeamMembersUseCase(
      repository: organizationRepository,
    );
    listTeamReposUseCase = ListTeamReposUseCase(
      repository: organizationRepository,
    );
    editOrgUseCase = EditOrgUseCase(repository: organizationRepository);
    createOrgUseCase = CreateOrgUseCase(repository: organizationRepository);
    listNotificationsUseCase = ListNotificationsUseCase(
      repository: notificationRepository,
    );
    listRepoNotificationsUseCase = ListRepoNotificationsUseCase(
      repository: notificationRepository,
    );
    markNotificationsReadUseCase = MarkNotificationsReadUseCase(
      repository: notificationRepository,
    );
    checkNewNotificationsUseCase = CheckNewNotificationsUseCase(
      repository: notificationRepository,
    );
    markThreadReadUseCase = MarkThreadReadUseCase(
      repository: notificationRepository,
    );
    listPackagesUseCase = ListPackagesUseCase(repository: packageRepository);
    getPackageUseCase = GetPackageUseCase(repository: packageRepository);
    searchUsersUseCase = SearchUsersUseCase(repository: adminRepository);
    createUserUseCase = CreateUserUseCase(repository: adminRepository);
    deleteUserUseCase = DeleteUserUseCase(repository: adminRepository);
    listCronTasksUseCase = ListCronTasksUseCase(repository: adminRepository);
    getGitignoreTemplatesUseCase = GetGitignoreTemplatesUseCase(
      repository: miscRepository,
    );
    renderMarkdownUseCase = RenderMarkdownUseCase(repository: miscRepository);
    getNodeInfoUseCase = GetNodeInfoUseCase(repository: miscRepository);
    getGeneralAPISettingsUseCase = GetGeneralAPISettingsUseCase(repository: miscRepository);
    getGeneralUISettingsUseCase = GetGeneralUISettingsUseCase(repository: miscRepository);
    getGeneralAttachmentSettingsUseCase = GetGeneralAttachmentSettingsUseCase(repository: miscRepository);
    getGeneralRepoSettingsUseCase = GetGeneralRepoSettingsUseCase(repository: miscRepository);
    editUserUseCase = EditUserUseCase(repository: adminRepository);
    runCronTaskUseCase = RunCronTaskUseCase(repository: adminRepository);
  }

  static void initialize({
    String? baseUrl,
    String? token,
    String? username,
    String? password,
  }) {
    apiClient = ApiClient(
      baseUrl: baseUrl ?? '',
      token: token,
      username: username,
      password: password,
    );
    apiService = GiteaApiService(client: apiClient);

    _initRepositories();
    _initUseCases();

    if (_initialized) {
      authNotifier.updateUseCases(
        loginUseCase: loginUseCase,
        getSettingsUseCase: getSettingsUseCase,
      );
      userNotifier.updateUseCases(
        getCurrentUserUseCase: getCurrentUserUseCase,
        listCurrentUserReposUseCase: listCurrentUserReposUseCase,
        getUserActivitiesUseCase: getUserActivitiesUseCase,
        listStarredReposUseCase: listStarredReposUseCase,
      );
      repoNotifier.updateUseCases(
        getRepoUseCase: getRepoUseCase,
        searchReposUseCase: searchReposUseCase,
        listBranchesUseCase: listBranchesUseCase,
        listCommitsUseCase: listCommitsUseCase,
        getCommitUseCase: getCommitUseCase,
        listTagsUseCase: listTagsUseCase,
        getTagUseCase: getTagUseCase,
        getRepoContentsUseCase: getRepoContentsUseCase,
        listPullRequestsUseCase: listPullRequestsUseCase,
        getPullRequestUseCase: getPullRequestUseCase,
        listReleasesUseCase: listReleasesUseCase,
        starRepoUseCase: starRepoUseCase,
        unstarRepoUseCase: unstarRepoUseCase,
        checkStarredUseCase: checkStarredUseCase,
        mergePullRequestUseCase: mergePullRequestUseCase,
        createPullRequestUseCase: createPullRequestUseCase,
        editRepoUseCase: editRepoUseCase,
        deleteRepoUseCase: deleteRepoUseCase,
        updateFileUseCase: updateFileUseCase,
        createForkUseCase: createForkUseCase,
        listWikiPagesUseCase: listWikiPagesUseCase,
        getWikiPageUseCase: getWikiPageUseCase,
        createWikiPageUseCase: createWikiPageUseCase,
        editWikiPageUseCase: editWikiPageUseCase,
        deleteWikiPageUseCase: deleteWikiPageUseCase,
      );
      issueNotifier.updateUseCases(
        listIssuesUseCase: listIssuesUseCase,
        getIssueUseCase: getIssueUseCase,
        createIssueUseCase: createIssueUseCase,
        editIssueUseCase: editIssueUseCase,
        listCommentsUseCase: listCommentsUseCase,
        createCommentUseCase: createCommentUseCase,
        searchIssuesUseCase: searchIssuesUseCase,
        listLabelsUseCase: listLabelsUseCase,
        listMilestonesUseCase: listMilestonesUseCase,
      );
      organizationNotifier.updateUseCases(
        getOrgUseCase: getOrgUseCase,
        listCurrentUserOrgsUseCase: listCurrentUserOrgsUseCase,
        listOrgReposUseCase: listOrgReposUseCase,
        listOrgTeamsUseCase: listOrgTeamsUseCase,
        getTeamUseCase: getTeamUseCase,
        listTeamMembersUseCase: listTeamMembersUseCase,
        listTeamReposUseCase: listTeamReposUseCase,
        editOrgUseCase: editOrgUseCase,
        createOrgUseCase: createOrgUseCase,
      );
      notificationNotifier.updateUseCases(
        listNotificationsUseCase: listNotificationsUseCase,
        markThreadReadUseCase: markThreadReadUseCase,
        markNotificationsReadUseCase: markNotificationsReadUseCase,
        checkNewAvailableUseCase: checkNewNotificationsUseCase,
      );
      adminNotifier.updateUseCases(
        searchUsersUseCase: searchUsersUseCase,
        createUserUseCase: createUserUseCase,
        editUserUseCase: editUserUseCase,
        deleteUserUseCase: deleteUserUseCase,
      );
    } else {
      authNotifier = AuthNotifier(
        loginUseCase: loginUseCase,
        getSettingsUseCase: getSettingsUseCase,
      );
      userNotifier = UserNotifier(
        getCurrentUserUseCase: getCurrentUserUseCase,
        listCurrentUserReposUseCase: listCurrentUserReposUseCase,
        getUserActivitiesUseCase: getUserActivitiesUseCase,
        listStarredReposUseCase: listStarredReposUseCase,
      );
      repoNotifier = RepoNotifier(
        getRepoUseCase: getRepoUseCase,
        searchReposUseCase: searchReposUseCase,
        listBranchesUseCase: listBranchesUseCase,
        listCommitsUseCase: listCommitsUseCase,
        getCommitUseCase: getCommitUseCase,
        listTagsUseCase: listTagsUseCase,
        getTagUseCase: getTagUseCase,
        getRepoContentsUseCase: getRepoContentsUseCase,
        listPullRequestsUseCase: listPullRequestsUseCase,
        getPullRequestUseCase: getPullRequestUseCase,
        listReleasesUseCase: listReleasesUseCase,
        starRepoUseCase: starRepoUseCase,
        unstarRepoUseCase: unstarRepoUseCase,
        checkStarredUseCase: checkStarredUseCase,
        mergePullRequestUseCase: mergePullRequestUseCase,
        createPullRequestUseCase: createPullRequestUseCase,
        editRepoUseCase: editRepoUseCase,
        deleteRepoUseCase: deleteRepoUseCase,
        updateFileUseCase: updateFileUseCase,
        createForkUseCase: createForkUseCase,
        listWikiPagesUseCase: listWikiPagesUseCase,
        getWikiPageUseCase: getWikiPageUseCase,
        createWikiPageUseCase: createWikiPageUseCase,
        editWikiPageUseCase: editWikiPageUseCase,
        deleteWikiPageUseCase: deleteWikiPageUseCase,
      );
      issueNotifier = IssueNotifier(
        listIssuesUseCase: listIssuesUseCase,
        getIssueUseCase: getIssueUseCase,
        createIssueUseCase: createIssueUseCase,
        editIssueUseCase: editIssueUseCase,
        listCommentsUseCase: listCommentsUseCase,
        createCommentUseCase: createCommentUseCase,
        searchIssuesUseCase: searchIssuesUseCase,
        listLabelsUseCase: listLabelsUseCase,
        listMilestonesUseCase: listMilestonesUseCase,
      );
      organizationNotifier = OrgNotifier(
        getOrgUseCase: getOrgUseCase,
        listCurrentUserOrgsUseCase: listCurrentUserOrgsUseCase,
        listOrgReposUseCase: listOrgReposUseCase,
        listOrgTeamsUseCase: listOrgTeamsUseCase,
        getTeamUseCase: getTeamUseCase,
        listTeamMembersUseCase: listTeamMembersUseCase,
        listTeamReposUseCase: listTeamReposUseCase,
        editOrgUseCase: editOrgUseCase,
        createOrgUseCase: createOrgUseCase,
      );
      notificationNotifier = NotificationNotifier(
        listNotificationsUseCase: listNotificationsUseCase,
        markThreadReadUseCase: markThreadReadUseCase,
        markNotificationsReadUseCase: markNotificationsReadUseCase,
        checkNewAvailableUseCase: checkNewNotificationsUseCase,
      );
      themeNotifier = ThemeNotifier();
      adminNotifier = AdminNotifier(
        searchUsersUseCase: searchUsersUseCase,
        createUserUseCase: createUserUseCase,
        editUserUseCase: editUserUseCase,
        deleteUserUseCase: deleteUserUseCase,
      );
      _initialized = true;
    }
  }

  static void updateAuth({
    String? baseUrl,
    String? token,
    String? username,
    String? password,
  }) {
    apiClient = ApiClient(
      baseUrl: baseUrl ?? '',
      token: token,
      username: username,
      password: password,
    );
    apiService = GiteaApiService(client: apiClient);

    _initRepositories();
    _initUseCases();

    authNotifier.updateUseCases(
      loginUseCase: loginUseCase,
      getSettingsUseCase: getSettingsUseCase,
    );
    userNotifier.updateUseCases(
      getCurrentUserUseCase: getCurrentUserUseCase,
      listCurrentUserReposUseCase: listCurrentUserReposUseCase,
      getUserActivitiesUseCase: getUserActivitiesUseCase,
      listStarredReposUseCase: listStarredReposUseCase,
    );
    repoNotifier.updateUseCases(
      getRepoUseCase: getRepoUseCase,
      searchReposUseCase: searchReposUseCase,
      listBranchesUseCase: listBranchesUseCase,
      listCommitsUseCase: listCommitsUseCase,
      getCommitUseCase: getCommitUseCase,
      listTagsUseCase: listTagsUseCase,
      getTagUseCase: getTagUseCase,
      getRepoContentsUseCase: getRepoContentsUseCase,
      listPullRequestsUseCase: listPullRequestsUseCase,
      getPullRequestUseCase: getPullRequestUseCase,
      listReleasesUseCase: listReleasesUseCase,
      starRepoUseCase: starRepoUseCase,
      unstarRepoUseCase: unstarRepoUseCase,
      checkStarredUseCase: checkStarredUseCase,
      mergePullRequestUseCase: mergePullRequestUseCase,
      createPullRequestUseCase: createPullRequestUseCase,
      editRepoUseCase: editRepoUseCase,
      deleteRepoUseCase: deleteRepoUseCase,
      updateFileUseCase: updateFileUseCase,
      createForkUseCase: createForkUseCase,
      listWikiPagesUseCase: listWikiPagesUseCase,
      getWikiPageUseCase: getWikiPageUseCase,
      createWikiPageUseCase: createWikiPageUseCase,
      editWikiPageUseCase: editWikiPageUseCase,
      deleteWikiPageUseCase: deleteWikiPageUseCase,
    );
    issueNotifier.updateUseCases(
      listIssuesUseCase: listIssuesUseCase,
      getIssueUseCase: getIssueUseCase,
      createIssueUseCase: createIssueUseCase,
      editIssueUseCase: editIssueUseCase,
      listCommentsUseCase: listCommentsUseCase,
      createCommentUseCase: createCommentUseCase,
      searchIssuesUseCase: searchIssuesUseCase,
      listLabelsUseCase: listLabelsUseCase,
      listMilestonesUseCase: listMilestonesUseCase,
    );
    organizationNotifier.updateUseCases(
      getOrgUseCase: getOrgUseCase,
      listCurrentUserOrgsUseCase: listCurrentUserOrgsUseCase,
      listOrgReposUseCase: listOrgReposUseCase,
      listOrgTeamsUseCase: listOrgTeamsUseCase,
      getTeamUseCase: getTeamUseCase,
      listTeamMembersUseCase: listTeamMembersUseCase,
      listTeamReposUseCase: listTeamReposUseCase,
      editOrgUseCase: editOrgUseCase,
      createOrgUseCase: createOrgUseCase,
    );
    notificationNotifier.updateUseCases(
      listNotificationsUseCase: listNotificationsUseCase,
      markThreadReadUseCase: markThreadReadUseCase,
      markNotificationsReadUseCase: markNotificationsReadUseCase,
      checkNewAvailableUseCase: checkNewNotificationsUseCase,
    );
    adminNotifier.updateUseCases(
      searchUsersUseCase: searchUsersUseCase,
      createUserUseCase: createUserUseCase,
      editUserUseCase: editUserUseCase,
      deleteUserUseCase: deleteUserUseCase,
    );
  }
}
