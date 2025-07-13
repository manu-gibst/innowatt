import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'slider_state.dart';

class SliderCubit extends Cubit<SliderState> {
  SliderCubit({required int size}) : super(SliderState(size: size));

  void onSelected(int index) async {
    int right = state.right;
    int left = state.left;

    // Checking if new index should shift right or left visible bounds.
    if (index >= right) {
      right = (index < state.size - 1) ? index + 1 : index;
      left = (right - left + 1 > state.range) ? left + 1 : left;
    }
    if (index <= left) {
      left = (index > 0) ? index - 1 : 0;
      right = (right - left + 1 > state.range) ? right - 1 : right;
    }

    // TODO: remove this
    // print("Left: $left \tIndex: $index \tRight: $right");
    return emit(state.copyWith(
      left: left,
      right: right,
      selectedIndex: index,
    ));
  }

  void onSizeChanged(int newSize) {
    emit(state.copyWith(
      size: newSize,
    ));
  }
}
