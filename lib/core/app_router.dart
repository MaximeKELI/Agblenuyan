import 'package:flutter/material.dart';
import 'package:agblenuyan/features/home_screen.dart';
import 'package:agblenuyan/features/diagnosis_screen.dart';
import 'package:agblenuyan/features/crops_screen.dart';
import 'package:agblenuyan/features/advice_screen.dart';
import 'package:agblenuyan/features/stats_screen.dart';
import 'package:agblenuyan/features/map_screen.dart';
import 'package:agblenuyan/features/settings_screen.dart';
import 'package:agblenuyan/core/profile_screen.dart';
import 'package:agblenuyan/features/history_screen.dart';
import 'package:agblenuyan/features/help_screen.dart';

class AppRouter {
  static const String home = '/';
  static const String diagnosis = '/diagnosis';
  static const String crops = '/crops';
  static const String advice = '/advice';
  static const String stats = '/stats';
  static const String map = '/map';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String history = '/history';
  static const String help = '/help';

  static Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case home:
        return _buildRoute(HomeScreen());
      case diagnosis:
        return _buildRoute(DiagnosisScreen());
      case crops:
        return _buildRoute(CropsScreen());
      case advice:
        return _buildRoute(AdviceScreen());
      case stats:
        return _buildRoute(StatsScreen());
      case map:
        return _buildRoute(MapScreen());
      case settings:
        return _buildRoute(SettingsScreen());
      case profile:
        return _buildRoute(ProfileScreen());
      case history:
        return _buildRoute(HistoryScreen());
      case help:
        return _buildRoute(HelpScreen());
      default:
        return _buildRoute(
          Scaffold(body: Center(child: Text('Page non trouvée'))),
        );
    }
  }

  static MaterialPageRoute _buildRoute(Widget widget) {
    return MaterialPageRoute(builder: (_) => widget);
  }
}
