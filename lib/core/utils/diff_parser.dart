class DiffLine {
  final DiffLineType type;
  final String content;
  final int? oldLineNum;
  final int? newLineNum;

  const DiffLine({
    required this.type,
    required this.content,
    this.oldLineNum,
    this.newLineNum,
  });
}

enum DiffLineType { added, removed, context, header, hunk }

class DiffFile {
  final String oldPath;
  final String newPath;
  final String status;
  final List<DiffHunk> hunks;

  const DiffFile({
    required this.oldPath,
    required this.newPath,
    required this.status,
    required this.hunks,
  });
}

class DiffHunk {
  final int oldStart;
  final int newStart;
  final String header;
  final List<DiffLine> lines;

  const DiffHunk({
    required this.oldStart,
    required this.newStart,
    required this.header,
    required this.lines,
  });
}

class DiffParser {
  static List<DiffFile> parse(String rawDiff) {
    final files = <DiffFile>[];
    final lines = rawDiff.split('\n');
    if (lines.isEmpty) return files;

    int i = 0;
    while (i < lines.length) {
      // Skip empty lines
      if (lines[i].trim().isEmpty) {
        i++;
        continue;
      }

      // Look for file header: diff --git a/file b/file
      if (!lines[i].startsWith('diff --git')) {
        i++;
        continue;
      }

      final diffLine = lines[i];
      final parts = diffLine.split(' ');
      final oldPath = parts.length >= 3 ? parts[2].replaceFirst('a/', '') : '';
      final newPath = parts.length >= 4 ? parts[3].replaceFirst('b/', '') : '';
      i++;

      // Determine status by looking for ---/+++ and index
      String status = 'modified';
      while (i < lines.length && !lines[i].startsWith('@@')) {
        if (lines[i].startsWith('new file')) status = 'added';
        if (lines[i].startsWith('deleted file')) status = 'removed';
        if (lines[i].startsWith('rename from')) status = 'renamed';
        i++;
      }

      final hunks = <DiffHunk>[];
      while (i < lines.length && !lines[i].startsWith('diff --git')) {
        if (lines[i].startsWith('@@')) {
          final hunk = _parseHunk(lines, i);
          hunks.add(hunk);
          i += hunk.lines.length + 1;
        } else {
          i++;
        }
      }

      files.add(DiffFile(
        oldPath: oldPath,
        newPath: newPath,
        status: status,
        hunks: hunks,
      ));
    }

    return files;
  }

  static DiffHunk _parseHunk(List<String> lines, int start) {
    final header = lines[start];
    // @@ -oldStart,oldCount +newStart,newCount @@ section header
    final match = RegExp(r'@@ -(\d+)(?:,(\d+))? \+(\d+)(?:,(\d+))? @@(.*)').firstMatch(header);
    final oldStart = int.tryParse(match?.group(1) ?? '') ?? 0;
    final newStart = int.tryParse(match?.group(3) ?? '') ?? 0;

    final diffLines = <DiffLine>[];
    int oldLineNum = oldStart;
    int newLineNum = newStart;

    for (int j = start + 1; j < lines.length; j++) {
      final line = lines[j];
      if (line.startsWith('@@') || line.startsWith('diff --git')) break;

      if (line.startsWith('+')) {
        diffLines.add(DiffLine(
          type: DiffLineType.added,
          content: line.substring(1),
          newLineNum: newLineNum++,
        ));
      } else if (line.startsWith('-')) {
        diffLines.add(DiffLine(
          type: DiffLineType.removed,
          content: line.substring(1),
          oldLineNum: oldLineNum++,
        ));
      } else if (line.startsWith(' ')) {
        diffLines.add(DiffLine(
          type: DiffLineType.context,
          content: line.substring(1),
          oldLineNum: oldLineNum++,
          newLineNum: newLineNum++,
        ));
      } else if (line.startsWith('\\')) {
        diffLines.add(DiffLine(
          type: DiffLineType.context,
          content: line,
        ));
      }
    }

    return DiffHunk(
      oldStart: oldStart,
      newStart: newStart,
      header: header,
      lines: diffLines,
    );
  }
}

/// Default per-file line cap for lazy diff rendering. Files with more
/// diff lines are truncated until the user asks to see everything.
const int kMaxDiffLinesPerFile = 3000;

/// A single row in a flattened, lazily-rendered diff list.
sealed class DiffRow {
  const DiffRow();
}

class DiffFileHeaderRow extends DiffRow {
  final DiffFile file;
  const DiffFileHeaderRow(this.file);
}

class DiffHunkHeaderRow extends DiffRow {
  final DiffHunk hunk;
  const DiffHunkHeaderRow(this.hunk);
}

class DiffLineRow extends DiffRow {
  final DiffLine line;
  const DiffLineRow(this.line);
}

/// Marks the tail of a truncated file; [hiddenLineCount] counts the lines
/// that were not flattened because the file exceeded the line cap.
class DiffTruncatedRow extends DiffRow {
  final DiffFile file;
  final int hiddenLineCount;
  const DiffTruncatedRow(this.file, this.hiddenLineCount);
}

/// Flatten parsed diff files into a row list suitable for
/// `ListView.builder`. Files with more than [maxLinesPerFile] diff lines
/// are truncated (unless [showAll] is true) and get a [DiffTruncatedRow]
/// appended instead of their remaining lines.
List<DiffRow> flattenDiffRows(
  List<DiffFile> files, {
  int maxLinesPerFile = kMaxDiffLinesPerFile,
  bool showAll = false,
}) {
  final rows = <DiffRow>[];
  for (final file in files) {
    rows.add(DiffFileHeaderRow(file));
    final totalLines = file.hunks.fold<int>(0, (sum, h) => sum + h.lines.length);
    final isTruncated = !showAll && totalLines > maxLinesPerFile;
    var emitted = 0;
    for (final hunk in file.hunks) {
      if (isTruncated && emitted >= maxLinesPerFile) break;
      rows.add(DiffHunkHeaderRow(hunk));
      for (final line in hunk.lines) {
        if (isTruncated && emitted >= maxLinesPerFile) break;
        rows.add(DiffLineRow(line));
        emitted++;
      }
    }
    if (isTruncated) {
      rows.add(DiffTruncatedRow(file, totalLines - emitted));
    }
  }
  return rows;
}
