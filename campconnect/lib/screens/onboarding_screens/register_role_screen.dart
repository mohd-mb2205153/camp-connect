import 'package:campconnect/models/student.dart';
import 'package:campconnect/theme/constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/teacher.dart';
import '../../models/user.dart';
import '../../routes/app_router.dart';

class RoleScreen extends ConsumerStatefulWidget {
  final User user;

  const RoleScreen({super.key, required this.user});

  @override
  ConsumerState<RoleScreen> createState() => _RoleScreenState();
}

class _RoleScreenState extends ConsumerState<RoleScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              Assets.image('bg7.png'),
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 220),
              child: Column(
                children: [
                  SizedBox(
                    width: screenWidth(context) - 48,
                    child: Column(
                      children: [
                        Text(
                          "Welcome, ${widget.user.firstName}",
                          style: getTextStyle('largeBold', color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        addVerticalSpace(8),
                        Text(
                          "Tell us more about you.",
                          style:
                              getTextStyle('xlargeBold', color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  addVerticalSpace(16),
                  Text(
                    textAlign: TextAlign.center,
                    wrapText(
                        "Please choose your role below to get started", 24),
                    style: getTextStyle('medium', color: Colors.white),
                  ),
                  addVerticalSpace(96),
                  StudentButton(user: widget.user),
                  addVerticalSpace(20),
                  EducatorButton(user: widget.user),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StudentButton extends StatelessWidget {
  final User user;

  const StudentButton({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton(
          onPressed: () {
            final student = Student(
              id: user.id,
              firstName: user.firstName,
              lastName: user.lastName,
              dateOfBirth: user.dateOfBirth,
              nationality: user.nationality,
              primaryLanguages: user.primaryLanguages,
              phoneCode: user.phoneCode,
              mobileNumber: user.mobileNumber,
              email: user.email,
              currentEducationLevel: '',
              guardianContact: '',
              guardianPhoneCode: '',
              preferredDistanceForCamps: '',
              preferredSubjects: [],
            );

            debugPrint(student.toString());

            context.pushNamed(
              AppRouter.studentOnboarding.name,
              extra: student,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Assets.image('student_icon_teal.png'),
                height: 20,
              ),
              addHorizontalSpace(16),
              Text(
                "I am a Student",
                style: getTextStyle('mediumBold', color: AppColors.lightTeal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EducatorButton extends StatelessWidget {
  final User user;

  const EducatorButton({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton(
          onPressed: () {
            final teacher = Teacher(
              id: user.id,
              firstName: user.firstName,
              lastName: user.lastName,
              dateOfBirth: user.dateOfBirth,
              nationality: user.nationality,
              primaryLanguages: user.primaryLanguages,
              phoneCode: user.phoneCode,
              mobileNumber: user.mobileNumber,
              email: user.email,
              highestEducationLevel: '',
              teachingExperience: 0,
              areasOfExpertise: [],
              willingnessToTravel: '',
              availabilitySchedule: '',
              preferredCampDuration: '',
            );

            debugPrint(teacher.toString());

            context.pushNamed(
              AppRouter.educatorOnboarding.name,
              extra: teacher,
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: 0,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                Assets.image('educator_icon_teal.png'),
                height: 20,
              ),
              addHorizontalSpace(16),
              Text(
                "I am an Educator",
                style: getTextStyle('mediumBold', color: AppColors.lightTeal),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
