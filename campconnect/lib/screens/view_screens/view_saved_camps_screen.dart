import 'package:campconnect/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campconnect/theme/constants.dart';

import '../../providers/show_nav_bar_provider.dart';
import '../../providers/camp_provider.dart';
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
      debugPrint(widget.userId);
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
          'View Saved Camps',
          style: getTextStyle("mediumBold", color: Colors.white),
        ),
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            buildBackground("bg12"),
            FutureBuilder(
              future: ref
                  .read(campProviderNotifier.notifier)
                  .getSavedCampsByStudentId(widget.userId),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return errorWidget(snapshot);
                }
                if (snapshot.hasData) {
                  return snapshot.data!.isEmpty
                      ? const EmptyScreen()
                      : ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final camp = snapshot.data![index];
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Card(
                                color: AppColors.darkTeal,
                                child: Stack(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
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
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      camp.name,
                                                      style: getTextStyle(
                                                          'mediumBold',
                                                          color: Colors.white),
                                                    ),
                                                  ],
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
                                    Positioned(
                                      top: 12,
                                      right: 16,
                                      child: GestureDetector(
                                        onTap: () {
                                          showModalBottomSheet(
                                            backgroundColor: AppColors.darkTeal,
                                            context: context,
                                            builder: (context) {
                                              return Container(
                                                height: 150,
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    ListTile(
                                                      leading: const Icon(
                                                        Icons.delete,
                                                        color: Colors.white,
                                                      ),
                                                      title: Text(
                                                          'Remove from Camps',
                                                          style: getTextStyle(
                                                              "mediumBold",
                                                              color: Colors
                                                                  .white)),
                                                      onTap: () {
                                                        showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return ConfirmationDialog(
                                                              type: 'Remove',
                                                              title:
                                                                  'Remove a Camp',
                                                              content:
                                                                  'Are you sure you want to remove this saved camp?',
                                                              onConfirm: () {},
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: const Icon(
                                          Icons.more_horiz,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                }
                return loadingWidget(snapshot: snapshot, label: 'Saved Camps');
              },
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
