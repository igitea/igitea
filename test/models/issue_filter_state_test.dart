import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/presentation/models/issue_filter_state.dart';

void main() {
  group('IssueFilterState', () {
    test('defaults have no filters', () {
      const state = IssueFilterState();
      expect(state.hasFilters, isFalse);
      expect(state.reviewRequested, isFalse);
    });

    test('reviewRequested is reflected in hasFilters', () {
      const state = IssueFilterState(reviewRequested: true);
      expect(state.hasFilters, isTrue);
      expect(state.reviewRequested, isTrue);
    });

    test('copyWith updates reviewRequested', () {
      const state = IssueFilterState();
      final updated = state.copyWith(reviewRequested: true);
      expect(updated.reviewRequested, isTrue);
      expect(updated.mentionedMe, isFalse);
    });

    test('equality includes reviewRequested', () {
      const a = IssueFilterState(reviewRequested: true);
      const b = IssueFilterState(reviewRequested: true);
      const c = IssueFilterState(reviewRequested: false);
      expect(a, equals(b));
      expect(a, isNot(equals(c)));
      expect(a.hashCode, equals(b.hashCode));
    });
  });
}
