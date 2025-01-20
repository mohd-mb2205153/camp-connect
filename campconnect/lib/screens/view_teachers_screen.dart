import 'package:campconnect/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:campconnect/providers/teacher_provider.dart';
import 'package:campconnect/theme/constants.dart';
import '../providers/show_nav_bar_provider.dart';
import '../widgets/empty_screen.dart';
import '../widgets/icon_container.dart';

class ViewTeachersScreen extends ConsumerStatefulWidget {
  final String campId;
  const ViewTeachersScreen({super.key, required this.campId});

  @override
  ConsumerState<ViewTeachersScreen> createState() => _ViewTeachersScreenState();
}

class _ViewTeachersScreenState extends ConsumerState<ViewTeachersScreen> {
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
          'View Teachers',
          style: getTextStyle("mediumBold", color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(child: TeacherList(campId: widget.campId)),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class TeacherList extends ConsumerWidget {
  final String campId;
  const TeacherList({super.key, required this.campId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teachers = ref.watch(teachersByCampIdProvider(campId));
    return teachers.when(
      data: (teacherList) {
        return teacherList.isEmpty
            ? const EmptyScreen()
            : ListView.builder(
                itemCount: teacherList.length,
                itemBuilder: (context, index) {
                  final teacher = teacherList[index];
                  return Card(
                    color: AppColors.darkTeal,
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: const BoxDecoration(
                                  color: AppColors.lightTeal,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person_2_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  '${teacher.firstName} ${teacher.lastName}',
                                  style: getTextStyle('mediumBold',
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                          addVerticalSpace(15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Experience: ',
                                        style: getTextStyle("smallBold",
                                            color: Colors.white),
                                      ),
                                      Text(
                                        '${teacher.teachingExperience} years',
                                        style: getTextStyle("small",
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Mobile: ',
                                        style: getTextStyle("smallBold",
                                            color: Colors.white),
                                      ),
                                      Text(
                                        '${teacher.phoneCode} ${teacher.mobileNumber}',
                                        style: getTextStyle("small",
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              addVerticalSpace(10),
                              Row(
                                children: [
                                  Text(
                                    'Availability: ',
                                    style: getTextStyle("smallBold",
                                        color: Colors.white),
                                  ),
                                  Expanded(
                                    child: Text(
                                      teacher.availabilitySchedule,
                                      style: getTextStyle("small",
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                              addVerticalSpace(10),
                              Text(
                                'Area of Expertise:',
                                style: getTextStyle("smallBold",
                                    color: Colors.white),
                              ),
                              addVerticalSpace(10),
                              buildChips(teacher.areasOfExpertise),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
      },
      error: (err, stack) => Text('Error: $err'),
      loading: () => const CircularProgressIndicator(),
    );
  }

  Widget buildChips(List<String>? items) {
    return Wrap(
      children: (items ?? []).map((item) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 8, 4),
          child: Chip(
            backgroundColor: Colors.white,
            label: Text(
              item,
              style: getTextStyle('xsmall', color: AppColors.lightTeal),
            ),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.circular(20),
            ),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 0),
          ),
        );
      }).toList(),
    );
  }
}
