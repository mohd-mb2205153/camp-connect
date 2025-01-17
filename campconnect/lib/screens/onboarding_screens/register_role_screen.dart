import 'package:campconnect/theme/styling_constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
          // Background Image
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
                  StudentButton(
                    onStudentPressed: () =>
                        (), // context.pushReplacementNamed(AppRouter.home.name),
                  ),
                  addVerticalSpace(20),
                  EducatorButton(
                    onEducatorPressed: () =>
                        (), // context.pushReplacementNamed(AppRouter.home.name),
                  ),
                ],
              ),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              height: screenHeight(context) * 0.55,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 60),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class StudentButton extends StatelessWidget {
  final VoidCallback onStudentPressed;

  const StudentButton({super.key, required this.onStudentPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton(
          onPressed: onStudentPressed,
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
                height: 20, // Adjust the size of the icon as needed
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
  final VoidCallback onEducatorPressed;

  const EducatorButton({super.key, required this.onEducatorPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        width: double.infinity,
        height: 44,
        child: ElevatedButton(
          onPressed: onEducatorPressed,
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
