import 'package:campconnect/screens/home_screen.dart';
import 'package:campconnect/screens/maps_screen.dart';
import 'package:campconnect/screens/notifications_screen.dart';
import 'package:campconnect/screens/profile_screen.dart';
import 'package:campconnect/screens/shell_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const home = (name: 'home', path: '/home');
  static const map = (name: 'maps', path: '/maps');
  static const profile = (name: 'profile', path: '/profile');
  static const notifications = (name: 'notifications', path: '/notifications');

  static final router = GoRouter(
    initialLocation: home.path,
    routes: [
      ShellRoute(
        routes: [
          GoRoute(
            name: home.name,
            path: home.path,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
              name: map.name,
              path: map.path,
              builder: (context, state) => const MapsScreen()),
          GoRoute(
              name: profile.name,
              path: profile.path,
              builder: (context, state) => const ProfileScreen()),
          GoRoute(
              name: notifications.name,
              path: notifications.path,
              builder: (context, state) => const NotificationsScreen()),
        ],
        builder: (context, state, child) =>
            ShellScreen(state: state, child: child),
      ),
    ],
  );
}
