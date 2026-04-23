part of 'generated_models.dart';

/// DismissPullReviewOptions are options to dismiss a pull review
class DismissPullReviewOptions {
  final String? message;
  final bool? priors;
  const DismissPullReviewOptions({
    this.message,
    this.priors,
  });
  factory DismissPullReviewOptions.fromJson(Map<String, dynamic> json) {
    return DismissPullReviewOptions(
      message: json['message'] != null ? json['message'] as String : null,
      priors: json['priors'] != null ? json['priors'] as bool : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (message != null) map['message'] = message!;
    if (priors != null) map['priors'] = priors!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DismissPullReviewOptions &&
          message == other.message &&
          priors == other.priors;
  @override
  int get hashCode => Object.hash(message, priors);
  @override
  String toString() => 'DismissPullReviewOptions(message: $message, priors: $priors)';
}
