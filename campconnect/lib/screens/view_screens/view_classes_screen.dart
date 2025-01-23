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
    final classesAsync = ref.watch(classProviderNotifier);

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
                    child: classesAsync.when(
                      data: (classes) {
                        final campClasses = classes
                            .where((c) =>
                                c.teacher.teachingCamps.contains(widget.campId))
                            .toList();

                        return campClasses.isEmpty
                            ? const EmptyScreen()
                            : ListView.builder(
                                itemCount: campClasses.length,
                                itemBuilder: (context, index) {
                                  final classItem = campClasses[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Card(
                                      color: AppColors.darkTeal,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Container(
                                        padding: const EdgeInsets.all(16.0),
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
                                                const SizedBox(width: 8),
                                                Text(
                                                  classItem.subject,
                                                  style: getTextStyle(
                                                      'mediumBold',
                                                      color: Colors.white),
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
                                                      color: Colors.white),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    classItem.subtitle,
                                                    style: getTextStyle('small',
                                                        color: Colors.white70),
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
                                                      color: Colors.white),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    "${classItem.teacher.firstName} ${classItem.teacher.lastName}",
                                                    style: getTextStyle('small',
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10),
                                            Text(
                                              'Description:',
                                              style: getTextStyle('smallBold',
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              classItem.description,
                                              style: getTextStyle('small',
                                                  color: Colors.white70),
                                            ),
                                            const SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Text(
                                                  'Time: ',
                                                  style: getTextStyle(
                                                      'smallBold',
                                                      color: Colors.white),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    '${classItem.timeFrom} - ${classItem.timeTo}',
                                                    style: getTextStyle('small',
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                      },
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(child: Text('Error: $err')),
                    ),
                  ),
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
