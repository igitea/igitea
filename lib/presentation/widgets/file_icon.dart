import 'package:flutter/material.dart';

IconData fileIcon(String? type, String? name) {
  if (type == 'dir') return Icons.folder;
  if (name == null) return Icons.insert_drive_file;
  final ext = name.contains('.') ? name.split('.').last.toLowerCase() : '';
  return switch (ext) {
    'dart' || 'js' || 'ts' || 'py' || 'rb' || 'go' || 'rs' || 'java' || 'kt' || 'c' || 'cpp' || 'h' || 'cs' || 'swift' || 'scala' || 'sh' || 'bash' => Icons.code,
    'md' || 'txt' || 'rst' || 'adoc' => Icons.article,
    'png' || 'jpg' || 'jpeg' || 'gif' || 'svg' || 'webp' || 'ico' => Icons.image,
    'pdf' => Icons.picture_as_pdf,
    'zip' || 'tar' || 'gz' || 'bz2' || 'xz' || '7z' || 'rar' => Icons.archive,
    'json' || 'yaml' || 'yml' || 'xml' || 'toml' || 'ini' || 'cfg' || 'env' => Icons.settings,
    'lock' => Icons.lock,
    _ => Icons.insert_drive_file,
  };
}