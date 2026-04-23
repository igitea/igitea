part of 'generated_models.dart';

/// GPGKey a user GPG key to sign commit and tag in repository
class GPGKey {
  final bool? can_certify;
  final bool? can_encrypt_comms;
  final bool? can_encrypt_storage;
  final bool? can_sign;
  final DateTime? created_at;
  final List<GPGKeyEmail>? emails;
  final DateTime? expires_at;
  final int? id;
  final String? key_id;
  final String? primary_key_id;
  final String? public_key;
  final List<GPGKey>? subkeys;
  final bool? verified;
  const GPGKey({
    this.can_certify,
    this.can_encrypt_comms,
    this.can_encrypt_storage,
    this.can_sign,
    this.created_at,
    this.emails,
    this.expires_at,
    this.id,
    this.key_id,
    this.primary_key_id,
    this.public_key,
    this.subkeys,
    this.verified,
  });
  factory GPGKey.fromJson(Map<String, dynamic> json) {
    return GPGKey(
      can_certify: json['can_certify'] != null ? json['can_certify'] as bool : null,
      can_encrypt_comms: json['can_encrypt_comms'] != null ? json['can_encrypt_comms'] as bool : null,
      can_encrypt_storage: json['can_encrypt_storage'] != null ? json['can_encrypt_storage'] as bool : null,
      can_sign: json['can_sign'] != null ? json['can_sign'] as bool : null,
      created_at: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      emails: json['emails'] != null ? (json['emails'] as List<dynamic>).map((e) => GPGKeyEmail.fromJson(e as Map<String, dynamic>)).toList() : null,
      expires_at: json['expires_at'] != null ? DateTime.parse(json['expires_at'] as String) : null,
      id: json['id'] != null ? (json['id'] as num).toInt() : null,
      key_id: json['key_id'] != null ? json['key_id'] as String : null,
      primary_key_id: json['primary_key_id'] != null ? json['primary_key_id'] as String : null,
      public_key: json['public_key'] != null ? json['public_key'] as String : null,
      subkeys: json['subkeys'] != null ? (json['subkeys'] as List<dynamic>).map((e) => GPGKey.fromJson(e as Map<String, dynamic>)).toList() : null,
      verified: json['verified'] != null ? json['verified'] as bool : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (can_certify != null) map['can_certify'] = can_certify!;
    if (can_encrypt_comms != null) map['can_encrypt_comms'] = can_encrypt_comms!;
    if (can_encrypt_storage != null) map['can_encrypt_storage'] = can_encrypt_storage!;
    if (can_sign != null) map['can_sign'] = can_sign!;
    if (created_at != null) map['created_at'] = created_at!.toIso8601String();
    if (emails != null) map['emails'] = emails!.map((e) => e.toJson()).toList();
    if (expires_at != null) map['expires_at'] = expires_at!.toIso8601String();
    if (id != null) map['id'] = id!;
    if (key_id != null) map['key_id'] = key_id!;
    if (primary_key_id != null) map['primary_key_id'] = primary_key_id!;
    if (public_key != null) map['public_key'] = public_key!;
    if (subkeys != null) map['subkeys'] = subkeys!.map((e) => e.toJson()).toList();
    if (verified != null) map['verified'] = verified!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GPGKey &&
          can_certify == other.can_certify &&
          can_encrypt_comms == other.can_encrypt_comms &&
          can_encrypt_storage == other.can_encrypt_storage &&
          can_sign == other.can_sign &&
          created_at == other.created_at &&
          emails == other.emails &&
          expires_at == other.expires_at &&
          id == other.id &&
          key_id == other.key_id &&
          primary_key_id == other.primary_key_id &&
          public_key == other.public_key &&
          subkeys == other.subkeys &&
          verified == other.verified;
  @override
  int get hashCode => Object.hash(can_certify, can_encrypt_comms, can_encrypt_storage, can_sign, created_at, emails, expires_at, id, key_id, primary_key_id, public_key, subkeys, verified);
  @override
  String toString() => 'GPGKey(can_certify: $can_certify, can_encrypt_comms: $can_encrypt_comms, can_encrypt_storage: $can_encrypt_storage, can_sign: $can_sign, created_at: $created_at, emails: $emails, expires_at: $expires_at, id: $id, key_id: $key_id, primary_key_id: $primary_key_id, public_key: $public_key, subkeys: $subkeys, verified: $verified)';
}
