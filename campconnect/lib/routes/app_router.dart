import 'package:campconnect/google_map.dart';
import 'package:campconnect/screens/add_camp_location_screen.dart';
import 'package:campconnect/screens/add_camp_screen.dart';
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
  static const home = (name: 'home', path: '/login/home');
  static const map = (name: 'maps', path: '/login/maps');
  static const profile = (name: 'profile', path: '/login/profile');
  static const notifications =
      (name: 'notifications', path: '/login/notifications');

  static const addCampLocation =
      (name: "addCampLocation", path: '/login/home/addCampLocation');
  static const addCamp =
      (name: "addCamp", path: '/login/home/addCampLocation/addCamp:location');

  //Profile Settings routes
  static const personal = (name: 'personal', path: '/login/profile/personal');
  static const educational =
      (name: 'educational', path: '/login/profile/educational');

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

                            return AddCampScreen(/*location: location!*/);
                          })
                    ])
              ]),
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
