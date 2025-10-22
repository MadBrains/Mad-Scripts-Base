import 'io.dart';

/// A class for logging operation execution time using a stopwatch.
class StopwatchLogger {
  StopwatchLogger._();

  /// Singleton instance of [StopwatchLogger].
  static final StopwatchLogger i = StopwatchLogger._();

  late final Stopwatch _watch = Stopwatch();

  /// The name of the current operation.
  String name = '';

  /// Whether logging is enabled.
  static bool log = false;

  /// Starts the stopwatch and begins tracking the operation duration.
  ///
  /// Parameters:
  /// - [name]: The name of the operation to display in the log.
  void start(String name) {
    if (log) {
      this.name = name;
      _watch.start();
      output.info('$name started');
    }
  }

  /// Logs a checkpoint message with success status and optional elapsed time.
  ///
  /// Parameters:
  /// - [comment]: A message to display along with the elapsed time.
  void checkpointSuccess(String comment) {
    if (log) {
      output.success('$comment in ${_watch.elapsed}');
    } else {
      output.success(comment);
    }
  }

  /// Logs a checkpoint message with info status and optional elapsed time.
  ///
  /// Parameters:
  /// - [comment]: A message to display along with the elapsed time.
  void checkpointInfo(String comment) {
    if (log) {
      output.info('$comment in ${_watch.elapsed}');
    } else {
      output.info(comment);
    }
  }

  /// Logs a checkpoint message with error status and optional elapsed time.
  ///
  /// Parameters:
  /// - [comment]: A message to display along with the elapsed time.
  void checkpointError(String comment) {
    if (log) {
      output.error('$comment in ${_watch.elapsed}');
    } else {
      output.error(comment);
    }
  }

  /// Logs a checkpoint message with warning status and optional elapsed time.
  ///
  /// Parameters:
  /// - [comment]: A message to display along with the elapsed time.
  void checkpointWarning(String comment) {
    if (log) {
      output.warning('$comment in ${_watch.elapsed}');
    } else {
      output.warning(comment);
    }
  }

  /// Stops the stopwatch and logs the total execution time.
  void stop() {
    if (log) {
      _watch.stop();
      output.success('$name executed in ${_watch.elapsed}');
    }
  }
}
