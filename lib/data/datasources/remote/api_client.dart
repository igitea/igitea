import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';

const _maxRetries = 2;
const _retryDelay = Duration(seconds: 1);

class ApiClient {
  final http.Client _client;
  final String baseUrl;
  String? _token;
  String? _basicAuthHeader;

  /// Simple in-memory response cache keyed by URL.
  final Map<String, _CachedResponse> _cache = {};

  ApiClient({
    required this.baseUrl,
    http.Client? client,
    String? token,
  }) : _client = client ?? http.Client(),
       _token = token;

  set token(String? value) => _token = value;

  /// Set Basic Auth from username:password. The password is used only to
  /// compute the Authorization header and is immediately discarded — it is
  /// never stored in memory as a class member.
  void setBasicAuth(String username, String password) {
    final credentials = base64Encode(utf8.encode('$username:$password'));
    _basicAuthHeader = 'Basic $credentials';
  }

  /// Clear the Basic Auth header (e.g. on logout or switch to token auth).
  void clearBasicAuth() => _basicAuthHeader = null;

  Future<http.Response> _retryGet(Uri uri) async {
    Object lastError = const NetworkException('Request failed');
    for (var i = 0; i <= _maxRetries; i++) {
      try {
        final response = await _client
            .get(uri, headers: _headers)
            .timeout(const Duration(seconds: defaultTimeoutSeconds));
        if (response.statusCode >= 500 && i < _maxRetries) {
          lastError = response;
          await Future.delayed(_retryDelay * (i + 1));
          continue;
        }
        return _processResponse(response);
      } on NetworkException catch (e) {
        lastError = e;
        if (i < _maxRetries) {
          await Future.delayed(_retryDelay * (i + 1));
          continue;
        }
      } on http.ClientException catch (e) {
        lastError = NetworkException(e.message.isNotEmpty ? e.message : 'Network error');
        if (i < _maxRetries) {
          await Future.delayed(_retryDelay * (i + 1));
          continue;
        }
      } on TimeoutException catch (_) {
        lastError = const NetworkException('Request timed out');
        if (i < _maxRetries) {
          await Future.delayed(_retryDelay * (i + 1));
          continue;
        }
      }
    }
    if (lastError is http.Response) throw ServerException('Server error: HTTP ${lastError.statusCode}');
    if (lastError is NetworkException) throw lastError;
    throw NetworkException('$lastError');
  }

  Future<http.Response> get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final uri = _buildUri(path, queryParameters);
    try {
      return await _retryGet(uri);
    } on FormatException catch (e) {
      throw NetworkException(e.message);
    }
  }

  /// GET returning raw bytes. Used for binary downloads.
  Future<List<int>> getBytes(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final uri = _buildUri(path, queryParameters);
    try {
      final response = await _client
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: defaultTimeoutSeconds * 3));
      _processResponse(response);
      return response.bodyBytes.toList();
    } on http.ClientException catch (e) {
      throw NetworkException(
        e.message.isNotEmpty ? e.message : 'Network error',
      );
    } on TimeoutException catch (_) {
      throw const NetworkException('Request timed out');
    } on FormatException catch (e) {
      throw NetworkException(e.message);
    }
  }

  /// GET returning raw text (no JSON parse). Used for diff/patch endpoints.
  Future<String> getRaw(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final uri = _buildUri(path, queryParameters);
    try {
      final response = await _client
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: defaultTimeoutSeconds));
      _processResponse(response);
      return response.body;
    } on http.ClientException catch (e) {
      throw NetworkException(
        e.message.isNotEmpty ? e.message : 'Network error',
      );
    } on TimeoutException catch (_) {
      throw const NetworkException('Request timed out');
    } on FormatException catch (e) {
      throw NetworkException(e.message);
    }
  }

  Future<http.Response> post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    final uri = _buildUri(path, queryParameters);
    try {
      final response = await _client
          .post(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: defaultTimeoutSeconds));
      return _processResponse(response);
    } on http.ClientException catch (e) {
      throw NetworkException(
        e.message.isNotEmpty ? e.message : 'Network error',
      );
    } on TimeoutException catch (_) {
      throw const NetworkException('Request timed out');
    } on FormatException catch (e) {
      throw NetworkException(e.message);
    }
  }

  /// POST without the API version prefix. Used for non-API endpoints.
  Future<http.Response> postRaw(
    String baseUrl,
    String path, {
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse(baseUrl).resolve(path);
    try {
      final response = await _client
          .post(
            uri,
            headers: {'Content-Type': 'application/json'},
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: defaultTimeoutSeconds));
      return response;
    } on http.ClientException catch (e) {
      throw NetworkException(
        e.message.isNotEmpty ? e.message : 'Network error',
      );
    } on TimeoutException catch (_) {
      throw const NetworkException('Request timed out');
    } on FormatException catch (e) {
      throw NetworkException(e.message);
    }
  }

  Future<http.Response> put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    final uri = _buildUri(path, queryParameters);
    try {
      final response = await _client
          .put(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: defaultTimeoutSeconds));
      return _processResponse(response);
    } on http.ClientException catch (e) {
      throw NetworkException(
        e.message.isNotEmpty ? e.message : 'Network error',
      );
    } on TimeoutException catch (_) {
      throw const NetworkException('Request timed out');
    } on FormatException catch (e) {
      throw NetworkException(e.message);
    }
  }

  Future<http.Response> patch(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    final uri = _buildUri(path, queryParameters);
    try {
      final response = await _client
          .patch(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: defaultTimeoutSeconds));
      return _processResponse(response);
    } on http.ClientException catch (e) {
      throw NetworkException(
        e.message.isNotEmpty ? e.message : 'Network error',
      );
    } on TimeoutException catch (_) {
      throw const NetworkException('Request timed out');
    } on FormatException catch (e) {
      throw NetworkException(e.message);
    }
  }

  Future<http.Response> delete(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? queryParameters,
  }) async {
    final uri = _buildUri(path, queryParameters);
    try {
      final response = await _client
          .delete(
            uri,
            headers: _headers,
            body: body != null ? jsonEncode(body) : null,
          )
          .timeout(const Duration(seconds: defaultTimeoutSeconds));
      return _processResponse(response);
    } on http.ClientException catch (e) {
      throw NetworkException(
        e.message.isNotEmpty ? e.message : 'Network error',
      );
    } on TimeoutException catch (_) {
      throw const NetworkException('Request timed out');
    } on FormatException catch (e) {
      throw NetworkException(e.message);
    }
  }

  Uri _buildUri(String path, Map<String, String>? query) {
    return Uri.parse(baseUrl).resolve(apiVersionPath + path).replace(
      queryParameters: query?.isNotEmpty == true ? query : null,
    );
  }

  Map<String, String> get _headers {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null && _token!.isNotEmpty) {
      headers['Authorization'] = 'token $_token';
    } else if (_basicAuthHeader != null) {
      headers['Authorization'] = _basicAuthHeader!;
    }
    return headers;
  }

  /// Get from cache if available and not expired.
  String? getCachedBody(String cacheKey) {
    final cached = _cache[cacheKey];
    if (cached != null && !cached.isExpired) return cached.body;
    _cache.remove(cacheKey);
    return null;
  }

  /// Store response body in cache.
  void setCached(String cacheKey, String body, {Duration maxAge = const Duration(minutes: 5)}) {
    _cache[cacheKey] = _CachedResponse(body: body, expiry: DateTime.now().add(maxAge));
  }

  void close() => _client.close();

  void clearCache() => _cache.clear();

  http.Response _processResponse(http.Response response) {
    final status = response.statusCode;
    if (status >= 200 && status < 300) {
      return response;
    }

    String message;
    try {
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      message = json['message'] as String? ?? 'HTTP $status';
    } catch (_) {
      message = 'HTTP $status';
    }

    if (status == 401 || status == 403) {
      throw AuthenticationException(message);
    }
    if (status >= 500) {
      throw ServerException('Server error: $message');
    }
    throw ServerException(message);
  }
}

class _CachedResponse {
  final String body;
  final DateTime expiry;

  const _CachedResponse({required this.body, required this.expiry});

  bool get isExpired => DateTime.now().isAfter(expiry);
}
