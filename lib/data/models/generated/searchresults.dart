part of 'generated_models.dart';

/// SearchResults results of a successful search
class SearchResults {
  final List<Repository>? data;
  final bool? ok;
  const SearchResults({
    this.data,
    this.ok,
  });
  factory SearchResults.fromJson(Map<String, dynamic> json) {
    return SearchResults(
      data: json['data'] != null ? (json['data'] as List<dynamic>).map((e) => Repository.fromJson(e as Map<String, dynamic>)).toList() : null,
      ok: json['ok'] != null ? json['ok'] as bool : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (data != null) map['data'] = data!.map((e) => e.toJson()).toList();
    if (ok != null) map['ok'] = ok!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SearchResults &&
          data == other.data &&
          ok == other.ok;
  @override
  int get hashCode => Object.hash(data, ok);
  @override
  String toString() => 'SearchResults(data: $data, ok: $ok)';
}
