import 'dart:convert';

import 'package:campconnect/routes/app_router.dart';
import 'package:campconnect/theme/styling_constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:country_code_picker/country_code_picker.dart';
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

  String selectedNationality = "Select Nationality";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context),
      body: Stack(
        children: [
          buildBackground(),
          Column(
            children: [
              buildHeader(),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: buildScrollableContent(context),
                ),
              ),
              buildTermsCheckbox(),
            ],
          ),
          buildRegisterButton(),
        ],
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: AppColors.lightTeal),
        onPressed: () => context.pop(),
      ),
    );
  }

  Widget buildBackground() {
    return Positioned.fill(
      child: Image.asset(
        'assets/images/bg9.png',
        fit: BoxFit.cover,
      ),
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 120),
      child: Align(
        alignment: Alignment.topCenter,
        child: Text(
          "Let's create your account",
          style: getTextStyle('largeBold', color: AppColors.lightTeal),
        ),
      ),
    );
  }

  Widget buildScrollableContent(BuildContext context) {
    return SizedBox(
      height: 420,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            buildNameFields(),
            const SizedBox(height: 20),
            buildEmailField(),
            const SizedBox(height: 20),
            buildPasswordField(),
            const SizedBox(height: 20),
            buildPhoneField(),
            const SizedBox(height: 20),
            buildDOBAndNationalityFields(context),
            const SizedBox(height: 20),
            buildLanguages(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildTermsCheckbox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: [
          Theme(
            data: ThemeData(
              checkboxTheme: CheckboxThemeData(
                side: WidgetStateBorderSide.resolveWith(
                  (states) => const BorderSide(
                    width: 2.0,
                    color: Colors.grey,
                  ),
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
        const SizedBox(width: 16),
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
        CountryCodePicker(
          hideSearch: true,
          onChanged: (code) {},
          initialSelection: 'QA',
        ),
        const SizedBox(width: 8),
        Expanded(
          child: buildTextField(
            controller: txtPhoneNumberController,
            hintText: "Phone Number",
            prefixIcon: const Icon(Icons.phone, color: Colors.grey),
            focusNode: phoneFocus,
          ),
        ),
      ],
    );
  }

  Widget buildDOBAndNationalityFields(BuildContext context) {
    return Row(
      children: [
        // Date of Birth Picker
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
            child: buildDecoratedInput(selectedDateOfBirth),
          ),
        ),
        const SizedBox(width: 16),
        // Nationality Picker
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
            child: buildDecoratedInput(selectedNationality),
          ),
        ),
      ],
    );
  }

  Widget buildDecoratedInput(String text) {
    return InputDecorator(
      decoration: buildInputDecoration(text),
      child: Row(
        children: [
          const Icon(Icons.flag, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            text,
            style: getTextStyle(
              'medium',
              color: Colors.grey,
            ),
          ),
        ],
      ),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Add Language",
                  style: getTextStyle('medium', color: Colors.grey),
                ),
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
        const SizedBox(height: 8),
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
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightTeal,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: Text(
              "Sign up",
              style: getTextStyle('mediumBold', color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
