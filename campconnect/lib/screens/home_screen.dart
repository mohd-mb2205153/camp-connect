import 'package:campconnect/providers/camp_provider.dart';
import 'package:campconnect/providers/class_provider.dart';
import 'package:campconnect/providers/show_nav_bar_provider.dart';
import 'package:campconnect/providers/student_provider.dart';
import 'package:campconnect/providers/teacher_provider.dart';
import 'package:campconnect/routes/app_router.dart';
import 'package:campconnect/theme/constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providers/loggedinuser_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool isStudent = false;
  bool isTeacher = false;
  dynamic loggedUser;
  int? campCount;

  @override
  void initState() {
    super.initState();
    initializeUserDetails();
    initializeAllProviders();
  }

  void initializeAllProviders() {
    ref.read(teacherProviderNotifier);
    ref.read(studentProviderNotifier);
    ref.read(campProviderNotifier);
    ref.read(classProviderNotifier);
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

      campCount = isStudent
          ? (loggedUser?.savedCamps.length ?? 0)
          : (loggedUser?.teachingCamps.length ?? 0);

      ref.read(showNavBarNotifierProvider.notifier).showBottomNavBar(true);

      setState(() {});
    });
  }

  Future<void> _launchURL() async {
    final Uri uri = Uri.parse(
      "https://www.unicef.org/drcongo/en/stories/temporary-learning-spaces-give-displaced-children-chance-learn",
    );
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $uri';
    }
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
                            "Hello there, ${loggedUser?.firstName ?? "Guest"}",
                            style:
                                getTextStyle("largeBold", color: Colors.white),
                          ),
                          addVerticalSpace(8),
                          Text(
                            "Ready to connect and ${isStudent ? "learn" : "teach"} today?",
                            style: getTextStyle("small", color: Colors.white),
                          ),
                        ],
                      ),
                      addVerticalSpace(66),
                      SizedBox(
                        height: 420,
                        child: Column(
                          children: [
                            buildHomeCard(),
                            addVerticalSpace(12),
                            buildHomeButtons(context),
                            addVerticalSpace(12),
                            buildLatestNotices(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildHomeButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        viewCampButton(),
        addHorizontalSpace(12),
        rightCampButton(context),
      ],
    );
  }

  Expanded viewCampButton() {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: () {
          ref.read(showNavBarNotifierProvider.notifier).showBottomNavBar(false);
          if (isStudent) {
            context
                .pushNamed(AppRouter.viewSavedCamps.name, extra: loggedUser.id)
                .then((_) => setState(() {
                      initializeUserDetails();
                    }));
          } else if (isTeacher) {
            context
                .pushNamed(AppRouter.viewTeachingCamps.name,
                    extra: loggedUser.id)
                .then((_) => setState(() {
                      initializeUserDetails();
                    }));
          }
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: Image.asset(
          'assets/images/tent_icon_white.png',
          width: 20,
          height: 20,
          color: Colors.white,
        ),
        label: Text(
          'View Camps',
          style: getTextStyle("small", color: Colors.white),
        ),
      ),
    );
  }

  Expanded rightCampButton(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: () {
          isTeacher
              ? ref
                  .read(showNavBarNotifierProvider.notifier)
                  .showBottomNavBar(false)
              : ref
                  .read(showNavBarNotifierProvider.notifier)
                  .setActiveBottomNavBar(1);
          isStudent
              ? context.replaceNamed(AppRouter.map.name)
              : context.goNamed(AppRouter.addCampLocation.name);
        },
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        icon: Icon(
          isStudent ? Icons.bookmark : Icons.add,
          size: 20,
          color: Colors.white,
        ),
        label: Text(
          isStudent ? "Save a Camp" : "Create Camp",
          style: getTextStyle("small", color: Colors.white),
        ),
      ),
    );
  }

  GestureDetector buildLatestNotices() {
    return GestureDetector(
      onTap: _launchURL,
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
                  Icon(
                    Icons.info,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Latest Notices",
                    style: getTextStyle("mediumBold", color: Colors.white),
                  ),
                ],
              ),
              addVerticalSpace(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 24, 0),
                    child: Image.asset(
                      'assets/images/unicef-logo-white.png',
                      width: 48,
                      height: 48,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: getTextStyle("small", color: Colors.white),
                        children: [
                          const TextSpan(
                            text:
                                "UNICEF is offering relief goods and books donations to educational camps for teachers and students.\n\n",
                          ),
                          TextSpan(
                            text: "Click here",
                            style:
                                getTextStyle("smallBold", color: Colors.white),
                          ),
                          const TextSpan(
                            text: " for more information.",
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

  Stack buildHomeCard() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: AssetImage("assets/images/home_card.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          left: 16,
          right: 16,
          top: 0,
          bottom: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                textAlign: TextAlign.left,
                wrapText(
                  "You ${isStudent ? "have saved" : "are teaching"}  $campCount camp${campCount == 1 ? "" : "s"}.",
                  17,
                ),
                style: getTextStyle("mediumBold", color: Colors.white),
              ),
              if (campCount == 0)
                Column(
                  children: [
                    addVerticalSpace(12),
                    Text(
                      textAlign: TextAlign.left,
                      "Get started today.",
                      style: getTextStyle("small", color: Colors.white),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
