# Mad Scripts Base

**Mad Scripts Base** is a developer toolkit for building CLI scripts in **Dart**, designed for automation, code generation, and DevOps integration.  
It provides a ready-to-use infrastructure for console utilities — from argument parsing and logging to Mustache templates and execution timing.

---

## 🚀 Features

- ⚙️ **Unified CLI command base** via `ScriptCommand`
- ⏱ **Execution timer and profiling** using `StopwatchLogger`
- 🧩 **Colorized console output** with structured blocks and verbose mode
- 🧰 **File and config utilities** (`FileManager`, `ConfigReader`)
- 📦 **Dependency management** for `pubspec.yaml`
- 🧠 **Template engine (MTL)** — Mustache extension with custom tags
- 🧙 **Simple extensibility** — just create new commands as classes

---

## 📦 Installation

Add the dependency in your `pubspec.yaml`:

```yaml
dependencies:
  mad_scripts_base: 1.0.0-dev
```

---

## 🧱 How to Create New Scripts

1. Extend `ScriptCommand<T>`
2. Implement `runWrapped()`
3. Define options in `argParser`
4. Register the command in your CLI runner

```dart
void main(List<String> args) async {
  final runner = CommandRunner('mad', 'Mad Scripts CLI');
  runner.addCommand(CreateServiceCommand());
  await runner.run(args);
}
```

---

## 🧩 Example: Creating a Custom Command

Let's create a simple `CreateServiceCommand` that generates a service class from a template.

```dart
import 'package:mad_scripts_base/mad_scripts_base.dart';

class CreateServiceCommand extends ScriptCommand<void> {
  @override
  final String name = 'create-service';

  @override
  final String description = 'Generate a new service class';

  @override
  Future<void> runWrapped() async {
    output.info('Starting service generation...');

    final fileManager = FileManager('lib/services');
    await fileManager.createFile(
      fileName: '${argResults?['name'] ?? 'my_service'}.dart',
      content: ScriptTemplates.fromFile('service', values: {'NAME': argResults?['name'] ?? 'MyService'}),
    );

    output.success('Service created successfully!');
  }
}
```

service.mustache

```mustache
class {{NAME}} {
  void execute() {
    print('Service executed');
  }
}
```

---

## 🧭 CLI Flags

| Flag | Short | Description |
|------|--------|-------------|
| `--config` | `-c` | Path to config file |
| `--timer` | `-t` | Measure execution time |
| `--verbose` | — | Enable detailed logging |
| `--help` | `-h` | Show available commands |


---

## 🧩 Built-in Utilities

### 🧾 `FileManager`
Create or update files with optional Git integration:
```dart
await FileManager('lib').createFile(
  fileName: 'new_file.dart',
  content: 'void main() {}',
  addToGit: true,
);
```

### ⚙️ `ConfigReader`
This allows you to pass multiple configuration parameters to your script without relying on command-line arguments, making it easier to maintain reusable and automated setups.
Load a JSON config and transform it into a model:
```dart
final config = ConfigReader.fromFile(
  'config.json',
  transformer: (data) => AppConfig.fromJson(data),
);
```

### ⏱ `StopwatchLogger`
Log execution times:
```dart
StopwatchLogger.log = true;
StopwatchLogger.i.start('Build process');
// ...
StopwatchLogger.i.stop();
```

### 🧠 `Output`
Colorful console output utilities:
```dart
output.success('Operation completed');
output.error('Something went wrong');
output.warning('Be careful');
output.info('Starting...');
output.debug('Visible only with --verbose')
```

---

## 🧬 Templates and MTL (Mad Template Language)

MTL is an enhanced Mustache engine supporting extra tags:
```mustache
{{export_part id=1}}
  Some reusable code
{{/export_part}}

{{insertion_part file="another_template.mustache" id=1}}

void {{NAME}}(){
  print('Test {{NAME}} function');
}
```

Usage example:
```dart
final rendered = ScriptTemplates.fromFile(
  'example',
  values: {'NAME': 'customTest'},
);
```

---
## 🧩 Code Analyzer Extensions and Insertion Builder

Mad Scripts Base also provides **lightweight wrappers around the Dart analyzer** that simplify **code introspection and modification**.

These utilities are designed for scenarios where scripts need to:
- Inspect existing Dart source code,
- Read and modify AST (Abstract Syntax Tree) structures,
- Inject new declarations or imports into existing files.

### 🧠 Analyzer Extensions
Analyzer helpers expose convenient access to parsed Dart models — such as classes, methods, and fields —  
allowing you to safely analyze and transform code without manual string manipulation.  
They are useful for tasks like:
- Automatically adding `copyWith()` or `toJson()` methods,
- Inserting imports or updating constructors,
- Generating additional parts of existing files.

### ✍️ Insertion Builder
`InsertionBuilder` is a small but powerful utility for **precise text insertion** operations.  
It allows you to define a list of insertions with offsets and apply them safely in descending order —  
ensuring that all modifications remain consistent.

Example:
```dart
final builder = InsertionBuilder(content: originalSource);
builder.addInsertion(150, '\n  void newMethod() {}\n');
final updated = builder.applyInsertions();
```
