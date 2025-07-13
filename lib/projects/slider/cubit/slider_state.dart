part of 'slider_cubit.dart';

const maxRange = 5;

final class SliderState extends Equatable {
  const SliderState({
    this.selectedIndex = 0,
    required this.size,
    this.left = 0,
    int? right,
  }) : right = right ?? ((size > maxRange) ? maxRange - 1 : size - 1);

  /// Current selected dot.
  final int selectedIndex;

  /// Size of all dots.
  final int size;

  /// Far left bound that should be displayed.
  final int left;

  /// Far right bound that should be displayed.
  final int right;

  /// Max number of dots that should be displayed.
  int get range => maxRange < size ? maxRange : size;

  SliderState copyWith({
    int? selectedIndex,
    int? size,
    int? left,
    int? right,
  }) {
    return SliderState(
      size: size ?? this.size,
      left: left ?? this.left,
      right: right ?? this.right,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  /// Returns whether the left bound (first dot) should be visible.
  bool leftBoundVisible() {
    return left != 0;
  }

  /// Returns whether the right bound (first dot) should be visible.
  bool rightBoundVisible() {
    return right != size - 1;
  }

  @override
  List<Object> get props => [selectedIndex, size, left, right];
}
