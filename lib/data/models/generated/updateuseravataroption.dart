part of 'generated_models.dart';

/// UpdateUserAvatarUserOption options when updating the user avatar
class UpdateUserAvatarOption {
  final String? image;
  const UpdateUserAvatarOption({
    this.image,
  });
  factory UpdateUserAvatarOption.fromJson(Map<String, dynamic> json) {
    return UpdateUserAvatarOption(
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
      other is UpdateUserAvatarOption &&
          image == other.image;
  @override
  int get hashCode => image.hashCode;
  @override
  String toString() => 'UpdateUserAvatarOption(image: $image)';
}
