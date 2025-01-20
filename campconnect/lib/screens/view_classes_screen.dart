import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/class.dart';
import '../models/teacher.dart';
import '../providers/show_nav_bar_provider.dart';
import '../theme/constants.dart';
import '../utils/helper_widgets.dart';

class ViewClassesScreen extends ConsumerStatefulWidget {
  final String campId;

  const ViewClassesScreen({super.key, required this.campId});

  @override
  ConsumerState<ViewClassesScreen> createState() => _ViewClassesScreenState();
}

class _ViewClassesScreenState extends ConsumerState<ViewClassesScreen> {
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
            context.pop();
          },
        ),
        title: Text(
          'View Classes',
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
                  Expanded(child: ClassList(campId: widget.campId)),
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

class ClassList extends StatelessWidget {
  final String campId;

  const ClassList({super.key, required this.campId});

  @override
  Widget build(BuildContext context) {
    // Placeholder data
    final classes = List.generate(
      5,
      (index) => Class(
        id: 'class_$index',
        teacher: Teacher(
          id: 'teacher_$index',
          firstName: 'Teacher $index',
          lastName: 'LastName',
          dateOfBirth: DateTime(1980 + index, 1, 1),
          nationality: 'Country',
          primaryLanguages: ['English'],
          phoneCode: '+974',
          mobileNumber: '6681562$index',
          highestEducationLevel: 'Master’s',
          teachingExperience: 5,
          areasOfExpertise: ['Math', 'Science'],
          willingnessToTravel: 'Within 10 km',
          availabilitySchedule: '9 AM - 3 PM',
          preferredCampDuration: 'Short-term',
        ),
        description: 'This is a placeholder description for Class $index.',
        subject: 'Subject $index',
        subtitle: 'Subtitle $index',
        timeFrom: '10:00 AM',
        timeTo: '12:00 PM',
      ),
    );

    return classes.isEmpty
        ? const Center(child: Text('No classes available'))
        : ListView.builder(
            itemCount: classes.length,
            itemBuilder: (context, index) {
              final classItem = classes[index];
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Card(
                  color: AppColors.darkTeal,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          classItem.subject,
                          style:
                              getTextStyle('mediumBold', color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          classItem.subtitle,
                          style: getTextStyle('small', color: Colors.white70),
                        ),
                        addVerticalSpace(10),
                        Row(
                          children: [
                            Text(
                              'Teacher: ',
                              style: getTextStyle('smallBold',
                                  color: Colors.white),
                            ),
                            Expanded(
                              child: Text(
                                classItem.teacher.firstName,
                                style:
                                    getTextStyle('small', color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        addVerticalSpace(10),
                        Text(
                          'Description:',
                          style: getTextStyle('smallBold', color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          classItem.description,
                          style: getTextStyle('small', color: Colors.white70),
                        ),
                        addVerticalSpace(10),
                        Row(
                          children: [
                            Text(
                              'Time: ',
                              style: getTextStyle('smallBold',
                                  color: Colors.white),
                            ),
                            Expanded(
                              child: Text(
                                '${classItem.timeFrom} - ${classItem.timeTo}',
                                style:
                                    getTextStyle('small', color: Colors.white),
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
  }
}
