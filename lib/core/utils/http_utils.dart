/// Combines a base URL with an API path to produce a full URI.
///
/// [baseUrl] should not end with a trailing slash.
/// [path] should start with a leading slash.
Uri buildUri(String baseUrl, String path) {
  final uri = Uri.parse(baseUrl);
  return uri.replace(path: path);
}

/// Builds standard headers for a Gitea API request.
///
/// If [token] is provided, an Authorization header is included.
Map<String, String> buildHeaders({String? token}) {
  final headers = <String, String>{
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  if (token != null && token.isNotEmpty) {
    headers['Authorization'] = 'token $token';
  }
  return headers;
}
