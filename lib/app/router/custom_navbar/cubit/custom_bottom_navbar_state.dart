part of 'custom_bottom_navbar_cubit.dart';

final class CustomBottomNavbarState extends Equatable {
  const CustomBottomNavbarState({this.opacity = 0});

  final double opacity;

  CustomBottomNavbarState copyWith({double? opacity}) {
    return CustomBottomNavbarState(
      opacity: opacity ?? this.opacity,
    );
  }

  @override
  List<Object> get props => [opacity];
}
