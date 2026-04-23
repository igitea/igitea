import 'dart:convert';

/// Safely extracts a string value from a JSON map.
///
/// Returns `null` if the key is missing or the value is not a string.
String? jsonString(Map<String, dynamic> json, String key) {
  final value = json[key];
  return value is String ? value : null;
}

/// Safely extracts an integer value from a JSON map.
///
/// Returns `null` if the key is missing or the value is not a num.
int? jsonInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  return value is num ? value.toInt() : null;
}

/// Safely extracts a boolean value from a JSON map.
///
/// Returns `null` if the key is missing or the value is not a bool.
bool? jsonBool(Map<String, dynamic> json, String key) {
  final value = json[key];
  return value is bool ? value : null;
}

/// Safely extracts a list from a JSON map.
///
/// Returns `null` if the key is missing or the value is not a list.
List<dynamic>? jsonList(Map<String, dynamic> json, String key) {
  final value = json[key];
  return value is List<dynamic> ? value : null;
}

/// Safely extracts a nested object from a JSON map.
///
/// Returns `null` if the key is missing or the value is not a map.
Map<String, dynamic>? jsonObject(Map<String, dynamic> json, String key) {
  final value = json[key];
  return value is Map<String, dynamic> ? value : null;
}

/// Encodes an object to a JSON string with pretty printing disabled.
String encodeJson(Object? object) => jsonEncode(object);
