import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';

import '../chat/chatscreen.dart';
import '../likes/like.dart';
import '../main_screen/mainscreen.dart';
import '../profile/profile_screen.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int _selectedIndex = 0;
  DateTime? _currentBackPressTime;

  final List<Widget> _screens = [
    MainScreen(),
    LikesScreen(),
    ChatMainScreen(),
    UserProfileScreen(), // Simple, no parameters needed
  ];

  Future<bool> _onWillPop() async {
    // Agar home screen par nahi hai, to home screen par switch karein
    if (_selectedIndex != 0) {
      setState(() {
        _selectedIndex = 0;
      });
      return false;
    }

    // Home screen par double tap exit logic
    final now = DateTime.now();
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime!) > const Duration(seconds: 2)) {
      _currentBackPressTime = now;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Press back again to exit app'),
          duration: Duration(seconds: 2),
        ),
      );
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: _screens,
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFFEE6044),
            unselectedItemColor: Colors.black54,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            elevation: 0,
            backgroundColor: Colors.white,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Iconsax.home_1_copy),
                activeIcon: Icon(Iconsax.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.heart_copy),
                activeIcon: Icon(Iconsax.heart),
                label: 'Likes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.message_copy),
                activeIcon: Icon(Iconsax.message),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Iconsax.user_copy),
                activeIcon: Icon(Iconsax.user),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
