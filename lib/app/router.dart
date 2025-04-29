import 'package:go_router/go_router.dart';
import 'package:triggerly/app/pages/analyzer/screens/mobile/analyzer.dart';
import 'package:triggerly/app/pages/charts/screens/mobile/charts_page.dart';
import 'package:triggerly/app/pages/home/screens/mobile/home_page.dart';
import 'package:triggerly/app/pages/health_profile/screens/mobile/health_profile_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HomePage()),
      GoRoute(
        path: '/analyzer',
        builder: (context, state) => const AnalyzerPage(),
      ),
      GoRoute(
        path: '/health-profile',
        builder: (context, state) => const HealthProfilePage(),
      ),
      GoRoute(path: '/charts', builder: (context, state) => const ChartsPage()),
    ],
  );
});
