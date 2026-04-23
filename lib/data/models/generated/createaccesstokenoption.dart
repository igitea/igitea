part of 'generated_models.dart';

/// CreateAccessTokenOption options when create access token
class CreateAccessTokenOption {
  final String? name;
  final List<String>? scopes;
  const CreateAccessTokenOption({
    this.name,
    this.scopes,
  });
  factory CreateAccessTokenOption.fromJson(Map<String, dynamic> json) {
    return CreateAccessTokenOption(
      name: json['name'] != null ? json['name'] as String : null,
      scopes: json['scopes'] != null ? (json['scopes'] as List<dynamic>).cast<String>() : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (name != null) map['name'] = name!;
    if (scopes != null) map['scopes'] = scopes!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateAccessTokenOption &&
          name == other.name &&
          scopes == other.scopes;
  @override
  int get hashCode => Object.hash(name, scopes);
  @override
  String toString() => 'CreateAccessTokenOption(name: $name, scopes: $scopes)';
}
