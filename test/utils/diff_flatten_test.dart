import 'package:flutter_test/flutter_test.dart';
import 'package:igitea/core/utils/diff_parser.dart';

DiffFile _file(int lineCount, {String path = 'a.dart'}) {
  return DiffFile(
    oldPath: path,
    newPath: path,
    status: 'modified',
    hunks: [
      DiffHunk(
        oldStart: 1,
        newStart: 1,
        header: '@@ -1,1 +1,1 @@',
        lines: List.generate(
          lineCount,
          (i) => DiffLine(
            type: i.isEven ? DiffLineType.added : DiffLineType.removed,
            content: 'line $i',
            oldLineNum: i + 1,
            newLineNum: i + 1,
          ),
        ),
      ),
    ],
  );
}

void main() {
  group('flattenDiffRows', () {
    test('small file flattens header + hunk + lines, no truncation', () {
      final rows = flattenDiffRows([_file(3)]);
      expect(rows.whereType<DiffFileHeaderRow>().length, 1);
      expect(rows.whereType<DiffHunkHeaderRow>().length, 1);
      expect(rows.whereType<DiffLineRow>().length, 3);
      expect(rows.whereType<DiffTruncatedRow>(), isEmpty);
      expect(rows.length, 5);
    });

    test('file above cap is truncated and gets a truncated row', () {
      const cap = 10;
      final rows = flattenDiffRows([_file(25)], maxLinesPerFile: cap);
      expect(rows.whereType<DiffLineRow>().length, cap);
      final truncated = rows.whereType<DiffTruncatedRow>().toList();
      expect(truncated.length, 1);
      expect(truncated.single.hiddenLineCount, 25 - cap);
      // Truncated row is the last row of the file.
      expect(rows.last, isA<DiffTruncatedRow>());
    });

    test('showAll disables truncation', () {
      final rows = flattenDiffRows([_file(25)], maxLinesPerFile: 10, showAll: true);
      expect(rows.whereType<DiffLineRow>().length, 25);
      expect(rows.whereType<DiffTruncatedRow>(), isEmpty);
    });

    test('multiple files each get their own header and truncation', () {
      final rows = flattenDiffRows([_file(2, path: 'a.dart'), _file(20, path: 'b.dart')],
          maxLinesPerFile: 10);
      expect(rows.whereType<DiffFileHeaderRow>().length, 2);
      expect(rows.whereType<DiffTruncatedRow>().length, 1);
      expect(rows.whereType<DiffTruncatedRow>().single.file.newPath, 'b.dart');
    });

    test('empty input produces no rows', () {
      expect(flattenDiffRows(const []), isEmpty);
    });
  });
}
