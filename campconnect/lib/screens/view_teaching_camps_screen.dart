import 'package:campconnect/providers/show_nav_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/constants.dart';
import '../utils/helper_widgets.dart';

class ViewTeachingCampsScreen extends ConsumerStatefulWidget {
  final String userId;
  const ViewTeachingCampsScreen({super.key, required this.userId});

  @override
  ConsumerState<ViewTeachingCampsScreen> createState() =>
      _ViewTeachingCampsScreenState();
}

class _ViewTeachingCampsScreenState
    extends ConsumerState<ViewTeachingCampsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(showNavBarNotifierProvider.notifier).showBottomNavBar(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'View Teaching Camps',
          style: getTextStyle("mediumBold", color: Colors.white),
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            buildBackground("bg12"), // Background for the screen
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Expanded(child: TeachingCampList()),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
}

class TeachingCampList extends StatelessWidget {
  const TeachingCampList({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder data
    final teachingCamps = List.generate(
      5,
      (index) => Camp(
        id: 'teaching_camp_$index',
        name: 'Teaching Camp $index',
        description:
            'This is a placeholder description for Teaching Camp $index.',
        latitude: 0.0,
        longitude: 0.0,
      ),
    );

    return teachingCamps.isEmpty
        ? const Center(child: Text('No teaching camps available'))
        : ListView.builder(
            itemCount: teachingCamps.length,
            itemBuilder: (context, index) {
              final camp = teachingCamps[index];
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
          );
  }
}

// Placeholder Camp Model
class Camp {
  final String id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;

  Camp({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
  });
}
