import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

IconData fileIcon(String? type, String? name) {
  if (type == 'dir') return FIcons.folder;
  if (name == null) return FIcons.file;
  final ext = name.contains('.') ? name.split('.').last.toLowerCase() : '';
  return switch (ext) {
    'dart' || 'js' || 'ts' || 'py' || 'rb' || 'go' || 'rs' || 'java' || 'kt' || 'c' || 'cpp' || 'h' || 'cs' || 'swift' || 'scala' || 'sh' || 'bash' => FIcons.fileCode,
    'md' || 'txt' || 'rst' || 'adoc' => FIcons.fileText,
    'png' || 'jpg' || 'jpeg' || 'gif' || 'svg' || 'webp' || 'ico' => FIcons.image,
    'pdf' => FIcons.fileType,
    'zip' || 'tar' || 'gz' || 'bz2' || 'xz' || '7z' || 'rar' => FIcons.archive,
    'json' || 'yaml' || 'yml' || 'xml' || 'toml' || 'ini' || 'cfg' || 'env' => FIcons.fileCog,
    'lock' => FIcons.lock,
    _ => FIcons.file,
  };
}