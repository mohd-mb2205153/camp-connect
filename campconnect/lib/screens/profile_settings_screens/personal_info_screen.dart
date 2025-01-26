import 'package:campconnect/models/student.dart';
import 'package:campconnect/models/teacher.dart';
import 'package:campconnect/models/user.dart';
import 'package:campconnect/providers/json_provider.dart';
import 'package:campconnect/providers/loggedinuser_provider.dart';
import 'package:campconnect/providers/show_nav_bar_provider.dart';
import 'package:campconnect/providers/student_provider.dart';
import 'package:campconnect/providers/teacher_provider.dart';
import 'package:campconnect/theme/frosted_glass.dart';
import 'package:campconnect/theme/constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:campconnect/widgets/detail_section.dart';
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
  String? selectedCountry;
  String? dateOfBirth;
  String? userPhoneCode;
  String? guardianPhoneCode;
  List<String> selectedLanguages = [];

  dynamic user;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController specialNeedsController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController guardianMobileController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    user = ref.read(loggedInUserNotifierProvider);
    initializeControllers(user);
  }

  @override
  void dispose() {
    specialNeedsController.dispose();
    guardianMobileController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  void initializeControllers(user) {
    firstNameController.text = user.firstName;
    lastNameController.text = user.lastName;
    selectedCountry = user.nationality;
    dateOfBirth = user.dateOfBirth.toString().substring(0, 10);
    emailController.text = user.email;
    mobileController.text = user.mobileNumber;
    userPhoneCode = user.phoneCode;
    if (user is Student) {
      guardianPhoneCode = user.guardianPhoneCode;
      guardianMobileController.text = user.guardianContact;
      specialNeedsController.text = user.specialNeeds;
    }
    selectedLanguages = List.from(user.primaryLanguages);
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
        dateOfBirth =
            "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    }
  }

  void phonePicker(BuildContext context, bool isGuardian) {
    showCountryPicker(
      exclude: <String>['IL'],
      useSafeArea: true,
      context: context,
      showPhoneCode: true,
      onSelect: (Country country) {
        setState(() {
          if (!isGuardian) {
            userPhoneCode = '+${country.phoneCode}';
          } else {
            guardianPhoneCode = '+${country.phoneCode}';
          }
        });
      },
      countryListTheme: CountryListThemeData(
        bottomSheetHeight: screenHeight(context) * .7,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
      ),
      showSearch: false,
    );
  }

  void handleUpdate(User user) {
    user.firstName = firstNameController.text;
    user.lastName = lastNameController.text;
    user.nationality = selectedCountry!;
    user.dateOfBirth = DateTime.parse(dateOfBirth!);
    user.email = emailController.text;
    user.mobileNumber = mobileController.text;
    user.phoneCode = userPhoneCode!;
    user.primaryLanguages = List<String>.from(selectedLanguages);
    if (user is Student) {
      user.guardianPhoneCode = guardianPhoneCode!;
      user.guardianContact = guardianMobileController.text;
      user.specialNeeds = specialNeedsController.text;
      ref.read(studentProviderNotifier.notifier).updateStudent(user);
    } else if (user is Teacher) {
      ref.read(teacherProviderNotifier.notifier).updateTeacher(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          ref
              .read(loggedInUserNotifierProvider.notifier)
              .handleDiscardUpdate(isEditing: isEditing, context: context);
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
                  .read(loggedInUserNotifierProvider.notifier)
                  .handleDiscardUpdate(isEditing: isEditing, context: context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(isEditing ? Icons.done : Icons.edit),
              onPressed: () {
                setState(() {
                  if (isEditing) {
                    handleUpdate(user);
                    ScaffoldMessenger.of(context).showSnackBar(
                      customSnackbar(
                          message: "Personal Details Updated",
                          backgroundColor: AppColors.lightTeal,
                          icon: Icons.task_alt),
                    );
                  }
                  isEditing = !isEditing;
                  if (isEditing) {
                    initializeControllers(user);
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
                Text(
                  'Hello, ${user.firstName} ${user.lastName}',
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
                      ],
                      selectDate: selectDate,
                      selectedCountry: selectedCountry ?? user.nationality,
                      onCountrySelected: (newCountry) {
                        setState(() {
                          selectedCountry = newCountry;
                        });
                      },
                      user: user,
                      dateOfBirth: dateOfBirth ??
                          user.dateOfBirth.toString().substring(0, 10),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FrostedGlassBox(
                  boxWidth: double.infinity,
                  isCurved: true,
                  boxChild: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ref.watch(languagesProvider).when(
                          data: (languageOptions) {
                            return LanguagesSection(
                              isEditing: isEditing,
                              context: context,
                              user: user!,
                              builder: (_) {
                                return ListView.builder(
                                  itemCount: languageOptions.length,
                                  itemBuilder: (_, index) {
                                    return ListTile(
                                      title: Text(
                                        languageOptions[index],
                                        style: getTextStyle("small"),
                                      ),
                                      onTap: () {
                                        setState(() {
                                          if (!selectedLanguages.contains(
                                              languageOptions[index])) {
                                            selectedLanguages
                                                .add(languageOptions[index]);
                                          }
                                        });
                                        Navigator.pop(context);
                                      },
                                    );
                                  },
                                );
                              },
                              children: selectedLanguages
                                  .map(
                                    (language) => Chip(
                                      backgroundColor: AppColors.lightTeal,
                                      label: Text(
                                        language,
                                        style: getTextStyle('small',
                                            color: Colors.white),
                                      ),
                                      deleteIcon: const Icon(Icons.close,
                                          color: Colors.white),
                                      onDeleted: () {
                                        setState(() {
                                          selectedLanguages.remove(language);
                                        });
                                      },
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                          color: Colors.transparent,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (err, stack) => Text('Error: $err'),
                        ),
                  ),
                ),
                if (user?.role == 'student') buildSpecialNeedSection(),
                SizedBox(
                  height: 20,
                ),
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
                      phoneCode: userPhoneCode ?? user.phoneCode,
                      guardianPhoneCode: user is Student
                          ? (guardianPhoneCode ?? user.guardianPhoneCode)
                          : null,
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
      ],
    );
  }
}

class NameSection extends ConsumerWidget {
  final bool isEditing;
  final List<TextEditingController> controllers;
  final String selectedCountry;
  final Function(BuildContext) selectDate;
  final Function(String) onCountrySelected;
  final User user;
  final String dateOfBirth;

  const NameSection({
    super.key,
    required this.isEditing,
    required this.controllers,
    required this.selectDate,
    required this.onCountrySelected,
    required this.selectedCountry,
    required this.user,
    required this.dateOfBirth,
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
                      value: user.dateOfBirth.toString().substring(0, 10),
                      divider: false,
                    ),
            ],
          ),
        ),
      ],
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
                          onCountrySelected(newCountry);
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
                  dateOfBirth,
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
            height: 100,
            label: '~${user.specialNeeds}~',
            controller: controller,
            width: MediaQuery.of(context).size.width,
            type: TextInputType.multiline,
            maxLines: 2,
          ),
        if (!isEditing)
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              user.specialNeeds,
              style: getTextStyle(
                'small',
                color: AppColors.darkBlue,
              ),
            ),
          ),
      ],
    );
  }
}

class LanguagesSection extends StatelessWidget {
  final bool isEditing;
  final BuildContext context;
  final Widget Function(BuildContext) builder;
  final User user;
  final List<Widget> children;

  const LanguagesSection({
    super.key,
    required this.isEditing,
    required this.context,
    required this.builder,
    required this.children,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return DetailsSection(
      title: "Languages",
      icon: Icons.language,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Languages you can speak:',
            style: getTextStyle('small', color: AppColors.darkBlue),
          ),
        ),
        if (isEditing) buildLanguages(context),
        if (!isEditing)
          const Divider(
            color: AppColors.darkBlue,
            thickness: 2,
            height: 20,
          ),
        if (!isEditing)
          Column(
            children: [
              for (var language in user.primaryLanguages)
                buildLanguageContainer(language)
            ],
          ),
      ],
    );
  }

  Widget buildLanguageContainer(String language) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.lightTeal,
            borderRadius: BorderRadius.circular(15),
          ),
          height: 35,
          child: Center(
            child: Text(
              '   $language   ',
              style: getTextStyle('small', color: AppColors.white),
            ),
          ),
        ),
        SizedBox(
          height: 5,
        )
      ],
    );
  }

  Widget buildLanguages(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Add Language",
                  style: getTextStyle('medium', color: AppColors.beige),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(12),
                        ),
                      ),
                      builder: builder,
                    );
                  },
                ),
              ],
            ),
            const Divider(
              color: AppColors.lightTeal,
              thickness: 2,
            ),
          ],
        ),
        addVerticalSpace(8),
        Wrap(
          spacing: 8,
          children: children,
        ),
      ],
    );
  }
}

class ContactSection extends StatelessWidget {
  final bool isEditing;
  final List<TextEditingController> controllers;
  final Function(BuildContext, bool) selectPhoneCode;
  final dynamic user;
  final String phoneCode;
  final String? guardianPhoneCode;

  const ContactSection(
      {super.key,
      required this.isEditing,
      required this.controllers,
      required this.selectPhoneCode,
      required this.user,
      required this.phoneCode,
      required this.guardianPhoneCode});

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
                      divider: user.role == 'student' ? true : false,
                      controller: controllers[1],
                      phoneCode: phoneCode,
                      text: 'Mobile',
                      mobileNo: user.mobileNumber)
                  : DetailsRow(
                      label: "Mobile",
                      value: '${user.phoneCode} ${user.mobileNumber}',
                      divider: user.role == 'student' ? true : false,
                    ),
              if (user.role == 'student')
                isEditing
                    ? buildMobileSection(
                        context: context,
                        divider: false,
                        controller: controllers[2],
                        phoneCode: guardianPhoneCode!,
                        mobileNo: user.guardianContact,
                        text: 'Guardian No.')
                    : DetailsRow(
                        label: 'Guardian No.',
                        value:
                            '${user.guardianPhoneCode} ${user.guardianContact}',
                        divider: false,
                      ),
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
      required String phoneCode,
      required String text,
      required String mobileNo}) {
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
              text,
              style: getTextStyle('smallBold', color: AppColors.darkBlue),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () =>
                      selectPhoneCode(context, text == 'Mobile' ? false : true),
                  child: Container(
                    height: 40,
                    width: 60,
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
                  label: "~$mobileNo~",
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
