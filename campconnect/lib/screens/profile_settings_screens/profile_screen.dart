import 'package:campconnect/routes/app_router.dart';
import 'package:campconnect/theme/styling_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/show_nav_bar_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 5,
        title: const Text("Your Profile"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
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
                      ), //Will change to images later..
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
                const SizedBox(
                  width: 30,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('First Name'),
                    Text('Last Name'),
                    Text('email@gmail.com'),
                    Text('Role'),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 5,
              color: AppColors.darkBlue,
            ),
            const SizedBox(
              height: 10,
            ),
            buildMenuItem(
              Icons.person,
              'Personal Information',
              () {
                context.pushNamed(AppRouter.personal.name);
                ref
                    .read(showNavBarNotifierProvider.notifier)
                    .showBottomNavBar(false);
              },
            ),
            buildMenuItem(Icons.menu_book_rounded, 'Educational Information',
                () {
              context.pushNamed(AppRouter.educational.name);
              ref
                  .read(showNavBarNotifierProvider.notifier)
                  .showBottomNavBar(false);
            }),
            buildMenuItem(Icons.tune, 'Preferences'),
            buildMenuItem(Icons.language, 'Language'),
            buildMenuItem(Icons.power_settings_new, 'Log out',
                () => context.go(AppRouter.onboarding.path)),
          ],
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
            color: AppColors.darkTeal,
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.chevron_right),
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
