import 'package:campconnect/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/loggedinuser_provider.dart';
import '../../providers/show_nav_bar_provider.dart';
import '../../providers/class_provider.dart';
import '../../routes/app_router.dart';
import '../../theme/constants.dart';
import '../../widgets/empty_screen.dart';

class ViewClassesScreen extends ConsumerStatefulWidget {
  final String campId;

  const ViewClassesScreen({super.key, required this.campId});

  @override
  ConsumerState<ViewClassesScreen> createState() => _ViewClassesScreenState();
}

class _ViewClassesScreenState extends ConsumerState<ViewClassesScreen> {
  bool isStudent = false;
  bool isTeacher = false;
  dynamic loggedUser;

  @override
  void initState() {
    super.initState();
    initializeUserDetails();
    debugPrint(widget.campId);
    Future.microtask(() {
      ref.read(showNavBarNotifierProvider.notifier).showBottomNavBar(false);
      ref.read(classProviderNotifier.notifier).initializeClasses();
    });
  }

  void initializeUserDetails() {
    Future.microtask(() {
      final userNotifier = ref.read(loggedInUserNotifierProvider.notifier);

      isStudent = userNotifier.isStudent;
      isTeacher = userNotifier.isTeacher;

      if (isStudent) {
        loggedUser = userNotifier.student;
      } else if (isTeacher) {
        loggedUser = userNotifier.teacher;
      }

      ref.read(showNavBarNotifierProvider.notifier).showBottomNavBar(true);

      setState(() {});
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
          actions: [
            isTeacher
                ? IconButton(
                    icon: const Icon(Icons.note_add, color: Colors.white),
                    onPressed: () {
                      ref
                          .read(showNavBarNotifierProvider.notifier)
                          .showBottomNavBar(false);

                      context.goNamed(AppRouter.addClass.name,
                          extra: widget.campId);
                    },
                  )
                : Text(""),
          ],
          title: Text(
            'View Classes',
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
                            .read(classProviderNotifier.notifier)
                            .getClassByCampId(widget.campId),
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
                                      final classItem = snapshot.data![index];
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
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Icon(
                                                          Icons.library_books,
                                                          color: Colors.white,
                                                          size: 24,
                                                        ),
                                                        const SizedBox(
                                                            width: 8),
                                                        Text(
                                                          classItem.subject,
                                                          style: getTextStyle(
                                                              'mediumBold',
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Subtopic: ',
                                                          style: getTextStyle(
                                                              'smallBold',
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            classItem.subtitle,
                                                            style: getTextStyle(
                                                                'small',
                                                                color: Colors
                                                                    .white70),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Teacher: ',
                                                          style: getTextStyle(
                                                              'smallBold',
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            "${classItem.teacher.firstName} ${classItem.teacher.lastName}",
                                                            style: getTextStyle(
                                                                'small',
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Text(
                                                      'Description:',
                                                      style: getTextStyle(
                                                          'smallBold',
                                                          color: Colors.white),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      classItem.description,
                                                      style: getTextStyle(
                                                          'small',
                                                          color:
                                                              Colors.white70),
                                                    ),
                                                    const SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        Text(
                                                          'Time: ',
                                                          style: getTextStyle(
                                                              'smallBold',
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                        Expanded(
                                                          child: Text(
                                                            '${classItem.timeFrom} - ${classItem.timeTo}',
                                                            style: getTextStyle(
                                                                'small',
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              if (isTeacher)
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
                                                            height: 150,
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
                                                                    'Edit Class',
                                                                    style: getTextStyle(
                                                                        "mediumBold",
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                  onTap: () {},
                                                                ),
                                                                ListTile(
                                                                  leading:
                                                                      const Icon(
                                                                    Icons
                                                                        .delete,
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                  title: Text(
                                                                      'Delete Class',
                                                                      style: getTextStyle(
                                                                          "mediumBold",
                                                                          color:
                                                                              Colors.white)),
                                                                  onTap: () {
                                                                    showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return ConfirmationDialog(
                                                                          type:
                                                                              'Delete',
                                                                          title:
                                                                              'Delete a Class Schedule',
                                                                          content:
                                                                              'Are you sure you want to delete this class?',
                                                                          onConfirm:
                                                                              () {},
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
                          return loadingWidget(
                              snapshot: snapshot, label: "Classes");
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
