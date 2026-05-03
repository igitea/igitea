part of 'generated_models.dart';

/// SubmitPullReviewOptions are options to submit a pending pull review
class SubmitPullReviewOptions {
  final String? body;
  final ReviewStateType? event;
  const SubmitPullReviewOptions({
    this.body,
    this.event,
  });
  factory SubmitPullReviewOptions.fromJson(Map<String, dynamic> json) {
    return SubmitPullReviewOptions(
      body: json['body'] != null ? json['body'] as String : null,
      event: json['event'] != null ? ReviewStateType.fromJson(json['event'] as Map<String, dynamic>) : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (body != null) map['body'] = body!;
    if (event != null) map['event'] = event!.toJson();
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubmitPullReviewOptions &&
          body == other.body &&
          event == other.event;
  @override
  int get hashCode => Object.hash(body, event);
  @override
  String toString() => 'SubmitPullReviewOptions(body: $body, event: $event)';
}
