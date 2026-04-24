import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/presentation/pages/repo_file_page.dart';

void main() {
  setUp(() {
    Injection.initialize();
  });

  testWidgets('renders file name in app bar', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RepoFilePage(
          owner: 'testowner',
          repo: 'testrepo',
          path: 'README.md',
          name: 'README.md',
        ),
      ),
    );
    expect(find.text('README.md'), findsOneWidget);
  });

  testWidgets('shows loading indicator initially', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: RepoFilePage(
          owner: 'testowner',
          repo: 'testrepo',
          path: 'test.png',
          name: 'test.png',
          downloadUrl: 'https://example.com/test.png',
        ),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
