part of 'generated_models.dart';

/// PayloadCommitVerification represents the GPG verification of a commit
class PayloadCommitVerification {
  final String? payload;
  final String? reason;
  final String? signature;
  final PayloadUser? signer;
  final bool? verified;
  const PayloadCommitVerification({
    this.payload,
    this.reason,
    this.signature,
    this.signer,
    this.verified,
  });
  factory PayloadCommitVerification.fromJson(Map<String, dynamic> json) {
    return PayloadCommitVerification(
      payload: json['payload'] != null ? json['payload'] as String : null,
      reason: json['reason'] != null ? json['reason'] as String : null,
      signature: json['signature'] != null ? json['signature'] as String : null,
      signer: json['signer'] != null
          ? PayloadUser.fromJson(json['signer'] as Map<String, dynamic>)
          : null,
      verified: json['verified'] != null ? json['verified'] as bool : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (payload != null) map['payload'] = payload!;
    if (reason != null) map['reason'] = reason!;
    if (signature != null) map['signature'] = signature!;
    if (signer != null) map['signer'] = signer!.toJson();
    if (verified != null) map['verified'] = verified!;
    return map;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PayloadCommitVerification &&
          payload == other.payload &&
          reason == other.reason &&
          signature == other.signature &&
          signer == other.signer &&
          verified == other.verified;
  @override
  int get hashCode => Object.hash(payload, reason, signature, signer, verified);
  @override
  String toString() =>
      'PayloadCommitVerification(payload: $payload, reason: $reason, signature: $signature, signer: $signer, verified: $verified)';
}
