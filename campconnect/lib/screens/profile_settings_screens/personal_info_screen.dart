import 'package:campconnect/providers/show_bot_nav_provider.dart';
import 'package:campconnect/theme/frosted_glass.dart';
import 'package:campconnect/widgets/details_row.dart';
import 'package:campconnect/widgets/section_title_with_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalInfoScreen extends ConsumerStatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  ConsumerState<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends ConsumerState<PersonalInfoScreen> {
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
                  "Editing Personal Details",
                )
              : Text(
                  "Personal Details",
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
                    child: NameSection(
                      isEditing: isEditing,
                      controllers: [
                        firstNameController,
                        lastNameController,
                        nationalityController,
                        dobController,
                        primaryLangController,
                        specialNeedsController,
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                FrostedGlassBox(
                  boxWidth: double.infinity,
                  isCurved: true,
                  boxChild: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ContactSection(
                      isEditing: isEditing,
                      controllers: [
                        emailController,
                        mobileController,
                        guardianMobileController,
                      ],
                    ),
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

class NameSection extends StatelessWidget {
  final bool isEditing;
  final List<TextEditingController> controllers;
  // final User user;

  const NameSection({
    super.key,
    required this.isEditing,
    required this.controllers,
    // required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SectionTitleWithIcon(
          icon: Icons.person,
          title: 'Personal Information',
          child: Column(
            children: [
              DetailsRow(
                label: "First Name",
                value: 'Amr',
                controller: isEditing ? controllers[0] : null,
              ),
              DetailsRow(
                label: "Last Name",
                value: 'Ahad',
                controller: isEditing ? controllers[1] : null,
              ),
              DetailsRow(
                label: "Nationality",
                value: 'Iraq',
                controller: isEditing ? controllers[2] : null,
              ),
              DetailsRow(
                label: "Date of Birth",
                value: '11-09-2004',
                controller: isEditing ? controllers[3] : null,
              ),
              DetailsRow(
                label: "Language",
                value: 'Arabic',
                controller: isEditing ? controllers[4] : null,
                divider: /*(user.role == 'Student' || user.specialNeeds != '')*/
                    false,
              ),
              // if (user.role == 'Student' || user.specialNeeds != '')
              // DetailsRow(
              //   label: "Special Needs",
              //   value: '...',
              //   controller: isEditing ? controllers[5] : null,
              //   divider: false,
              // )
            ],
          ),
        )
      ],
    );
  }
}

class ContactSection extends StatelessWidget {
  final bool isEditing;
  final List<TextEditingController> controllers;
  // final User user;

  const ContactSection({
    super.key,
    required this.isEditing,
    required this.controllers,
    // required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SectionTitleWithIcon(
          icon: Icons.person,
          title: 'Contact Information',
          child: Column(
            children: [
              DetailsRow(
                label: "Email",
                value: 'enter@gmail.com',
                controller: isEditing ? controllers[0] : null,
              ),
              DetailsRow(
                label: "Mobile No.",
                value: '30334066',
                controller: isEditing ? controllers[1] : null,
                divider: /*(user.role == 'Student')*/ false,
              ),
              // if (user.role == 'Student')
              // DetailsRow(
              //   label: "Guardian No.",
              //   value: '30224077',
              //   controller: isEditing ? controllers[2] : null,
              //   divider: false,
              // )
            ],
          ),
        )
      ],
    );
  }
}
