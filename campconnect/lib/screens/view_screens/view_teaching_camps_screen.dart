import 'package:campconnect/models/camp.dart';
import 'package:campconnect/providers/camp_provider.dart';
import 'package:campconnect/providers/show_nav_bar_provider.dart';
import 'package:campconnect/providers/teacher_provider.dart';
import 'package:campconnect/routes/app_router.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:campconnect/widgets/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../theme/constants.dart';

class ViewTeachingCampsScreen extends ConsumerStatefulWidget {
  final String userId;
  const ViewTeachingCampsScreen({super.key, required this.userId});

  @override
  ConsumerState<ViewTeachingCampsScreen> createState() =>
      _ViewTeachingCampsScreenState();
}

class _ViewTeachingCampsScreenState
    extends ConsumerState<ViewTeachingCampsScreen> {
  List<Camp> teachingCamps = [];

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
          backgroundColor: AppColors.darkTeal,
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
            'View Teaching Camps',
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
                            .getTeachingCampsByTeacherId(widget.userId),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return errorWidget(snapshot);
                          }
                          if (snapshot.hasData) {
                            teachingCamps =
                                List<Camp>.from(snapshot.data as List<Camp>);
                            return teachingCamps.isEmpty
                                ? const EmptyScreen()
                                : ListView.builder(
                                    itemCount: teachingCamps.length,
                                    itemBuilder: (context, index) {
                                      final camp = teachingCamps[index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Card(
                                          color: AppColors.darkTeal,
                                          child: Stack(
                                            children: [
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    // Camp Icon
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
                                                    // Camp Details
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            camp.name,
                                                            style: getTextStyle(
                                                                'mediumBold',
                                                                color: Colors
                                                                    .white),
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
                                                                  Icons.edit,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                                title: Text(
                                                                  'Update Teaching Camp',
                                                                  style: getTextStyle(
                                                                      "mediumBold",
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                onTap: () {
                                                                  context.pop();
                                                                  context.pushNamed(
                                                                      AppRouter
                                                                          .updateCampLocation
                                                                          .name,
                                                                      extra: camp
                                                                          .id);
                                                                },
                                                              ),
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
                                                                onTap: () =>
                                                                    handleDeleteTeachingCamps(
                                                                        camp),
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
                              snapshot: snapshot, label: "Teaching Camps");
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

  void handleDeleteTeachingCamps(Camp camp) async {
    bool exit = false;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          type: 'Remove',
          title: 'Remove ${camp.name} Camp?',
          content: 'Are you sure you want to remove this as a teaching camp?',
          onConfirm: () async {
            exit = true;
            ref.read(teacherProviderNotifier.notifier).removeTeachingCamps(
                teacherId: widget.userId, campId: camp.id!);
            await ref.read(campProviderNotifier.notifier).removeCampsClass(
                targetTeacherId: widget.userId, campId: camp.id!);
            setState(() {
              teachingCamps.remove(camp);
            });
          },
        );
      },
    );
    exit ? context.pop() : null;
  }
}
