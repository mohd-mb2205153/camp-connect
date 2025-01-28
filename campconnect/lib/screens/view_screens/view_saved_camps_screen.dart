import 'package:campconnect/models/camp.dart';
import 'package:campconnect/providers/student_provider.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campconnect/theme/constants.dart';
import 'package:go_router/go_router.dart';

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
  List<Camp> savedCamps = [];

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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Expanded(
                      child: FutureBuilder(
                        future: ref
                            .read(campProviderNotifier.notifier)
                            .getSavedCampsByStudentId(widget.userId),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return errorWidget(snapshot);
                          }
                          if (snapshot.hasData) {
                            savedCamps =
                                List<Camp>.from(snapshot.data as List<Camp>);
                            return savedCamps.isEmpty
                                ? const EmptyScreen()
                                : ListView.builder(
                                    itemCount: savedCamps.length,
                                    itemBuilder: (context, index) {
                                      final camp = savedCamps[index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Card(
                                          color: AppColors.darkTeal,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Stack(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      width: 50,
                                                      height: 50,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            AppColors.lightTeal,
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
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                camp.name,
                                                                style: getTextStyle(
                                                                    'mediumBold',
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                            ],
                                                          ),
                                                          const SizedBox(
                                                              height: 8),
                                                          Text(
                                                            camp.description,
                                                            style: getTextStyle(
                                                                'small',
                                                                color: Colors
                                                                    .white70),
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
                                                      backgroundColor:
                                                          AppColors.darkTeal,
                                                      context: context,
                                                      builder: (context) {
                                                        return Container(
                                                          height: screenHeight(
                                                                  context) *
                                                              0.12,
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              ListTile(
                                                                leading:
                                                                    const Icon(
                                                                  Icons.delete,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                title: Text(
                                                                    'Remove from Camps',
                                                                    style: getTextStyle(
                                                                        "mediumBold",
                                                                        color: Colors
                                                                            .white)),
                                                                onTap:
                                                                    () async {
                                                                  bool exit =
                                                                      false;
                                                                  await showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return ConfirmationDialog(
                                                                        type:
                                                                            'Remove',
                                                                        title:
                                                                            'Remove ${camp.name} Camp?',
                                                                        content:
                                                                            'Are you sure you want to remove this saved camp?',
                                                                        onConfirm:
                                                                            () async {
                                                                          // Return Stream instead of Future (Update provider)
                                                                          exit =
                                                                              true;
                                                                          await ref.read(studentProviderNotifier.notifier).removedSavedCamps(
                                                                              studentId: widget.userId,
                                                                              campId: camp.id!);
                                                                          setState(
                                                                              () {
                                                                            savedCamps.remove(camp);
                                                                          });
                                                                        },
                                                                      );
                                                                    },
                                                                  );
                                                                  exit
                                                                      ? context
                                                                          .pop()
                                                                      : null;
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
                          return loadingWidget(
                              snapshot: snapshot, label: 'Saved Camps');
                        },
                      ),
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
