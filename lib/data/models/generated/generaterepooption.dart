part of 'generated_models.dart';

/// GenerateRepoOption options when creating a repository using a template
class GenerateRepoOption {
  final bool? avatar;
  final String? default_branch;
  final String? description;
  final bool? git_content;
  final bool? git_hooks;
  final bool? labels;
  final String? name;
  final String? owner;
  final bool? private;
  final bool? protected_branch;
  final bool? topics;
  final bool? webhooks;
  const GenerateRepoOption({
    this.avatar,
    this.default_branch,
    this.description,
    this.git_content,
    this.git_hooks,
    this.labels,
    this.name,
    this.owner,
    this.private,
    this.protected_branch,
    this.topics,
    this.webhooks,
  });
  factory GenerateRepoOption.fromJson(Map<String, dynamic> json) {
    return GenerateRepoOption(
      avatar: json['avatar'] != null ? json['avatar'] as bool : null,
      default_branch: json['default_branch'] != null
          ? json['default_branch'] as String
          : null,
      description: json['description'] != null
          ? json['description'] as String
          : null,
      git_content: json['git_content'] != null
          ? json['git_content'] as bool
          : null,
      git_hooks: json['git_hooks'] != null ? json['git_hooks'] as bool : null,
      labels: json['labels'] != null ? json['labels'] as bool : null,
      name: json['name'] != null ? json['name'] as String : null,
      owner: json['owner'] != null ? json['owner'] as String : null,
      private: json['private'] != null ? json['private'] as bool : null,
      protected_branch: json['protected_branch'] != null
          ? json['protected_branch'] as bool
          : null,
      topics: json['topics'] != null ? json['topics'] as bool : null,
      webhooks: json['webhooks'] != null ? json['webhooks'] as bool : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (avatar != null) map['avatar'] = avatar!;
    if (default_branch != null) map['default_branch'] = default_branch!;
    if (description != null) map['description'] = description!;
    if (git_content != null) map['git_content'] = git_content!;
    if (git_hooks != null) map['git_hooks'] = git_hooks!;
    if (labels != null) map['labels'] = labels!;
    if (name != null) map['name'] = name!;
    if (owner != null) map['owner'] = owner!;
    if (private != null) map['private'] = private!;
    if (protected_branch != null) map['protected_branch'] = protected_branch!;
    if (topics != null) map['topics'] = topics!;
    if (webhooks != null) map['webhooks'] = webhooks!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GenerateRepoOption &&
          avatar == other.avatar &&
          default_branch == other.default_branch &&
          description == other.description &&
          git_content == other.git_content &&
          git_hooks == other.git_hooks &&
          labels == other.labels &&
          name == other.name &&
          owner == other.owner &&
          private == other.private &&
          protected_branch == other.protected_branch &&
          topics == other.topics &&
          webhooks == other.webhooks;
  @override
  int get hashCode => Object.hash(
    avatar,
    default_branch,
    description,
    git_content,
    git_hooks,
    labels,
    name,
    owner,
    private,
    protected_branch,
    topics,
    webhooks,
  );
  @override
  String toString() =>
      'GenerateRepoOption(avatar: $avatar, default_branch: $default_branch, description: $description, git_content: $git_content, git_hooks: $git_hooks, labels: $labels, name: $name, owner: $owner, private: $private, protected_branch: $protected_branch, topics: $topics, webhooks: $webhooks)';
}
