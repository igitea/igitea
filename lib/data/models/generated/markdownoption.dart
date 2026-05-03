part of 'generated_models.dart';

/// MarkdownOption markdown options
class MarkdownOption {
  final String? Context;
  final String? Mode;
  final String? Text;
  final bool? Wiki;
  const MarkdownOption({
    this.Context,
    this.Mode,
    this.Text,
    this.Wiki,
  });
  factory MarkdownOption.fromJson(Map<String, dynamic> json) {
    return MarkdownOption(
      Context: json['Context'] != null ? json['Context'] as String : null,
      Mode: json['Mode'] != null ? json['Mode'] as String : null,
      Text: json['Text'] != null ? json['Text'] as String : null,
      Wiki: json['Wiki'] != null ? json['Wiki'] as bool : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (Context != null) map['Context'] = Context!;
    if (Mode != null) map['Mode'] = Mode!;
    if (Text != null) map['Text'] = Text!;
    if (Wiki != null) map['Wiki'] = Wiki!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarkdownOption &&
          Context == other.Context &&
          Mode == other.Mode &&
          Text == other.Text &&
          Wiki == other.Wiki;
  @override
  int get hashCode => Object.hash(Context, Mode, Text, Wiki);
  @override
  String toString() => 'MarkdownOption(Context: $Context, Mode: $Mode, Text: $Text, Wiki: $Wiki)';
}
