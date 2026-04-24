part of 'generated_models.dart';

/// GeneralAPISettings contains global api settings exposed by it
class GeneralAPISettings {
  final int? default_git_trees_per_page;
  final int? default_max_blob_size;
  final int? default_max_response_size;
  final int? default_paging_num;
  final int? max_response_items;
  const GeneralAPISettings({
    this.default_git_trees_per_page,
    this.default_max_blob_size,
    this.default_max_response_size,
    this.default_paging_num,
    this.max_response_items,
  });
  factory GeneralAPISettings.fromJson(Map<String, dynamic> json) {
    return GeneralAPISettings(
      default_git_trees_per_page: json['default_git_trees_per_page'] != null
          ? (json['default_git_trees_per_page'] as num).toInt()
          : null,
      default_max_blob_size: json['default_max_blob_size'] != null
          ? (json['default_max_blob_size'] as num).toInt()
          : null,
      default_max_response_size: json['default_max_response_size'] != null
          ? (json['default_max_response_size'] as num).toInt()
          : null,
      default_paging_num: json['default_paging_num'] != null
          ? (json['default_paging_num'] as num).toInt()
          : null,
      max_response_items: json['max_response_items'] != null
          ? (json['max_response_items'] as num).toInt()
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (default_git_trees_per_page != null)
      map['default_git_trees_per_page'] = default_git_trees_per_page!;
    if (default_max_blob_size != null)
      map['default_max_blob_size'] = default_max_blob_size!;
    if (default_max_response_size != null)
      map['default_max_response_size'] = default_max_response_size!;
    if (default_paging_num != null)
      map['default_paging_num'] = default_paging_num!;
    if (max_response_items != null)
      map['max_response_items'] = max_response_items!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneralAPISettings &&
          default_git_trees_per_page == other.default_git_trees_per_page &&
          default_max_blob_size == other.default_max_blob_size &&
          default_max_response_size == other.default_max_response_size &&
          default_paging_num == other.default_paging_num &&
          max_response_items == other.max_response_items;
  @override
  int get hashCode => Object.hash(
    default_git_trees_per_page,
    default_max_blob_size,
    default_max_response_size,
    default_paging_num,
    max_response_items,
  );
  @override
  String toString() =>
      'GeneralAPISettings(default_git_trees_per_page: $default_git_trees_per_page, default_max_blob_size: $default_max_blob_size, default_max_response_size: $default_max_response_size, default_paging_num: $default_paging_num, max_response_items: $max_response_items)';
}
