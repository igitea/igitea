part of 'generated_models.dart';

/// CreateGPGKeyOption options create user GPG key
class CreateGPGKeyOption {
  final String? armored_public_key;
  final String? armored_signature;
  const CreateGPGKeyOption({this.armored_public_key, this.armored_signature});
  factory CreateGPGKeyOption.fromJson(Map<String, dynamic> json) {
    return CreateGPGKeyOption(
      armored_public_key: json['armored_public_key'] != null
          ? json['armored_public_key'] as String
          : null,
      armored_signature: json['armored_signature'] != null
          ? json['armored_signature'] as String
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (armored_public_key != null)
      map['armored_public_key'] = armored_public_key!;
    if (armored_signature != null)
      map['armored_signature'] = armored_signature!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CreateGPGKeyOption &&
          armored_public_key == other.armored_public_key &&
          armored_signature == other.armored_signature;
  @override
  int get hashCode => Object.hash(armored_public_key, armored_signature);
  @override
  String toString() =>
      'CreateGPGKeyOption(armored_public_key: $armored_public_key, armored_signature: $armored_signature)';
}
