import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/show_nav_bar_provider.dart';
import '../theme/constants.dart';

class ViewCreatedCampsScreen extends ConsumerStatefulWidget {
  const ViewCreatedCampsScreen({super.key});

  @override
  ConsumerState<ViewCreatedCampsScreen> createState() =>
      _ViewCreatedCampsScreenState();
}

class _ViewCreatedCampsScreenState
    extends ConsumerState<ViewCreatedCampsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(showNavBarNotifierProvider.notifier).showBottomNavBar(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          ref.read(showNavBarNotifierProvider.notifier).showBottomNavBar(true);
          Navigator.of(context).pop(result);
        }
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: AppColors.lightTeal,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              ref
                  .read(showNavBarNotifierProvider.notifier)
                  .showBottomNavBar(true);
              context.pop();
            },
          ),
          title: Text(
            'View Created Camps',
            style: getTextStyle("mediumBold", color: Colors.white),
          ),
        ),
      ),
    );
  }
}
