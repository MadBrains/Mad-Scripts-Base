import 'dart:io';
import 'package:mad_scripts_base/src/src.dart';

/// Prompts the user for input with a given title.
///
/// Prints `title` to the console and waits for a line of input.
/// If the entered string is empty or null, throws a `ScriptException`.
///
/// Returns the value entered by the user.
///
/// Example:
/// ```dart
/// String name = input('Enter your name');
/// ```
String input(String title) {
  stdout.write('$title: ');
  final String? temp = stdin.readLineSync();
  if (temp?.isEmpty ?? true) {
    throw const ScriptException("Value can't be null or empty");
  }

  return temp ?? '';
}

/// The `Output` class provides convenient, formatted console logging.
class Output {
  /// Creates an instance of `Output`.
  Output({this.verboseEnabled = false}) {
    if (verboseEnabled) {
      warning('Verbose mode is enabled');
    }
  }

  final bool verboseEnabled;

  /// Simple, unformatted console output.
  ///
  /// [text] — the text to print.
  void call(String text) {
    stdout.writeln(text);
  }

  /// Prints a warning message in yellow with the `[WARN]` prefix.
  ///
  /// [text] — the main message.
  ///
  /// [prefix] and [suffix] — optional strings added before and after the text,
  /// and are not colorized.
  ///
  /// [blockTitle] — when provided, the message is printed as a block with a title and decorative lines.
  void warning(String text, {String prefix = '', String suffix = '', String? blockTitle}) {
    if (blockTitle == null) {
      _print('[WARN]'.yellow, text.yellow, prefix, suffix);
    } else {
      _printBlock(blockTitle, text, (String s) => s.yellow);
    }
  }

  /// Prints an informational message in blue with the `[INFO]` prefix.
  ///
  /// [text] — the main message.
  ///
  /// [prefix] and [suffix] — optional strings added before and after the text,
  /// and are not colorized.
  ///
  /// [blockTitle] — when provided, the message is printed as a block with a title and decorative lines.
  void info(String text, {String prefix = '', String suffix = '', String? blockTitle}) {
    if (blockTitle == null) {
      _print('[INFO]'.blue, text.blue, prefix, suffix);
    } else {
      _printBlock(blockTitle, text, (String s) => s.blue);
    }
  }

  /// Prints an error message in red with the `[ERR]` prefix.
  ///
  /// [text] — the main message.
  ///
  /// [prefix] and [suffix] — optional strings added before and after the text,
  /// and are not colorized.
  ///
  /// [blockTitle] — when provided, the message is printed as a block with a title and decorative lines.
  void error(String text, {String prefix = '', String suffix = '', String? blockTitle}) {
    if (blockTitle == null) {
      _print('[ERR]'.red, text.red, prefix, suffix);
    } else {
      _printBlock(blockTitle, text, (String s) => s.red);
    }
  }

  /// Prints a success message in green with the `[SUCCESS]` prefix.
  ///
  /// [text] — the main message.
  ///
  /// [prefix] and [suffix] — optional strings added before and after the text,
  /// and are not colorized.
  ///
  /// [blockTitle] — when provided, the message is printed as a block with a title and decorative lines.
  void success(String text, {String prefix = '', String suffix = '', String? blockTitle}) {
    if (blockTitle == null) {
      _print('[SUCCESS]'.green, text.green, prefix, suffix);
    } else {
      _printBlock(blockTitle, text, (String s) => s.green);
    }
  }

  /// Prints debug messages only when [verboseEnabled] is `true`.
  void debug(String text, {String prefix = '', String suffix = '', String? blockTitle}) {
    if (!verboseEnabled) return;
    if (blockTitle == null) {
      _print('[DBG]', text, prefix, suffix);
    } else {
      _printBlock('[DBG] $blockTitle', text, (String s) => s);
    }
  }

  /// Helper to print a single line with color and optional prefix/suffix.
  void _print(String label, String coloredText, String prefix, String suffix) {
    stdout.writeln('$label $prefix$coloredText$suffix');
  }

  /// Helper to print a multi-line block with a colored title, message,
  /// and a separator line beneath it.
  ///
  /// [title] — the block title.
  ///
  /// [message] — the main message.
  ///
  /// [color] — a function used to colorize the text.
  void _printBlock(String title, String message, String Function(String) color) {
    final String titleLine = '-- $title --';
    const int minWidth = 50;
    final int lineLength = titleLine.length > minWidth ? titleLine.length : minWidth;
    final int extraDashes = lineLength - titleLine.length;
    final int leftDashes = extraDashes ~/ 2;
    final int rightDashes = extraDashes - leftDashes;
    final String paddedTitle = '${'-' * leftDashes}$titleLine${'-' * rightDashes}';

    stdout.writeln();
    stdout.writeln(color(paddedTitle));
    stdout.writeln(color(message));
    stdout.writeln(color('-' * lineLength));
    stdout.writeln();
  }
}

/// Provides methods to print messages of different types with color indication
/// and optional titled blocks.
///
/// Features:
/// - Common message levels: plain output, warning, info, error, and success.
/// - Automatic prefixes (`[WARN]`, `[INFO]`, `[ERR]`, `[SUCCESS]`).
/// - Colored text via ANSI escape sequences.
/// - Multi-line blocks with a title and decorative separators.
/// - `prefix` and `suffix` parameters to wrap the main text with additional strings.
///
/// Example:
/// ```dart
/// output('Plain output');
/// output.warning('Warning');
/// output.error('Error', blockTitle: 'Loading error');
/// output.info('Info message', prefix: ' >> ', suffix: ' <<');
/// output.success('Completed successfully');
/// ```
late final Output output;
