part of 'generated_models.dart';

/// MarkupOption markup options
class MarkupOption {
  final String? Context;
  final String? FilePath;
  final String? Mode;
  final String? Text;
  final bool? Wiki;
  const MarkupOption({
    this.Context,
    this.FilePath,
    this.Mode,
    this.Text,
    this.Wiki,
  });
  factory MarkupOption.fromJson(Map<String, dynamic> json) {
    return MarkupOption(
      Context: json['Context'] != null ? json['Context'] as String : null,
      FilePath: json['FilePath'] != null ? json['FilePath'] as String : null,
      Mode: json['Mode'] != null ? json['Mode'] as String : null,
      Text: json['Text'] != null ? json['Text'] as String : null,
      Wiki: json['Wiki'] != null ? json['Wiki'] as bool : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (Context != null) map['Context'] = Context!;
    if (FilePath != null) map['FilePath'] = FilePath!;
    if (Mode != null) map['Mode'] = Mode!;
    if (Text != null) map['Text'] = Text!;
    if (Wiki != null) map['Wiki'] = Wiki!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarkupOption &&
          Context == other.Context &&
          FilePath == other.FilePath &&
          Mode == other.Mode &&
          Text == other.Text &&
          Wiki == other.Wiki;
  @override
  int get hashCode => Object.hash(Context, FilePath, Mode, Text, Wiki);
  @override
  String toString() =>
      'MarkupOption(Context: $Context, FilePath: $FilePath, Mode: $Mode, Text: $Text, Wiki: $Wiki)';
}
