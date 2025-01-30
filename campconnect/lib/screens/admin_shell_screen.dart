import 'package:campconnect/providers/show_nav_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminShellScreen extends ConsumerStatefulWidget {
  final Widget? child;
  final GoRouterState state;
  const AdminShellScreen({super.key, required this.state, this.child});

  @override
  ConsumerState<AdminShellScreen> createState() => _AdminShellScreenState();
}

class _AdminShellScreenState extends ConsumerState<AdminShellScreen> {
  final List<String> _routes = [
    '/dashboard',
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
              backgroundColor: Colors.white,
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: _selectedIndex == 2 ? 30 : 26,
                    height: _selectedIndex == 2 ? 30 : 26,
                    child: Image.asset(
                      _selectedIndex == 2
                          ? 'assets/images/profile_icon_teal.png'
                          : 'assets/images/profile_icon_grey.png',
                    ),
                  ),
                  label: '',
                ),
              ],
            )
          : null,
    );
  }
}
