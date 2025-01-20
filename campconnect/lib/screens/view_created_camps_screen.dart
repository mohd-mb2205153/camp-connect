import 'package:campconnect/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/show_nav_bar_provider.dart';
import '../providers/teacher_provider.dart';
import '../theme/constants.dart';

class ViewCreatedCampsScreen extends ConsumerStatefulWidget {
  final String userId;
  const ViewCreatedCampsScreen({super.key, required this.userId});

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
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: AppColors.darkTeal,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              ref
                  .read(showNavBarNotifierProvider.notifier)
                  .showBottomNavBar(true);
              Navigator.pop(context);
            },
          ),
          title: Text(
            'View Created Camps',
            style: getTextStyle("mediumBold", color: Colors.white),
          ),
        ),
        body: SizedBox.expand(
          child: Stack(
            children: [
              buildBackground("bg12"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Expanded(
                      child: CreatedCampListView(userId: widget.userId),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildBackground(String imageName) {
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage("assets/images/$imageName.png"),
        fit: BoxFit.cover,
      ),
    ),
  );
}

class CreatedCampListView extends ConsumerWidget {
  final String userId;
  const CreatedCampListView({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final createdCamps = ref.watch(createdCampsProvider(userId));

    return createdCamps.when(
      data: (camps) => camps.isEmpty
          ? const Center(child: Text('No created camps available'))
          : ListView.builder(
              itemCount: camps.length,
              itemBuilder: (context, index) {
                final camp = camps[index];
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Card(
                    color: AppColors.darkTeal,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Camp Icon
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.lightTeal,
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              'assets/images/tent_icon_white.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Camp Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  camp.name,
                                  style: getTextStyle('mediumBold',
                                      color: Colors.white),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  camp.description,
                                  style: getTextStyle('small',
                                      color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      error: (err, _) => Center(child: Text('Error: $err')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
