import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../constants/text_styles.dart';
import 'home/home_screen.dart';
import 'courses/courses_screen.dart';
import 'games/welcome_screen.dart';
import 'aqi/aqi_screen.dart';
import 'news/news_screen.dart';
import 'profile/profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 2; // Start with Home tab

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const CoursesScreen(),
       WelcomeScreen(),
      const HomeScreen(),
      const AQIScreen(),
      const NewsScreen(),
      const ProfileScreen(),
    ];
  }

  final List<BottomNavigationBarItem> _navItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.school_outlined),
      activeIcon: Icon(Icons.school),
      label: 'Courses',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.games_outlined),
      activeIcon: Icon(Icons.games),
      label: 'Games',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.air_outlined),
      activeIcon: Icon(Icons.air),
      label: 'AQI',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.article_outlined),
      activeIcon: Icon(Icons.article),
      label: 'News',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  String _getTitle() {
    switch (_selectedIndex) {
      case 0:
        return 'Courses';
      case 1:
        return 'Games';
      case 2:
        return 'Home';
      case 3:
        return 'AQI';
      case 4:
        return 'News';
      case 5:
        return 'Profile';
      default:
        return 'EcoMentor';
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _getTitle(),
          style: AppTextStyles.h3.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: _navItems,
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.textSecondary,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}
