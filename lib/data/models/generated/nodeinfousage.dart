part of 'generated_models.dart';

/// NodeInfoUsage contains usage statistics for this server
class NodeInfoUsage {
  final int? localComments;
  final int? localPosts;
  final NodeInfoUsageUsers? users;
  const NodeInfoUsage({
    this.localComments,
    this.localPosts,
    this.users,
  });
  factory NodeInfoUsage.fromJson(Map<String, dynamic> json) {
    return NodeInfoUsage(
      localComments: json['localComments'] != null ? (json['localComments'] as num).toInt() : null,
      localPosts: json['localPosts'] != null ? (json['localPosts'] as num).toInt() : null,
      users: json['users'] != null ? NodeInfoUsageUsers.fromJson(json['users'] as Map<String, dynamic>) : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (localComments != null) map['localComments'] = localComments!;
    if (localPosts != null) map['localPosts'] = localPosts!;
    if (users != null) map['users'] = users!.toJson();
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NodeInfoUsage &&
          localComments == other.localComments &&
          localPosts == other.localPosts &&
          users == other.users;
  @override
  int get hashCode => Object.hash(localComments, localPosts, users);
  @override
  String toString() => 'NodeInfoUsage(localComments: $localComments, localPosts: $localPosts, users: $users)';
}
