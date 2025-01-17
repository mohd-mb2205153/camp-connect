import 'package:campconnect/google_map.dart';
import 'package:campconnect/screens/add_camp_location_screen.dart';
import 'package:campconnect/screens/add_camp_screen.dart';
import 'package:campconnect/screens/home_screen.dart';
import 'package:campconnect/screens/onboarding_screens/login_screen.dart';
import 'package:campconnect/screens/maps_screen.dart';
import 'package:campconnect/screens/notifications_screen.dart';
import 'package:campconnect/screens/onboarding_screens/onboarding_screen.dart';
import 'package:campconnect/screens/profile_settings_screens/educational_info_screen.dart';
import 'package:campconnect/screens/profile_settings_screens/personal_info_screen.dart';
import 'package:campconnect/screens/profile_settings_screens/profile_screen.dart';
import 'package:campconnect/screens/onboarding_screens/register_role_screen.dart';
import 'package:campconnect/screens/shell_screen.dart';
import 'package:go_router/go_router.dart';

import '../screens/onboarding_screens/register_screen.dart';

class AppRouter {
  static const onboarding = (name: 'onboarding', path: '/');
  static const login = (name: 'login', path: '/login');
  static const register = (name: 'register', path: '/register');
  static const role = (name: 'role', path: '/role');
  static const home = (name: 'home', path: '/home');
  static const map = (name: 'maps', path: '/maps');
  static const profile = (name: 'profile', path: '/profile');
  static const notifications = (name: 'notifications', path: '/notifications');

  static const addCampLocation =
      (name: "addCampLocation", path: '/home/addCampLocation');
  static const addCamp =
      (name: "addCamp", path: '/home/addCampLocation/addCamp:location');

  //Profile Settings routes
  static const personal = (name: 'personal', path: '/profile/personal');
  static const educational =
      (name: 'educational', path: '/profile/educational');

  static final router = GoRouter(
    initialLocation: onboarding.path,
    routes: [
      GoRoute(
        path: onboarding.path,
        name: onboarding.name,
        builder: (context, state) => const OnboardingScreen(),
        routes: [
          GoRoute(
            path: login.path,
            name: login.name,
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: register.path,
            name: register.name,
            builder: (context, state) => const RegisterScreen(),
            routes: [
              GoRoute(
                path: role.path,
                name: role.name,
                builder: (context, state) => const RoleScreen(),
              ),
            ],
          ),
        ],
      ),
      ShellRoute(
        routes: [
          GoRoute(
            name: home.name,
            path: home.path,
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                name: addCampLocation.name,
                path: addCampLocation.path,
                builder: (context, state) => const AddCampLocationScreen(),
                routes: [
                  GoRoute(
                      name: addCamp.name,
                      path: addCamp.path,
                      builder: (context, state) {
                        final location = state.pathParameters['location'];
                        return AddCampScreen(location: location!);
                      })
                ],
              ),
            ],
          ),
          GoRoute(
              name: map.name,
              path: map.path,
              builder: (context, state) => const MapsScreen()),
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
              GoRoute(
                path: educational.path,
                name: educational.name,
                builder: (context, state) => const EducationalInfoScreen(),
              ),
            ],
          ),
          GoRoute(
            name: notifications.name,
            path: notifications.path,
            builder: (context, state) => const NotificationsScreen(),
          ),
        ],
        builder: (context, state, child) =>
            ShellScreen(state: state, child: child),
      ),
    ],
  );
}
