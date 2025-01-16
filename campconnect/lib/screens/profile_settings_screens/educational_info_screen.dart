import 'package:campconnect/providers/show_bot_nav_provider.dart';
import 'package:campconnect/theme/frosted_glass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EducationalInfoScreen extends ConsumerStatefulWidget {
  const EducationalInfoScreen({super.key});

  @override
  ConsumerState<EducationalInfoScreen> createState() => _EducationalInfoState();
}

class _EducationalInfoState extends ConsumerState<EducationalInfoScreen> {
  bool isEditing = false;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController primaryLangController = TextEditingController();
  final TextEditingController specialNeedsController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController guardianMobileController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          ref.read(showBotNavNotifierProvider.notifier).showBottomNavBar(true);
          Navigator.of(context).pop(result);
        }
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 5,
          title: isEditing
              ? Text(
                  "Editing Educational Info",
                )
              : Text(
                  "Educational Information",
                ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              ref
                  .read(showBotNavNotifierProvider.notifier)
                  .showBottomNavBar(true);
              Navigator.of(context).pop();
            },
          ),
          actions: [
            IconButton(
              icon: Icon(isEditing ? Icons.done : Icons.edit),
              onPressed: () {
                setState(() {
                  isEditing = !isEditing;
                  if (isEditing) {
                    // initializeControllers(customer);
                  }
                });
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                FrostedGlassBox(
                  boxWidth: double.infinity,
                  isCurved: true,
                  boxChild: Padding(
                    padding: const EdgeInsets.all(16.0),
                    // child: NameSection(
                    //   isEditing: isEditing,
                    //   controllers: [
                    //     firstNameController,
                    //     lastNameController,
                    //     nationalityController,
                    //     dobController,
                    //     primaryLangController,
                    //     specialNeedsController,
                    //   ],
                    // ),
                  ),
                ),
                const SizedBox(height: 20),
                FrostedGlassBox(
                  boxWidth: double.infinity,
                  isCurved: true,
                  boxChild: Padding(
                    padding: const EdgeInsets.all(16.0),
                    // child: ContactSection(
                    //   isEditing: isEditing,
                    //   controllers: [
                    //     emailController,
                    //     mobileController,
                    //     guardianMobileController,
                    //   ],
                    // ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
