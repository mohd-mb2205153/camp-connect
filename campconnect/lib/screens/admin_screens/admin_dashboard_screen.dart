import 'package:campconnect/providers/camp_provider.dart';
import 'package:campconnect/providers/class_provider.dart';
import 'package:campconnect/providers/loggedinuser_provider.dart';
import 'package:campconnect/providers/teacher_provider.dart';
import 'package:campconnect/routes/app_router.dart';
import 'package:campconnect/services/auth_services.dart';
import 'package:campconnect/theme/constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() =>
      _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  dynamic adminUser;

  @override
  void initState() {
    super.initState();
    initializeAdminDetails();
    initializeAllProviders();
  }

  void initializeAllProviders() {
    ref.read(campProviderNotifier);
    ref.read(classProviderNotifier);
  }

  void initializeAdminDetails() {
    Future.microtask(() {
      final userNotifier = ref.read(loggedInUserNotifierProvider.notifier);
      adminUser = userNotifier.admin;
      setState(() {});
    });
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await AuthService().signout(context: context);
    ref.read(loggedInUserNotifierProvider.notifier).clearUser();
    context.go(AppRouter.onboarding.path);
  }

  Future<void> _launchNoticesURL() async {
    final Uri uri = Uri.parse(
      "https://www.unicef.org/drcongo/en/stories/temporary-learning-spaces-give-displaced-children-chance-learn",
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $uri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/campconnect_whitetextlogo_1500px.png',
              width: 120,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.power_settings_new, color: Colors.white),
            tooltip: 'Logout',
            onPressed: () => _logout(context, ref),
          ),
        ],
      ),
      body: SizedBox.expand(
        child: Stack(
          children: [
            buildBackground("bg12"),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 120),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hello ${adminUser?.firstName ?? "Guest"}",
                          style: getTextStyle("largeBold", color: Colors.white),
                        ),
                        addVerticalSpace(8),
                        Text(
                          "Here’s an overview of the platform",
                          style: getTextStyle("small", color: Colors.white),
                        ),
                      ],
                    ),
                    addVerticalSpace(40),
                    buildAdminDashboardCards(),
                    addVerticalSpace(20),
                    buildLatestNotices(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAdminDashboardCards() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildDashboardCard("Manage Users", Icons.group, () {
              // context.goNamed(AppRouter.manageUsers.name);
            }),
            buildDashboardCard("Manage Camps", Icons.house, () {
              // context.goNamed(AppRouter.manageCamps.name);
            }),
          ],
        ),
        addVerticalSpace(12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildDashboardCard("Reports", Icons.bar_chart, () {
              // context.goNamed(AppRouter.reports.name);
            }),
            buildDashboardCard("Settings", Icons.settings, () {
              // context.goNamed(AppRouter.settings.name);
            }),
          ],
        ),
      ],
    );
  }

  Widget buildDashboardCard(String title, IconData icon, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: AppColors.orange,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20, color: Colors.white),
              addHorizontalSpace(8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: getTextStyle("smallBold", color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector buildLatestNotices() {
    final teachers = ref.watch(teacherProviderNotifier).value ?? [];
    int pendingCount = teachers
        .where((teacher) => teacher.verificationStatus == 'pending')
        .length;

    return GestureDetector(
      onTap: _launchNoticesURL,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.teal,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.notifications_active,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Admin Notifications",
                    style: getTextStyle("mediumBold", color: Colors.white),
                  ),
                ],
              ),
              addVerticalSpace(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 16, 0),
                    child: Icon(Icons.warning_amber_rounded,
                        size: 36, color: Colors.white),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: getTextStyle("small", color: Colors.white),
                        children: [
                          TextSpan(
                            text: "🔧 Scheduled Maintenance:\n",
                            style:
                                getTextStyle("smallBold", color: Colors.white),
                          ),
                          const TextSpan(
                            text:
                                "The platform will undergo maintenance on Sunday from 12:00 AM - 3:00 AM.\n\n",
                          ),
                          TextSpan(
                            text: "📋 Pending Verifications:\n",
                            style:
                                getTextStyle("smallBold", color: Colors.white),
                          ),
                          TextSpan(
                            text:
                                "There are $pendingCount teacher verification requests pending approval.\n\n",
                          ),
                          TextSpan(
                            text: "📊 Platform Analytics:\n",
                            style:
                                getTextStyle("smallBold", color: Colors.white),
                          ),
                          const TextSpan(
                            text:
                                "Active users have increased by 18% this month. Check reports for more details.",
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              addVerticalSpace(4),
            ],
          ),
        ),
      ),
    );
  }
}
