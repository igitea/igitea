import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/errors/failures.dart';
import 'package:igitea/core/utils/either.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/domain/repositories/repo_repository.dart';
import 'package:igitea/domain/usecases/repo_usecases.dart';
import 'package:igitea/presentation/state/repo_notifier.dart';

class FakeRepoRepository implements RepoRepository {
  bool shouldFail = false;
  Failure failure = const ServerFailure('error');

  Repository repo = const Repository(id: 1, name: 'test-repo');
  SearchResults searchResults = const SearchResults(
    data: [Repository(id: 2, name: 'search-repo')],
    ok: true,
  );
  List<Branch> branches = const [Branch(name: 'main')];
  List<Commit> commits = const [Commit(sha: 'abc123')];
  List<Tag> tags = const [Tag(name: 'v1.0')];

  @override
  Future<Either<Failure, Repository>> getRepo(
    String owner,
    String repoName,
  ) async {
    if (shouldFail) return Left(failure);
    return Right(repo);
  }

  @override
  Future<Either<Failure, SearchResults>> searchRepos({
    String? q,
    int? uid,
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return Right(searchResults);
  }

  @override
  Future<Either<Failure, List<Branch>>> listBranches(
    String owner,
    String repoName, {
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return Right(branches);
  }

  @override
  Future<Either<Failure, List<Tag>>> listTags(
    String owner,
    String repoName, {
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return Right(tags);
  }

  @override
  Future<Either<Failure, List<Commit>>> listCommits(
    String owner,
    String repo, {
    String? sha,
    String? path,
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return Right(commits);
  }

  @override
  Future<Either<Failure, void>> deleteRepo(String owner, String repoName) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, Repository>> editRepo(
    String owner,
    String repoName,
    Map<String, dynamic> body,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, Repository>> migrateRepo(Map<String, dynamic> body) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, Repository>> createRepo(Map<String, dynamic> body) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, Branch>> getBranch(
    String owner,
    String repoName,
    String branch,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, Commit>> getCommit(
    String owner,
    String repoName,
    String sha,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, Tag>> getTag(
    String owner,
    String repoName,
    String tag,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<Release>>> listReleases(
    String owner,
    String repoName, {
    int? page,
    int? limit,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, Release>> getRelease(
    String owner,
    String repoName,
    int id,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<User>>> listCollaborators(
    String owner,
    String repoName, {
    int? page,
    int? limit,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> addCollaborator(
    String owner,
    String repoName,
    String collaborator,
    Map<String, dynamic> body,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> removeCollaborator(
    String owner,
    String repoName,
    String collaborator,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<Hook>>> listHooks(
    String owner,
    String repoName, {
    int? page,
    int? limit,
  }) => throw UnimplementedError();

  @override
  Future<Either<Failure, Hook>> createHook(
    String owner,
    String repoName,
    Map<String, dynamic> body,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> deleteHook(
    String owner,
    String repoName,
    int id,
  ) => throw UnimplementedError();

  @override
  Future<Either<Failure, List<ContentsResponse>>> getRepoContents(
    String owner,
    String repo, {
    String? path,
    String? ref,
  }) async {
    if (shouldFail) return Left(failure);
    return Right(<ContentsResponse>[]);
  }

  @override
  Future<Either<Failure, FileResponse>> updateFile(
    String owner,
    String repo,
    String filepath,
    UpdateFileOptions body,
  ) async {
    if (shouldFail) return Left(failure);
    return Right(const FileResponse(content: null, commit: null));
  }

  @override
  Future<Either<Failure, List<PullRequest>>> listPullRequests(
    String owner,
    String repo, {
    String? state,
    int? page,
    int? limit,
  }) async {
    if (shouldFail) return Left(failure);
    return Right(<PullRequest>[]);
  }

  @override
  Future<Either<Failure, PullRequest>> getPullRequest(
    String owner,
    String repo,
    int index,
  ) async {
    if (shouldFail) return Left(failure);
    return Right(const PullRequest());
  }

  @override
  Future<Either<Failure, PullRequest>> createPullRequest(
    String owner, String repo, Map<String, dynamic> body) => throw UnimplementedError();

  @override
  Future<Either<Failure, void>> starRepo(String owner, String repo) async {
    if (shouldFail) return Left(failure);
    return Right(null);
  }

  @override
  Future<Either<Failure, void>> unstarRepo(String owner, String repo) async {
    if (shouldFail) return Left(failure);
    return Right(null);
  }

  @override
  Future<Either<Failure, bool>> checkStarred(String owner, String repo) async {
    if (shouldFail) return Left(failure);
    return Right(false);
  }

  @override
  Future<Either<Failure, void>> mergePullRequest(
    String owner,
    String repo,
    int index, {
    MergePullRequestOption? body,
  }) async {
    if (shouldFail) return Left(failure);
    return Right(null);
  }

  @override
  Future<Either<Failure, Repository>> createFork(
    String owner,
    String repo, {
    CreateForkOption? body,
  }) async {
    if (shouldFail) return Left(failure);
    return Right(Repository(id: 2, name: '${repo}-fork'));
  }

  @override
  Future<Either<Failure, List<WikiPageMetaData>>> listWikiPages(
    String owner,
    String repo,
  ) async {
    if (shouldFail) return Left(failure);
    return Right(<WikiPageMetaData>[]);
  }

  @override
  Future<Either<Failure, WikiPage>> getWikiPage(
    String owner,
    String repo,
    String pageName,
  ) async {
    if (shouldFail) return Left(failure);
    return Right(const WikiPage());
  }

  @override
  Future<Either<Failure, WikiPage>> createWikiPage(
    String owner,
    String repo,
    String title,
    String content, {
    String? message,
  }) async {
    if (shouldFail) return Left(failure);
    return Right(const WikiPage());
  }

  @override
  Future<Either<Failure, WikiPage>> editWikiPage(
    String owner,
    String repo,
    String title,
    String content, {
    String? message,
  }) async {
    if (shouldFail) return Left(failure);
    return Right(const WikiPage());
  }

  @override
  Future<Either<Failure, void>> deleteWikiPage(
    String owner,
    String repo,
    String pageName,
  ) async {
    if (shouldFail) return Left(failure);
    return Right(null);
  }

  @override
  Future<Either<Failure, Release>> createRelease(
    String owner,
    String repo,
    CreateReleaseOption option,
  ) async {
    if (shouldFail) return Left(failure);
    return Right(Release(id: 1, tag_name: option.tag_name));
  }

  @override
  Future<Either<Failure, Release>> editRelease(
    String owner,
    String repo,
    int id,
    EditReleaseOption option,
  ) async {
    if (shouldFail) return Left(failure);
    return Right(Release(id: id, tag_name: option.tag_name));
  }

  @override
  Future<Either<Failure, void>> deleteRelease(
    String owner,
    String repo,
    int id,
  ) async {
    if (shouldFail) return Left(failure);
    return const Right(null);
  }
}

void main() {
  group('RepoNotifier', () {
    late FakeRepoRepository fakeRepo;
    late RepoNotifier notifier;

    setUp(() {
      fakeRepo = FakeRepoRepository();
      notifier = RepoNotifier(
        getRepoUseCase: GetRepoUseCase(repository: fakeRepo),
        searchReposUseCase: SearchReposUseCase(repository: fakeRepo),
        listBranchesUseCase: ListBranchesUseCase(repository: fakeRepo),
        listCommitsUseCase: ListCommitsUseCase(repository: fakeRepo),
        getCommitUseCase: GetCommitUseCase(repository: fakeRepo),
        listTagsUseCase: ListTagsUseCase(repository: fakeRepo),
        getTagUseCase: GetTagUseCase(repository: fakeRepo),
        getRepoContentsUseCase: GetRepoContentsUseCase(repository: fakeRepo),
        listPullRequestsUseCase: ListPullRequestsUseCase(repository: fakeRepo),
        getPullRequestUseCase: GetPullRequestUseCase(repository: fakeRepo),
        listReleasesUseCase: ListReleasesUseCase(repository: fakeRepo),
        createReleaseUseCase: CreateReleaseUseCase(repository: fakeRepo),
        editReleaseUseCase: EditReleaseUseCase(repository: fakeRepo),
        deleteReleaseUseCase: DeleteReleaseUseCase(repository: fakeRepo),
        starRepoUseCase: StarRepoUseCase(repository: fakeRepo),
        unstarRepoUseCase: UnstarRepoUseCase(repository: fakeRepo),
        checkStarredUseCase: CheckStarredUseCase(repository: fakeRepo),
        mergePullRequestUseCase: MergePullRequestUseCase(repository: fakeRepo),
        createPullRequestUseCase: CreatePullRequestUseCase(repository: fakeRepo),
        editRepoUseCase: EditRepoUseCase(repository: fakeRepo),
        deleteRepoUseCase: DeleteRepoUseCase(repository: fakeRepo),
        updateFileUseCase: UpdateFileUseCase(repository: fakeRepo),
        createForkUseCase: CreateForkUseCase(repository: fakeRepo),
        listWikiPagesUseCase: ListWikiPagesUseCase(repository: fakeRepo),
        getWikiPageUseCase: GetWikiPageUseCase(repository: fakeRepo),
        createWikiPageUseCase: CreateWikiPageUseCase(repository: fakeRepo),
        editWikiPageUseCase: EditWikiPageUseCase(repository: fakeRepo),
        deleteWikiPageUseCase: DeleteWikiPageUseCase(repository: fakeRepo),
        listHooksUseCase: ListHooksUseCase(repository: fakeRepo),
        createHookUseCase: CreateHookUseCase(repository: fakeRepo),
        deleteHookUseCase: DeleteHookUseCase(repository: fakeRepo),
      );
    });

    test('initial state is RepoInitial', () {
      expect(notifier.state, isA<RepoInitial>());
    });

    group('getRepo', () {
      test(
        'transitions through RepoLoading to RepoLoaded on success',
        () async {
          final states = <RepoState>[];
          notifier.addListener(() {
            states.add(notifier.state);
          });

          await notifier.getRepo('owner', 'repo');

          expect(states.length, 2);
          expect(states[0], isA<RepoLoading>());
          expect(states[1], isA<RepoLoaded>());

          final loaded = states[1] as RepoLoaded;
          expect(loaded.repo.id, 1);
          expect(loaded.repo.name, 'test-repo');
        },
      );

      test('transitions through RepoLoading to RepoError on failure', () async {
        fakeRepo.shouldFail = true;
        fakeRepo.failure = const ServerFailure('server error');

        final states = <RepoState>[];
        notifier.addListener(() {
          states.add(notifier.state);
        });

        await notifier.getRepo('owner', 'repo');

        expect(states.length, 2);
        expect(states[0], isA<RepoLoading>());
        expect(states[1], isA<RepoError>());

        final errorState = states[1] as RepoError;
        expect(errorState.message, 'server error');
      });

      test('notifyListeners called on each state change', () async {
        var notificationCount = 0;
        notifier.addListener(() {
          notificationCount++;
        });

        await notifier.getRepo('owner', 'repo');

        expect(notificationCount, 2);
      });
    });

    group('searchRepos', () {
      test(
        'transitions through RepoLoading to SearchResultsLoaded on success',
        () async {
          final states = <RepoState>[];
          notifier.addListener(() {
            states.add(notifier.state);
          });

          await notifier.searchRepos(q: 'test');

          expect(states.length, 2);
          expect(states[0], isA<RepoLoading>());
          expect(states[1], isA<SearchResultsLoaded>());

          final loaded = states[1] as SearchResultsLoaded;
          expect(loaded.results.ok, isTrue);
          expect(loaded.results.data?.length, 1);
        },
      );

      test('transitions through RepoLoading to RepoError on failure', () async {
        fakeRepo.shouldFail = true;
        fakeRepo.failure = const ServerFailure('search failed');

        await notifier.searchRepos(q: 'test');

        expect(notifier.state, isA<RepoError>());
        expect((notifier.state as RepoError).message, 'search failed');
      });
    });

    group('listBranches', () {
      test(
        'transitions through BranchesLoading to BranchesLoaded on success',
        () async {
          final states = <BranchesState>[];
          notifier.addListener(() {
            states.add(notifier.branchesState);
          });

          await notifier.listBranches('owner', 'repo');

          expect(states.length, 2);
          expect(states[0], isA<BranchesLoading>());
          expect(states[1], isA<BranchesLoaded>());

          final loaded = states[1] as BranchesLoaded;
          expect(loaded.branches.length, 1);
          expect(loaded.branches.first.name, 'main');
        },
      );

      test('transitions to BranchesError on failure', () async {
        fakeRepo.shouldFail = true;
        fakeRepo.failure = const ServerFailure('fail');

        await notifier.listBranches('owner', 'repo');

        expect(notifier.branchesState, isA<BranchesError>());
      });
    });

    group('listCommits', () {
      test(
        'transitions through CommitsLoading to CommitsLoaded on success',
        () async {
          final states = <CommitsState>[];
          notifier.addListener(() {
            states.add(notifier.commitsState);
          });

          await notifier.listCommits('owner', 'repo');

          expect(states.length, 2);
          expect(states[0], isA<CommitsLoading>());
          expect(states[1], isA<CommitsLoaded>());

          final loaded = states[1] as CommitsLoaded;
          expect(loaded.commits.length, 1);
          expect(loaded.commits.first.sha, 'abc123');
        },
      );

      test('transitions to CommitsError on failure', () async {
        fakeRepo.shouldFail = true;

        await notifier.listCommits('owner', 'repo');

        expect(notifier.commitsState, isA<CommitsError>());
      });
    });

    group('listTags', () {
      test(
        'transitions through TagsLoading to TagsLoaded on success',
        () async {
          final states = <TagsState>[];
          notifier.addListener(() {
            states.add(notifier.tagsState);
          });

          await notifier.listTags('owner', 'repo');

          expect(states.length, 2);
          expect(states[0], isA<TagsLoading>());
          expect(states[1], isA<TagsLoaded>());

          final loaded = states[1] as TagsLoaded;
          expect(loaded.tags.length, 1);
          expect(loaded.tags.first.name, 'v1.0');
        },
      );

      test('transitions to TagsError on failure', () async {
        fakeRepo.shouldFail = true;

        await notifier.listTags('owner', 'repo');

        expect(notifier.tagsState, isA<TagsError>());
      });
    });
  });
}
