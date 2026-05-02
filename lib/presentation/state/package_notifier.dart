import 'package:flutter/material.dart';

import '../../core/errors/failures.dart';
import '../../core/utils/either.dart';
import '../../data/models/generated/generated_models.dart';
import '../../domain/usecases/package_usecases.dart';

sealed class PackageListState {
  const PackageListState();
}

class PackageListInitial extends PackageListState {
  const PackageListInitial();
}

class PackageListLoading extends PackageListState {
  const PackageListLoading();
}

class PackageListLoaded extends PackageListState {
  final List<Package> packages;
  const PackageListLoaded(this.packages);
}

class PackageListError extends PackageListState {
  final String message;
  const PackageListError(this.message);
}

sealed class PackageDetailState {
  const PackageDetailState();
}

class PackageDetailInitial extends PackageDetailState {
  const PackageDetailInitial();
}

class PackageDetailLoading extends PackageDetailState {
  const PackageDetailLoading();
}

class PackageDetailLoaded extends PackageDetailState {
  final Package package;
  final List<PackageFile> files;
  const PackageDetailLoaded(this.package, this.files);
}

class PackageDetailError extends PackageDetailState {
  final String message;
  const PackageDetailError(this.message);
}

class PackageNotifier extends ChangeNotifier {
  ListPackagesUseCase _listPackagesUseCase;
  GetPackageUseCase _getPackageUseCase;
  ListPackageFilesUseCase _listPackageFilesUseCase;
  DeletePackageUseCase _deletePackageUseCase;
  ListPackageVersionsUseCase _listPackageVersionsUseCase;

  PackageListState _listState = const PackageListInitial();
  PackageListState get listState => _listState;

  PackageDetailState _detailState = const PackageDetailInitial();
  PackageDetailState get detailState => _detailState;

  List<Package> _versions = [];
  List<Package> get versions => _versions;

  bool _versionsLoading = false;
  bool get versionsLoading => _versionsLoading;

  bool _versionsHasMore = true;
  bool get versionsHasMore => _versionsHasMore;

  int _versionsPage = 1;
  static const _versionsPerPage = 20;

  PackageNotifier({
    required ListPackagesUseCase listPackagesUseCase,
    required GetPackageUseCase getPackageUseCase,
    required ListPackageFilesUseCase listPackageFilesUseCase,
    required DeletePackageUseCase deletePackageUseCase,
    required ListPackageVersionsUseCase listPackageVersionsUseCase,
  }) : _listPackagesUseCase = listPackagesUseCase,
       _getPackageUseCase = getPackageUseCase,
       _listPackageFilesUseCase = listPackageFilesUseCase,
       _deletePackageUseCase = deletePackageUseCase,
       _listPackageVersionsUseCase = listPackageVersionsUseCase;

  void updateUseCases({
    required ListPackagesUseCase listPackagesUseCase,
    required GetPackageUseCase getPackageUseCase,
    required ListPackageFilesUseCase listPackageFilesUseCase,
    required DeletePackageUseCase deletePackageUseCase,
    required ListPackageVersionsUseCase listPackageVersionsUseCase,
  }) {
    _listPackagesUseCase = listPackagesUseCase;
    _getPackageUseCase = getPackageUseCase;
    _listPackageFilesUseCase = listPackageFilesUseCase;
    _deletePackageUseCase = deletePackageUseCase;
    _listPackageVersionsUseCase = listPackageVersionsUseCase;
  }

  Future<void> loadPackages(String owner, {String? type}) async {
    _listState = const PackageListLoading();
    notifyListeners();

    final result = await _listPackagesUseCase(ListPackagesParams(
      owner: owner,
      type: type,
    ));

    switch (result) {
      case Right<Failure, List<Package>>(:final value):
        _listState = PackageListLoaded(value);
      case Left<Failure, List<Package>>(:final value):
        _listState = PackageListError(value.message);
    }
    notifyListeners();
  }

  Future<void> loadPackageDetail({
    required String owner,
    required String type,
    required String name,
    required String version,
  }) async {
    _detailState = const PackageDetailLoading();
    notifyListeners();

    final result = await _getPackageUseCase(GetPackageParams(
      owner: owner,
      type: type,
      name: name,
      version: version,
    ));

    switch (result) {
      case Right<Failure, Package>(:final value):
        _detailState = PackageDetailLoaded(value, []);
        notifyListeners();
        _loadPackageFiles(owner, type, name, version);
      case Left<Failure, Package>(:final value):
        _detailState = PackageDetailError(value.message);
        notifyListeners();
    }
  }

  Future<void> loadVersions({
    required String owner,
    required String type,
    required String name,
  }) async {
    _versionsPage = 1;
    _versionsHasMore = true;
    _versionsLoading = true;
    _versions = [];
    notifyListeners();

    final result = await _listPackageVersionsUseCase(
      ListPackageVersionsParams(
        owner: owner,
        type: type,
        name: name,
        page: _versionsPage,
        limit: _versionsPerPage,
      ),
    );

    switch (result) {
      case Right<Failure, List<Package>>(:final value):
        _versions = value;
        _versionsHasMore = value.length >= _versionsPerPage;
      case Left():
        _versionsHasMore = false;
    }
    _versionsLoading = false;
    notifyListeners();
  }

  Future<void> loadMoreVersions({
    required String owner,
    required String type,
    required String name,
  }) async {
    if (_versionsLoading || !_versionsHasMore) return;
    _versionsLoading = true;
    _versionsPage++;
    notifyListeners();

    final result = await _listPackageVersionsUseCase(
      ListPackageVersionsParams(
        owner: owner,
        type: type,
        name: name,
        page: _versionsPage,
        limit: _versionsPerPage,
      ),
    );

    switch (result) {
      case Right<Failure, List<Package>>(:final value):
        _versions = [..._versions, ...value];
        _versionsHasMore = value.length >= _versionsPerPage;
      case Left():
        _versionsHasMore = false;
        _versionsPage--;
    }
    _versionsLoading = false;
    notifyListeners();
  }

  Future<void> _loadPackageFiles(
    String owner,
    String type,
    String name,
    String version,
  ) async {
    final result = await _listPackageFilesUseCase(ListPackageFilesParams(
      owner: owner,
      type: type,
      name: name,
      version: version,
    ));

    switch (result) {
      case Right<Failure, List<PackageFile>>(:final value):
        if (_detailState is PackageDetailLoaded) {
          final current = _detailState as PackageDetailLoaded;
          _detailState = PackageDetailLoaded(current.package, value);
          notifyListeners();
        }
      case Left():
        break;
    }
  }

  Future<bool> deletePackageVersion({
    required String owner,
    required String type,
    required String name,
    required String version,
  }) async {
    final result = await _deletePackageUseCase(DeletePackageParams(
      owner: owner,
      type: type,
      name: name,
      version: version,
    ));

    return result is Right;
  }
}
