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
import '../../presentation/state/package_notifier.dart';
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
  static late SearchPublicUsersUseCase searchPublicUsersUseCase;
  static late GetRepoUseCase getRepoUseCase;
  static late SearchReposUseCase searchReposUseCase;
  static late ListBranchesUseCase listBranchesUseCase;
  static late ListTagsUseCase listTagsUseCase;
  static late ListCommitsUseCase listCommitsUseCase;
  static late GetCommitUseCase getCommitUseCase;
  static late GetTagUseCase getTagUseCase;
  static late ListReleasesUseCase listReleasesUseCase;
  static late CreateReleaseUseCase createReleaseUseCase;
  static late EditReleaseUseCase editReleaseUseCase;
  static late DeleteReleaseUseCase deleteReleaseUseCase;
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
  static late ListHooksUseCase listHooksUseCase;
  static late CreateHookUseCase createHookUseCase;
  static late DeleteHookUseCase deleteHookUseCase;
  static late ListCollaboratorsUseCase listCollaboratorsUseCase;
  static late AddCollaboratorUseCase addCollaboratorUseCase;
  static late RemoveCollaboratorUseCase removeCollaboratorUseCase;
  static late ListIssuesUseCase listIssuesUseCase;
  static late GetIssueUseCase getIssueUseCase;
  static late CreateIssueUseCase createIssueUseCase;
  static late EditIssueUseCase editIssueUseCase;
  static late ListCommentsUseCase listCommentsUseCase;
  static late CreateCommentUseCase createCommentUseCase;
  static late SearchIssuesUseCase searchIssuesUseCase;
  static late ListLabelsUseCase listLabelsUseCase;
  static late CreateLabelUseCase createLabelUseCase;
  static late EditLabelUseCase editLabelUseCase;
  static late DeleteLabelUseCase deleteLabelUseCase;
  static late ReplaceIssueLabelsUseCase replaceIssueLabelsUseCase;
  static late ListMilestonesUseCase listMilestonesUseCase;
  static late CreateMilestoneUseCase createMilestoneUseCase;
  static late GetMilestoneUseCase getMilestoneUseCase;
  static late EditMilestoneUseCase editMilestoneUseCase;
  static late DeleteMilestoneUseCase deleteMilestoneUseCase;
  static late GetOrgUseCase getOrgUseCase;
  static late ListCurrentUserOrgsUseCase listCurrentUserOrgsUseCase;
  static late ListOrgReposUseCase listOrgReposUseCase;
  static late ListOrgTeamsUseCase listOrgTeamsUseCase;
  static late GetTeamUseCase getTeamUseCase;
  static late ListTeamMembersUseCase listTeamMembersUseCase;
  static late ListTeamReposUseCase listTeamReposUseCase;
  static late EditOrgUseCase editOrgUseCase;
  static late CreateOrgUseCase createOrgUseCase;
  static late CreateTeamUseCase createTeamUseCase;
  static late EditTeamUseCase editTeamUseCase;
  static late DeleteTeamUseCase deleteTeamUseCase;
  static late AddTeamMemberUseCase addTeamMemberUseCase;
  static late RemoveTeamMemberUseCase removeTeamMemberUseCase;
  static late ListNotificationsUseCase listNotificationsUseCase;
  static late ListRepoNotificationsUseCase listRepoNotificationsUseCase;
  static late MarkNotificationsReadUseCase markNotificationsReadUseCase;
  static late CheckNewNotificationsUseCase checkNewNotificationsUseCase;
  static late MarkThreadReadUseCase markThreadReadUseCase;
  static late ListPackagesUseCase listPackagesUseCase;
  static late GetPackageUseCase getPackageUseCase;
  static late ListPackageFilesUseCase listPackageFilesUseCase;
  static late ListPackageVersionsUseCase listPackageVersionsUseCase;
  static late DeletePackageUseCase deletePackageUseCase;
  static late SearchUsersUseCase searchUsersUseCase;
  static late CreateUserUseCase createUserUseCase;
  static late DeleteUserUseCase deleteUserUseCase;
  static late ListCronTasksUseCase listCronTasksUseCase;
  static late EditUserUseCase editUserUseCase;
  static late RunCronTaskUseCase runCronTaskUseCase;
  static late ListAdminHooksUseCase listAdminHooksUseCase;
  static late GetAdminHookUseCase getAdminHookUseCase;
  static late DeleteAdminHookUseCase deleteAdminHookUseCase;
  static late ListAdminRunnersUseCase listAdminRunnersUseCase;
  static late GetAdminRunnerUseCase getAdminRunnerUseCase;
  static late GetAdminRunnerRegistrationTokenUseCase getAdminRunnerRegistrationTokenUseCase;
  static late ListAdminEmailsUseCase listAdminEmailsUseCase;
  static late ListUserBadgesUseCase listUserBadgesUseCase;
  static late CreateUserBadgeUseCase createUserBadgeUseCase;
  static late DeleteUserBadgeUseCase deleteUserBadgeUseCase;
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
  static late PackageNotifier packageNotifier;
  static late ThemeNotifier themeNotifier;
  static late AdminNotifier adminNotifier;

  static bool _initialized = false;

  /// Asserts that all use cases have been initialized.
  /// Catches missing wiring in any of the 3 init paths.
  static void _assertUseCasesInitialized() {
    assert(getRepoUseCase != null);
    assert(listBranchesUseCase != null);
    assert(listCommitsUseCase != null);
    assert(getCommitUseCase != null);
    assert(listTagsUseCase != null);
    assert(getTagUseCase != null);
    assert(listReleasesUseCase != null);
    assert(getRepoContentsUseCase != null);
    assert(listPullRequestsUseCase != null);
    assert(getPullRequestUseCase != null);
    assert(starRepoUseCase != null);
    assert(unstarRepoUseCase != null);
    assert(checkStarredUseCase != null);
    assert(mergePullRequestUseCase != null);
    assert(createPullRequestUseCase != null);
    assert(editRepoUseCase != null);
    assert(deleteRepoUseCase != null);
    assert(updateFileUseCase != null);
    assert(createForkUseCase != null);
    assert(createRepoUseCase != null);
    assert(listWikiPagesUseCase != null);
    assert(getWikiPageUseCase != null);
    assert(createWikiPageUseCase != null);
    assert(editWikiPageUseCase != null);
    assert(deleteWikiPageUseCase != null);
    assert(listHooksUseCase != null);
    assert(createHookUseCase != null);
    assert(deleteHookUseCase != null);
    assert(listCollaboratorsUseCase != null);
    assert(addCollaboratorUseCase != null);
    assert(removeCollaboratorUseCase != null);
    assert(listIssuesUseCase != null);
    assert(getIssueUseCase != null);
    assert(createIssueUseCase != null);
    assert(editIssueUseCase != null);
    assert(listCommentsUseCase != null);
    assert(createCommentUseCase != null);
    assert(searchIssuesUseCase != null);
    assert(listLabelsUseCase != null);
    assert(createLabelUseCase != null);
    assert(editLabelUseCase != null);
    assert(deleteLabelUseCase != null);
    assert(replaceIssueLabelsUseCase != null);
    assert(listMilestonesUseCase != null);
    assert(createMilestoneUseCase != null);
    assert(getMilestoneUseCase != null);
    assert(editMilestoneUseCase != null);
    assert(deleteMilestoneUseCase != null);
    assert(getOrgUseCase != null);
    assert(listCurrentUserOrgsUseCase != null);
    assert(listOrgReposUseCase != null);
    assert(listOrgTeamsUseCase != null);
    assert(getTeamUseCase != null);
    assert(listTeamMembersUseCase != null);
    assert(listTeamReposUseCase != null);
    assert(editOrgUseCase != null);
    assert(createOrgUseCase != null);
    assert(createTeamUseCase != null);
    assert(editTeamUseCase != null);
    assert(deleteTeamUseCase != null);
    assert(addTeamMemberUseCase != null);
    assert(removeTeamMemberUseCase != null);
    assert(listNotificationsUseCase != null);
    assert(listRepoNotificationsUseCase != null);
    assert(markNotificationsReadUseCase != null);
    assert(checkNewNotificationsUseCase != null);
    assert(markThreadReadUseCase != null);
    assert(listPackagesUseCase != null);
    assert(getPackageUseCase != null);
    assert(listPackageFilesUseCase != null);
    assert(listPackageVersionsUseCase != null);
    assert(deletePackageUseCase != null);
    assert(searchUsersUseCase != null);
    assert(createUserUseCase != null);
    assert(deleteUserUseCase != null);
    assert(listCronTasksUseCase != null);
    assert(editUserUseCase != null);
    assert(runCronTaskUseCase != null);
    assert(listAdminHooksUseCase != null);
    assert(getAdminHookUseCase != null);
    assert(deleteAdminHookUseCase != null);
    assert(listAdminRunnersUseCase != null);
    assert(getAdminRunnerUseCase != null);
    assert(getAdminRunnerRegistrationTokenUseCase != null);
    assert(listAdminEmailsUseCase != null);
    assert(listUserBadgesUseCase != null);
    assert(createUserBadgeUseCase != null);
    assert(deleteUserBadgeUseCase != null);
    assert(getGitignoreTemplatesUseCase != null);
    assert(renderMarkdownUseCase != null);
    assert(getNodeInfoUseCase != null);
    assert(getGeneralAPISettingsUseCase != null);
    assert(getGeneralUISettingsUseCase != null);
    assert(getGeneralAttachmentSettingsUseCase != null);
    assert(getGeneralRepoSettingsUseCase != null);
  }

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
    searchPublicUsersUseCase = SearchPublicUsersUseCase(repository: userRepository);
    getRepoUseCase = GetRepoUseCase(repository: repoRepository);
    searchReposUseCase = SearchReposUseCase(repository: repoRepository);
    listBranchesUseCase = ListBranchesUseCase(repository: repoRepository);
    listTagsUseCase = ListTagsUseCase(repository: repoRepository);
    listCommitsUseCase = ListCommitsUseCase(repository: repoRepository);
    getCommitUseCase = GetCommitUseCase(repository: repoRepository);
    getTagUseCase = GetTagUseCase(repository: repoRepository);
    listReleasesUseCase = ListReleasesUseCase(repository: repoRepository);
    createReleaseUseCase = CreateReleaseUseCase(repository: repoRepository);
    editReleaseUseCase = EditReleaseUseCase(repository: repoRepository);
    deleteReleaseUseCase = DeleteReleaseUseCase(repository: repoRepository);
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
    listHooksUseCase = ListHooksUseCase(repository: repoRepository);
    createHookUseCase = CreateHookUseCase(repository: repoRepository);
    deleteHookUseCase = DeleteHookUseCase(repository: repoRepository);
    listCollaboratorsUseCase = ListCollaboratorsUseCase(repository: repoRepository);
    addCollaboratorUseCase = AddCollaboratorUseCase(repository: repoRepository);
    removeCollaboratorUseCase = RemoveCollaboratorUseCase(repository: repoRepository);
    listIssuesUseCase = ListIssuesUseCase(repository: issueRepository);
    getIssueUseCase = GetIssueUseCase(repository: issueRepository);
    createIssueUseCase = CreateIssueUseCase(repository: issueRepository);
    editIssueUseCase = EditIssueUseCase(repository: issueRepository);
    listCommentsUseCase = ListCommentsUseCase(repository: issueRepository);
    createCommentUseCase = CreateCommentUseCase(repository: issueRepository);
    searchIssuesUseCase = SearchIssuesUseCase(repository: issueRepository);
    listLabelsUseCase = ListLabelsUseCase(repository: issueRepository);
    createLabelUseCase = CreateLabelUseCase(repository: issueRepository);
    editLabelUseCase = EditLabelUseCase(repository: issueRepository);
    deleteLabelUseCase = DeleteLabelUseCase(repository: issueRepository);
    replaceIssueLabelsUseCase = ReplaceIssueLabelsUseCase(repository: issueRepository);
    listMilestonesUseCase = ListMilestonesUseCase(repository: issueRepository);
    createMilestoneUseCase = CreateMilestoneUseCase(
      repository: issueRepository,
    );
    getMilestoneUseCase = GetMilestoneUseCase(repository: issueRepository);
    editMilestoneUseCase = EditMilestoneUseCase(repository: issueRepository);
    deleteMilestoneUseCase = DeleteMilestoneUseCase(repository: issueRepository);
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
    createTeamUseCase = CreateTeamUseCase(repository: organizationRepository);
    editTeamUseCase = EditTeamUseCase(repository: organizationRepository);
    deleteTeamUseCase = DeleteTeamUseCase(repository: organizationRepository);
    addTeamMemberUseCase = AddTeamMemberUseCase(repository: organizationRepository);
    removeTeamMemberUseCase = RemoveTeamMemberUseCase(repository: organizationRepository);
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
    listPackageFilesUseCase = ListPackageFilesUseCase(repository: packageRepository);
    listPackageVersionsUseCase = ListPackageVersionsUseCase(repository: packageRepository);
    deletePackageUseCase = DeletePackageUseCase(repository: packageRepository);
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
    listAdminHooksUseCase = ListAdminHooksUseCase(repository: adminRepository);
    getAdminHookUseCase = GetAdminHookUseCase(repository: adminRepository);
    deleteAdminHookUseCase = DeleteAdminHookUseCase(repository: adminRepository);
    listAdminRunnersUseCase = ListAdminRunnersUseCase(repository: adminRepository);
    getAdminRunnerUseCase = GetAdminRunnerUseCase(repository: adminRepository);
    getAdminRunnerRegistrationTokenUseCase = GetAdminRunnerRegistrationTokenUseCase(repository: adminRepository);
    listAdminEmailsUseCase = ListAdminEmailsUseCase(repository: adminRepository);
    listUserBadgesUseCase = ListUserBadgesUseCase(repository: adminRepository);
    createUserBadgeUseCase = CreateUserBadgeUseCase(repository: adminRepository);
    deleteUserBadgeUseCase = DeleteUserBadgeUseCase(repository: adminRepository);
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
    _assertUseCasesInitialized();

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
        searchPublicUsersUseCase: searchPublicUsersUseCase,
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
        createReleaseUseCase: createReleaseUseCase,
        editReleaseUseCase: editReleaseUseCase,
        deleteReleaseUseCase: deleteReleaseUseCase,
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
        listHooksUseCase: listHooksUseCase,
        createHookUseCase: createHookUseCase,
        deleteHookUseCase: deleteHookUseCase,
        listCollaboratorsUseCase: listCollaboratorsUseCase,
        addCollaboratorUseCase: addCollaboratorUseCase,
        removeCollaboratorUseCase: removeCollaboratorUseCase,
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
        createMilestoneUseCase: createMilestoneUseCase,
        editMilestoneUseCase: editMilestoneUseCase,
        deleteMilestoneUseCase: deleteMilestoneUseCase,
        createLabelUseCase: createLabelUseCase,
        editLabelUseCase: editLabelUseCase,
        deleteLabelUseCase: deleteLabelUseCase,
      replaceIssueLabelsUseCase: replaceIssueLabelsUseCase,
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
        createTeamUseCase: createTeamUseCase,
        editTeamUseCase: editTeamUseCase,
        deleteTeamUseCase: deleteTeamUseCase,
        addTeamMemberUseCase: addTeamMemberUseCase,
        removeTeamMemberUseCase: removeTeamMemberUseCase,
      );
      notificationNotifier.updateUseCases(
        listNotificationsUseCase: listNotificationsUseCase,
        markThreadReadUseCase: markThreadReadUseCase,
        markNotificationsReadUseCase: markNotificationsReadUseCase,
        checkNewAvailableUseCase: checkNewNotificationsUseCase,
      );
      packageNotifier.updateUseCases(
        listPackagesUseCase: listPackagesUseCase,
        getPackageUseCase: getPackageUseCase,
        listPackageFilesUseCase: listPackageFilesUseCase,
        deletePackageUseCase: deletePackageUseCase,
        listPackageVersionsUseCase: listPackageVersionsUseCase,
      );
      adminNotifier.updateUseCases(
        searchUsersUseCase: searchUsersUseCase,
        createUserUseCase: createUserUseCase,
        editUserUseCase: editUserUseCase,
        deleteUserUseCase: deleteUserUseCase,
        listAdminHooksUseCase: listAdminHooksUseCase,
        getAdminHookUseCase: getAdminHookUseCase,
        deleteAdminHookUseCase: deleteAdminHookUseCase,
        listCronTasksUseCase: listCronTasksUseCase,
        runCronTaskUseCase: runCronTaskUseCase,
        listAdminRunnersUseCase: listAdminRunnersUseCase,
        getAdminRunnerUseCase: getAdminRunnerUseCase,
        getAdminRunnerRegistrationTokenUseCase: getAdminRunnerRegistrationTokenUseCase,
        listAdminEmailsUseCase: listAdminEmailsUseCase,
        listUserBadgesUseCase: listUserBadgesUseCase,
        createUserBadgeUseCase: createUserBadgeUseCase,
        deleteUserBadgeUseCase: deleteUserBadgeUseCase,
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
        searchPublicUsersUseCase: searchPublicUsersUseCase,
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
        createReleaseUseCase: createReleaseUseCase,
        editReleaseUseCase: editReleaseUseCase,
        deleteReleaseUseCase: deleteReleaseUseCase,
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
        listHooksUseCase: listHooksUseCase,
        createHookUseCase: createHookUseCase,
        deleteHookUseCase: deleteHookUseCase,
        listCollaboratorsUseCase: listCollaboratorsUseCase,
        addCollaboratorUseCase: addCollaboratorUseCase,
        removeCollaboratorUseCase: removeCollaboratorUseCase,
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
        createMilestoneUseCase: createMilestoneUseCase,
        editMilestoneUseCase: editMilestoneUseCase,
        deleteMilestoneUseCase: deleteMilestoneUseCase,
        createLabelUseCase: createLabelUseCase,
        editLabelUseCase: editLabelUseCase,
        deleteLabelUseCase: deleteLabelUseCase,
      replaceIssueLabelsUseCase: replaceIssueLabelsUseCase,
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
        createTeamUseCase: createTeamUseCase,
        editTeamUseCase: editTeamUseCase,
        deleteTeamUseCase: deleteTeamUseCase,
        addTeamMemberUseCase: addTeamMemberUseCase,
        removeTeamMemberUseCase: removeTeamMemberUseCase,
      );
      notificationNotifier = NotificationNotifier(
        listNotificationsUseCase: listNotificationsUseCase,
        markThreadReadUseCase: markThreadReadUseCase,
        markNotificationsReadUseCase: markNotificationsReadUseCase,
        checkNewAvailableUseCase: checkNewNotificationsUseCase,
      );
      themeNotifier = ThemeNotifier();
      packageNotifier = PackageNotifier(
        listPackagesUseCase: listPackagesUseCase,
        getPackageUseCase: getPackageUseCase,
        listPackageFilesUseCase: listPackageFilesUseCase,
        deletePackageUseCase: deletePackageUseCase,
        listPackageVersionsUseCase: listPackageVersionsUseCase,
      );
      adminNotifier = AdminNotifier(
        searchUsersUseCase: searchUsersUseCase,
        createUserUseCase: createUserUseCase,
        editUserUseCase: editUserUseCase,
        deleteUserUseCase: deleteUserUseCase,
        listAdminHooksUseCase: listAdminHooksUseCase,
        getAdminHookUseCase: getAdminHookUseCase,
        deleteAdminHookUseCase: deleteAdminHookUseCase,
        listCronTasksUseCase: listCronTasksUseCase,
        runCronTaskUseCase: runCronTaskUseCase,
        listAdminRunnersUseCase: listAdminRunnersUseCase,
        getAdminRunnerUseCase: getAdminRunnerUseCase,
        getAdminRunnerRegistrationTokenUseCase: getAdminRunnerRegistrationTokenUseCase,
        listAdminEmailsUseCase: listAdminEmailsUseCase,
        listUserBadgesUseCase: listUserBadgesUseCase,
        createUserBadgeUseCase: createUserBadgeUseCase,
        deleteUserBadgeUseCase: deleteUserBadgeUseCase,
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
    _assertUseCasesInitialized();

    authNotifier.updateUseCases(
      loginUseCase: loginUseCase,
      getSettingsUseCase: getSettingsUseCase,
    );
    userNotifier.updateUseCases(
      getCurrentUserUseCase: getCurrentUserUseCase,
      listCurrentUserReposUseCase: listCurrentUserReposUseCase,
      getUserActivitiesUseCase: getUserActivitiesUseCase,
      listStarredReposUseCase: listStarredReposUseCase,
      searchPublicUsersUseCase: searchPublicUsersUseCase,
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
      createReleaseUseCase: createReleaseUseCase,
      editReleaseUseCase: editReleaseUseCase,
      deleteReleaseUseCase: deleteReleaseUseCase,
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
      listHooksUseCase: listHooksUseCase,
      createHookUseCase: createHookUseCase,
      deleteHookUseCase: deleteHookUseCase,
      listCollaboratorsUseCase: listCollaboratorsUseCase,
      addCollaboratorUseCase: addCollaboratorUseCase,
      removeCollaboratorUseCase: removeCollaboratorUseCase,
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
      createMilestoneUseCase: createMilestoneUseCase,
      editMilestoneUseCase: editMilestoneUseCase,
      deleteMilestoneUseCase: deleteMilestoneUseCase,
      createLabelUseCase: createLabelUseCase,
      editLabelUseCase: editLabelUseCase,
      deleteLabelUseCase: deleteLabelUseCase,
      replaceIssueLabelsUseCase: replaceIssueLabelsUseCase,
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
      createTeamUseCase: createTeamUseCase,
      editTeamUseCase: editTeamUseCase,
      deleteTeamUseCase: deleteTeamUseCase,
      addTeamMemberUseCase: addTeamMemberUseCase,
      removeTeamMemberUseCase: removeTeamMemberUseCase,
    );
    notificationNotifier.updateUseCases(
      listNotificationsUseCase: listNotificationsUseCase,
      markThreadReadUseCase: markThreadReadUseCase,
      markNotificationsReadUseCase: markNotificationsReadUseCase,
      checkNewAvailableUseCase: checkNewNotificationsUseCase,
    );
    packageNotifier.updateUseCases(
      listPackagesUseCase: listPackagesUseCase,
      getPackageUseCase: getPackageUseCase,
      listPackageFilesUseCase: listPackageFilesUseCase,
      deletePackageUseCase: deletePackageUseCase,
      listPackageVersionsUseCase: listPackageVersionsUseCase,
    );
    adminNotifier.updateUseCases(
      searchUsersUseCase: searchUsersUseCase,
      createUserUseCase: createUserUseCase,
      editUserUseCase: editUserUseCase,
      deleteUserUseCase: deleteUserUseCase,
      listAdminHooksUseCase: listAdminHooksUseCase,
      getAdminHookUseCase: getAdminHookUseCase,
      deleteAdminHookUseCase: deleteAdminHookUseCase,
      listCronTasksUseCase: listCronTasksUseCase,
      runCronTaskUseCase: runCronTaskUseCase,
      listAdminRunnersUseCase: listAdminRunnersUseCase,
      getAdminRunnerUseCase: getAdminRunnerUseCase,
      getAdminRunnerRegistrationTokenUseCase: getAdminRunnerRegistrationTokenUseCase,
      listAdminEmailsUseCase: listAdminEmailsUseCase,
      listUserBadgesUseCase: listUserBadgesUseCase,
      createUserBadgeUseCase: createUserBadgeUseCase,
      deleteUserBadgeUseCase: deleteUserBadgeUseCase,
    );
  }
}
