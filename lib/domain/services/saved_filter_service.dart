import 'dart:convert';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/saved_filter.dart';

class SavedFilterService {
  static const _key = 'saved_filters';
  SharedPreferences? _prefs;

  Future<SharedPreferences> get _prefsInstance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  Future<List<SavedFilter>> loadFilters() async {
    final prefs = await _prefsInstance;
    final json = prefs.getString(_key);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((e) => SavedFilter.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveFilters(List<SavedFilter> filters) async {
    final prefs = await _prefsInstance;
    final json = jsonEncode(filters.map((f) => f.toJson()).toList());
    await prefs.setString(_key, json);
  }

  Future<SavedFilter> addFilter(String name, String state, {String? query, String? labels, String? milestone}) async {
    final filters = await loadFilters();
    final filter = SavedFilter(
      id: DateTime.now().millisecondsSinceEpoch.toString() + Random().nextInt(9999).toString(),
      name: name,
      state: state,
      query: query,
      labels: labels,
      milestone: milestone,
    );
    filters.add(filter);
    await saveFilters(filters);
    return filter;
  }

  Future<void> deleteFilter(String id) async {
    final filters = await loadFilters();
    filters.removeWhere((f) => f.id == id);
    await saveFilters(filters);
  }

  Future<void> renameFilter(String id, String newName) async {
    final filters = await loadFilters();
    final idx = filters.indexWhere((f) => f.id == id);
    if (idx != -1) {
      filters[idx].name = newName;
      await saveFilters(filters);
    }
  }
}
