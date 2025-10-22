/// A class representing a text insertion at a specific position in the source content.
class Insertion {
  /// Creates an instance of `Insertion` with the given offset and content.
  const Insertion({required this.offset, required this.content});

  /// The position in the string where the content will be inserted.
  final int offset;

  /// The content to be inserted.
  final String content;
}

/// A class for managing and applying multiple insertions to a source text.
class InsertionBuilder {
  /// Creates an instance of `InsertionBuilder` with the provided source content.
  InsertionBuilder({required this.content});

  /// The original content to which insertions will be applied.
  final String content;

  /// A list of insertions to apply to the source content.
  late final List<Insertion> insertions = <Insertion>[];

  /// Adds an insertion to the list of pending insertions.
  ///
  /// Parameters:
  /// - [offset]: The position where the content should be inserted.
  /// - [content]: The content to insert.
  void addInsertion(int offset, String content) => insertions.add(Insertion(offset: offset, content: content));

  /// Applies all insertions to the original content and returns the updated string.
  ///
  /// Insertions are applied in descending order of position to avoid conflicts.
  ///
  /// Returns the updated content after applying all insertions.
  String applyInsertions() {
    String updatedContent = content;
    insertions.sort((Insertion first, Insertion second) => second.offset.compareTo(first.offset));
    for (final Insertion change in insertions) {
      updatedContent = updatedContent.replaceRange(change.offset, change.offset, change.content);
    }

    return updatedContent;
  }
}
