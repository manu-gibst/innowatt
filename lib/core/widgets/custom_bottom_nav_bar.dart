import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

enum NavBarItem {
  diary,
  home,
  profile;

  Widget build(BuildContext context,
      {bool active = false, required VoidCallback onTap}) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: active ? colorScheme.secondary : null,
            ),
            width: 64,
            height: 32,
            child: Icon(
              icon(context),
              color: active ? colorScheme.onSecondary : colorScheme.onSurface,
              shadows: !active
                  ? null
                  : [
                      Shadow(
                        color: colorScheme.onSecondary,
                        blurRadius: 10,
                      )
                    ],
            ),
          ),
          Text(
            name.toTitleCase,
            style: textTheme.labelSmall,
          ),
        ],
      ),
    );
  }

  IconData icon(BuildContext context) {
    return switch (this) {
      NavBarItem.diary => Ionicons.book_outline,
      NavBarItem.home => Ionicons.home_outline,
      NavBarItem.profile => Ionicons.person_outline,
    };
  }
}

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.activeIndex,
    required this.onTap,
  });

  final int activeIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: kBottomNavigationBarHeight + 20,
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(80),
          color: colorScheme.surfaceContainer,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: NavBarItem.values.map((item) {
            return item.build(
              context,
              active: item.index == activeIndex,
              onTap: () => onTap(item.index),
            );
          }).toList(),
        ),
      ),
    );
  }
}

extension StringCasingExtension on String {
  String get toCapitalized =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String get toTitleCase => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized)
      .join(' ');
}
