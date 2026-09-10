/// Timeout for regular JSON API requests. Kept short so slow networks
/// surface errors quickly instead of spinning for a minute.
const int requestTimeoutSeconds = 15;

/// Timeout for large binary downloads (raw file bytes, archives).
const int binaryTimeoutSeconds = 45;

/// Default API version path segment.
const String apiVersionPath = '/api/v1';
