import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campconnect/theme/constants.dart';

import '../../providers/show_nav_bar_provider.dart';
import '../../providers/camp_provider.dart';
import '../../providers/student_provider.dart';
import '../../widgets/empty_screen.dart';

class ViewSavedCampsScreen extends ConsumerStatefulWidget {
  final String userId;
  const ViewSavedCampsScreen({super.key, required this.userId});

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
    final studentAsyncValue = ref.watch(studentProviderNotifier);
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
          'View Saved Camps',
          style: getTextStyle("mediumBold", color: Colors.white),
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            buildBackground("bg12"),
            studentAsyncValue.when(
              data: (students) {
                final student = students.firstWhere(
                  (s) => s.id == widget.userId,
                );

                // if (student == null || student.savedCamps.isEmpty) {
                //   return Center(
                //     child: Padding(
                //       padding: const EdgeInsets.only(bottom: 60),
                //       child: Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           Icon(
                //             Icons.bookmark_add,
                //             size: 32,
                //             color: const Color.fromARGB(179, 245, 245, 245),
                //           ),
                //           const SizedBox(height: 16),
                //           Text(
                //             'You do not have\n any saved camps',
                //             style: getTextStyle("medium",
                //                 color:
                //                     const Color.fromARGB(179, 245, 245, 245)),
                //             textAlign: TextAlign.center,
                //           ),
                //         ],
                //       ),
                //     ),
                //   );
                // }

                final savedCamps = ref.watch(campProviderNotifier).whenData(
                      (camps) => camps
                          .where((camp) => student.savedCamps.contains(camp.id))
                          .toList(),
                    );

                return savedCamps.when(
                  data: (camps) => camps.isEmpty
                      ? const EmptyScreen()
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                );
              },
              error: (err, _) => Center(child: Text('Error: $err')),
              loading: () => const Center(child: CircularProgressIndicator()),
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
