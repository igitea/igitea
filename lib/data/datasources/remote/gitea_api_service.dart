// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import '../../../data/models/generated/generated_models.dart';
import 'api_client.dart';

/// Service layer for all Gitea API endpoints.
///
/// Methods are grouped by OpenAPI tag and ordered by priority.
class GiteaApiService {
  final ApiClient _client;

  GiteaApiService({required ApiClient client}) : _client = client;

  // Settings

  Future<GeneralAPISettings> getGeneralAPISettings() async {
    final response = await _client.get('/settings/api');
    return GeneralAPISettings.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<GeneralAttachmentSettings> getGeneralAttachmentSettings() async {
    final response = await _client.get('/settings/attachment');
    return GeneralAttachmentSettings.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<GeneralRepoSettings> getGeneralRepositorySettings() async {
    final response = await _client.get('/settings/repository');
    return GeneralRepoSettings.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<GeneralUISettings> getGeneralUISettings() async {
    final response = await _client.get('/settings/ui');
    return GeneralUISettings.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  // User

  Future<User> userGetCurrent() async {
    final response = await _client.get('/user');
    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<User> userGet({required String username}) async {
    final response = await _client.get(
      '/users/${Uri.encodeComponent(username)}',
    );
    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<Repository>> userListRepos({
    required String username,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/users/${Uri.encodeComponent(username)}/repos',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => Repository.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<User>> userListFollowers({
    required String username,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/users/${Uri.encodeComponent(username)}/followers',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<User>> userListFollowing({
    required String username,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/users/${Uri.encodeComponent(username)}/following',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Repository>> userCurrentListRepos({int? page, int? limit}) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get('/user/repos', queryParameters: query);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => Repository.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<AccessToken> userCreateToken({
    required String username,
    Map<String, dynamic>? body,
  }) async {
    final response = await _client.post(
      '/users/${Uri.encodeComponent(username)}/tokens',
      body: body,
    );
    return AccessToken.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<List<Email>> userListEmails() async {
    final response = await _client.get('/user/emails');
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => Email.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Email>> userAddEmail({Map<String, dynamic>? body}) async {
    final response = await _client.post('/user/emails', body: body);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => Email.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> userDeleteEmail({Map<String, dynamic>? body}) async {
    await _client.delete('/user/emails', body: body);
  }

  Future<List<PublicKey>> userListKeys({
    required String username,
    String? fingerprint,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (fingerprint != null) query['fingerprint'] = fingerprint;
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/users/${Uri.encodeComponent(username)}/keys',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => PublicKey.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<PublicKey>> userCurrentListKeys({
    String? fingerprint,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (fingerprint != null) query['fingerprint'] = fingerprint;
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get('/user/keys', queryParameters: query);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => PublicKey.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PublicKey> userCurrentPostKey({Map<String, dynamic>? body}) async {
    final response = await _client.post('/user/keys', body: body);
    return PublicKey.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<void> userCurrentDeleteKey({required int id}) async {
    await _client.delete('/user/keys/${id.toString()}');
  }

  // Repository

  Future<Repository> repoGet({
    required String owner,
    required String repo,
  }) async {
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}',
    );
    return Repository.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<void> repoDelete({required String owner, required String repo}) async {
    await _client.delete(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}',
    );
  }

  Future<Repository> repoEdit({
    required String owner,
    required String repo,
    Map<String, dynamic>? body,
  }) async {
    final response = await _client.patch(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}',
      body: body,
    );
    return Repository.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<PullRequest> repoCreatePullRequest({
    required String owner,
    required String repo,
    Map<String, dynamic>? body,
  }) async {
    final response = await _client.post(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/pulls',
      body: body,
    );
    return PullRequest.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<Repository> repoMigrate({Map<String, dynamic>? body}) async {
    final response = await _client.post('/repos/migrate', body: body);
    return Repository.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<List<Commit>> repoGetAllCommits({
    required String owner,
    required String repo,
    String? sha,
    String? path,
    DateTime? since,
    DateTime? until,
    bool? stat,
    bool? verification,
    bool? files,
    int? page,
    int? limit,
    String? not,
  }) async {
    final query = <String, String>{};
    if (sha != null) query['sha'] = sha;
    if (path != null) query['path'] = path;
    if (since != null) query['since'] = since.toIso8601String();
    if (until != null) query['until'] = until.toIso8601String();
    if (stat != null) query['stat'] = stat.toString();
    if (verification != null) query['verification'] = verification.toString();
    if (files != null) query['files'] = files.toString();
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    if (not != null) query['not'] = not;
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/commits',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => Commit.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Commit> repoGetSingleCommit({
    required String owner,
    required String repo,
    required String sha,
    bool? stat,
    bool? verification,
    bool? files,
  }) async {
    final query = <String, String>{};
    if (stat != null) query['stat'] = stat.toString();
    if (verification != null) query['verification'] = verification.toString();
    if (files != null) query['files'] = files.toString();
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/git/commits/${Uri.encodeComponent(sha)}',
      queryParameters: query,
    );
    return Commit.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  /// Compare two commits/branches.
  Future<Map<String, dynamic>> repoCompareDiff({
    required String owner,
    required String repo,
    required String basehead,
  }) async {
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/compare/${Uri.encodeComponent(basehead)}',
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Get a commit's raw diff text.
  Future<String> repoGetCommitDiff({
    required String owner,
    required String repo,
    required String sha,
  }) async {
    return _client.getRaw(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/git/commits/${Uri.encodeComponent(sha)}.diff',
    );
  }

  /// Get blame info for a file.
  Future<Map<String, dynamic>> repoGetBlame({
    required String owner,
    required String repo,
    required String ref,
    required String path,
  }) async {
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/git/blame/${Uri.encodeComponent(ref)}',
      queryParameters: {'path': path},
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<List<Branch>> repoListBranches({
    required String owner,
    required String repo,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/branches',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => Branch.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Branch> repoGetBranch({
    required String owner,
    required String repo,
    required String branch,
  }) async {
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/branches/${Uri.encodeComponent(branch)}',
    );
    return Branch.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<Tag>> repoListTags({
    required String owner,
    required String repo,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/tags',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => Tag.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Tag> repoGetTag({
    required String owner,
    required String repo,
    required String tag,
  }) async {
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/tags/${Uri.encodeComponent(tag)}',
    );
    return Tag.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<Release>> repoListReleases({
    required String owner,
    required String repo,
    bool? draft,
    bool? pre_release,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (draft != null) query['draft'] = draft.toString();
    if (pre_release != null) query['pre-release'] = pre_release.toString();
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/releases',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => Release.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Release> repoGetRelease({
    required String owner,
    required String repo,
    required int id,
  }) async {
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/releases/${id.toString()}',
    );
    return Release.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Release> repoCreateRelease({
    required String owner,
    required String repo,
    required CreateReleaseOption body,
  }) async {
    final response = await _client.post(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/releases',
      body: body.toJson(),
    );
    return Release.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Release> repoEditRelease({
    required String owner,
    required String repo,
    required int id,
    required EditReleaseOption body,
  }) async {
    final response = await _client.patch(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/releases/${id.toString()}',
      body: body.toJson(),
    );
    return Release.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> repoDeleteRelease({
    required String owner,
    required String repo,
    required int id,
  }) async {
    await _client.delete(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/releases/${id.toString()}',
    );
  }

  Future<List<User>> repoListCollaborators({
    required String owner,
    required String repo,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/collaborators',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> repoAddCollaborator({
    required String owner,
    required String repo,
    required String collaborator,
    Map<String, dynamic>? body,
  }) async {
    await _client.put(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/collaborators/${Uri.encodeComponent(collaborator)}',
      body: body,
    );
  }

  Future<void> repoDeleteCollaborator({
    required String owner,
    required String repo,
    required String collaborator,
  }) async {
    await _client.delete(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/collaborators/${Uri.encodeComponent(collaborator)}',
    );
  }

  Future<List<Hook>> repoListHooks({
    required String owner,
    required String repo,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/hooks',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => Hook.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Hook> repoCreateHook({
    required String owner,
    required String repo,
    Map<String, dynamic>? body,
  }) async {
    final response = await _client.post(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/hooks',
      body: body,
    );
    return Hook.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> repoDeleteHook({
    required String owner,
    required String repo,
    required int id,
  }) async {
    await _client.delete(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/hooks/${id.toString()}',
    );
  }

  Future<Hook> repoEditHook({
    required String owner,
    required String repo,
    required int id,
    Map<String, dynamic>? body,
  }) async {
    final response = await _client.patch(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/hooks/${id.toString()}',
      body: body,
    );
    return Hook.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<Hook>> orgListHooks({
    required String org,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get('/orgs/${Uri.encodeComponent(org)}/hooks', queryParameters: query);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => Hook.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Hook> orgCreateHook({
    required String org,
    required Map<String, dynamic> body,
  }) async {
    final response = await _client.post('/orgs/${Uri.encodeComponent(org)}/hooks', body: body);
    return Hook.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Hook> orgEditHook({
    required String org,
    required int id,
    required Map<String, dynamic> body,
  }) async {
    final response = await _client.patch('/orgs/${Uri.encodeComponent(org)}/hooks/${id.toString()}', body: body);
    return Hook.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> orgDeleteHook({
    required String org,
    required int id,
  }) async {
    await _client.delete('/orgs/${Uri.encodeComponent(org)}/hooks/${id.toString()}');
  }

  Future<List<ContentsResponse>> repoGetContents({
    required String owner,
    required String repo,
    String? path,
    String? ref,
  }) async {
    final query = <String, String>{};
    if (ref != null) query['ref'] = ref;
    final pathPart = path != null && path.isNotEmpty ? '/${Uri.encodeComponent(path)}' : '';
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/contents$pathPart',
      queryParameters: query,
    );
    final decoded = jsonDecode(response.body);
    if (decoded is List<dynamic>) {
      return decoded
          .map((e) => ContentsResponse.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [
      ContentsResponse.fromJson(decoded as Map<String, dynamic>),
    ];
  }

  Future<FileResponse> repoUpdateFile({
    required String owner,
    required String repo,
    required String filepath,
    required UpdateFileOptions body,
  }) async {
    final response = await _client.put(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/contents/${Uri.encodeComponent(filepath)}',
      body: body.toJson(),
    );
    return FileResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<PullRequest>> repoListPullRequests({
    required String owner,
    required String repo,
    String? state,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (state != null) query['state'] = state;
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/pulls',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => PullRequest.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PullRequest> repoGetPullRequest({
    required String owner,
    required String repo,
    required int index,
  }) async {
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/pulls/$index',
    );
    return PullRequest.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> repoMergePullRequest({
    required String owner,
    required String repo,
    required int index,
    MergePullRequestOption? body,
  }) async {
    await _client.post(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/pulls/$index/merge',
      body: body?.toJson(),
    );
  }

  Future<SearchResults> repoSearch({
    String? q,
    bool? topic,
    bool? includeDesc,
    int? uid,
    int? priority_owner_id,
    int? team_id,
    int? starredBy,
    bool? private,
    bool? is_private,
    bool? template,
    bool? archived,
    String? mode,
    bool? exclusive,
    String? sort,
    String? order,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (q != null) query['q'] = q;
    if (topic != null) query['topic'] = topic.toString();
    if (includeDesc != null) query['includeDesc'] = includeDesc.toString();
    if (uid != null) query['uid'] = uid.toString();
    if (priority_owner_id != null) {
      query['priority_owner_id'] = priority_owner_id.toString();
    }
    if (team_id != null) query['team_id'] = team_id.toString();
    if (starredBy != null) query['starredBy'] = starredBy.toString();
    if (private != null) query['private'] = private.toString();
    if (is_private != null) query['is_private'] = is_private.toString();
    if (template != null) query['template'] = template.toString();
    if (archived != null) query['archived'] = archived.toString();
    if (mode != null) query['mode'] = mode;
    if (exclusive != null) query['exclusive'] = exclusive.toString();
    if (sort != null) query['sort'] = sort;
    if (order != null) query['order'] = order;
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get('/repos/search', queryParameters: query);
    return SearchResults.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  // Issue

  Future<List<Issue>> issueListIssues({
    required String owner,
    required String repo,
    String? state,
    String? labels,
    String? q,
    String? type,
    String? milestones,
    DateTime? since,
    DateTime? before,
    String? created_by,
    String? assigned_by,
    String? mentioned_by,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (state != null) query['state'] = state;
    if (labels != null) query['labels'] = labels;
    if (q != null) query['q'] = q;
    if (type != null) query['type'] = type;
    if (milestones != null) query['milestones'] = milestones;
    if (since != null) query['since'] = since.toIso8601String();
    if (before != null) query['before'] = before.toIso8601String();
    if (created_by != null) query['created_by'] = created_by;
    if (assigned_by != null) query['assigned_by'] = assigned_by;
    if (mentioned_by != null) query['mentioned_by'] = mentioned_by;
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/issues',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => Issue.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Issue> issueGetIssue({
    required String owner,
    required String repo,
    required int index,
  }) async {
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/issues/${index.toString()}',
    );
    return Issue.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Issue> issueCreateIssue({
    required String owner,
    required String repo,
    Map<String, dynamic>? body,
  }) async {
    final response = await _client.post(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/issues',
      body: body,
    );
    return Issue.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Issue> issueEditIssue({
    required String owner,
    required String repo,
    required int index,
    Map<String, dynamic>? body,
  }) async {
    final response = await _client.patch(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/issues/${index.toString()}',
      body: body,
    );
    return Issue.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> issueDelete({
    required String owner,
    required String repo,
    required int index,
  }) async {
    await _client.delete(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/issues/${index.toString()}',
    );
  }

  Future<List<Comment>> issueGetComments({
    required String owner,
    required String repo,
    required int index,
    DateTime? since,
    DateTime? before,
  }) async {
    final query = <String, String>{};
    if (since != null) query['since'] = since.toIso8601String();
    if (before != null) query['before'] = before.toIso8601String();
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/issues/${index.toString()}/comments',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => Comment.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Comment> issueCreateComment({
    required String owner,
    required String repo,
    required int index,
    Map<String, dynamic>? body,
  }) async {
    final response = await _client.post(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/issues/${index.toString()}/comments',
      body: body,
    );
    return Comment.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Comment> issueEditComment({
    required String owner,
    required String repo,
    required int id,
    Map<String, dynamic>? body,
  }) async {
    final response = await _client.patch(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/issues/comments/${id.toString()}',
      body: body,
    );
    return Comment.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> issueDeleteComment({
    required String owner,
    required String repo,
    required int id,
  }) async {
    await _client.delete(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/issues/comments/${id.toString()}',
    );
  }

  Future<List<Label>> issueListLabels({
    required String owner,
    required String repo,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/labels',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => Label.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Label> issueCreateLabel({
    required String owner,
    required String repo,
    Map<String, dynamic>? body,
  }) async {
    final response = await _client.post(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/labels',
      body: body,
    );
    return Label.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Label> issueGetLabel({
    required String owner,
    required String repo,
    required int id,
  }) async {
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/labels/${id.toString()}',
    );
    return Label.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Label> issueEditLabel({
    required String owner,
    required String repo,
    required int id,
    Map<String, dynamic>? body,
  }) async {
    final response = await _client.patch(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/labels/${id.toString()}',
      body: body,
    );
    return Label.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> issueDeleteLabel({
    required String owner,
    required String repo,
    required int id,
  }) async {
    await _client.delete(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/labels/${id.toString()}',
    );
  }

  Future<List<Milestone>> issueGetMilestonesList({
    required String owner,
    required String repo,
    String? state,
    String? name,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (state != null) query['state'] = state;
    if (name != null) query['name'] = name;
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/milestones',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => Milestone.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Milestone> issueGetMilestone({
    required String owner,
    required String repo,
    required String id,
  }) async {
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/milestones/${Uri.encodeComponent(id)}',
    );
    return Milestone.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<Milestone> issueCreateMilestone({
    required String owner,
    required String repo,
    Map<String, dynamic>? body,
  }) async {
    final response = await _client.post(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/milestones',
      body: body,
    );
    return Milestone.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<Milestone> issueEditMilestone({
    required String owner,
    required String repo,
    required String id,
    Map<String, dynamic>? body,
  }) async {
    final response = await _client.patch(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/milestones/${Uri.encodeComponent(id)}',
      body: body,
    );
    return Milestone.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<void> issueDeleteMilestone({
    required String owner,
    required String repo,
    required String id,
  }) async {
    await _client.delete(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/milestones/${Uri.encodeComponent(id)}',
    );
  }

  // Organization

  Future<Organization> orgGet({required String org}) async {
    final response = await _client.get('/orgs/${Uri.encodeComponent(org)}');
    return Organization.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<List<Organization>> orgListCurrentUserOrgs({
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get('/user/orgs', queryParameters: query);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => Organization.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Organization>> orgListUserOrgs({
    required String username,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/users/${Uri.encodeComponent(username)}/orgs',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => Organization.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Organization> orgCreate({Map<String, dynamic>? body}) async {
    final response = await _client.post('/orgs', body: body);
    return Organization.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<Organization> orgEdit({
    required String org,
    Map<String, dynamic>? body,
  }) async {
    final response = await _client.patch(
      '/orgs/${Uri.encodeComponent(org)}',
      body: body,
    );
    return Organization.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<void> orgDelete({required String org}) async {
    await _client.delete('/orgs/${Uri.encodeComponent(org)}');
  }

  Future<List<Repository>> orgListRepos({
    required String org,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/orgs/${Uri.encodeComponent(org)}/repos',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => Repository.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Team>> orgListTeams({
    required String org,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/orgs/${Uri.encodeComponent(org)}/teams',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => Team.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Team> orgGetTeam({required int id}) async {
    final response = await _client.get('/teams/${id.toString()}');
    return Team.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<User>> orgListTeamMembers({
    required int id,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/teams/${id.toString()}/members',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Repository>> orgListTeamRepos({
    required int id,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/teams/${id.toString()}/repos',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => Repository.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Team> orgCreateTeam({
    required String org,
    required CreateTeamOption body,
  }) async {
    final response = await _client.post(
      '/orgs/${Uri.encodeComponent(org)}/teams',
      body: body.toJson(),
    );
    return Team.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Team> orgEditTeam({
    required int id,
    required EditTeamOption body,
  }) async {
    final response = await _client.patch(
      '/teams/${id.toString()}',
      body: body.toJson(),
    );
    return Team.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> orgDeleteTeam({required int id}) async {
    await _client.delete('/teams/${id.toString()}');
  }

  Future<void> orgAddTeamMember({
    required int id,
    required String username,
  }) async {
    await _client.put('/teams/${id.toString()}/members/${Uri.encodeComponent(username)}');
  }

  Future<void> orgRemoveTeamMember({
    required int id,
    required String username,
  }) async {
    await _client.delete('/teams/${id.toString()}/members/${Uri.encodeComponent(username)}');
  }

  // Notification

  Future<List<NotificationThread>> notifyGetList({
    bool? all,
    List<String>? status_types,
    List<String>? subject_type,
    DateTime? since,
    DateTime? before,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (all != null) query['all'] = all.toString();
    if (status_types != null) query['status-types'] = status_types.join(',');
    if (subject_type != null) query['subject-type'] = subject_type.join(',');
    if (since != null) query['since'] = since.toIso8601String();
    if (before != null) query['before'] = before.toIso8601String();
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/notifications',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => NotificationThread.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<NotificationThread>> notifyGetRepoList({
    required String owner,
    required String repo,
    bool? all,
    List<String>? status_types,
    List<String>? subject_type,
    DateTime? since,
    DateTime? before,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (all != null) query['all'] = all.toString();
    if (status_types != null) query['status-types'] = status_types.join(',');
    if (subject_type != null) query['subject-type'] = subject_type.join(',');
    if (since != null) query['since'] = since.toIso8601String();
    if (before != null) query['before'] = before.toIso8601String();
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/notifications',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => NotificationThread.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> notifyReadList({
    DateTime? last_read_at,
    String? all,
    List<String>? status_types,
    String? to_status,
  }) async {
    final query = <String, String>{};
    if (last_read_at != null) {
      query['last_read_at'] = last_read_at.toIso8601String();
    }
    if (all != null) query['all'] = all;
    if (status_types != null) query['status-types'] = status_types.join(',');
    if (to_status != null) query['to-status'] = to_status;
    await _client.put('/notifications', queryParameters: query);
  }

  Future<NotificationCount> notifyNewAvailable() async {
    final response = await _client.get('/notifications/new');
    return NotificationCount.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<void> notifyReadThread({required String id, String? to_status}) async {
    final query = <String, String>{};
    if (to_status != null) query['to-status'] = to_status;
    await _client.patch(
      '/notifications/threads/${Uri.encodeComponent(id)}',
      queryParameters: query,
    );
  }

  // Package

  Future<List<Package>> listPackages({
    required String owner,
    int? page,
    int? limit,
    String? type,
    String? q,
  }) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    if (type != null) query['type'] = type;
    if (q != null) query['q'] = q;
    final response = await _client.get(
      '/packages/${Uri.encodeComponent(owner)}',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => Package.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Package>> listPackageVersions({
    required String owner,
    required String type,
    required String name,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/packages/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(type)}/${Uri.encodeComponent(name)}',
      queryParameters: query,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => Package.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Package> getPackage({
    required String owner,
    required String type,
    required String name,
    required String version,
  }) async {
    final response = await _client.get(
      '/packages/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(type)}/${Uri.encodeComponent(name)}/${Uri.encodeComponent(version)}',
    );
    return Package.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<PackageFile>> listPackageFiles({
    required String owner,
    required String type,
    required String name,
    required String version,
  }) async {
    final response = await _client.get(
      '/packages/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(type)}/${Uri.encodeComponent(name)}/${Uri.encodeComponent(version)}/files',
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => PackageFile.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> deletePackage({
    required String owner,
    required String type,
    required String name,
    required String version,
  }) async {
    await _client.delete(
      '/packages/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(type)}/${Uri.encodeComponent(name)}/${Uri.encodeComponent(version)}',
    );
  }

  // Admin

  Future<List<User>> adminSearchUsers({
    int? source_id,
    String? login_name,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (source_id != null) query['source_id'] = source_id.toString();
    if (login_name != null) query['login_name'] = login_name;
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get('/admin/users', queryParameters: query);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => User.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<User> adminCreateUser({Map<String, dynamic>? body}) async {
    final response = await _client.post('/admin/users', body: body);
    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> adminDeleteUser({required String username, bool? purge}) async {
    final query = <String, String>{};
    if (purge != null) query['purge'] = purge.toString();
    await _client.delete(
      '/admin/users/${Uri.encodeComponent(username)}',
      queryParameters: query,
    );
  }

  Future<User> adminEditUser({
    required String username,
    Map<String, dynamic>? body,
  }) async {
    final response = await _client.patch(
      '/admin/users/${Uri.encodeComponent(username)}',
      body: body,
    );
    return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<Organization>> adminGetAllOrgs({int? page, int? limit}) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get('/admin/orgs', queryParameters: query);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => Organization.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Cron>> adminCronList({int? page, int? limit}) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get('/admin/cron', queryParameters: query);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => Cron.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> adminCronRun({required String task}) async {
    await _client.post('/admin/cron/${Uri.encodeComponent(task)}');
  }

  Future<List<Hook>> adminListHooks({
    int? page,
    int? limit,
    String? type,
  }) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    if (type != null) query['type'] = type;
    final response = await _client.get('/admin/hooks', queryParameters: query);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => Hook.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Hook> adminGetHook({required int id}) async {
    final response = await _client.get('/admin/hooks/${id.toString()}');
    return Hook.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Hook> adminCreateHook({Map<String, dynamic>? body}) async {
    final response = await _client.post('/admin/hooks', body: body);
    return Hook.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> adminDeleteHook({required int id}) async {
    await _client.delete('/admin/hooks/${id.toString()}');
  }

  // Miscellaneous

  Future<List<String>> listGitignoresTemplates() async {
    final response = await _client.get('/gitignore/templates');
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.cast<String>();
  }

  Future<GitignoreTemplateInfo> getGitignoreTemplateInfo({
    required String name,
  }) async {
    final response = await _client.get(
      '/gitignore/templates/${Uri.encodeComponent(name)}',
    );
    return GitignoreTemplateInfo.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<List<Map<String, dynamic>>> listLabelTemplates() async {
    final response = await _client.get('/label/templates');
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => e as Map<String, dynamic>).toList();
  }

  Future<String> renderMarkdown({Map<String, dynamic>? body}) async {
    final response = await _client.post('/markdown', body: body);
    return response.body;
  }

  Future<String> renderMarkdownRaw({Map<String, dynamic>? body}) async {
    final response = await _client.post('/markdown/raw', body: body);
    return response.body;
  }

  Future<NodeInfo> getNodeInfo() async {
    final response = await _client.get('/nodeinfo');
    return NodeInfo.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<Issue>> issueSearchIssues({
    String? state,
    String? labels,
    String? milestones,
    String? q,
    int? priority_repo_id,
    String? type,
    DateTime? since,
    DateTime? before,
    bool? assigned,
    bool? created,
    bool? mentioned,
    bool? review_requested,
    bool? reviewed,
    String? owner,
    String? team,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (state != null) query['state'] = state;
    if (labels != null) query['labels'] = labels;
    if (milestones != null) query['milestones'] = milestones;
    if (q != null) query['q'] = q;
    if (priority_repo_id != null) query['priority_repo_id'] = priority_repo_id.toString();
    if (type != null) query['type'] = type;
    if (since != null) query['since'] = since.toIso8601String();
    if (before != null) query['before'] = before.toIso8601String();
    if (assigned != null) query['assigned'] = assigned.toString();
    if (created != null) query['created'] = created.toString();
    if (mentioned != null) query['mentioned'] = mentioned.toString();
    if (review_requested != null) query['review_requested'] = review_requested.toString();
    if (reviewed != null) query['reviewed'] = reviewed.toString();
    if (owner != null) query['owner'] = owner;
    if (team != null) query['team'] = team;
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get('/repos/issues/search', queryParameters: query);
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => Issue.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> userCurrentPutStar({required String owner, required String repo}) async {
    await _client.put('/user/starred/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}');
  }

  Future<void> userCurrentDeleteStar({required String owner, required String repo}) async {
    await _client.delete('/user/starred/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}');
  }

  Future<bool> userCurrentCheckStar({required String owner, required String repo}) async {
    try {
      await _client.get('/user/starred/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}');
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<List<Repository>> userCurrentListStarred({int? page, int? limit}) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/user/starred',
      queryParameters: query.isNotEmpty ? query : null,
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => Repository.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Repository> repoCreateFork({
    required String owner,
    required String repo,
    CreateForkOption? body,
  }) async {
    final response = await _client.post(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/forks',
      body: body?.toJson(),
    );
    return Repository.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<Repository> userCreateRepo({Map<String, dynamic>? body}) async {
    final response = await _client.post('/user/repos', body: body);
    return Repository.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<List<Activity>> listUserActivities(String username, {int? page, int? limit}) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();

    final response = await _client.get(
      '/users/${Uri.encodeComponent(username)}/activities/feeds',
      queryParameters: query.isNotEmpty ? query : null,
    );

    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => Activity.fromJson(e as Map<String, dynamic>)).toList();
  }

  // Activitypub

  Future<ActivityPub> activitypubPerson({required int user_id}) async {
    final response = await _client.get(
      '/activitypub/user-id/${user_id.toString()}',
    );
    return ActivityPub.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
    );
  }

  Future<void> activitypubPersonInbox({required int user_id}) async {
    await _client.post('/activitypub/user-id/${user_id.toString()}/inbox');
  }

  // Pull Request Diff

  Future<List<dynamic>> repoGetPullRequestFiles({
    required String owner,
    required String repo,
    required int index,
  }) async {
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/pulls/${index.toString()}/files',
    );
    return jsonDecode(response.body) as List<dynamic>;
  }

  Future<String> repoGetPullRequestDiff({
    required String owner,
    required String repo,
    required int index,
  }) async {
    return _client.getRaw(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/pulls/${index.toString()}.diff',
    );
  }

  // Pull Request Reviews

  Future<List<dynamic>> repoListPullReviews({
    required String owner,
    required String repo,
    required int index,
  }) async {
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/pulls/${index.toString()}/reviews',
    );
    return jsonDecode(response.body) as List<dynamic>;
  }

  Future<Map<String, dynamic>> repoCreatePullReview({
    required String owner,
    required String repo,
    required int index,
    required Map<String, dynamic> body,
  }) async {
    final response = await _client.post(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/pulls/${index.toString()}/reviews',
      body: body,
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Create review requests for a PR
  Future<void> repoCreatePullReviewRequests({
    required String owner,
    required String repo,
    required int index,
    required Map<String, dynamic> body,
  }) async {
    await _client.post(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/pulls/${index.toString()}/requested_reviewers',
      body: body,
    );
  }

  /// Subscribe to an issue
  Future<void> issueAddSubscription({
    required String owner,
    required String repo,
    required int index,
  }) async {
    await _client.put(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/issues/${index.toString()}/subscriptions',
    );
  }

  /// Set issue due date
  Future<Map<String, dynamic>> issueEditDeadline({
    required String owner,
    required String repo,
    required int index,
    required Map<String, dynamic> body,
  }) async {
    final response = await _client.post(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/issues/${index.toString()}/deadline',
      body: body,
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// List repository topics
  Future<List<String>> repoListTopics({
    required String owner,
    required String repo,
  }) async {
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/topics',
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return (data['topics'] as List<dynamic>?)?.cast<String>() ?? [];
  }

  /// List branch protections
  Future<List<dynamic>> repoListBranchProtections({
    required String owner,
    required String repo,
  }) async {
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/branch_protections',
    );
    return jsonDecode(response.body) as List<dynamic>;
  }

  /// Create branch protection
  Future<Map<String, dynamic>> repoCreateBranchProtection({
    required String owner,
    required String repo,
    required Map<String, dynamic> body,
  }) async {
    final response = await _client.post(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/branch_protections',
      body: body,
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> repoGetBranchProtection({
    required String owner,
    required String repo,
    required String name,
  }) async {
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/branch_protections/${Uri.encodeComponent(name)}',
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> repoEditBranchProtection({
    required String owner,
    required String repo,
    required String name,
    required Map<String, dynamic> body,
  }) async {
    final response = await _client.patch(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/branch_protections/${Uri.encodeComponent(name)}',
      body: body,
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<void> repoDeleteBranchProtection({
    required String owner,
    required String repo,
    required String name,
  }) async {
    await _client.delete(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/branch_protections/${Uri.encodeComponent(name)}',
    );
  }

  // Actions

  Future<Map<String, dynamic>> repoListActionWorkflows({
    required String owner,
    required String repo,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/actions/workflows',
      queryParameters: query,
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> repoListActionRuns({
    required String owner,
    required String repo,
    String? actor,
    String? branch,
    String? status,
    int? page,
    int? limit,
  }) async {
    final query = <String, String>{};
    if (actor != null) query['actor'] = actor;
    if (branch != null) query['branch'] = branch;
    if (status != null) query['status'] = status;
    if (page != null) query['page'] = page.toString();
    if (limit != null) query['limit'] = limit.toString();
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/actions/runs',
      queryParameters: query,
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> repoGetActionRun({
    required String owner,
    required String repo,
    required int run,
  }) async {
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/actions/runs/$run',
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> repoListActionJobs({
    required String owner,
    required String repo,
    required int run,
  }) async {
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/actions/runs/$run/jobs',
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<String> repoGetActionJobLogs({
    required String owner,
    required String repo,
    required int jobId,
  }) async {
    return _client.getRaw(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/actions/jobs/$jobId/logs',
    );
  }

  Future<Map<String, dynamic>> repoListActionArtifacts({
    required String owner,
    required String repo,
  }) async {
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/actions/artifacts',
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  /// Download an artifact as raw bytes.
  Future<List<int>> repoDownloadArtifact({
    required String owner,
    required String repo,
    required int artifactId,
  }) async {
    final response = await _client.getBytes(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/actions/artifacts/$artifactId/zip',
    );
    return response;
  }

  // Wiki

  Future<List<WikiPageMetaData>> repoGetWikiPages({
    required String owner,
    required String repo,
  }) async {
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/wiki/pages',
    );
    final list = jsonDecode(response.body) as List<dynamic>;
    return list.map((e) => WikiPageMetaData.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<WikiPage> repoGetWikiPage({
    required String owner,
    required String repo,
    required String pageName,
  }) async {
    final response = await _client.get(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/wiki/page/${Uri.encodeComponent(pageName)}',
    );
    return WikiPage.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<WikiPage> repoCreateWikiPage({
    required String owner,
    required String repo,
    required Map<String, dynamic> body,
  }) async {
    final response = await _client.post(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/wiki/new',
      body: body,
    );
    return WikiPage.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<WikiPage> repoEditWikiPage({
    required String owner,
    required String repo,
    required String pageName,
    required Map<String, dynamic> body,
  }) async {
    final response = await _client.patch(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/wiki/page/${Uri.encodeComponent(pageName)}',
      body: body,
    );
    return WikiPage.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> repoDeleteWikiPage({
    required String owner,
    required String repo,
    required String pageName,
  }) async {
    await _client.delete(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/wiki/page/${Uri.encodeComponent(pageName)}',
    );
  }

  /// Exchange an OAuth2 authorization code for an access token.
  /// Uses a direct POST without API version prefix.
  Future<Map<String, dynamic>> oauth2ExchangeCode({
    required String baseUrl,
    required String clientId,
    required String clientSecret,
    required String code,
    required String redirectUri,
  }) async {
    final response = await _client.postRaw(
      baseUrl,
      '/login/oauth/access_token',
      body: {
        'client_id': clientId,
        'client_secret': clientSecret,
        'code': code,
        'redirect_uri': redirectUri,
        'grant_type': 'authorization_code',
      },
    );
    return jsonDecode(response.body) as Map<String, dynamic>;
  }

  Future<List<Label>> issueReplaceLabels({
    required String owner,
    required String repo,
    required int index,
    required Map<String, dynamic> body,
  }) async {
    final response = await _client.put(
      '/repos/${Uri.encodeComponent(owner)}/${Uri.encodeComponent(repo)}/issues/${index.toString()}/labels',
      body: body,
    );
    return (jsonDecode(response.body) as List<dynamic>)
        .map((e) => Label.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
