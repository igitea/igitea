// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';

import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/notification_usecases.dart';

sealed class NotificationState {
  const NotificationState();
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationListLoaded extends NotificationState {
  final List<NotificationThread> notifications;
  final bool hasMore;
  const NotificationListLoaded(this.notifications, {this.hasMore = false});
}

class NotificationCountLoaded extends NotificationState {
  final NotificationCount count;
  const NotificationCountLoaded(this.count);
}

class NotificationError extends NotificationState {
  final String message;
  const NotificationError(this.message);
}

class NotificationNotifier extends ChangeNotifier {
  ListNotificationsUseCase _listNotificationsUseCase;
  MarkThreadReadUseCase _markThreadReadUseCase;
  MarkNotificationsReadUseCase _markNotificationsReadUseCase;
  CheckNewNotificationsUseCase _checkNewAvailableUseCase;

  NotificationState _state = const NotificationInitial();
  NotificationState get state => _state;

  int _notifPage = 1;
  bool _notifLoadingMore = false;
  bool get notifLoadingMore => _notifLoadingMore;
  static const int _notifLimit = 20;

  NotificationNotifier({
    required ListNotificationsUseCase listNotificationsUseCase,
    required MarkThreadReadUseCase markThreadReadUseCase,
    required MarkNotificationsReadUseCase markNotificationsReadUseCase,
    required CheckNewNotificationsUseCase checkNewAvailableUseCase,
  }) : _listNotificationsUseCase = listNotificationsUseCase,
       _markThreadReadUseCase = markThreadReadUseCase,
       _markNotificationsReadUseCase = markNotificationsReadUseCase,
       _checkNewAvailableUseCase = checkNewAvailableUseCase;

  void updateUseCases({
    required ListNotificationsUseCase listNotificationsUseCase,
    required MarkThreadReadUseCase markThreadReadUseCase,
    required MarkNotificationsReadUseCase markNotificationsReadUseCase,
    required CheckNewNotificationsUseCase checkNewAvailableUseCase,
  }) {
    _listNotificationsUseCase = listNotificationsUseCase;
    _markThreadReadUseCase = markThreadReadUseCase;
    _markNotificationsReadUseCase = markNotificationsReadUseCase;
    _checkNewAvailableUseCase = checkNewAvailableUseCase;
  }

  Future<void> listNotifications({
    bool? all,
    List<String>? status_types,
    List<String>? subject_type,
    DateTime? since,
    DateTime? before,
    int? page,
    int? limit,
  }) async {
    _state = const NotificationLoading();
    _notifPage = 1;
    notifyListeners();

    final result = await _listNotificationsUseCase.call(
      all: all,
      status_types: status_types,
      subject_type: subject_type,
      since: since,
      before: before,
      page: page ?? 1,
      limit: limit ?? _notifLimit,
    );
    switch (result) {
      case Left<Failure, List<NotificationThread>>(:final value):
        _state = NotificationError(value.message);
        notifyListeners();
      case Right<Failure, List<NotificationThread>>(:final value):
        _state = NotificationListLoaded(value, hasMore: value.length >= _notifLimit);
        notifyListeners();
    }
  }

  Future<void> loadMoreNotifications() async {
    if (_notifLoadingMore) return;
    final current = _state;
    if (current is! NotificationListLoaded || !current.hasMore) return;
    _notifLoadingMore = true;
    notifyListeners();
    _notifPage++;
    final result = await _listNotificationsUseCase.call(
      page: _notifPage, limit: _notifLimit,
    );
    switch (result) {
      case Right<Failure, List<NotificationThread>>(:final value):
        _state = NotificationListLoaded(
          [...current.notifications, ...value],
          hasMore: value.length >= _notifLimit,
        );
      case Left<Failure, List<NotificationThread>>():
        _notifPage--;
    }
    _notifLoadingMore = false;
    notifyListeners();
  }

  Future<void> markThreadRead(String id, {String? to_status}) async {
    final result = await _markThreadReadUseCase.call(
      MarkThreadReadParams(id: id, to_status: to_status),
    );
    switch (result) {
      case Left<Failure, void>(:final value):
        _state = NotificationError(value.message);
        notifyListeners();
      case Right<Failure, void>():
        break;
    }
  }

  Future<void> markAllRead() async {
    final result = await _markNotificationsReadUseCase.call();
    switch (result) {
      case Left<Failure, void>(:final value):
        _state = NotificationError(value.message);
        notifyListeners();
      case Right<Failure, void>():
        await listNotifications();
    }
  }

  Future<void> checkNewAvailable() async {
    _state = const NotificationLoading();
    notifyListeners();

    final result = await _checkNewAvailableUseCase.call();
    switch (result) {
      case Left<Failure, NotificationCount>(:final value):
        _state = NotificationError(value.message);
        notifyListeners();
      case Right<Failure, NotificationCount>(:final value):
        _state = NotificationCountLoaded(value);
        notifyListeners();
    }
  }
}
