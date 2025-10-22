// ignore: depend_on_referenced_packages
import 'package:args/command_runner.dart';
import 'package:mad_scripts_base/mad_scripts_base.dart';

void main(List<String> arguments) async {
  CommandRunner<bool>('scripts', 'Various scripts to help generate code in Mad Brains flutter projects.')
    ..addCommand(ExampleCommand())
    ..run(arguments);
}

class ExampleCommand extends ScriptCommand<bool>{
  @override
  String get description => 'Example command';

  @override
  String get name => 'example';

  @override
  String? get defaultConfig => 'example_config.json';

  @override
  Future<bool> runWrapped() async {
    output.info('Example command');
    final config = ConfigReader.fromFile(configPath ?? '', transformer: ExampleConfigModel.fromMap);
    output.debug(config.toString());

    return true;
  }
}

class ExampleConfigModel{
  const ExampleConfigModel({required this.path});

  final String path;

  factory ExampleConfigModel.fromMap(Map<String, dynamic> map) {
    return ExampleConfigModel(
      path: map['path'] as String,
    );
  }

  @override
  String toString() {
    return 'ExampleConfigModel(path: $path)';
  }
}