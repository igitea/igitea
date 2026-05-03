import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/core/storage/auth_method_storage.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/domain/entities/auth_state.dart';
import 'package:igitea/presentation/pages/profile_page.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  setUp(() {
    Injection.initialize();
    Injection.authNotifier.state = const AuthAuthenticated(
      baseUrl: 'https://gitea.example.com',
      method: AuthMethod.token,
      token: 'test-token',
      user: User(id: 1, login: 'testuser'),
    );
  });

  testWidgets('renders profile page', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const ProfilePage()));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(find.byType(Scaffold), findsOneWidget);
  });
}
