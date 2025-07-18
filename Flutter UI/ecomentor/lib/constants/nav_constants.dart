import 'package:flutter/material.dart';

class NavConstants {
  static const List<NavItem> bottomNavItems = [
    NavItem(
      label: 'Courses',
      icon: Icons.school_rounded,
      activeIcon: Icons.school_rounded,
    ),
    NavItem(
      label: 'AQI',
      icon: Icons.air_rounded,
      activeIcon: Icons.air_rounded,
    ),
    NavItem(
      label: 'Home',
      icon: Icons.home_rounded,
      activeIcon: Icons.home_rounded,
    ),
    NavItem(
      label: 'Games',
      icon: Icons.games_rounded,
      activeIcon: Icons.games_rounded,
    ),
    NavItem(
      label: 'News',
      icon: Icons.newspaper_rounded,
      activeIcon: Icons.newspaper_rounded,
    ),
  ];
}

class NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}
