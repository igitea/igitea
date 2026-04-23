part of 'generated_models.dart';

/// CreateRepoOption options when creating repository
class CreateRepoOption {
  final bool? auto_init;
  final String? default_branch;
  final String? description;
  final String? gitignores;
  final String? issue_labels;
  final String? license;
  final String? name;
  final String? object_format_name;
  final bool? private;
  final String? readme;
  final bool? template;
  final String? trust_model;
  const CreateRepoOption({
    this.auto_init,
    this.default_branch,
    this.description,
    this.gitignores,
    this.issue_labels,
    this.license,
    this.name,
    this.object_format_name,
    this.private,
    this.readme,
    this.template,
    this.trust_model,
  });
  factory CreateRepoOption.fromJson(Map<String, dynamic> json) {
    return CreateRepoOption(
      auto_init: json['auto_init'] != null ? json['auto_init'] as bool : null,
      default_branch: json['default_branch'] != null ? json['default_branch'] as String : null,
      description: json['description'] != null ? json['description'] as String : null,
      gitignores: json['gitignores'] != null ? json['gitignores'] as String : null,
      issue_labels: json['issue_labels'] != null ? json['issue_labels'] as String : null,
      license: json['license'] != null ? json['license'] as String : null,
      name: json['name'] != null ? json['name'] as String : null,
      object_format_name: json['object_format_name'] != null ? json['object_format_name'] as String : null,
      private: json['private'] != null ? json['private'] as bool : null,
      readme: json['readme'] != null ? json['readme'] as String : null,
      template: json['template'] != null ? json['template'] as bool : null,
      trust_model: json['trust_model'] != null ? json['trust_model'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (auto_init != null) map['auto_init'] = auto_init!;
    if (default_branch != null) map['default_branch'] = default_branch!;
    if (description != null) map['description'] = description!;
    if (gitignores != null) map['gitignores'] = gitignores!;
    if (issue_labels != null) map['issue_labels'] = issue_labels!;
    if (license != null) map['license'] = license!;
    if (name != null) map['name'] = name!;
    if (object_format_name != null) map['object_format_name'] = object_format_name!;
    if (private != null) map['private'] = private!;
    if (readme != null) map['readme'] = readme!;
    if (template != null) map['template'] = template!;
    if (trust_model != null) map['trust_model'] = trust_model!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateRepoOption &&
          auto_init == other.auto_init &&
          default_branch == other.default_branch &&
          description == other.description &&
          gitignores == other.gitignores &&
          issue_labels == other.issue_labels &&
          license == other.license &&
          name == other.name &&
          object_format_name == other.object_format_name &&
          private == other.private &&
          readme == other.readme &&
          template == other.template &&
          trust_model == other.trust_model;
  @override
  int get hashCode => Object.hash(auto_init, default_branch, description, gitignores, issue_labels, license, name, object_format_name, private, readme, template, trust_model);
  @override
  String toString() => 'CreateRepoOption(auto_init: $auto_init, default_branch: $default_branch, description: $description, gitignores: $gitignores, issue_labels: $issue_labels, license: $license, name: $name, object_format_name: $object_format_name, private: $private, readme: $readme, template: $template, trust_model: $trust_model)';
}
