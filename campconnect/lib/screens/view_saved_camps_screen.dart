import 'package:campconnect/providers/show_nav_bar_provider.dart';
import 'package:campconnect/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ViewSavedCampsScreen extends ConsumerStatefulWidget {
  const ViewSavedCampsScreen({super.key});

  @override
  ConsumerState<ViewSavedCampsScreen> createState() =>
      _ViewSavedCampsScreenState();
}

class _ViewSavedCampsScreenState extends ConsumerState<ViewSavedCampsScreen> {
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
            'View Saved Camps',
            style: getTextStyle("mediumBold", color: Colors.white),
          ),
        ),
      ),
    );
  }
}
