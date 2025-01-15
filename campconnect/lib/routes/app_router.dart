import 'package:campconnect/google_map.dart';
import 'package:campconnect/screens/home_screen.dart';
import 'package:campconnect/screens/onboarding_screens/login_screen.dart';
import 'package:campconnect/screens/maps_screen.dart';
import 'package:campconnect/screens/notifications_screen.dart';
import 'package:campconnect/screens/onboarding_screens/onboarding_screen.dart';
import 'package:campconnect/screens/profile_settings_screens/personal_info_screen.dart';
import 'package:campconnect/screens/profile_settings_screens/profile_screen.dart';
import 'package:campconnect/screens/onboarding_screens/register_screen.dart';
import 'package:campconnect/screens/shell_screen.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const onboarding = (name: 'onboarding', path: '/');
  static const login = (name: 'login', path: '/login');
  static const register = (name: 'register', path: '/register');
  static const home = (name: 'home', path: '/home');
  static const map = (name: 'maps', path: '/maps');
  static const profile = (name: 'profile', path: '/profile');
  static const notifications = (name: 'notifications', path: '/notifications');

  //Profile Settings routes
  static const personal = (name: 'personal', path: '/profile/personal');

  static final router = GoRouter(
    initialLocation: home.path,
    routes: [
      GoRoute(
          path: onboarding.path,
          name: onboarding.name,
          builder: (context, state) => const OnboardingScreen()),
      GoRoute(
          path: login.path,
          name: login.name,
          builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: register.path,
        name: register.name,
        builder: (context, state) => const RegisterScreen(),
      ),
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
              builder: (context, state) => const MapSample()),
          GoRoute(
            name: profile.name,
            path: profile.path,
            builder: (context, state) => const ProfileScreen(),
            routes: [
              GoRoute(
                path: personal.path,
                name: personal.name,
                builder: (context, state) => const PersonalInfoScreen(),
              ),
            ],
          ),
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
