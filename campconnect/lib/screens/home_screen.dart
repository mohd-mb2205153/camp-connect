import 'package:campconnect/providers/show_nav_bar_provider.dart';
import 'package:campconnect/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    Future.microtask(() {
      ref.read(showNavBarNotifierProvider.notifier).showBottomNavBar(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ref.read(showNavBarNotifierProvider.notifier).showBottomNavBar(false);
          context.pushNamed(AppRouter.addCampLocation.name);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
