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
        child: StatefulBuilder(
          builder: (context, setState) {
            return TabBar(
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.label,
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
      child: SizedBox(
        width: double.infinity,
        child: Center(
          child: Text(
            text,
            style: getTextStyle(
              'smallBold',
              color: isSelected ? AppColors.lightTeal : Colors.white,
            ),
          ),
        ),
      ),
    );
  }

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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return AppColors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return AppColors.lightTeal;
    }
  }

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
      padding: const EdgeInsets.only(top: 6.0), // Reduce top padding
      child: Card(
        color: AppColors.darkTeal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0), // Reduce padding inside card
          child: Stack(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Status Indicator Circle
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: _getStatusColor(teacher.verificationStatus),
                      shape: BoxShape.circle,
                    ),
                  ),
                  addHorizontalSpace(20),

                  // Teacher Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min, // Ensures column shrinks
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 35, // Reduce profile icon size
                              height: 35,
                              decoration: const BoxDecoration(
                                color: AppColors.lightTeal,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person_2_rounded,
                                color: Colors.white,
                                size: 20, // Reduce icon size
                              ),
                            ),
                            const SizedBox(width: 15), // Reduce spacing
                            Expanded(
                              child: Text(
                                '${teacher.firstName} ${teacher.lastName}',
                                style: getTextStyle('mediumBold',
                                    color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        addVerticalSpace(6), // Reduce spacing
                        Text(
                          'Contact: ${teacher.phoneCode} ${teacher.mobileNumber}',
                          style: getTextStyle('small', color: Colors.white),
                        ),
                        addVerticalSpace(4), // Reduce spacing
                        Text(
                          'Email: ${teacher.email}',
                          style: getTextStyle('small', color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // More Button (Positioned on Top Right)
              Positioned(
                top: 6,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    _showTeacherOptionsBottomSheet(context, teacher);
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
      ),
    );
  }

  /// Action Button with White Icons (Smaller and Tighter)
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return IconButton(
      icon: Icon(icon, color: color, size: 20),
      tooltip: tooltip,
      onPressed: onTap,
      padding: EdgeInsets.zero,
      constraints: BoxConstraints(),
    );
  }

  void _showTeacherOptionsBottomSheet(BuildContext context, Teacher teacher) {
    showModalBottomSheet(
      backgroundColor: AppColors.darkTeal,
      context: context,
      builder: (context) {
        return Container(
          height: 200, // Increased height to accommodate View option
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // View Details Option
              ListTile(
                leading: const Icon(Icons.visibility, color: Colors.white),
                title: Text(
                  'View Details',
                  style: getTextStyle("mediumBold", color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context); // Close Bottom Sheet
                  _showTeacherDetailsDialog(context, teacher);
                },
              ),

              // Change Status Option
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: Text(
                  'Change Status',
                  style: getTextStyle("mediumBold", color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context); // Close Bottom Sheet
                  _showStatusChangeDialog(context, teacher);
                },
              ),

              // Delete Teacher Option
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.white),
                title: Text(
                  'Delete Teacher',
                  style: getTextStyle("mediumBold", color: Colors.white),
                ),
                onTap: () {
                  Navigator.pop(context); // Close Bottom Sheet
                  _deleteTeacher(teacher);
                },
              ),
            ],
          ),
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
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: const Color.fromARGB(255, 0, 36, 39),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              title: Text(
                "Change Verification Status",
                style: getTextStyle("mediumBold", color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select a new status:",
                    style: getTextStyle("small", color: Colors.white70),
                  ),
                  addVerticalSpace(10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: const Color.fromARGB(255, 0, 36, 39),
                        value: selectedStatus,
                        isExpanded: true,
                        style: getTextStyle("small", color: Colors.white),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              selectedStatus = newValue;
                            });
                          }
                        },
                        items: statuses.map((status) {
                          return DropdownMenuItem<String>(
                            value: status,
                            child: Text(
                              status.toUpperCase(),
                              style: getTextStyle("smallBold",
                                  color: AppColors.lightTeal),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text(
                    'Cancel',
                    style:
                        getTextStyle("smallBold", color: AppColors.lightTeal),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text(
                    'Confirm',
                    style:
                        getTextStyle("smallBold", color: AppColors.lightTeal),
                  ),
                  onPressed: () {
                    setState(() {
                      teacher.verificationStatus = selectedStatus;
                    });
                    Navigator.of(context).pop();

                    // Show SnackBar notification
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Status changed to ${selectedStatus.toUpperCase()}',
                          style: getTextStyle('small', color: AppColors.white),
                        ),
                        duration: const Duration(seconds: 3),
                        backgroundColor: AppColors.teal,
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showTeacherDetailsDialog(BuildContext context, Teacher teacher) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Reduced radius
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Added padding for spacing
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min, // Ensures dialog wraps content
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(Assets.image('educator_icon_teal.png'),
                          width: 24, height: 24),
                      const SizedBox(width: 8),
                      Text(
                        '${teacher.firstName} ${teacher.lastName}',
                        style:
                            getTextStyle('mediumBold', color: AppColors.teal),
                      ),
                    ],
                  ),
                  addVerticalSpace(10),

                  // Contact Details
                  _buildDetailRow(Icons.email, 'Email', teacher.email),
                  _buildDetailRow(Icons.phone, 'Phone',
                      '${teacher.phoneCode} ${teacher.mobileNumber}'),
                  _buildDetailRow(
                      Icons.public, 'Nationality', teacher.nationality),
                  _buildDetailRow(
                      Icons.school, 'Education', teacher.highestEducationLevel),
                  _buildDetailRow(Icons.work, 'Experience',
                      '${teacher.teachingExperience} years'),
                  _buildDetailRow(Icons.calendar_today, 'Availability',
                      teacher.availabilitySchedule),
                  _buildDetailRow(
                      Icons.location_on, 'Travel', teacher.willingnessToTravel),

                  addVerticalSpace(16),

                  // Areas of Expertise
                  _buildSectionHeader(Icons.book, 'Areas of Expertise'),
                  buildChips(teacher.areasOfExpertise),

                  addVerticalSpace(10),

                  // Certifications
                  _buildSectionHeader(Icons.badge, 'Certifications'),
                  buildChips(teacher.certifications),

                  addVerticalSpace(10),

                  // Teaching Camps
                  _buildSectionHeader(Icons.cottage, 'Teaching Camps'),
                  buildChips(teacher.teachingCamps),

                  addVerticalSpace(10),

                  // Close Button
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Close",
                        style: getTextStyle('small', color: AppColors.teal),
                      ),
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

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey, size: 20),
          const SizedBox(width: 8),
          Text('$label: ',
              style: getTextStyle('smallBold', color: Colors.teal)),
          Expanded(
            child:
                Text(value, style: getTextStyle('small', color: Colors.grey)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.teal, size: 20),
        const SizedBox(width: 8),
        Text(title, style: getTextStyle('smallBold', color: AppColors.teal)),
      ],
    );
  }

  void _deleteTeacher(Teacher teacher) async {
    bool confirmed = await _showDeleteConfirmationDialog(context, teacher);
    if (!confirmed) return;

    // ref
    //     .read(teacherProviderNotifier.notifier)
    //     .removeTeachingCampFromTeacher(teacherId: teacher.id!, campId: widget.campId);
    // await ref.read(campProviderNotifier.notifier).removeCampsClass(
    //     targetTeacherId: teacher.id!, campId: widget.campId);

    // setState(() {
    //   teachers.remove(teacher);
    // });

    // Show deletion confirmation
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${teacher.firstName} has been removed')),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(
      BuildContext context, Teacher teacher) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return ConfirmationDialog(
              type: 'Remove',
              title: 'Remove ${teacher.firstName} ${teacher.lastName}?',
              content: 'Are you sure you want to remove this teacher?',
              onConfirm: () {
                Navigator.pop(context, true);
              },
            );
          },
        ) ??
        false;
  }

  Widget buildChips(List<String>? items) {
    return Wrap(
      children: (items ?? []).map((item) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(0, 4, 8, 4),
          child: Chip(
            backgroundColor: AppColors.lightTeal,
            label: Text(
              item,
              style: getTextStyle('xsmall', color: Colors.white),
            ),
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: Colors.white),
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
