part of 'generated_models.dart';

/// APIError is an api error with a message
class APIError {
  final String? message;
  final String? url;
  const APIError({
    this.message,
    this.url,
  });
  factory APIError.fromJson(Map<String, dynamic> json) {
    return APIError(
      message: json['message'] != null ? json['message'] as String : null,
      url: json['url'] != null ? json['url'] as String : null,
    );
  }
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (message != null) map['message'] = message!;
    if (url != null) map['url'] = url!;
    return map;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is APIError &&
          message == other.message &&
          url == other.url;
  @override
  int get hashCode => Object.hash(message, url);
  @override
  String toString() => 'APIError(message: $message, url: $url)';
}
