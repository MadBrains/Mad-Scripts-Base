## 1.0.0-dev — Initial Developer Release

### 🚀 Overview
This is the initial developer release of **mad_scripts_base**, a modular Dart toolkit
for creating CLI scripts and automation tools used in internal MadBrains projects.

### ✨ Features
- Added base command system (`ScriptCommand`) with CLI argument parsing.
- Introduced colorful and structured console output via `Output`.
- Implemented execution timing and profiling with `StopwatchLogger`.
- Added file and configuration management (`FileManager`, `ConfigReader`).
- Integrated Mustache template engine with MTL (Mad Template Language).
- Added dependency manager for updating `pubspec.yaml` entries.
- Introduced text manipulation utilities (`InsertionBuilder`, string extensions).
- Added analyzer extensions for working with Dart AST nodes.
- Provided helper utilities (`Helper`, `EnumX`, `BoolExt`, etc.).

### 🧱 Foundation
This release forms the foundation for future CLI utilities and automation scripts,
enabling faster development and consistent tool behavior across MadBrains projects.
