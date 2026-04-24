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
  const NotificationListLoaded(this.notifications);
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
  CheckNewNotificationsUseCase _checkNewAvailableUseCase;

  NotificationState _state = const NotificationInitial();
  NotificationState get state => _state;

  NotificationNotifier({
    required ListNotificationsUseCase listNotificationsUseCase,
    required MarkThreadReadUseCase markThreadReadUseCase,
    required CheckNewNotificationsUseCase checkNewAvailableUseCase,
  }) : _listNotificationsUseCase = listNotificationsUseCase,
       _markThreadReadUseCase = markThreadReadUseCase,
       _checkNewAvailableUseCase = checkNewAvailableUseCase;

  void updateUseCases({
    required ListNotificationsUseCase listNotificationsUseCase,
    required MarkThreadReadUseCase markThreadReadUseCase,
    required CheckNewNotificationsUseCase checkNewAvailableUseCase,
  }) {
    _listNotificationsUseCase = listNotificationsUseCase;
    _markThreadReadUseCase = markThreadReadUseCase;
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
    notifyListeners();

    final result = await _listNotificationsUseCase.call(
      all: all,
      status_types: status_types,
      subject_type: subject_type,
      since: since,
      before: before,
      page: page,
      limit: limit,
    );
    switch (result) {
      case Left<Failure, List<NotificationThread>>(:final value):
        _state = NotificationError(value.message);
        notifyListeners();
      case Right<Failure, List<NotificationThread>>(:final value):
        _state = NotificationListLoaded(value);
        notifyListeners();
    }
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
