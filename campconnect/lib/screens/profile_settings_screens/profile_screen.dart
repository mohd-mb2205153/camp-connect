import 'package:campconnect/providers/loggedinuser_provider.dart';
import 'package:campconnect/routes/app_router.dart';
import 'package:campconnect/theme/constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/show_nav_bar_provider.dart';
import '../../services/auth_services.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final loggedInUser = ref.watch(loggedInUserNotifierProvider);

    // If user is null, show a placeholder or redirect
    if (loggedInUser == null) {
      return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Profile",
            style: getTextStyle("largeBold", color: AppColors.teal),
          ),
        ),
        body: const Center(
          child: Text("User is not logged in."),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Profile",
          style: getTextStyle("largeBold", color: AppColors.teal),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.darkTeal,
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white,
                        ), // Will change to images later..
                      ),
                      Positioned(
                        bottom: 0,
                        left: 60,
                        child: CircleAvatar(
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        wrapText(
                            '${loggedInUser.firstName} ${loggedInUser.lastName}',
                            24),
                        style: getTextStyle("mediumBold",
                            color: AppColors.lightTeal),
                      ),
                      Text(
                        loggedInUser.email,
                        style: getTextStyle("smallBold", color: Colors.grey),
                      ),
                      addVerticalSpace(12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: AppColors.teal,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Text(
                          loggedInUser.role.toUpperCase(),
                          style: getTextStyle(
                            "smallBold",
                            color: Colors.white, // Text color
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
              addVerticalSpace(12),
              const Divider(
                thickness: 2,
                color: AppColors.teal,
              ),
              addVerticalSpace(12),
              buildMenuItem(
                Icons.person,
                'Personal Information',
                () {
                  context.pushNamed(AppRouter.personal.name).then((_) {
                    setState(() {
                      ref.watch(loggedInUserNotifierProvider);
                    });
                  });

                  ref
                      .read(showNavBarNotifierProvider.notifier)
                      .showBottomNavBar(false);
                },
              ),
              buildMenuItem(Icons.menu_book_rounded, 'Educational Information',
                  () {
                context.pushNamed(AppRouter.educational.name).then((_) {
                  setState(() {
                    ref.watch(loggedInUserNotifierProvider);
                  });
                });
                ref
                    .read(showNavBarNotifierProvider.notifier)
                    .showBottomNavBar(false);
              }),
              buildMenuItem(Icons.tune, 'Preferences'),
              buildMenuItem(Icons.language, 'Language'),
              buildMenuItem(Icons.power_settings_new, 'Logout', () async {
                await AuthService().signout(context: context);
                ref.read(loggedInUserNotifierProvider.notifier).clearUser();
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.remove('jwt_token');
                await prefs.remove('email');
                context.go(AppRouter.onboarding.path);
              }),
            ],
          ),
        ),
      ),
    );
  }

  //For now onPressed is optional.
  Widget buildMenuItem(IconData icon, String title, [Function()? onPressed]) {
    return Column(
      children: [
        ListTile(
          leading: Icon(
            icon,
            color: AppColors.lightTeal,
          ),
          title: Text(
            title,
            style: getTextStyle("small", color: Colors.black45),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.chevron_right,
              color: AppColors.lightTeal,
            ),
            onPressed: onPressed,
          ),
        ),
        Divider(
          height: 1,
          color: AppColors.darkBeige,
        ),
      ],
    );
  }
}
