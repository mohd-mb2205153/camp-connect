import 'package:campconnect/providers/json_provider.dart';
import 'package:campconnect/providers/show_bot_nav_provider.dart';
import 'package:campconnect/theme/frosted_glass.dart';
import 'package:campconnect/theme/styling_constants.dart';
import 'package:campconnect/widgets/details_row.dart';
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
  String? dateOfBirth;
  String? countryName;
  String? selectedLanguage;

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController primaryLangController = TextEditingController();
  final TextEditingController specialNeedsController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController guardianMobileController =
      TextEditingController();

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

  void selectNationality(BuildContext context) {
    showCountryPicker(
      exclude: <String>['IL'],
      useSafeArea: true,
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          countryName = '${country.flagEmoji} ${country.name}';
        });
      },
      countryListTheme: CountryListThemeData(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search Nationality',
          prefixIcon: const Icon(Icons.search),
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
    final languages = ref.watch(languagesProvider);
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
                  FrostedGlassBox(
                    boxWidth: double.infinity,
                    isCurved: true,
                    boxChild: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: languages.when(
                        data: (list) {
                          return NameSection(
                            isEditing: isEditing,
                            controllers: [
                              firstNameController,
                              lastNameController,
                              primaryLangController,
                              specialNeedsController,
                            ],
                            dateOfBirth: dateOfBirth, //Dummy
                            countryName: countryName, //Dummy
                            selectDate: selectDate,
                            selectNationality: selectNationality,
                            selectedLanguage:
                                selectedLanguage ?? 'Arabic', // Dummy
                            languages: list,
                            onLanguageSelected: (newLanguage) {
                              setState(() {
                                selectedLanguage = newLanguage;
                              });
                            },
                          );
                        },
                        error: (err, stack) => Text('Error: $err'),
                        loading: () => const CircularProgressIndicator(),
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
      ),
    );
  }
}

class NameSection extends StatelessWidget {
  final bool isEditing;
  final List<TextEditingController> controllers;
  //The two below will not be used once user authentication is used.
  final String? dateOfBirth;
  final String? countryName;
  // -----
  final String selectedLanguage;
  final List<String> languages;
  final Function(BuildContext) selectDate;
  final Function(BuildContext) selectNationality;
  final Function(String) onLanguageSelected;
  // final User user;

  const NameSection({
    super.key,
    required this.isEditing,
    required this.controllers,
    required this.dateOfBirth,
    required this.selectDate,
    required this.countryName,
    required this.selectNationality,
    required this.selectedLanguage,
    required this.languages,
    required this.onLanguageSelected,
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
                value: 'Amr', //Dummy
                controller: isEditing ? controllers[0] : null,
              ),
              DetailsRow(
                label: "Last Name",
                value: 'Ahad', //Dummy
                controller: isEditing ? controllers[1] : null,
              ),
              isEditing
                  ? buildNationalityPicker(context)
                  : DetailsRow(
                      label: "Nationality",
                      value: countryName ?? 'Iraq', // Dummy values
                    ),
              isEditing
                  ? buildDatePicker(context)
                  : DetailsRow(
                      label: "Date of Birth",
                      value: dateOfBirth ?? '11-09-2004', //Dummy
                    ),
              isEditing
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: SizedBox(
                        height: 48,
                        width: MediaQuery.of(context).size.width * .8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "First Language",
                              style: getTextStyle('smallBold',
                                  color: AppColors.darkBlue),
                            ),
                            FilterDropdown(
                              selectedFilter: selectedLanguage,
                              options: languages,
                              onSelected: (String? newLanguage) {
                                if (newLanguage != null) {
                                  onLanguageSelected(newLanguage);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    )
                  : DetailsRow(
                      label: "First Language",
                      value: selectedLanguage,
                      divider: /*(user.role == 'Student')*/
                          false,
                    ),
              // if (user.role == 'Student' || user.specialNeeds != '')
              // DetailsRow(
              //   label: "Special Needs",
              //   value: '...',
              //   controller: isEditing ? controllers[2] : null,
              //   divider: false,
              // )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildNationalityPicker(BuildContext context) {
    return GestureDetector(
      onTap: () => selectNationality(context),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.darkBlue, width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          height: 48,
          width: MediaQuery.of(context).size.width * .8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Nationality",
                style: getTextStyle('smallBold', color: AppColors.darkBlue),
              ),
              Container(
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
                  countryName ?? 'Iraq', //For now dummy value
                  style: getTextStyle('small', color: AppColors.darkBlue),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDatePicker(BuildContext context) {
    return GestureDetector(
      onTap: () => selectDate(context),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.darkBlue, width: 1),
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: SizedBox(
          height: 48,
          width: MediaQuery.of(context).size.width * .8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Date Of Birth",
                style: getTextStyle('smallBold', color: AppColors.darkBlue),
              ),
              Container(
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
                  dateOfBirth ?? '11-09-2004', //For now dummy value
                  style: getTextStyle('small', color: AppColors.darkBlue),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
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
          icon: Icons.call,
          title: 'Contact Information',
          child: Column(
            children: [
              DetailsRow(
                label: "Email",
                value: 'enter@gmail.com', //Dummy
                controller: isEditing ? controllers[0] : null,
                keyboardType: TextInputType.emailAddress,
              ),
              DetailsRow(
                label: "Mobile No.",
                value: '30334066', //Dummy
                controller: isEditing ? controllers[1] : null,
                keyboardType: TextInputType.phone,
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
}
