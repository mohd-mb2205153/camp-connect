import 'package:campconnect/utils/helper_widgets.dart'; // For Assets and screenWidth helper
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Top Section
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              color: const Color.fromARGB(255, 247, 247, 247),
              child: Stack(
                children: [
                  // Top-left logo
                  Positioned(
                    top: 40,
                    left: 16,
                    child: SizedBox(
                      width: 120,
                      child: Image.asset(
                        Assets.image('campconnect_textlogo_1500px.png'),
                      ),
                    ),
                  ),
                  // Centered bottom logo
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: SizedBox(
                        width: screenWidth(context) * 0.6,
                        child: Image.asset(
                          Assets.image('campconnect_logo_1152px.png'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Section
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: Column(
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: BorderSide(
                                color: Theme.of(context).primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Sign In',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Create Account',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Circle Buttons Section
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Donate Button
                        IconButton(
                          onPressed: () {
                            // Navigate to Support Us page
                          },
                          icon: const Icon(Icons.volunteer_activism,
                              color: Colors.grey),
                          iconSize: 40,
                        ),
                        const SizedBox(width: 20),
                        // Info Button
                        IconButton(
                          onPressed: () {
                            // Navigate to About Us page
                          },
                          icon: const Icon(Icons.info_outline,
                              color: Colors.grey),
                          iconSize: 40,
                        ),
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
