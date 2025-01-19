import 'package:campconnect/theme/constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../routes/app_router.dart';

class RoleScreen extends ConsumerStatefulWidget {
  const RoleScreen({super.key});

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
                  Flexible(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          width: screenWidth(context) - 48,
                          child: Text(
                            "Tell us who you are",
                            style:
                                getTextStyle('xlargeBold', color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
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
                  StudentButton(),
                  addVerticalSpace(20),
                  EducatorButton(),
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
  const StudentButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton(
          onPressed: () => context.pushNamed(AppRouter.studentOnboarding.name),
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
  const EducatorButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton(
          onPressed: () => context.pushNamed(AppRouter.educatorOnboarding.name),
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
