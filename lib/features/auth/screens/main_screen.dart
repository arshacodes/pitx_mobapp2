import 'package:flutter/material.dart';
import 'package:pitx_mobapp2/features/auth/home/home_screen.dart';
import 'package:pitx_mobapp2/features/auth/more/more_screen.dart';
import 'package:pitx_mobapp2/features/auth/route_finding/route_finding_screen.dart';
import 'package:pitx_mobapp2/shared/widgets/app_bottom_nav.dart';
import 'package:pitx_mobapp2/shared/widgets/app_top_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  int _lastNonRouteIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    RouteFindingScreen(),
    MoreScreen(),
  ];

  final List<String> _titles = const ['Home', 'Route Finding', 'More'];

  @override
  Widget build(BuildContext context) {
    final bool isRouteSelected = _currentIndex == 1;

    return Scaffold(
      appBar: isRouteSelected
          ? AppTopBar(
              title: _titles[_currentIndex],
              showBackButton: true,
              onBackPressed: () {
                setState(() {
                  _currentIndex = _lastNonRouteIndex;
                });
              },
            )
          : null,
      body: _screens[_currentIndex],
      bottomNavigationBar: isRouteSelected
          ? null
          : AppBottomNav(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  if (index != 1) {
                    _lastNonRouteIndex = index;
                  } else if (_currentIndex != 1) {
                    _lastNonRouteIndex = _currentIndex;
                  }
                  _currentIndex = index;
                });
              },
            ),
    );
  }
}
