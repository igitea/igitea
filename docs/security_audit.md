# iGitea 安全审计报告

**日期:** 2026-07-31  
**范围:** `lib/` 下 100+ Dart 文件  
**审计类型:** 安全漏洞（认证、数据存储、传输、授权）  
**前置报告:** [PARALLEL_AUDIT_REPORT.md](../PARALLEL_AUDIT_REPORT.md)（62个BUG已审计，58个已修复）

---

## 总览

| 级别 | 数量 | 状态 |
|------|------|------|
| 🔴 **严重 (P0)** | 3 | 需立即修复 |
| 🟠 **高危 (P1)** | 4 | 本周修复 |
| 🟡 **中危 (P2)** | 7 | 下个迭代修复 |
| **合计** | **14** | |

---

## 🔴 P0 — 严重漏洞

### [SEC-001] 密码和Token以明文存储在SharedPreferences中

**文件:** `lib/core/storage/auth_storage.dart:22-43`  
**风险等级:** 🔴 CRITICAL  
**CWE:** [CWE-312: Cleartext Storage of Sensitive Information](https://cwe.mitre.org/data/definitions/312.html)

**描述:**  
`AuthStorage` 使用 `SharedPreferences` 存储：
- 用户密码 (`auth_password`)
- Access Token (`auth_token`)  
- Refresh Token (`auth_refresh_token`)

`SharedPreferences` 在 Android 上存储为 XML 文件，iOS 上为 plist 文件，**均未加密**。任何有物理/ADB 访问权限的人，或利用备份、恶意应用读取 `/data/data/<package>/shared_prefs/*.xml` 即可获取明文凭据。

**影响:** 攻击者获取设备文件系统访问后可直接盗取 Gitea 账号凭据。

**修复建议:**
```dart
// 使用 flutter_secure_storage 替代 SharedPreferences
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  final _secureStorage = const FlutterSecureStorage();
  
  Future<void> saveCredentials({...}) async {
    if (token != null) {
      await _secureStorage.write(key: _keyToken, value: token);
    }
    if (password != null) {
      await _secureStorage.write(key: _keyPassword, value: password);
    }
  }
}
```

---

### [SEC-002] ApiClient 在内存中明文存留密码和Token

**文件:** `lib/data/datasources/remote/api_client.dart:15-17`  
**风险等级:** 🔴 CRITICAL  
**CWE:** [CWE-316: Cleartext Storage of Sensitive Information in Memory](https://cwe.mitre.org/data/definitions/316.html)

**描述:**  
`ApiClient` 类将 `_token`、`_username`、`_password` 作为私有成员变量明文存储在整个应用生命周期中。内存 dump 或进程检查即可泄露。

```dart
class ApiClient {
  String? _token;      // ← 明文
  String? _username;   // ← 明文
  String? _password;   // ← 明文
}
```

**影响:** 内存取证攻击可恢复凭据。

**修复建议:**
- Token 使用后立即置 null（每次请求时从 `FlutterSecureStorage` 读取）
- 密码仅用于登录时的一次性 Basic Auth 头构建，不应存储

---

### [SEC-003] 无 HTTPS 强制 — 用户可输入 HTTP 地址导致凭据明文传输

**文件:** `lib/presentation/pages/login_page.dart:84-93`  
**风险等级:** 🔴 CRITICAL  
**CWE:** [CWE-319: Cleartext Transmission of Sensitive Information](https://cwe.mitre.org/data/definitions/319.html)

**描述:**  
登录页面的 URL 验证只检查 `hasScheme` 和 `hasAuthority`，**允许 `http://`**。如果用户输入 `http://gitea.example.com`，后续所有 API 请求（包括 Basic Auth 的 username:password Base64 编码、Token 明文）都将通过 HTTP 明文传输。

```dart
final uri = Uri.tryParse(value.trim());
if (uri == null || !uri.hasScheme || !uri.hasAuthority) {  // ← 未拒绝 HTTP
  return l10n.pleaseEnterValidUrl;
}
return null;
```

**修复建议:**
```dart
String? _validateUrl(String? value, AppLocalizations l10n) {
  if (value == null || value.trim().isEmpty) return l10n.pleaseEnterServerUrl;
  final uri = Uri.tryParse(value.trim());
  if (uri == null || !uri.hasScheme || !uri.hasAuthority) {
    return l10n.pleaseEnterValidUrl;
  }
  if (uri.scheme != 'https') {
    return '请使用 HTTPS 地址';  // 或 l10n.requireHttps
  }
  return null;
}
```

---

## 🟠 P1 — 高危漏洞

### [SEC-004] 无证书固定 (Certificate Pinning)，易受中间人攻击

**文件:** `lib/data/datasources/remote/api_client.dart:12-31`  
**风险等级:** 🟠 HIGH  
**CWE:** [CWE-295: Improper Certificate Validation](https://cwe.mitre.org/data/definitions/295.html)

**描述:**  
`ApiClient` 使用默认的 `http.Client()`，信任所有系统 CA 证书。如果设备被安装了恶意 CA 证书，或攻击者控制了中间 CA，所有 HTTPS 流量可被解密。

**修复建议:**
```dart
// 使用 HttpClient 配置证书固定
final ioClient = HttpClient()
  ..badCertificateCallback = (cert, host, port) {
    // 仅在开发环境允许，生产环境必须验证
    return false;
  };
final client = IOClient(ioClient);
```

或集成 `certificate_pinning_http_client` 包。

---

### [SEC-005] OAuth2 自定义 URI Scheme `igitea://` 可被劫持

**文件:** `lib/presentation/pages/login_page.dart:30-32`  
**风险等级:** 🟠 HIGH  
**CWE:** [CWE-939: Improper Authorization in Handler for Custom URL Scheme](https://cwe.mitre.org/data/definitions/939.html)

**描述:**  
OAuth2 回调使用自定义 URI scheme `igitea://oauth/callback`。Android/iOS 上任何应用都可以注册相同 scheme，恶意应用可抢先劫持回调，窃取 OAuth2 Authorization Code。

```dart
final _oauthRedirectUriController = TextEditingController(
  text: 'igitea://oauth/callback',  // ← 自定义 scheme
);
```

**修复建议:**
- Android 使用 [App Links](https://developer.android.com/training/app-links) (HTTPS)
- iOS 使用 [Universal Links](https://developer.apple.com/ios/universal-links/) (HTTPS)  
- 或使用 PKCE (Proof Key for Code Exchange) 增加安全性

---

### [SEC-006] OAuth2 Client Secret 在 TextEditingController 中明文存储

**文件:** `lib/presentation/pages/login_page.dart:29`  
**风险等级:** 🟠 HIGH  
**CWE:** [CWE-316: Cleartext Storage of Sensitive Information in Memory](https://cwe.mitre.org/data/definitions/316.html)

**描述:**  
`_oauthClientSecretController` 将 OAuth2 `client_secret` 明文保存在内存中。配合本地恶意应用或内存 dump，Secret 可被窃取。

```dart
final _oauthClientSecretController = TextEditingController();
```

**修复建议:**
- client_secret 应仅在 `exchangeOAuth2Code` 调用期间存活，调用后立即置 null
- 理想情况下，OAuth2 PKCE 流程不需要 client_secret

---

### [SEC-007] 无登录失败次数限制 / 暴力破解保护

**文件:** `lib/presentation/pages/login_page.dart:95-112`, `lib/presentation/state/auth_notifier.dart:43-65`  
**风险等级:** 🟠 HIGH  
**CWE:** [CWE-307: Improper Restriction of Excessive Authentication Attempts](https://cwe.mitre.org/data/definitions/307.html)

**描述:**  
登录方法 (`_loginWithBasicAuth`, `_loginWithToken`) 没有客户端级别或应用级别的登录尝试次数限制。虽然 Gitea 服务端可能有限制，但客户端应实现指数退避和锁定机制作为防御层。

**修复建议:**
```dart
class LoginAttemptTracker {
  int _failures = 0;
  DateTime? _lockedUntil;
  static const _maxAttempts = 5;
  static const _lockoutDuration = Duration(minutes: 15);
  
  bool get isLocked => _lockedUntil?.isAfter(DateTime.now()) ?? false;
  
  void recordFailure() {
    _failures++;
    if (_failures >= _maxAttempts) {
      _lockedUntil = DateTime.now().add(_lockoutDuration);
    }
  }
}
```

---

### [SEC-008] 无会话超时 / 自动登出机制

**文件:** `lib/presentation/state/auth_notifier.dart:164-181`  
**风险等级:** 🟡 MEDIUM  
**CWE:** [CWE-613: Insufficient Session Expiration](https://cwe.mitre.org/data/definitions/613.html)

**描述:**  
`restoreSession()` 在应用启动时自动恢复登录状态，且没有设置会话超时。认证状态永久有效，直到用户手动登出。

**产品决策:**  
经讨论，iGitea 作为开发者工具，**保持永久会话是正确选择**。理由：
- Gitea Token 不会自动过期（除非手动吊销），与 Token 自身生命周期一致
- 不涉及资金/支付等高风险操作，无需金融级会话管理
- 同类产品（GitHub Mobile、GitLab App、Gitea 官方 App）均为永久登录
- 设备锁屏密码/Face ID 已是第一道防线
- 强制用户频繁重新登录会损害体验，尤其对于日常高频使用的开发工具

**真正需要保证的安全防线（由其他 SEC 项覆盖）：**
1. ✅ Token 加密存储 → **SEC-001** (`flutter_secure_storage`)
2. ✅ 传输加密 → **SEC-003** (强制 HTTPS)
3. ✅ 手动登出彻底清除 → 当前已实现 (`AuthStorage.clear()`)

只要以上三项到位，永久会话的风险可控。用户也可随时在 Gitea Web 端吊销 Token。

**N/A — 不添加会话超时。** 保持当前行为：自动恢复会话 + 手动登出清除。如有需要可后续添加可选的 App Lock（生物识别二次验证）但不做强制超时。

---

## 🟡 P2 — 中危漏洞

### [SEC-009] debugPrint 可能泄露错误信息

**文件:** `lib/app.dart:35-37`, `lib/main.dart:7-9`  
**风险等级:** 🟡 MEDIUM  
**CWE:** [CWE-532: Insertion of Sensitive Information into Log File](https://cwe.mitre.org/data/definitions/532.html)

**描述:**  
`debugPrint` 在 Release 模式下虽然被 Flutter 框架禁用，但错误 handler 中的 `debugPrint` 仍可能将包含敏感信息的异常堆栈输出到系统日志。

**修复建议:**
- 使用条件化日志 (`kDebugMode ? debugPrint(...) : null`)
- 或集成 Logger 包并进行 Release 过滤

---

### [SEC-010] Deep Link 路由缺乏权限验证

**文件:** `lib/app.dart` (Deep Link 处理)  
**风险等级:** 🟡 MEDIUM  
**CWE:** [CWE-939: Improper Authorization in Handler for Custom URL Scheme](https://cwe.mitre.org/data/definitions/939.html)

**描述:**  
根据 README，应用支持 Deep Link：
- `/{owner}/{repo}` → 仓库
- `/{owner}/{repo}/issues/{id}` → Issue
- `/{owner}/{repo}/pulls/{id}` → Pull Request

如果未验证用户是否已登录就处理这些链接，可为未授权用户提供敏感仓库信息。

**修复建议:**
- 所有 Deep Link 处理器先检查 `isAuthenticated`
- 未认证时先引导用户登录

---

### [SEC-011] Basic Auth Base64 编码 ≠ 加密

**文件:** `lib/data/datasources/remote/api_client.dart:281`  
**风险等级:** 🟡 MEDIUM  
**CWE:** [CWE-327: Use of a Broken or Risky Cryptographic Algorithm](https://cwe.mitre.org/data/definitions/327.html)

**描述:**  
Basic Auth 的 username:password 使用 Base64 编码（`base64Encode(utf8.encode('$_username:$_password')`），但 Base64 **不是加密**，本质仍为明文。即使通过 HTTPS 传输，如果 SSL 被 strip，凭据立即可读。

```dart
final credentials = base64Encode(utf8.encode('$_username:$_password'));
headers['Authorization'] = 'Basic $credentials';
```

**修复建议:**
- 完全废弃 Basic Auth，仅保留 Token/OAuth2
- 如果必须保留，在 URL 验证中强制 HTTPS（参见 SEC-003）

---

### [SEC-012] API 响应缓存未清理敏感数据

**文件:** `lib/data/datasources/remote/api_client.dart:20,296-298`  
**风险等级:** 🟡 MEDIUM  
**CWE:** [CWE-525: Use of Web Browser Cache Containing Sensitive Information](https://cwe.mitre.org/data/definitions/525.html)

**描述:**  
`ApiClient` 有一个内存缓存 `_cache`（5分钟 TTL），缓存 API 响应包括用户数据、Token 列表等。缓存没有按内容分类 purge 敏感数据的机制。

**修复建议:**
- 登出时调用 `clearCache()`
- 对敏感端点（如 `/user`, `/tokens`）设置 `maxAge: Duration.zero` 跳过缓存

---

### [SEC-013] Auth State 中存储明文凭据

**文件:** `lib/domain/entities/auth_state.dart`, `lib/presentation/state/auth_notifier.dart:58-65`  
**风险等级:** 🟡 MEDIUM  
**CWE:** [CWE-316: Cleartext Storage of Sensitive Information in Memory](https://cwe.mitre.org/data/definitions/316.html)

**描述:**  
`AuthAuthenticated` 状态对象包含明文 `token`、`username`、`password`。这些值在 Flutter Widget 树中传递，每次 rebuild 都暴露在内存中。

```dart
_state = AuthAuthenticated(
  baseUrl: baseUrl,
  method: AuthMethod.basic,
  username: username,   // ← 明文
  password: password,   // ← 明文
  user: value,
);
```

**修复建议:**
- `AuthAuthenticated` 不应携带 `password`，应仅存储 `method` 和 `user`
- Token 按需从 `FlutterSecureStorage` 读取

---

### [SEC-014] 文件下载缺少 MIME 类型和内容安全校验

**文件:** `lib/presentation/pages/repo_file_page.dart`, `lib/presentation/pages/release_detail_page.dart`  
**风险等级:** 🟡 MEDIUM  
**CWE:** [CWE-434: Unrestricted Upload of File with Dangerous Type](https://cwe.mitre.org/data/definitions/434.html)

**描述:**  
Release 附件下载和仓库文件下载未校验 Content-Type 和文件扩展名。恶意服务端可返回危险文件类型（`.dmg`, `.apk`, `.exe`）伪装数据文件。

**修复建议:**
- 在下载前检查 `Content-Type` 响应头
- 显示文件类型警告（如 "此文件类型可能不安全"）
- 使用白名单限制可下载的文件类型

---

## 未发现问题（已验证安全）

| 检查项 | 结果 |
|--------|------|
| 硬编码 API 密钥/Token | ✅ 未发现 |
| 硬编码密码 | ✅ 未发现 |
| `eval()` 或代码注入 | ✅ 未发现 |
| 不安全 HTTP URL（代码中） | ✅ 全部使用 HTTPS 引用 |
| SQL 注入 | ✅ Flutter 无 SQL 直接使用 |
| dart:mirrors 反射 | ✅ 未使用 |

---

## 修复优先级建议

### Sprint 1 — 本周 (P0)
1. **[SEC-001]** 替换 `SharedPreferences` 为 `flutter_secure_storage`
2. **[SEC-003]** 在 URL 验证中强制 HTTPS
3. **[SEC-002]** 重构 `ApiClient` 不在内存中持久化密码

### Sprint 2 — 下周 (P1)
4. **[SEC-007]** 添加登录失败限制
5. **[SEC-005]** OAuth2 使用 HTTPS Universal Links
6. **[SEC-006]** client_secret 用后即焚
7. **[SEC-004]** 添加证书固定（可选，需要维护）

### Sprint 3 — 后续 (P2)
9-14. 依次处理剩余 P2 漏洞

---

*此报告仅覆盖安全相关漏洞，非安全 BUG 请参见 [PARALLEL_AUDIT_REPORT.md](../PARALLEL_AUDIT_REPORT.md)。*
