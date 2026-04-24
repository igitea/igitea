part of 'generated_models.dart';

/// GeneralAttachmentSettings contains global Attachment settings exposed by API
class GeneralAttachmentSettings {
  final String? allowed_types;
  final bool? enabled;
  final int? max_files;
  final int? max_size;
  const GeneralAttachmentSettings({
    this.allowed_types,
    this.enabled,
    this.max_files,
    this.max_size,
  });
  factory GeneralAttachmentSettings.fromJson(Map<String, dynamic> json) {
    return GeneralAttachmentSettings(
      allowed_types: json['allowed_types'] != null
          ? json['allowed_types'] as String
          : null,
      enabled: json['enabled'] != null ? json['enabled'] as bool : null,
      max_files: json['max_files'] != null
          ? (json['max_files'] as num).toInt()
          : null,
      max_size: json['max_size'] != null
          ? (json['max_size'] as num).toInt()
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (allowed_types != null) map['allowed_types'] = allowed_types!;
    if (enabled != null) map['enabled'] = enabled!;
    if (max_files != null) map['max_files'] = max_files!;
    if (max_size != null) map['max_size'] = max_size!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneralAttachmentSettings &&
          allowed_types == other.allowed_types &&
          enabled == other.enabled &&
          max_files == other.max_files &&
          max_size == other.max_size;
  @override
  int get hashCode => Object.hash(allowed_types, enabled, max_files, max_size);
  @override
  String toString() =>
      'GeneralAttachmentSettings(allowed_types: $allowed_types, enabled: $enabled, max_files: $max_files, max_size: $max_size)';
}
