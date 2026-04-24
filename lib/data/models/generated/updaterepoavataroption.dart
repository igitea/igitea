part of 'generated_models.dart';

/// UpdateRepoAvatarUserOption options when updating the repo avatar
class UpdateRepoAvatarOption {
  final String? image;
  const UpdateRepoAvatarOption({this.image});
  factory UpdateRepoAvatarOption.fromJson(Map<String, dynamic> json) {
    return UpdateRepoAvatarOption(
      image: json['image'] != null ? json['image'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (image != null) map['image'] = image!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UpdateRepoAvatarOption && image == other.image;
  @override
  int get hashCode => image.hashCode;
  @override
  String toString() => 'UpdateRepoAvatarOption(image: $image)';
}
