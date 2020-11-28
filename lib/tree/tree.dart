abstract class Tree<T> {
  void add(T value, {String path});

  void remove(T element, {String path});

  void addAll(Iterable<T> iterable, {String path});

  void removeAll(Iterable<T> iterable, {String path});

  void removeWhere(bool test(T element), {String path});

  void clear({String path});

  T elementAt(String path);

  T operator [](covariant dynamic at);

  void operator []=(covariant dynamic at, T value);

  int get length;
}

abstract class IndexedTree<T> extends Tree<T> {
  void insert(int index, T element, {String path});

  void insertAll(int index, Iterable<T> iterable, {String path});

  void insertAfter(T element, {String path});

  void insertBefore(T element, {String path});

  T removeAt(int index, {String path});

  set first(T value);

  T get first;

  set last(T value);

  T get last;

  int indexWhere(bool test(T element), {int start = 0, String path});

  T firstWhere(bool test(T element), {T orElse(), String path});

  T lastWhere(bool test(T element), {T orElse(), String path});
}
