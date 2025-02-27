import 'dart:convert';

import 'package:campconnect/models/user.dart';
import 'package:campconnect/routes/app_router.dart';
import 'package:campconnect/theme/constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  bool notVisible = true;
  bool isEmailValid = false;
  bool agreeToTerms = false;

  late TextEditingController txtFirstNameController;
  late TextEditingController txtLastNameController;
  late TextEditingController txtEmailController;
  late TextEditingController txtPasswordController;
  late TextEditingController txtPhoneNumberController;

  final FocusNode firstNameFocus = FocusNode();
  final FocusNode lastNameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  final FocusNode phoneFocus = FocusNode();

  String userPhoneCode = '';
  String selectedNationality = "Nationality";
  String selectedDateOfBirth = "Date of Birth";

  late List<String> nationalityOptions = [];
  late List<String> languageOptions = [];
  List<String> selectedLanguages = [];

  @override
  void initState() {
    super.initState();
    initializeControllers();
    loadDropdownData();

    firstNameFocus.addListener(() => setState(() {}));
    lastNameFocus.addListener(() => setState(() {}));
    emailFocus.addListener(() => setState(() {}));
    passwordFocus.addListener(() => setState(() {}));
    phoneFocus.addListener(() => setState(() {}));
  }

  void initializeControllers() {
    txtFirstNameController = TextEditingController();
    txtLastNameController = TextEditingController();
    txtEmailController = TextEditingController();
    txtPasswordController = TextEditingController();
    txtPhoneNumberController = TextEditingController();
  }

  bool isAllFilled() {
    bool areTextFieldsFilled = [
      txtFirstNameController,
      txtLastNameController,
      txtEmailController,
      txtPasswordController,
      txtPhoneNumberController,
    ].every((controller) => controller.text.isNotEmpty);

    bool hasSelectedLanguages = selectedLanguages.isNotEmpty;

    bool hasValidDateOfBirth = selectedDateOfBirth != "Date of Birth" &&
        selectedDateOfBirth.isNotEmpty;

    bool hasValidNationality =
        selectedNationality != "Nationality" && selectedNationality.isNotEmpty;

    return areTextFieldsFilled &&
        hasSelectedLanguages &&
        hasValidDateOfBirth &&
        hasValidNationality;
  }

  bool validateFields(BuildContext context) {
    if (!isAllFilled()) {
      showCustomSnackBar(
          message: "All fields are required.",
          icon: Icons.error,
          context: context);
      return false;
    }

    final email = txtEmailController.text.trim();
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(email)) {
      showCustomSnackBar(
          message: "Please enter a valid email address.",
          icon: Icons.email,
          context: context);
      return false;
    }

    final password = txtPasswordController.text.trim();
    if (password.length < 6) {
      showCustomSnackBar(
          message: "Password must be at least 6 characters long.",
          icon: Icons.password,
          context: context);
      return false;
    }

    final firstName = txtFirstNameController.text.trim();
    if (firstName.isEmpty || firstName.length < 2) {
      showCustomSnackBar(
          message: "First name must be at least 2 characters long.",
          context: context);
      return false;
    }

    final lastName = txtLastNameController.text.trim();
    if (lastName.isEmpty || lastName.length < 2) {
      showCustomSnackBar(
          message: "Last name must be at least 2 characters long.",
          context: context);
      return false;
    }

    final phoneNumber = txtPhoneNumberController.text.trim();
    if (phoneNumber.isEmpty || !RegExp(r'^\d+$').hasMatch(phoneNumber)) {
      showCustomSnackBar(
          message: "Please enter a valid phone number.",
          icon: Icons.phone,
          context: context);
      return false;
    }

    if (!agreeToTerms) {
      showCustomSnackBar(
          message: "You must agree to the Terms of Use.",
          icon: Icons.assignment,
          context: context);
      return false;
    }

    return true;
  }

  Future<void> loadDropdownData() async {
    final countriesJson = await DefaultAssetBundle.of(context)
        .loadString("assets/data/countries.json");
    nationalityOptions = (json.decode(countriesJson) as List)
        .map((item) => item["en_short_name"] as String)
        .toList();

    final langJson = await DefaultAssetBundle.of(context)
        .loadString("assets/data/lang.json");
    languageOptions = (json.decode(langJson) as List)
        .map((item) => item["name"] as String)
        .toList();

    setState(() {});
  }

  @override
  void dispose() {
    txtFirstNameController.dispose();
    txtLastNameController.dispose();
    txtEmailController.dispose();
    txtPasswordController.dispose();
    txtPhoneNumberController.dispose();
    firstNameFocus.dispose();
    lastNameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    phoneFocus.dispose();
    super.dispose();
  }

  bool handleUser(BuildContext context) {
    if (!isAllFilled()) {
      showCustomSnackBar(message: 'All fields are required.', context: context);
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: buildAppBar(context),
        body: Stack(
          children: [
            buildBackground("bg9"),
            Column(
              children: [
                buildHeader("Let's create your account",
                    "Join us and ignite your passion for learning today"),
                addVerticalSpace(16),
                buildScrollableContent(context),
                buildTermsCheckbox(),
              ],
            ),
            buildRegisterButton(),
          ],
        ),
      ),
    );
  }

  Widget buildScrollableContent(BuildContext context) {
    return Center(
      child: SizedBox(
        height: 400,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildNameFields(),
              addVerticalSpace(20),
              buildEmailField(),
              addVerticalSpace(20),
              buildPasswordField(),
              addVerticalSpace(20),
              buildPhoneField(),
              addVerticalSpace(20),
              buildDOBAndNationalityFields(context),
              addVerticalSpace(20),
              buildLanguages(),
              addVerticalSpace(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTermsCheckbox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Theme(
            data: ThemeData(
              checkboxTheme: CheckboxThemeData(
                side: WidgetStateBorderSide.resolveWith(
                  (states) {
                    if (states.contains(WidgetState.selected)) {
                      return const BorderSide(
                        width: 2.0,
                        color: Colors
                            .transparent, // Transparent border when checked
                      );
                    }
                    return const BorderSide(
                      width: 2.0,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
            child: Checkbox(
              value: agreeToTerms,
              activeColor: AppColors.lightTeal,
              onChanged: (value) {
                setState(() {
                  agreeToTerms = value ?? false;
                });
              },
            ),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "I agree to ",
                style: getTextStyle('small', color: Colors.grey),
                children: [
                  TextSpan(
                    text: "Terms of Use",
                    style: getTextStyle('small', color: AppColors.lightTeal),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Handle Terms of Use tap
                      },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNameFields() {
    return Row(
      children: [
        Expanded(
          child: buildTextField(
            controller: txtFirstNameController,
            hintText: "First Name",
            prefixIcon: const Icon(Icons.person, color: Colors.grey),
            focusNode: firstNameFocus,
          ),
        ),
        addHorizontalSpace(16),
        Expanded(
          child: buildTextField(
            controller: txtLastNameController,
            hintText: "Last Name",
            prefixIcon: const Icon(Icons.person_outline, color: Colors.grey),
            focusNode: lastNameFocus,
          ),
        ),
      ],
    );
  }

  Widget buildEmailField() {
    return buildTextField(
      controller: txtEmailController,
      hintText: "Email",
      prefixIcon: const Icon(Icons.email, color: Colors.grey),
      focusNode: emailFocus,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget buildPasswordField() {
    return buildTextField(
      controller: txtPasswordController,
      hintText: "Password",
      obscureText: notVisible,
      prefixIcon: const Icon(Icons.lock, color: Colors.grey),
      suffixIcon: IconButton(
        icon: Icon(
          notVisible ? Icons.visibility_off : Icons.visibility,
          color: Colors.grey,
        ),
        onPressed: () {
          setState(() {
            notVisible = !notVisible;
          });
        },
      ),
      focusNode: passwordFocus,
    );
  }

  Widget buildPhoneField() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            showCountryPicker(
              context: context,
              useSafeArea: true,
              showPhoneCode: true,
              onSelect: (Country country) {
                setState(() {
                  userPhoneCode = '+${country.phoneCode}';
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
          },
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.lightTeal,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  userPhoneCode.isNotEmpty ? userPhoneCode : "Phone Code",
                  style: getTextStyle("smallBold", color: Colors.white),
                ),
                addHorizontalSpace(8),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                )
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: buildTextField(
            controller: txtPhoneNumberController,
            focusNode: phoneFocus,
            keyboardType: TextInputType.phone,
            hintText: 'Phone Number',
            prefixIcon: const Icon(Icons.phone, color: Colors.grey),
          ),
        ),
      ],
    );
  }

  Widget buildDOBAndNationalityFields(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => showCupertinoModalPopup(
              context: context,
              builder: (_) {
                DateTime tempDate = DateTime.now();
                return Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoButton(
                            child: const Text("Cancel"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          CupertinoButton(
                            child: const Text("Confirm"),
                            onPressed: () {
                              setState(() {
                                selectedDateOfBirth =
                                    "${tempDate.day}/${tempDate.month}/${tempDate.year}";
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 250,
                        child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: DateTime.now(),
                          maximumDate: DateTime.now(),
                          onDateTimeChanged: (pickedDate) {
                            tempDate = pickedDate;
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            child: buildDecoratedInput(selectedDateOfBirth, Icons.date_range),
          ),
        ),
        addHorizontalSpace(16),
        Expanded(
          child: GestureDetector(
            onTap: () => showCupertinoModalPopup(
              context: context,
              builder: (_) {
                int tempIndex = 0;
                return Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CupertinoButton(
                            child: const Text("Cancel"),
                            onPressed: () => Navigator.pop(context),
                          ),
                          CupertinoButton(
                            child: const Text("Confirm"),
                            onPressed: () {
                              setState(() {
                                selectedNationality =
                                    nationalityOptions[tempIndex];
                              });
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 250,
                        child: CupertinoPicker(
                          itemExtent: 32,
                          onSelectedItemChanged: (index) {
                            tempIndex = index;
                          },
                          children: nationalityOptions
                              .map(
                                (country) => Text(
                                  country.length > 15
                                      ? "${country.substring(0, 12)}..."
                                      : country,
                                  style: getTextStyle('medium',
                                      color: Colors.black),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            child: buildDecoratedInput(selectedNationality, Icons.flag),
          ),
        ),
      ],
    );
  }

  Widget buildLanguages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.language, color: Colors.grey),
                addHorizontalSpace(10),
                Text(
                  "Add Language",
                  style: getTextStyle('medium', color: Colors.grey),
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
                                  if (!selectedLanguages
                                      .contains(languageOptions[index])) {
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
          children: selectedLanguages
              .map(
                (language) => Chip(
                  backgroundColor: AppColors.lightTeal,
                  label: Text(
                    language,
                    style: getTextStyle('small', color: Colors.white),
                  ),
                  deleteIcon: const Icon(Icons.close, color: Colors.white),
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
        ),
      ],
    );
  }

  Widget buildRegisterButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
        child: SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton(
            onPressed: () {
              if (validateFields(context)) {
                final user = User(
                  firstName: txtFirstNameController.text.trim(),
                  lastName: txtLastNameController.text.trim(),
                  dateOfBirth: parseCustomDate(selectedDateOfBirth),
                  nationality: selectedNationality,
                  primaryLanguages: selectedLanguages,
                  phoneCode: userPhoneCode,
                  mobileNumber: txtPhoneNumberController.text.trim(),
                  email: txtEmailController.text.trim(),
                  password: txtPasswordController.text.trim(),
                  role: '', // This will be updated later
                );

                // Navigate to Role Selection screen
                context.pushNamed(
                  AppRouter.role.name,
                  extra: user,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightTeal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Text(
              "Next",
              style: getTextStyle('mediumBold', color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  DateTime parseCustomDate(String dateString) {
    final parts = dateString.split('/');
    if (parts.length == 3) {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } else {
      throw FormatException('Invalid date format: $dateString');
    }
  }
}
