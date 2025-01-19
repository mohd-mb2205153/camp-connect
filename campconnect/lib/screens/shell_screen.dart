import 'package:campconnect/providers/show_nav_bar_provider.dart';
import 'package:campconnect/theme/styling_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ShellScreen extends ConsumerStatefulWidget {
  final Widget? child;
  final GoRouterState state;
  const ShellScreen({super.key, required this.state, this.child});

  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<ShellScreen> {
  final List<String> _routes = [
    '/home',
    '/maps',
    '/profile',
  ];

  void _onItemTapped(int index) {
    if (index != ref.read(showNavBarNotifierProvider)['selectedIndex']) {
      context.go(_routes[index]);
      ref
          .read(showNavBarNotifierProvider.notifier)
          .setActiveBottomNavBar(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final navBarState = ref.watch(showNavBarNotifierProvider);
    final _selectedIndex = navBarState['selectedIndex'];

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: navBarState['showNavBar']
          ? BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: AppColors.lightTeal,
              unselectedItemColor: Colors.grey,
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.map),
                  label: '',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: '',
                ),
              ],
            )
          : null,
    );
  }
}
