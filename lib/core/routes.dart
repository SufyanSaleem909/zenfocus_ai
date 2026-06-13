import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/checkin_screen.dart';
import '../screens/chat_screen.dart';
import '../screens/planner_screen.dart';
import '../screens/calm_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/history_screen.dart';
import '../screens/settings_screen.dart';

class AppRoutes {
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String checkIn = '/checkin';
  static const String chat = '/chat';
  static const String planner = '/planner';
  static const String calm = '/calm';
  static const String history = '/history';
  static const String settings = '/settings';

  static Map<String, WidgetBuilder> get routes => {
    onboarding: (_) => const OnboardingScreen(),
    home: (_) => const HomeScreen(),
    checkIn: (_) => const CheckInScreen(),
    chat: (_) => const ChatScreen(),
    planner: (_) => const PlannerScreen(),
    calm: (_) => const CalmScreen(),
    history: (_) => const HistoryScreen(),
    settings: (_) => const SettingsScreen(),
  };
}
