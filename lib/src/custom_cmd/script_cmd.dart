// ignore: depend_on_referenced_packages
import 'package:args/command_runner.dart';
import 'package:mad_scripts_base/src/src.dart';

/// Abstract base class for all project commands.
/// Inherits from [Command] and provides shared behavior for console commands.
///
/// ## Purpose
/// Offer a consistent surface for CLI commands with common options, lifecycle,
/// and logging behavior. Subclasses implement the actual logic in [runWrapped].
///
/// ## Built-in CLI options
/// - `--config, -c` — Path to a config file. If not provided, [configPath]
///   falls back to [defaultConfig] (which subclasses may set).
/// - `--timer, -t` — Enables execution time measurements via [StopwatchLogger].
///   When set, the command prints start/stop and checkpoint timings.
/// - `--verbose` — Enables verbose logging for [output.debug] and prints a
///   notice that verbose mode is enabled at startup.
///
/// ## Lifecycle
/// - [run] initializes [output] with the current verbosity,
///   shows deprecation/experimental notices, optionally starts timing,
///   then calls [runWrapped] and finally stops timing.
/// - Subclasses should implement [runWrapped] to perform their work.
///
/// ### Example
/// ```dart
/// class MyCommand extends ScriptCommand<void> {
///   @override
///   String get description => 'Does something useful';
///
///   @override
///   String get name => 'my-command';
///
///   @override
///   Future<void> runWrapped() async {
///     output.info('Running ${this.name}');
///     // ... your logic
///   }
/// }
/// ```
abstract class ScriptCommand<T> extends Command<T> {
  /// Creates a command with common CLI options preconfigured.
  ScriptCommand() {
    // Path to a configuration file
    argParser.addOption(
      'config',
      abbr: 'c',
      help: 'Path to config',
      callback: (String? value) => _configPath = value,
    );

    // Enable execution time measurement
    argParser.addFlag(
      'timer',
      abbr: 't',
      help: 'Measure execution time',
      callback: (bool value) {
        StopwatchLogger.log = value;
      },
    );

    // Enable verbose logs
    argParser.addFlag(
      'verbose',
      callback: (bool value) => verbose = value,
      defaultsTo: false,
    );
  }

  /// Whether verbose logging is enabled.
  bool? verbose;

  /// Optional default config path used when `--config` is not provided.
  /// Subclasses can set this to define a sensible default.
  String? defaultConfig;

  /// Returns the default config path if set. Subclasses may override
  /// this to compute a path dynamically.
  String? getDefaultConfigPath() {
    return defaultConfig;
  }

  /// The config path provided via CLI `--config`, if any.
  String? _configPath;

  /// Effective config path: CLI `--config` if present, otherwise [getDefaultConfigPath].
  String? get configPath => _configPath ?? getDefaultConfigPath();

  /// Marks the command as experimental (e.g., pre-release / unstable).
  /// When `true`, a visible warning is printed before execution.
  bool get experimental => false;

  /// Marks the command as deprecated. When `true`, a visible error message
  /// is printed before execution.
  bool get deprecated => false;

  /// Suggested replacement command name for a deprecated command.
  /// If `null`, a generic "another" script suggestion is shown.
  String? get replacementScript => null;

  /// Message shown when the command is deprecated.
  String get deprecatedMessage =>
      'This script is deprecated. Use ${replacementScript ?? 'another'} script instead.';

  /// Convenience getter for verbosity flag.
  bool get isVerbose => verbose == true;

  /// Orchestrates command execution:
  /// - Initializes [output] with verbosity
  /// - Prints deprecation/experimental banners
  /// - Starts the stopwatch (if `--timer`)
  /// - Awaits [runWrapped]
  /// - Stops the stopwatch (if `--timer`)
  @override
  Future<T> run() async {
    output = Output(verboseEnabled: isVerbose);

    if (deprecated) {
      output.error(deprecatedMessage, blockTitle: 'DEPRECATED SCRIPT');
    }
    if (experimental) {
      output.warning(
        'This script is in experimental mode. Unexpected errors may occur during its operation.',
        blockTitle: 'EXPERIMENTAL COMMAND',
      );
    }

    StopwatchLogger.i.start(name);

    final T result = await runWrapped();

    StopwatchLogger.i.stop();

    return result;
  }

  /// Command-specific logic goes here. Must be implemented by subclasses.
  Future<T> runWrapped();
}
