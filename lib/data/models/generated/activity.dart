part of 'generated_models.dart';

class Activity {
  final User? act_user;
  final int? act_user_id;
  final Comment? comment;
  final int? comment_id;
  final String? content;
  final DateTime? created;
  final int? id;
  final bool? is_private;
  final String? op_type;
  final String? ref_name;
  final Repository? repo;
  final int? repo_id;
  final int? user_id;
  const Activity({
    this.act_user,
    this.act_user_id,
    this.comment,
    this.comment_id,
    this.content,
    this.created,
    this.id,
    this.is_private,
    this.op_type,
    this.ref_name,
    this.repo,
    this.repo_id,
    this.user_id,
  });
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      act_user: json['act_user'] != null
          ? User.fromJson(json['act_user'] as Map<String, dynamic>)
          : null,
      act_user_id: json['act_user_id'] != null
          ? (json['act_user_id'] as num).toInt()
          : null,
      comment: json['comment'] != null
          ? Comment.fromJson(json['comment'] as Map<String, dynamic>)
          : null,
      comment_id: json['comment_id'] != null
          ? (json['comment_id'] as num).toInt()
          : null,
      content: json['content'] != null ? json['content'] as String : null,
      created: json['created'] != null
          ? DateTime.parse(json['created'] as String)
          : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      is_private: json['is_private'] != null
          ? json['is_private'] as bool
          : null,
      op_type: json['op_type'] != null ? json['op_type'] as String : null,
      ref_name: json['ref_name'] != null ? json['ref_name'] as String : null,
      repo: json['repo'] != null
          ? Repository.fromJson(json['repo'] as Map<String, dynamic>)
          : null,
      repo_id: json['repo_id'] != null
          ? (json['repo_id'] as num).toInt()
          : null,
      user_id: json['user_id'] != null
          ? (json['user_id'] as num).toInt()
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (act_user != null) map['act_user'] = act_user!.toJson();
    if (act_user_id != null) map['act_user_id'] = act_user_id!;
    if (comment != null) map['comment'] = comment!.toJson();
    if (comment_id != null) map['comment_id'] = comment_id!;
    if (content != null) map['content'] = content!;
    if (created != null) map['created'] = created!.toIso8601String();
    if (id != null) map['id'] = id!;
    if (is_private != null) map['is_private'] = is_private!;
    if (op_type != null) map['op_type'] = op_type!;
    if (ref_name != null) map['ref_name'] = ref_name!;
    if (repo != null) map['repo'] = repo!.toJson();
    if (repo_id != null) map['repo_id'] = repo_id!;
    if (user_id != null) map['user_id'] = user_id!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Activity &&
          act_user == other.act_user &&
          act_user_id == other.act_user_id &&
          comment == other.comment &&
          comment_id == other.comment_id &&
          content == other.content &&
          created == other.created &&
          id == other.id &&
          is_private == other.is_private &&
          op_type == other.op_type &&
          ref_name == other.ref_name &&
          repo == other.repo &&
          repo_id == other.repo_id &&
          user_id == other.user_id;
  @override
  int get hashCode => Object.hash(
    act_user,
    act_user_id,
    comment,
    comment_id,
    content,
    created,
    id,
    is_private,
    op_type,
    ref_name,
    repo,
    repo_id,
    user_id,
  );
  @override
  String toString() =>
      'Activity(act_user: $act_user, act_user_id: $act_user_id, comment: $comment, comment_id: $comment_id, content: $content, created: $created, id: $id, is_private: $is_private, op_type: $op_type, ref_name: $ref_name, repo: $repo, repo_id: $repo_id, user_id: $user_id)';
}
