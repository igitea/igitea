part of 'generated_models.dart';

class MergeUpstreamRequest {
  final String? branch;
  final bool? ff_only;
  const MergeUpstreamRequest({this.branch, this.ff_only});
  factory MergeUpstreamRequest.fromJson(Map<String, dynamic> json) {
    return MergeUpstreamRequest(
      branch: json['branch'] != null ? json['branch'] as String : null,
      ff_only: json['ff_only'] != null ? json['ff_only'] as bool : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (branch != null) map['branch'] = branch!;
    if (ff_only != null) map['ff_only'] = ff_only!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MergeUpstreamRequest &&
          branch == other.branch &&
          ff_only == other.ff_only;
  @override
  int get hashCode => Object.hash(branch, ff_only);
  @override
  String toString() =>
      'MergeUpstreamRequest(branch: $branch, ff_only: $ff_only)';
}
