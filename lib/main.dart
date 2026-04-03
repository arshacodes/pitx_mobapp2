import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controllers/authentication.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/route_finding/route_finding_map_screen.dart';
import 'features/auth/screens/main_screen.dart';
import 'features/guest/screens/login_screen.dart';
import 'features/guest/screens/register_screen.dart';
import 'features/guest/screens/welcome_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PITX Commuter App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: _getInitialScreen(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/main': (_) => const MainScreen(),
        '/route-finding-map': (_) => const RouteFindingMapScreen(),
      },
    );
  }

  Widget _getInitialScreen() {
    final authController = Get.put(AuthenticationController());
    
    // Check if user has a saved session
    if (authController.token.value.isNotEmpty && authController.user.value != null) {
      return const MainScreen();
    }
    
    return const WelcomeScreen();
  }
}
