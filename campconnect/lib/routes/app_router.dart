import 'package:campconnect/models/user.dart';
import 'package:campconnect/screens/add_screens/add_camp_location_screen.dart';
import 'package:campconnect/screens/add_screens/add_camp_screen.dart';
import 'package:campconnect/screens/home_screen.dart';
import 'package:campconnect/screens/onboarding_screens/educator_onboarding_screen.dart';
import 'package:campconnect/screens/onboarding_screens/login_screen.dart';
import 'package:campconnect/screens/maps_screen.dart';
import 'package:campconnect/screens/onboarding_screens/onboarding_screen.dart';
import 'package:campconnect/screens/profile_settings_screens/educational_info_screen.dart';
import 'package:campconnect/screens/profile_settings_screens/personal_info_screen.dart';
import 'package:campconnect/screens/profile_settings_screens/profile_screen.dart';
import 'package:campconnect/screens/onboarding_screens/register_role_screen.dart';
import 'package:campconnect/screens/shell_screen.dart';
import 'package:campconnect/screens/view_screens/view_classes_screen.dart';
import 'package:campconnect/screens/view_screens/view_teachers_screen.dart';
import 'package:go_router/go_router.dart';

import '../screens/add_screens/add_class_screen.dart';
import '../screens/onboarding_screens/register_screen.dart';
import '../screens/onboarding_screens/student_onboarding_screen.dart';
import '../screens/view_screens/view_saved_camps_screen.dart';
import '../screens/view_screens/view_teaching_camps_screen.dart';

class AppRouter {
  // Onboarding Routes
  static const onboarding = (name: 'onboarding', path: '/');
  static const login = (name: 'login', path: 'login');
  static const register = (name: 'register', path: 'register');
  static const role = (name: 'role', path: 'role');
  static const studentOnboarding =
      (name: 'studentOnboarding', path: 'studentOnboarding');
  static const educatorOnboarding =
      (name: 'educatorOnboarding', path: 'educatorOnboarding');

  // Main Screen Routes
  static const home = (name: 'home', path: '/home');
  static const map = (name: 'maps', path: '/maps');
  static const profile = (name: 'profile', path: '/profile');
  static const notifications = (name: 'notifications', path: '/notifications');

  // Viewing Routes
  static const viewSavedCamps =
      (name: 'viewSavedCamps', path: '/viewSavedCamps');
  static const viewTeachingCamps =
      (name: 'viewTeachingCamps', path: '/viewTeachingCamps');
  static const viewTeachers = (name: 'viewTeachers', path: '/viewTeachers');
  static const viewClasses = (name: 'viewClasses', path: '/viewClasses');

  // Add Camp Routes
  static const addCampLocation =
      (name: 'addCampLocation', path: 'addCampLocation');
  static const addCamp = (name: 'addCamp', path: 'addCamp:location');

  // Add Class Route
  static const addClass = (name: 'addClass', path: 'addClass');

  // Profile Settings Routes
  static const personal = (name: 'personal', path: 'personal');
  static const educational = (name: 'educational', path: 'educational');

  static final router = GoRouter(
    initialLocation: onboarding.path,
    routes: [
      // Onboarding Routes
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
                builder: (context, state) {
                  final user = state.extra as User;
                  return RoleScreen(user: user);
                },
                routes: [
                  GoRoute(
                      path: studentOnboarding.path,
                      name: studentOnboarding.name,
                      builder: (context, state) {
                        final user = state.extra as User;
                        return StudentOnboardingScreen(user: user);
                      }),
                  GoRoute(
                      path: educatorOnboarding.path,
                      name: educatorOnboarding.name,
                      builder: (context, state) {
                        final user = state.extra as User;
                        return EducatorOnboardingScreen(user: user);
                      }),
                ],
              ),
            ],
          ),
        ],
      ),

      // Main Screens with ShellRoute
      ShellRoute(
        builder: (context, state, child) =>
            ShellScreen(state: state, child: child),
        routes: [
          GoRoute(
            name: home.name,
            path: home.path,
            builder: (context, state) => const HomeScreen(),
            routes: [
              GoRoute(
                name: viewTeachingCamps.name,
                path: viewTeachingCamps.path,
                builder: (context, state) {
                  final userId = state.extra as String;
                  return ViewTeachingCampsScreen(userId: userId);
                },
              ),
              GoRoute(
                name: viewSavedCamps.name,
                path: viewSavedCamps.path,
                builder: (context, state) {
                  final userId = state.extra as String;
                  return ViewSavedCampsScreen(userId: userId);
                },
              ),
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
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            name: map.name,
            path: map.path,
            builder: (context, state) => const MapsScreen(),
            routes: [
              GoRoute(
                path: viewClasses.path,
                name: viewClasses.name,
                builder: (context, state) {
                  final campId = state.extra as String;
                  return ViewClassesScreen(campId: campId);
                },
                routes: [
                  GoRoute(
                    path: addClass.path,
                    name: addClass.name,
                    builder: (context, state) {
                      final campId = state.extra as String;
                      return AddClassScreen(campId: campId);
                    },
                  ),
                ],
              ),
              GoRoute(
                path: viewTeachers.path,
                name: viewTeachers.name,
                builder: (context, state) {
                  final campId = state.extra as String;
                  return ViewTeachersScreen(campId: campId);
                },
              ),
            ],
          ),
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
        ],
      ),
    ],
  );
}
