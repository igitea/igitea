# Changelog

## [0.1.0] - 2026-04-23

### Added

- Bootstrap Flutter project with Android, iOS, macOS, Linux, and Windows support.
- Set up Clean Architecture folder structure under `lib/`.
- Add approved third-party dependencies: `http`, `path_provider`, `shared_preferences`, `url_launcher`, `file_picker`.
- Initialize bilingual README and CHANGELOG.
- Add `tools/generate_models.py` to generate Dart data models from `doc/openapi.yaml`.
- Generate 216 Dart model classes under `lib/data/models/generated/`.
- Add unit tests for model serialization round-trips.
- Implement `ApiClient` with token/Basic auth, timeout, and error mapping.
- Implement `GiteaApiService` with 93 core API methods across all 10 tags.
- Add `tools/generate_api_service.py` for generating service methods from OpenAPI spec.
- Add unit tests for `ApiClient` and `GiteaApiService` covering success, 4xx, 5xx, and network failures.
