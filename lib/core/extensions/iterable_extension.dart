extension IndexedIterable<E> on Iterable<E> {
  Iterable<T> mapIndexed<T>(T Function(E e, int i) f) {
    var index = 0;
    return map((e) => f(e, index++));
  }
}