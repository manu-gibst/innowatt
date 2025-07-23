part of '../router.dart';

class _NewScaffoldWithNavbar extends StatelessWidget {
  const _NewScaffoldWithNavbar({
    required this.navigationShell,
  });
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: navigationShell,
      extendBody: true,
      bottomNavigationBar: SafeArea(
        child: BlocBuilder<CustomBottomNavbarCubit, CustomBottomNavbarState>(
          builder: (context, state) {
            return Opacity(
              opacity: state.opacity,
              child: AbsorbPointer(
                absorbing: state.opacity != 1,
                child: CustomBottomNavBar(
                  activeIndex: navigationShell.currentIndex,
                  onTap: (value) => navigationShell.goBranch(value),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
