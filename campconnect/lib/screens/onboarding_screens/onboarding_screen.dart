import 'package:campconnect/routes/app_router.dart';
import 'package:campconnect/theme/styling_constants.dart';
import 'package:campconnect/utils/helper_widgets.dart'; // For Assets and screenWidth helper
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              Assets.image('bg1.png'),
              fit: BoxFit.cover,
            ),
          ),
          // Top-Left Logo
          Positioned(
            top: 40,
            left: 24,
            child: SizedBox(
              width: 108,
              child: Image.asset(
                Assets.image('campconnect_whitetextlogo_1500px.png'),
              ),
            ),
          ),
          // Lower Half Container
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: double.infinity,
              height: screenHeight(context) * 0.38, // occupies lower half
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12, left: 24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Education everywhere.",
                                style: getTextStyle('largeBold',
                                    color: Colors.white),
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                        addVerticalSpace(8),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                wrapText(
                                    "We empower safe spaces for learning, growth, and brighter futures, even in challenging times.",
                                    37),
                                style:
                                    getTextStyle('small', color: Colors.white),
                                overflow: TextOverflow.visible,
                                softWrap: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 60),
                    child: Column(
                      children: [
                        LoginButton(
                            onLoginPressed: () => context
                                .pushReplacementNamed(AppRouter.login.name)),
                        addVerticalSpace(20),
                        RegisterButton(
                            onRegisterPressed: () => context
                                .pushReplacementNamed(AppRouter.register.name)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginButton extends StatelessWidget {
  final VoidCallback onLoginPressed;

  const LoginButton({super.key, required this.onLoginPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: onLoginPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: Text(
          "Sign in",
          style: getTextStyle('mediumBold', color: AppColors.lightTeal),
        ),
      ),
    );
  }
}

class RegisterButton extends StatelessWidget {
  final VoidCallback onRegisterPressed;

  const RegisterButton({super.key, required this.onRegisterPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: onRegisterPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lightTeal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: const BorderSide(color: Colors.white, width: 1),
          ),
          elevation: 0,
        ),
        child: Text(
          "Sign up",
          style: getTextStyle('mediumBold', color: Colors.white),
        ),
      ),
    );
  }
}
