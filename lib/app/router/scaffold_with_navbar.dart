part of 'router.dart';

class _ScaffoldWithNavbar extends StatelessWidget {
  const _ScaffoldWithNavbar({
    required this.navigationShell,
  });
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.comments),
            activeIcon: FaIcon(FontAwesomeIcons.solidComments),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.lightbulb),
            activeIcon: FaIcon(FontAwesomeIcons.solidLightbulb),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.user),
            activeIcon: FaIcon(FontAwesomeIcons.solidUser),
            label: 'Profile',
          ),
        ],
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(index),
      ),
    );
  }
}
