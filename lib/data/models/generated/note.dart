part of 'generated_models.dart';

/// Note contains information related to a git note
class Note {
  final Commit? commit;
  final String? message;
  const Note({
    this.commit,
    this.message,
  });
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      commit: json['commit'] != null ? Commit.fromJson(json['commit'] as Map<String, dynamic>) : null,
      message: json['message'] != null ? json['message'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (commit != null) map['commit'] = commit!.toJson();
    if (message != null) map['message'] = message!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note &&
          commit == other.commit &&
          message == other.message;
  @override
  int get hashCode => Object.hash(commit, message);
  @override
  String toString() => 'Note(commit: $commit, message: $message)';
}
