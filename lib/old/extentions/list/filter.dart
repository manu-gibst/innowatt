// If ur confused look up Chapter 35. Basically user calls filter function and passes a filter as an argument(function that returns bool values)
extension Filter<T> on Stream<List<T>> {
  Stream<List<T>> filter(bool Function(T) where) =>
      map((items) => items.where(where).toList());
}
