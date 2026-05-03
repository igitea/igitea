import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/di/injection.dart';
import 'package:igitea/data/models/generated/generated_models.dart';
import 'package:igitea/presentation/pages/search_page.dart';
import 'package:igitea/presentation/state/repo_notifier.dart';
import 'package:igitea/widget_test_helpers.dart';

void main() {
  setUp(() {
    Injection.initialize();
  });

  testWidgets('renders SearchBar and tabs', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const SearchPage()));
    await tester.pump();

    expect(find.byType(SearchBar), findsOneWidget);
    expect(find.text('Repositories'), findsWidgets);
    expect(find.text('Issues'), findsWidgets);
    expect(find.text('Users'), findsWidgets);
  });

  testWidgets('shows search results for repos after search', (tester) async {
    await tester.pumpWidget(buildTestableWidget(const SearchPage()));
    await tester.pump();

    final searchBar = find.byType(SearchBar);
    await tester.enterText(searchBar, 'flutter');
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pump();

    Injection.repoNotifier.state = SearchResultsLoaded(
      SearchResults(data: [
        Repository(id: 1, name: 'flutter', full_name: 'user/flutter', stars_count: 100, forks_count: 50),
      ]),
    );
    await tester.pump();
    expect(find.text('user/flutter'), findsOneWidget);
  });
}
