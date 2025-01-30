import 'package:campconnect/models/teacher.dart';
import 'package:campconnect/theme/constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:campconnect/widgets/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:campconnect/models/teacher.dart';
import 'package:campconnect/theme/constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:campconnect/widgets/empty_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminTeacherVerificationScreen extends ConsumerStatefulWidget {
  const AdminTeacherVerificationScreen({super.key});

  @override
  ConsumerState<AdminTeacherVerificationScreen> createState() =>
      _AdminTeacherVerificationScreenState();
}

class _AdminTeacherVerificationScreenState
    extends ConsumerState<AdminTeacherVerificationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: AppColors.darkTeal,
        elevation: 0,
        title: Text(
          'Teacher Verification',
          style: getTextStyle("mediumBold", color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          buildBackground("bg10"), // Same background as ViewTeachersScreen
          Column(
            children: [
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTeacherList('pending'),
                    _buildTeacherList('rejected'),
                    _buildTeacherList('existing'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 0.7,
          ),
          borderRadius: BorderRadius.circular(25),
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return TabBar(
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              controller: _tabController,
              indicator: BoxDecoration(
                color: Colors.white, // Selected tab background
                borderRadius: BorderRadius.circular(25),
              ),
              onTap: (index) =>
                  setState(() {}), // Update the UI when a tab is tapped
              tabs: [
                _buildTabItem('Pending', 0),
                _buildTabItem('Rejected', 1),
                _buildTabItem('Existing', 2),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabItem(String text, int index) {
    bool isSelected = _tabController.index == index;

    return Tab(
      child: Container(
        width: 130, // Set a fixed width for all tabs
        alignment: Alignment.center,
        child: Text(
          text,
          style: getTextStyle(
            'smallBold',
            color: isSelected ? AppColors.lightTeal : Colors.white,
          ),
        ),
      ),
    );
  }

  /// Generates dummy data
  List<Teacher> _generateDummyTeachers(String status) {
    return [
      Teacher(
        id: 'T001',
        firstName: 'John',
        lastName: 'Doe',
        dateOfBirth: DateTime(1990, 7, 20),
        nationality: 'American',
        primaryLanguages: ['English'],
        phoneCode: '+1',
        mobileNumber: '1234567890',
        email: 'johndoe@example.com',
        highestEducationLevel: 'Bachelors',
        certifications: ['Teaching Certificate'],
        teachingExperience: 5,
        areasOfExpertise: ['Mathematics', 'Physics'],
        willingnessToTravel: 'Within 10 km',
        availabilitySchedule: 'Mon-Fri 9 AM - 5 PM',
        preferredCampDuration: 'Short-term',
        teachingCamps: ['Camp Alpha'],
        verificationStatus: status,
      ),
      Teacher(
        id: 'T002',
        firstName: 'Jane',
        lastName: 'Smith',
        dateOfBirth: DateTime(1985, 5, 15),
        nationality: 'British',
        primaryLanguages: ['English'],
        phoneCode: '+44',
        mobileNumber: '9876543210',
        email: 'janesmith@example.com',
        highestEducationLevel: 'Masters',
        certifications: ['TESOL Certification', 'PGCE'],
        teachingExperience: 8,
        areasOfExpertise: ['Biology', 'Chemistry'],
        willingnessToTravel: 'Within 20 km',
        availabilitySchedule: 'Tue-Thu 10 AM - 3 PM',
        preferredCampDuration: '1 week',
        teachingCamps: ['Camp Beta'],
        verificationStatus: status,
      ),
      Teacher(
        id: 'T003',
        firstName: 'Alice',
        lastName: 'Johnson',
        dateOfBirth: DateTime(1992, 11, 10),
        nationality: 'Canadian',
        primaryLanguages: ['English', 'French'],
        phoneCode: '+1',
        mobileNumber: '4567890123',
        email: 'alicejohnson@example.com',
        highestEducationLevel: 'PhD',
        certifications: ['Teaching License'],
        teachingExperience: 10,
        areasOfExpertise: ['Computer Science', 'Physics'],
        willingnessToTravel: 'Remote Only',
        availabilitySchedule: 'Flexible',
        preferredCampDuration: 'Long-term',
        teachingCamps: ['Camp Gamma'],
        verificationStatus: status,
      ),
    ];
  }

  /// Builds the teacher list for each tab
  Widget _buildTeacherList(String status) {
    List<Teacher> teachers = _generateDummyTeachers(status);

    return teachers.isEmpty
        ? const EmptyScreen()
        : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: teachers.length,
            itemBuilder: (context, index) {
              return _buildTeacherCard(teachers[index]);
            },
          );
  }

  Widget _buildTeacherCard(Teacher teacher) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        color: AppColors.darkTeal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment:
                CrossAxisAlignment.center, // Center items vertically
            children: [
              // Teacher Info (Left Side)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
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
                            style:
                                getTextStyle('mediumBold', color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    addVerticalSpace(10),
                    Text(
                      'Contact: ${teacher.phoneCode} ${teacher.mobileNumber}',
                      style: getTextStyle('small', color: Colors.white),
                    ),
                    addVerticalSpace(5),
                    Text(
                      'Email: ${teacher.email}',
                      style: getTextStyle('small', color: Colors.white),
                    ),
                    addVerticalSpace(5),
                    Text(
                      'Status: ${teacher.verificationStatus}',
                      style:
                          getTextStyle('smallBold', color: AppColors.lightTeal),
                    ),
                  ],
                ),
              ),

              Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centers vertically
                children: [
                  _buildActionButton(
                    icon: Icons.visibility,
                    color: Colors.white, // White icon
                    tooltip: "View Details",
                    onTap: () => _showTeacherDetailsDialog(context, teacher),
                  ),
                  _buildActionButton(
                    icon: Icons.edit,
                    color: Colors.white, // White icon
                    tooltip: "Change Status",
                    onTap: () => _showStatusChangeDialog(context, teacher),
                  ),
                  _buildActionButton(
                    icon: Icons.delete,
                    color: Colors.white, // White icon
                    tooltip: "Delete",
                    onTap: () => _deleteTeacher(teacher),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Action Button with White Icons
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return IconButton(
      icon: Icon(icon, color: color, size: 20), // White icons
      tooltip: tooltip,
      onPressed: onTap,
    );
  }

  void _showTeacherDetailsDialog(BuildContext context, Teacher teacher) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('${teacher.firstName} ${teacher.lastName}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Email: ${teacher.email}'),
                Text('Phone: ${teacher.phoneCode} ${teacher.mobileNumber}'),
                Text('Nationality: ${teacher.nationality}'),
                Text('Education: ${teacher.highestEducationLevel}'),
                Text(
                    'Teaching Experience: ${teacher.teachingExperience} years'),
                Text('Availability: ${teacher.availabilitySchedule}'),
                Text('Willingness to Travel: ${teacher.willingnessToTravel}'),
                addVerticalSpace(10),
                Text('Areas of Expertise:', style: getTextStyle('smallBold')),
                buildChips(teacher.areasOfExpertise),
                addVerticalSpace(10),
                Text('Certifications:', style: getTextStyle('smallBold')),
                buildChips(teacher.certifications),
                addVerticalSpace(10),
                Text('Teaching Camps:', style: getTextStyle('smallBold')),
                buildChips(teacher.teachingCamps),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Close"),
            ),
          ],
        );
      },
    );
  }

  void _showStatusChangeDialog(BuildContext context, Teacher teacher) {
    List<String> statuses = ['pending', 'existing', 'rejected'];
    String selectedStatus = teacher.verificationStatus;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Change Verification Status"),
          content: DropdownButton<String>(
            value: selectedStatus,
            isExpanded: true,
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  teacher.verificationStatus = newValue;
                });
                Navigator.pop(context);
              }
            },
            items: statuses.map((status) {
              return DropdownMenuItem<String>(
                value: status,
                child: Text(status.toUpperCase()),
              );
            }).toList(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _deleteTeacher(Teacher teacher) {
    setState(() {
      // // Assuming you have a list `teachers` storing the teacher data
      // teachers.removeWhere((t) => t.id == teacher.id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${teacher.firstName} has been deleted')),
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
              style: getTextStyle('xsmall', color: AppColors.darkTeal),
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
