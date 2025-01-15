import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
                      backgroundColor: Colors.black54,
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
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 5,
              color: Colors.black,
            ),
            const SizedBox(
              height: 10,
            ),
            buildMenuItem(const Icon(Icons.person), 'Personal Information'),
            buildMenuItem(
                const Icon(Icons.menu_book_rounded), 'Educational Information'),
            buildMenuItem(const Icon(Icons.tune), 'Preferences'),
            buildMenuItem(const Icon(Icons.language), 'Language'),
            buildMenuItem(const Icon(Icons.power_settings_new), 'Logout'),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem(Icon icon, String title) {
    return Column(
      children: [
        ListTile(
          leading: icon,
          title: Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {},
          ),
        ),
        Divider(
          height: 1,
          color: Colors.grey[300],
        ),
      ],
    );
  }
}
