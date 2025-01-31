import 'package:campconnect/models/teacher.dart';
import 'package:campconnect/providers/teacher_provider.dart';
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
  List<Teacher> statusList = [];

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
          buildBackground("bg10"),
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
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              onTap: (index) => setState(() {}),
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

  Widget _buildTeacherList(String status) {
    return Consumer(
      builder: (context, ref, child) {
        return FutureBuilder(
          future: ref
              .read(teacherProviderNotifier.notifier)
              .getTeachersByStatus(status),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const EmptyScreen();
            }
            statusList = List<Teacher>.from(snapshot.data!);
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: statusList.length,
              itemBuilder: (context, index) {
                return _buildTeacherCard(statusList[index]);
              },
            );
          },
        );
      },
    );
  }

  Widget _buildTeacherCard(Teacher teacher) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0),
      child: Card(
        color: AppColors.darkTeal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Row(
                children: [
                  Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      color: _getStatusColor(teacher.verificationStatus),
                      shape: BoxShape.circle,
                    ),
                  ),
                  addHorizontalSpace(20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${teacher.firstName} ${teacher.lastName}',
                          style:
                              getTextStyle('mediumBold', color: Colors.white),
                        ),
                        addVerticalSpace(6),
                        Text(
                            'Contact: ${teacher.phoneCode} ${teacher.mobileNumber}',
                            style: getTextStyle('small', color: Colors.white)),
                        addVerticalSpace(4),
                        Text('Email: ${teacher.email}',
                            style: getTextStyle('small', color: Colors.white)),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 6,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    _showTeacherOptionsBottomSheet(context, teacher);
                  },
                  child: const Icon(Icons.more_horiz, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTeacherOptionsBottomSheet(BuildContext context, Teacher teacher) {
    showModalBottomSheet(
      backgroundColor: AppColors.darkTeal,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.visibility, color: Colors.white),
                title: Text('View Details',
                    style: getTextStyle("mediumBold", color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _showTeacherDetailsDialog(context, teacher);
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.white),
                title: Text('Change Status',
                    style: getTextStyle("mediumBold", color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
                  _showStatusChangeDialog(context, teacher);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.white),
                title: Text('Delete Teacher',
                    style: getTextStyle("mediumBold", color: Colors.white)),
                onTap: () {
                  Navigator.pop(context);
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
          builder: (context, setModalState) {
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
                            setModalState(() {
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
                  onPressed: () async {
                    teacher =
                        teacher.copyWith(verificationStatus: selectedStatus);
                    ref
                        .read(teacherProviderNotifier.notifier)
                        .updateTeacher(teacher);
                    setState(() {
                      statusList.remove(teacher);
                    });
                    Navigator.of(context).pop();

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

  void _deleteTeacher(Teacher teacher) async {
    ref.read(teacherProviderNotifier.notifier).deleteTeacher(teacher);
    setState(() {
      statusList.remove(teacher);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${teacher.firstName} has been removed')),
    );
  }

  void _showTeacherDetailsDialog(BuildContext context, Teacher teacher) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  _buildSectionHeader(Icons.book, 'Areas of Expertise'),
                  buildChips(teacher.areasOfExpertise),
                  addVerticalSpace(10),
                  _buildSectionHeader(Icons.badge, 'Certifications'),
                  buildChips(teacher.certifications),
                  addVerticalSpace(10),
                  _buildSectionHeader(Icons.cottage, 'Teaching Camps'),
                  buildChips(teacher.teachingCamps),
                  addVerticalSpace(10),
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
}
