import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'custom_bottom_navbar_state.dart';

class CustomBottomNavbarCubit extends Cubit<CustomBottomNavbarState> {
  CustomBottomNavbarCubit() : super(CustomBottomNavbarState());

  void opacityChanged(double value) {
    emit(state.copyWith(opacity: value));
  }
}
