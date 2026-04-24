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

class IssueListLoaded extends IssueState {
  final List<Issue> issues;
  const IssueListLoaded(this.issues);
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
  const CommentsLoaded(this.comments);
}

class CommentsError extends CommentsState {
  final String message;
  const CommentsError(this.message);
}

class IssueNotifier extends ChangeNotifier {
  ListIssuesUseCase _listIssuesUseCase;
  GetIssueUseCase _getIssueUseCase;
  CreateIssueUseCase _createIssueUseCase;
  EditIssueUseCase _editIssueUseCase;
  ListCommentsUseCase _listCommentsUseCase;
  CreateCommentUseCase _createCommentUseCase;
  ListLabelsUseCase _listLabelsUseCase;
  ListMilestonesUseCase _listMilestonesUseCase;

  IssueState _state = const IssueInitial();
  IssueState get state => _state;

  CommentsState _commentsState = const CommentsInitial();
  CommentsState get commentsState => _commentsState;

  IssueNotifier({
    required ListIssuesUseCase listIssuesUseCase,
    required GetIssueUseCase getIssueUseCase,
    required CreateIssueUseCase createIssueUseCase,
    required EditIssueUseCase editIssueUseCase,
    required ListCommentsUseCase listCommentsUseCase,
    required CreateCommentUseCase createCommentUseCase,
    required ListLabelsUseCase listLabelsUseCase,
    required ListMilestonesUseCase listMilestonesUseCase,
  }) : _listIssuesUseCase = listIssuesUseCase,
       _getIssueUseCase = getIssueUseCase,
       _createIssueUseCase = createIssueUseCase,
       _editIssueUseCase = editIssueUseCase,
       _listCommentsUseCase = listCommentsUseCase,
       _createCommentUseCase = createCommentUseCase,
       _listLabelsUseCase = listLabelsUseCase,
       _listMilestonesUseCase = listMilestonesUseCase;

  void updateUseCases({
    required ListIssuesUseCase listIssuesUseCase,
    required GetIssueUseCase getIssueUseCase,
    required CreateIssueUseCase createIssueUseCase,
    required EditIssueUseCase editIssueUseCase,
    required ListCommentsUseCase listCommentsUseCase,
    required CreateCommentUseCase createCommentUseCase,
    required ListLabelsUseCase listLabelsUseCase,
    required ListMilestonesUseCase listMilestonesUseCase,
  }) {
    _listIssuesUseCase = listIssuesUseCase;
    _getIssueUseCase = getIssueUseCase;
    _createIssueUseCase = createIssueUseCase;
    _editIssueUseCase = editIssueUseCase;
    _listCommentsUseCase = listCommentsUseCase;
    _createCommentUseCase = createCommentUseCase;
    _listLabelsUseCase = listLabelsUseCase;
    _listMilestonesUseCase = listMilestonesUseCase;
  }

  Future<void> listIssues(ListIssuesParams params) async {
    _state = const IssueLoading();
    notifyListeners();

    final result = await _listIssuesUseCase.call(params);
    switch (result) {
      case Left<Failure, List<Issue>>(:final value):
        _state = IssueError(value.message);
        notifyListeners();
      case Right<Failure, List<Issue>>(:final value):
        _state = IssueListLoaded(value);
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

  Future<void> listComments(String owner, String repo, int index) async {
    _commentsState = const CommentsLoading();
    notifyListeners();

    final result = await _listCommentsUseCase.call(
      ListCommentsParams(owner: owner, repo: repo, index: index),
    );
    switch (result) {
      case Left<Failure, List<Comment>>(:final value):
        _commentsState = CommentsError(value.message);
        notifyListeners();
      case Right<Failure, List<Comment>>(:final value):
        _commentsState = CommentsLoaded(value);
        notifyListeners();
    }
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
}
