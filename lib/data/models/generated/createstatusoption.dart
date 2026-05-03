part of 'generated_models.dart';

/// CreateStatusOption holds the information needed to create a new CommitStatus for a Commit
class CreateStatusOption {
  final String? context;
  final String? description;
  final String? state;
  final String? target_url;
  const CreateStatusOption({
    this.context,
    this.description,
    this.state,
    this.target_url,
  });
  factory CreateStatusOption.fromJson(Map<String, dynamic> json) {
    return CreateStatusOption(
      context: json['context'] != null ? json['context'] as String : null,
      description: json['description'] != null ? json['description'] as String : null,
      state: json['state'] != null ? json['state'] as String : null,
      target_url: json['target_url'] != null ? json['target_url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (context != null) map['context'] = context!;
    if (description != null) map['description'] = description!;
    if (state != null) map['state'] = state!;
    if (target_url != null) map['target_url'] = target_url!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateStatusOption &&
          context == other.context &&
          description == other.description &&
          state == other.state &&
          target_url == other.target_url;
  @override
  int get hashCode => Object.hash(context, description, state, target_url);
  @override
  String toString() => 'CreateStatusOption(context: $context, description: $description, state: $state, target_url: $target_url)';
}
