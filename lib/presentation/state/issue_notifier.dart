import 'package:flutter/material.dart';

import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/issue_usecases.dart';

sealed class IssueState {
  const IssueState();
}

class IssueInitial extends IssueState {
  const IssueInitial();
}

class IssueLoading extends IssueState {
  const IssueLoading();
}

class IssueDetailLoaded extends IssueState {
  final Issue issue;
  const IssueDetailLoaded(this.issue);
}

class LabelsLoaded extends IssueState {
  final List<Label> labels;
  const LabelsLoaded(this.labels);
}

class MilestonesLoaded extends IssueState {
  final List<Milestone> milestones;
  const MilestonesLoaded(this.milestones);
}

class IssueError extends IssueState {
  final String message;
  const IssueError(this.message);
}

class CommentsState {
  const CommentsState();
}

class CommentsInitial extends CommentsState {
  const CommentsInitial();
}

class CommentsLoading extends CommentsState {
  const CommentsLoading();
}

class CommentsLoaded extends CommentsState {
  final List<Comment> comments;
  final bool hasMore;
  const CommentsLoaded(this.comments, {this.hasMore = false});
}

class CommentsError extends CommentsState {
  final String message;
  const CommentsError(this.message);
}

sealed class IssuesListState {
  const IssuesListState();
}

class IssuesListInitial extends IssuesListState {
  const IssuesListInitial();
}

class IssuesListLoading extends IssuesListState {
  const IssuesListLoading();
}

class IssuesListLoaded extends IssuesListState {
  final List<Issue> issues;
  final bool hasMore;
  const IssuesListLoaded(this.issues, {this.hasMore = true});
}

class IssuesListError extends IssuesListState {
  final String message;
  const IssuesListError(this.message);
}

class IssueNotifier extends ChangeNotifier {
  ListIssuesUseCase _listIssuesUseCase;
  GetIssueUseCase _getIssueUseCase;
  CreateIssueUseCase _createIssueUseCase;
  EditIssueUseCase _editIssueUseCase;
  DeleteIssueUseCase _deleteIssueUseCase;
  ListCommentsUseCase _listCommentsUseCase;
  CreateCommentUseCase _createCommentUseCase;
  SearchIssuesUseCase _searchIssuesUseCase;
  ListLabelsUseCase _listLabelsUseCase;
  ListMilestonesUseCase _listMilestonesUseCase;
  CreateMilestoneUseCase _createMilestoneUseCase;
  EditMilestoneUseCase _editMilestoneUseCase;
  DeleteMilestoneUseCase _deleteMilestoneUseCase;
  CreateLabelUseCase _createLabelUseCase;
  EditLabelUseCase _editLabelUseCase;
  DeleteLabelUseCase _deleteLabelUseCase;
  ReplaceIssueLabelsUseCase _replaceIssueLabelsUseCase;

  IssueState _state = const IssueInitial();
  IssueState get state => _state;

  IssuesListState _issuesListState = const IssuesListInitial();
  IssuesListState get issuesListState => _issuesListState;

  CommentsState _commentsState = const CommentsInitial();
  CommentsState get commentsState => _commentsState;
  int _commentPage = 1;
  bool _commentLoadingMore = false;
  bool get commentLoadingMore => _commentLoadingMore;
  static const int _commentLimit = 20;

  String? lastSearchQuery;
  String? _issuesListFilter;
  String? get issuesListFilter => _issuesListFilter;

  static const _pageSize = 20;
  int _currentPage = 1;
  bool _loadingMore = false;
  bool get loadingMore => _loadingMore;

  IssueNotifier({
    required ListIssuesUseCase listIssuesUseCase,
    required GetIssueUseCase getIssueUseCase,
    required CreateIssueUseCase createIssueUseCase,
    required EditIssueUseCase editIssueUseCase,
    required DeleteIssueUseCase deleteIssueUseCase,
    required ListCommentsUseCase listCommentsUseCase,
    required CreateCommentUseCase createCommentUseCase,
    required SearchIssuesUseCase searchIssuesUseCase,
    required ListLabelsUseCase listLabelsUseCase,
    required ListMilestonesUseCase listMilestonesUseCase,
    required CreateMilestoneUseCase createMilestoneUseCase,
    required EditMilestoneUseCase editMilestoneUseCase,
    required DeleteMilestoneUseCase deleteMilestoneUseCase,
    required CreateLabelUseCase createLabelUseCase,
    required EditLabelUseCase editLabelUseCase,
    required DeleteLabelUseCase deleteLabelUseCase,
    required ReplaceIssueLabelsUseCase replaceIssueLabelsUseCase,
  }) : _listIssuesUseCase = listIssuesUseCase,
       _getIssueUseCase = getIssueUseCase,
       _createIssueUseCase = createIssueUseCase,
       _editIssueUseCase = editIssueUseCase,
       _deleteIssueUseCase = deleteIssueUseCase,
       _listCommentsUseCase = listCommentsUseCase,
       _createCommentUseCase = createCommentUseCase,
       _searchIssuesUseCase = searchIssuesUseCase,
       _listLabelsUseCase = listLabelsUseCase,
       _listMilestonesUseCase = listMilestonesUseCase,
       _createMilestoneUseCase = createMilestoneUseCase,
       _editMilestoneUseCase = editMilestoneUseCase,
       _deleteMilestoneUseCase = deleteMilestoneUseCase,
       _editLabelUseCase = editLabelUseCase,
       _deleteLabelUseCase = deleteLabelUseCase,
       _createLabelUseCase = createLabelUseCase,
       _replaceIssueLabelsUseCase = replaceIssueLabelsUseCase;

  void updateUseCases({
    required ListIssuesUseCase listIssuesUseCase,
    required GetIssueUseCase getIssueUseCase,
    required CreateIssueUseCase createIssueUseCase,
    required EditIssueUseCase editIssueUseCase,
    required DeleteIssueUseCase deleteIssueUseCase,
    required ListCommentsUseCase listCommentsUseCase,
    required CreateCommentUseCase createCommentUseCase,
    required SearchIssuesUseCase searchIssuesUseCase,
    required ListLabelsUseCase listLabelsUseCase,
    required ListMilestonesUseCase listMilestonesUseCase,
    required CreateMilestoneUseCase createMilestoneUseCase,
    required EditMilestoneUseCase editMilestoneUseCase,
    required DeleteMilestoneUseCase deleteMilestoneUseCase,
    required CreateLabelUseCase createLabelUseCase,
    required EditLabelUseCase editLabelUseCase,
    required DeleteLabelUseCase deleteLabelUseCase,
    required ReplaceIssueLabelsUseCase replaceIssueLabelsUseCase,
  }) {
    _listIssuesUseCase = listIssuesUseCase;
    _getIssueUseCase = getIssueUseCase;
    _createIssueUseCase = createIssueUseCase;
    _editIssueUseCase = editIssueUseCase;
    _deleteIssueUseCase = deleteIssueUseCase;
    _listCommentsUseCase = listCommentsUseCase;
    _createCommentUseCase = createCommentUseCase;
    _searchIssuesUseCase = searchIssuesUseCase;
    _listLabelsUseCase = listLabelsUseCase;
_listMilestonesUseCase = listMilestonesUseCase;
     _createMilestoneUseCase = createMilestoneUseCase;
    _editMilestoneUseCase = editMilestoneUseCase;
    _deleteMilestoneUseCase = deleteMilestoneUseCase;
    _editLabelUseCase = editLabelUseCase;
    _deleteLabelUseCase = deleteLabelUseCase;
    _replaceIssueLabelsUseCase = replaceIssueLabelsUseCase;
    _createLabelUseCase = createLabelUseCase;
  }

  Future<void> listIssues(ListIssuesParams params) async {
    _issuesListState = const IssuesListLoading();
    notifyListeners();

    final result = await _listIssuesUseCase.call(params);
    switch (result) {
      case Left<Failure, List<Issue>>(:final value):
        _issuesListState = IssuesListError(value.message);
        notifyListeners();
      case Right<Failure, List<Issue>>(:final value):
        _issuesListState = IssuesListLoaded(value);
        notifyListeners();
    }
  }

  Future<void> getIssue(String owner, String repo, int index) async {
    _state = const IssueLoading();
    notifyListeners();

    final result = await _getIssueUseCase.call(
      GetIssueParams(owner: owner, repo: repo, index: index),
    );
    switch (result) {
      case Left<Failure, Issue>(:final value):
        _state = IssueError(value.message);
        notifyListeners();
      case Right<Failure, Issue>(:final value):
         _state = IssueDetailLoaded(value);
         notifyListeners();
     }
   }

   Future<void> reloadIssue(String owner, String repo, int index) async {
     final result = await _getIssueUseCase.call(
       GetIssueParams(owner: owner, repo: repo, index: index),
     );
     switch (result) {
       case Right<Failure, Issue>(:final value):
         _state = IssueDetailLoaded(value);
         notifyListeners();
       case Left<Failure, Issue>():
         break;
     }
   }

   Future<void> createIssue(
    String owner,
    String repo,
    Map<String, dynamic> body,
  ) async {
    _state = const IssueLoading();
    notifyListeners();

    final result = await _createIssueUseCase.call(
      CreateIssueParams(owner: owner, repo: repo, body: body),
    );
    switch (result) {
      case Left<Failure, Issue>(:final value):
        _state = IssueError(value.message);
        notifyListeners();
      case Right<Failure, Issue>(:final value):
        _state = IssueDetailLoaded(value);
        notifyListeners();
    }
  }

  Future<void> listLabels(
    String owner,
    String repo, {
    int? page,
    int? limit,
  }) async {
    _state = const IssueLoading();
    notifyListeners();

    final result = await _listLabelsUseCase.call(
      ListLabelsParams(owner: owner, repo: repo, page: page, limit: limit),
    );
    switch (result) {
      case Left<Failure, List<Label>>(:final value):
        _state = IssueError(value.message);
        notifyListeners();
      case Right<Failure, List<Label>>(:final value):
        _state = LabelsLoaded(value);
        notifyListeners();
    }
  }

  Future<Either<Failure, Label>> createLabel(
    String owner,
    String repo,
    Map<String, dynamic> body,
  ) async {
    return _createLabelUseCase.call(
      CreateLabelParams(owner: owner, repo: repo, body: body),
    );
  }

  Future<Either<Failure, Label>> editLabel(
    String owner,
    String repo,
    int id,
    Map<String, dynamic> body,
  ) async {
    return _editLabelUseCase.call(
      EditLabelParams(owner: owner, repo: repo, id: id, body: body),
    );
  }

  Future<Either<Failure, void>> deleteLabel(
    String owner,
    String repo,
    int id,
  ) async {
    return _deleteLabelUseCase.call(
      DeleteLabelParams(owner: owner, repo: repo, id: id),
    );
  }

  Future<Either<Failure, List<Label>>> replaceIssueLabels(
    String owner,
    String repo,
    int index,
    Map<String, dynamic> body,
  ) async {
    return _replaceIssueLabelsUseCase.call(
      ReplaceIssueLabelsParams(
        owner: owner,
        repo: repo,
        index: index,
        body: body,
      ),
    );
  }

  Future<void> listMilestones(
    String owner,
    String repo, {
    String? state,
    String? name,
    int? page,
    int? limit,
  }) async {
    _state = const IssueLoading();
    notifyListeners();

    final result = await _listMilestonesUseCase.call(
      ListMilestonesParams(
        owner: owner,
        repo: repo,
        state: state,
        name: name,
        page: page,
        limit: limit,
      ),
    );
    switch (result) {
      case Left<Failure, List<Milestone>>(:final value):
        _state = IssueError(value.message);
        notifyListeners();
      case Right<Failure, List<Milestone>>(:final value):
        _state = MilestonesLoaded(value);
        notifyListeners();
    }
  }

  Future<Either<Failure, Milestone>> createMilestone(
    String owner,
    String repo,
    Map<String, dynamic> body,
  ) async {
    return _createMilestoneUseCase.call(
      CreateMilestoneParams(owner: owner, repo: repo, body: body),
    );
  }

  Future<Either<Failure, Milestone>> editMilestone(
    String owner,
    String repo,
    String id,
    Map<String, dynamic> body,
  ) async {
    return _editMilestoneUseCase.call(
      EditMilestoneParams(owner: owner, repo: repo, id: id, body: body),
    );
  }

  Future<Either<Failure, void>> deleteMilestone(
    String owner,
    String repo,
    int id,
  ) async {
    return _deleteMilestoneUseCase.call(
      DeleteMilestoneParams(owner: owner, repo: repo, id: id),
    );
  }

  Future<void> listComments(String owner, String repo, int index) async {
    _commentsState = const CommentsLoading();
    _commentPage = 1;
    notifyListeners();

    final result = await _listCommentsUseCase.call(
      ListCommentsParams(owner: owner, repo: repo, index: index, page: 1, limit: _commentLimit),
    );
    switch (result) {
      case Left<Failure, List<Comment>>(:final value):
        _commentsState = CommentsError(value.message);
        notifyListeners();
      case Right<Failure, List<Comment>>(:final value):
        _commentsState = CommentsLoaded(value, hasMore: value.length >= _commentLimit);
        notifyListeners();
    }
  }

  Future<void> loadMoreComments(String owner, String repo, int index) async {
    if (_commentLoadingMore) return;
    final current = _commentsState;
    if (current is! CommentsLoaded || !current.hasMore) return;

    _commentLoadingMore = true;
    notifyListeners();
    _commentPage++;

    final result = await _listCommentsUseCase.call(
      ListCommentsParams(owner: owner, repo: repo, index: index, page: _commentPage, limit: _commentLimit),
    );
    switch (result) {
      case Right<Failure, List<Comment>>(:final value):
        _commentsState = CommentsLoaded(
          [...current.comments, ...value],
          hasMore: value.length >= _commentLimit,
        );
      case Left<Failure, List<Comment>>():
        _commentPage--;
    }
    _commentLoadingMore = false;
    notifyListeners();
  }

  Future<void> createComment(
    String owner,
    String repo,
    int index,
    Map<String, dynamic> body,
  ) async {
    final result = await _createCommentUseCase.call(
      CreateCommentParams(owner: owner, repo: repo, index: index, body: body),
    );
    switch (result) {
      case Left<Failure, Comment>():
        break;
      case Right<Failure, Comment>():
        await listComments(owner, repo, index);
    }
  }

  Future<void> editIssue(
    String owner,
    String repo,
    int index,
    Map<String, dynamic> body,
  ) async {
    final result = await _editIssueUseCase.call(
      EditIssueParams(owner: owner, repo: repo, index: index, body: body),
    );
    switch (result) {
      case Left<Failure, Issue>(:final value):
        _state = IssueError(value.message);
        notifyListeners();
      case Right<Failure, Issue>(:final value):
        _state = IssueDetailLoaded(value);
        notifyListeners();
    }
  }

  Future<Either<Failure, void>> deleteIssue(String owner, String repo, int index) async {
    return _deleteIssueUseCase.call(
      DeleteIssueParams(owner: owner, repo: repo, index: index),
    );
  }

  Future<void> searchIssues(
    String query, {
    String? state,
    String? labels,
    String? milestones,
    bool? assigned,
  }) async {
    _issuesListFilter = state;
    _currentPage = 1;
    _issuesListState = const IssuesListLoading();
    notifyListeners();

    lastSearchQuery = query;
    final result = await _searchIssuesUseCase.call(
      SearchIssuesParams(
        q: query.isEmpty ? null : query,
        state: state,
        labels: labels,
        milestones: milestones,
        assigned: assigned,
        page: _currentPage,
        limit: _pageSize,
      ),
    );
    switch (result) {
      case Left<Failure, List<Issue>>(:final value):
        _issuesListState = IssuesListError(value.message);
        notifyListeners();
      case Right<Failure, List<Issue>>(:final value):
        final hasMore = value.length >= _pageSize;
        _issuesListState = IssuesListLoaded(value, hasMore: hasMore);
        notifyListeners();
    }
  }

  Future<void> loadMoreIssues() async {
    if (_loadingMore) return;
    final currentState = _issuesListState;
    if (currentState is! IssuesListLoaded) return;
    if (!currentState.hasMore) return;

    _loadingMore = true;
    notifyListeners();

    _currentPage++;
    final result = await _searchIssuesUseCase.call(
      SearchIssuesParams(
        q: lastSearchQuery?.isEmpty ?? true ? null : lastSearchQuery,
        state: _issuesListFilter,
        page: _currentPage,
        limit: _pageSize,
      ),
    );
    switch (result) {
      case Left<Failure, List<Issue>>():
        _currentPage--;
      case Right<Failure, List<Issue>>(:final value):
        final allIssues = [...currentState.issues, ...value];
        final hasMore = value.length >= _pageSize;
        _issuesListState = IssuesListLoaded(allIssues, hasMore: hasMore);
    }
    _loadingMore = false;
    notifyListeners();
  }
}
