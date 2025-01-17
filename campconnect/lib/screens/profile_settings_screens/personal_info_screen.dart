import 'package:campconnect/models/student.dart';
import 'package:campconnect/models/user.dart';
import 'package:campconnect/providers/json_provider.dart';
import 'package:campconnect/providers/show_bot_nav_provider.dart';
import 'package:campconnect/theme/frosted_glass.dart';
import 'package:campconnect/theme/styling_constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:campconnect/widgets/details_row.dart';
import 'package:campconnect/widgets/edit_screen_fields.dart';
import 'package:campconnect/widgets/filter_dropdown.dart';
import 'package:campconnect/widgets/section_title_with_icon.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PersonalInfoScreen extends ConsumerStatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  ConsumerState<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends ConsumerState<PersonalInfoScreen> {
  bool isEditing = false;
  String? selectedLanguage;
  String? userPhoneCode;
  String? selectedCountry;
  String? guardianPhoneCode;
  User?
      user; //Testing for now, later we will get user that is logged in thru provider.

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController primaryLangController = TextEditingController();
  final TextEditingController specialNeedsController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController guardianMobileController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    //Dummy value
    user = Student(
      firstName: 'Ahmad',
      lastName: 'John',
      dateOfBirth: DateTime(2004, 11, 9),
      nationality: 'Iraq',
      primaryLanguages: ['Arabic', 'English'],
      countryCode: 'QA',
      mobileNumber: '3033067',
      email: 'enter@gmail.com',
      currentEducationLevel: 'High School',
      currentLocation: '',
      enrolledCamps: [],
      guardianContact: '44450699',
      guardianCountryCode: 'IN',
      preferredDistanceForCamps: '',
      preferredSubjects: [],
      learningGoals:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
      specialNeeds: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
    );
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        String dateOfBirth =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
        user!.dateOfBirth = DateTime.parse(dateOfBirth);
      });
    }
  }

  void phonePicker(BuildContext context) {
    showCountryPicker(
      exclude: <String>['IL'],
      useSafeArea: true,
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          userPhoneCode = '${country.flagEmoji} +${country.phoneCode}';
        });
      },
      countryListTheme: CountryListThemeData(
        bottomSheetHeight: screenHeight(context) * .7,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search Phone Code',
          labelStyle: getTextStyle('medium', color: AppColors.darkBeige),
          prefixIcon: const Icon(
            Icons.search,
            color: AppColors.darkBlue,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.darkBlue,
            ),
          ),
        ),
        searchTextStyle: TextStyle(
          color: AppColors.darkBlue,
          fontSize: 18,
        ),
      ),
    );
  }

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
            child: Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      width: 75,
                      height: 75,
                      decoration: const BoxDecoration(
                        color: AppColors.darkTeal,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.person_2_rounded,
                        color: Colors.white,
                        size: 50,
                      ),
                    ),
                  ),
                  //Dummy
                  Text(
                    'Hello, ${user?.firstName} ${user?.lastName}',
                    style: getTextStyle('largeBold', color: AppColors.teal),
                  ),
                  SizedBox(
                    height: 10,
                  ),
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
                          primaryLangController,
                          specialNeedsController,
                        ],
                        selectDate: selectDate,
                        selectedLanguage: selectedLanguage ?? 'Arabic', // Dummy
                        onLanguageSelected: (newLanguage) {
                          setState(() {
                            selectedLanguage = newLanguage;
                          });
                        },
                        selectedCountry:
                            selectedCountry ?? user!.nationality, //Dummy
                        onCountrySelected: (newCountry) {
                          setState(() {
                            selectedCountry = newCountry;
                          });
                        },
                        user: user!,
                      ),
                    ),
                  ),
                  if (user?.role == 'student') buildSpecialNeedSection(),
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
                        selectPhoneCode: phonePicker,
                        user: user,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSpecialNeedSection() {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        FrostedGlassBox(
          boxWidth: double.infinity,
          isCurved: true,
          boxChild: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SpecialNeedsSection(
              isEditing: isEditing,
              controller: specialNeedsController,
              user: user as Student,
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class NameSection extends ConsumerWidget {
  final bool isEditing;
  final List<TextEditingController> controllers;
  final String selectedLanguage;
  final String selectedCountry;
  final Function(BuildContext) selectDate;
  final Function(String) onLanguageSelected;
  final Function(String) onCountrySelected;
  final User user;

  const NameSection({
    super.key,
    required this.isEditing,
    required this.controllers,
    required this.selectDate,
    required this.onCountrySelected,
    required this.selectedLanguage,
    required this.onLanguageSelected,
    required this.selectedCountry,
    required this.user,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                value: user.firstName,
                controller: isEditing ? controllers[0] : null,
              ),
              DetailsRow(
                label: "Last Name",
                value: user.lastName,
                controller: isEditing ? controllers[1] : null,
              ),
              isEditing
                  ? buildNationalityPicker(context, ref)
                  : DetailsRow(
                      label: "Nationality",
                      value: user.nationality,
                    ),
              isEditing
                  ? buildDatePicker(context)
                  : DetailsRow(
                      label: "Date of Birth",
                      value: user.dateOfBirth.toString().substring(0, 10)),
              isEditing
                  ? buildLanguagePicker(context, ref)
                  : DetailsRow(
                      label: "First Language",
                      value: selectedLanguage,
                      divider: false,
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildLanguagePicker(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 48,
        width: screenWidth(context) * .8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "First Language",
              style: getTextStyle('smallBold', color: AppColors.darkBlue),
            ),
            ref.watch(languagesProvider).when(
                  data: (data) {
                    return FilterDropdown(
                      selectedFilter: selectedLanguage,
                      options: data,
                      onSelected: (String? newLanguage) {
                        if (newLanguage != null) {
                          onLanguageSelected(newLanguage);
                        }
                      },
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (err, stack) => Text('Error: $err'),
                ),
          ],
        ),
      ),
    );
  }

  Widget buildNationalityPicker(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.darkBlue, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 48,
        width: screenWidth(context) * .8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Nationality",
              style: getTextStyle('smallBold', color: AppColors.darkBlue),
            ),
            ref.watch(countryProvider).when(
                  data: (data) {
                    return FilterDropdown(
                      selectedFilter: selectedCountry,
                      options: data,
                      onSelected: (String? newCountry) {
                        if (newCountry != null) {
                          onLanguageSelected(newCountry);
                        }
                      },
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (err, stack) => Text('Error: $err'),
                ),
          ],
        ),
      ),
    );
  }

  Widget buildDatePicker(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.darkBlue, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 48,
        width: screenWidth(context) * .8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Date Of Birth",
              style: getTextStyle('smallBold', color: AppColors.darkBlue),
            ),
            GestureDetector(
              onTap: () => selectDate(context),
              child: Container(
                height: 40,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppColors.darkBlue,
                    width: 2.0,
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                alignment: Alignment.centerLeft,
                child: Text(
                  user.dateOfBirth.toString().substring(0, 10),
                  style: getTextStyle('small', color: AppColors.darkBlue),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SpecialNeedsSection extends StatelessWidget {
  final bool isEditing;
  final TextEditingController controller;
  final Student user;

  const SpecialNeedsSection({
    super.key,
    required this.isEditing,
    required this.controller,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return DetailsSection(
      title: "Special Needs",
      icon: Icons.wheelchair_pickup,
      children: [
        if (isEditing)
          EditScreenTextField(
            label: 'Special Needs',
            controller: controller,
            width: MediaQuery.of(context).size.width,
          ),
        if (!isEditing) Text(user.specialNeeds),
      ],
    );
  }
}

class ContactSection extends StatelessWidget {
  final bool isEditing;
  final List<TextEditingController> controllers;
  final Function(BuildContext) selectPhoneCode;
  final dynamic user;

  const ContactSection({
    super.key,
    required this.isEditing,
    required this.controllers,
    required this.selectPhoneCode,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SectionTitleWithIcon(
          icon: Icons.call,
          title: 'Contact Information',
          child: Column(
            children: [
              DetailsRow(
                label: "Email",
                value: user.email,
                controller: isEditing ? controllers[0] : null,
                keyboardType: TextInputType.emailAddress,
              ),
              isEditing
                  ? buildMobileSection(
                      context: context,
                      divider: user.role == 'student' ? false : true,
                      controller: controllers[1],
                      phoneCode: user.countryCode)
                  : DetailsRow(
                      label: "Mobile",
                      value: '${user.countryCode} ${user.mobileNumber}', //Dummy
                      divider: /*(user.role == 'Student')*/ false,
                    ),
              // if (user.role == 'Student')
              // DetailsRow(
              //   label: "Guardian No.",
              //   value: '30224077',
              //   controller: isEditing ? controllers[2] : null,
              //   keyboardType: TextInputType.phone,
              //   divider: false,
              // )
            ],
          ),
        )
      ],
    );
  }

  Widget buildMobileSection(
      {required BuildContext context,
      required bool divider,
      required TextEditingController controller,
      required String phoneCode}) {
    return Container(
      decoration: divider
          ? const BoxDecoration(
              border: Border(
              bottom: BorderSide(color: AppColors.darkBlue, width: 1),
            ))
          : null,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: SizedBox(
        height: 48,
        width: screenWidth(context) * .8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Mobile",
              style: getTextStyle('smallBold', color: AppColors.darkBlue),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () => selectPhoneCode(context),
                  child: Container(
                    height: 40,
                    width: 85,
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: AppColors.darkBlue,
                        width: 2.0,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      phoneCode,
                      style: getTextStyle('small', color: AppColors.darkBlue),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                EditScreenTextField(
                  label: "~30334066~", //dummy
                  controller: controller,
                  type: TextInputType.phone,
                  width: 150,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DetailsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const DetailsSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SectionTitleWithIcon(
        icon: icon,
        title: title,
        child: Column(
          children: children,
        ),
      ),
    );
  }
}
