# 更新日志

## [0.1.0] - 2026-04-23

### 新增

- 初始化 Flutter 项目，支持 Android、iOS、macOS、Linux、Windows 平台。
- 在 `lib/` 下搭建 Clean Architecture 目录结构。
- 添加已批准的第三方依赖：`http`、`path_provider`、`shared_preferences`、`url_launcher`、`file_picker`。
- 初始化双语 README 和 CHANGELOG。
- 添加 `tools/generate_models.py`，用于从 `doc/openapi.yaml` 生成 Dart 数据模型。
- 在 `lib/data/models/generated/` 下生成 216 个 Dart 模型类。
- 添加模型序列化单元测试。
- 实现 `ApiClient`，支持 token/Basic 认证、超时和错误映射。
- 实现 `GiteaApiService`，覆盖全部 10 个 tag 的 93 个核心 API 方法。
- 添加 `tools/generate_api_service.py`，用于从 OpenAPI spec 自动生成 service 方法。
- 添加 `ApiClient` 和 `GiteaApiService` 单元测试，覆盖成功、4xx、5xx 及网络异常路径。
