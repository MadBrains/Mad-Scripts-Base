import 'dart:io';

import 'package:mad_scripts_base/src/src.dart';

/// A helper class for managing files in a directory.
class FileManager {
  const FileManager(this._dirName);

  /// Path to the directory where files will be created.
  final String _dirName;

  /// Creates a file with the provided content.
  ///
  /// Parameters:
  /// - [fileName]: File name (if `null`, [_dirName] is treated as the full file path when [dirPathContainsFile] is `true`).
  /// - [content]: File contents.
  /// - [ignoreExistCheck]: Skip existence check (default: `false`).
  /// - [addToGit]: Add the file to Git (default: `false`).
  /// - [dirPathContainsFile]: When `true`, [_dirName] is a full file path, not a directory (default: `false`).
  /// - [createMessage]: Message shown on creation (default: `'Create new'`).
  /// - [skipExistsCheck]: Additional flag to skip the existence check (default: `false`).
  /// - [throwOnError]: Whether to throw on errors like existing file (default: `true`).
  Future<void> createFile({
    required String content,
    String? fileName,
    bool ignoreExistCheck = false,
    bool addToGit = false,
    bool dirPathContainsFile = false,
    String createMessage = 'Create new',
    bool skipExistsCheck = false,
    bool throwOnError = true,
  }) async {
    if (fileName == null && !dirPathContainsFile) {
      throw const ScriptException('File name is required!');
    }

    File file;
    if (fileName != null) {
      final bool hasFormatName = fileName.contains('.');
      file = File('$_dirName/${hasFormatName ? fileName : '$fileName.dart'}');
    } else {
      file = File(_dirName);
    }

    if (!ignoreExistCheck && file.existsSync() && !skipExistsCheck && throwOnError) {
      throw const ScriptException('File already exists!');
    }

    await file.create(recursive: true);
    file.writeAsStringSync(content);

    if (addToGit) {
      _tryGitAdd(file.path);
    }

    output.success('$createMessage file://${Uri.parse(file.absolute.path).toFilePath()}');
  }

  /// Updates a file with the provided content.
  ///
  /// If the file does not exist, it will be created.
  ///
  /// Parameters:
  /// - [fileName]: File name (if `null`, [_dirName] is treated as the full file path when [dirPathContainsFile] is `true`).
  /// - [content]: New file contents.
  /// - [dirPathContainsFile]: When `true`, [_dirName] is a full file path, not a directory (default: `false`).
  /// - [addToGit]: Add the file to Git (default: `false`).
  Future<void> updateFile({
    required String content,
    String? fileName,
    bool dirPathContainsFile = false,
    bool addToGit = false,
  }) async {
    await createFile(
      fileName: fileName,
      content: content,
      ignoreExistCheck: true,
      dirPathContainsFile: dirPathContainsFile,
      addToGit: addToGit,
      createMessage: 'Update',
    );
  }

  /// Internal helper to run `git add` for the given file.
  Future<void> _tryGitAdd(String filename) async {
    try {
      await Process.run('git', <String>['add', filename]);
    } catch (e) {
      output.warning(e.toString());
      output.error('Git add error.');
    }
  }
}
