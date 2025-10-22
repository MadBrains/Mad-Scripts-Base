extension IterableExtension<T> on Iterable<T> {
  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final T element in this) {
      if (test(element)) return element;
    }

    return null;
  }

  /// The last element satisfying [test], or `null` if there are none.
  T? lastWhereOrNull(bool Function(T element) test) {
    T? result;
    for (final T element in this) {
      if (test(element)) result = element;
    }

    return result;
  }
}
