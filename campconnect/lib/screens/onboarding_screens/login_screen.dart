import 'package:campconnect/models/admin.dart';
import 'package:campconnect/models/student.dart';
import 'package:campconnect/models/teacher.dart';
import 'package:campconnect/providers/loggedinuser_provider.dart';
import 'package:campconnect/providers/show_nav_bar_provider.dart';
import 'package:campconnect/routes/app_router.dart';
import 'package:campconnect/theme/constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/auth_services.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool notVisible = true;
  bool isEmailValid = false;
  late TextEditingController txtEmailController;
  late TextEditingController txtPasswordController;

  late FocusNode emailFocusNode;
  late FocusNode passwordFocusNode;

  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    ref.read(showNavBarNotifierProvider.notifier);

    txtEmailController = TextEditingController();
    txtPasswordController = TextEditingController();

    emailFocusNode = FocusNode();
    passwordFocusNode = FocusNode();

    txtEmailController.addListener(() {
      final email = txtEmailController.text;
      setState(() {
        isEmailValid =
            RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                .hasMatch(email);
      });
    });

    emailFocusNode.addListener(() {
      setState(() {});
    });
    passwordFocusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    txtEmailController.dispose();
    txtPasswordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> getJwtToken() async {
    String? token = await FirebaseAuth.instance.currentUser
        ?.getIdToken(); // Firebase JWT token
    print("This is the user 1st login token: $token");
    if (token != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('jwt_token', token); // Store token
    }
  }

  void handleLogin(BuildContext context) async {
    final email = txtEmailController.text.trim();
    final password = txtPasswordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      showCustomSnackBar(
        message: "Please fill in all fields",
        icon: Icons.error,
        context: context,
      );
      return;
    }

    try {
      await _authService.signin(email: email, password: password);

      // check if the user is a student
      final studentDoc = await FirebaseFirestore.instance
          .collection('students')
          .where('email', isEqualTo: email)
          .get();
      
      //Saving the email address of the user locally, for future JWT authentication 
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('email', email);

      if (studentDoc.docs.isNotEmpty) {
        final student = Student.fromJson(studentDoc.docs.first.data());
        ref.read(loggedInUserNotifierProvider.notifier).setStudent(student);
        ref.read(showNavBarNotifierProvider.notifier).setActiveBottomNavBar(0);
        await getJwtToken(); //Should be outside the condition
        context.replaceNamed(AppRouter.home.name);
        return;
      }

      final teacherDoc = await FirebaseFirestore.instance
          .collection('teachers')
          .where('email', isEqualTo: email)
          .get();

      if (teacherDoc.docs.isNotEmpty) {
        final teacher = Teacher.fromJson(teacherDoc.docs.first.data());

        // handle pending teachers
        if (teacher.verificationStatus == 'pending') {
          showCustomSnackBar(
            message:
                "Your account is pending verification. Please wait for approval.",
            icon: Icons.info,
            backgroundColor: AppColors.orange,
            context: context,
          );
          return;
        }

        // handle rejected teachers
        if (teacher.verificationStatus == 'rejected') {
          showCustomSnackBar(
            message:
                "Your registration was rejected. Click 'Report Issue' to dispute.",
            icon: Icons.warning,
            backgroundColor: Colors.red,
            context: context,
          );
          return;
        }

        // only approved teachers to log in
        ref.read(loggedInUserNotifierProvider.notifier).setTeacher(teacher);
        ref.read(showNavBarNotifierProvider.notifier).setActiveBottomNavBar(0);
        context.replaceNamed(AppRouter.home.name);
        return;
      }

      // check if the user is an admin
      final adminDoc = await FirebaseFirestore.instance
          .collection('admin')
          .where('email', isEqualTo: email)
          .get();

      if (adminDoc.docs.isNotEmpty) {
        final admin = Admin.fromJson(adminDoc.docs.first.data());
        ref.read(loggedInUserNotifierProvider.notifier).setAdmin(admin);
        ref.read(showNavBarNotifierProvider.notifier).setActiveBottomNavBar(0);
        context.replaceNamed(AppRouter.adminDashboard.name);
        return;
      }

      throw Exception(
          "User not found in students, teachers, or admin collections.");
    } on FirebaseAuthException catch (e) {
      handleFirebaseAuthErrors(e, context);
    } on FirebaseException catch (e) {
      showCustomSnackBar(
        message: "Database error: ${e.message ?? 'Unknown error occurred'}",
        icon: Icons.error,
        context: context,
      );
    } catch (e) {
      showCustomSnackBar(
        message: "Something went wrong. Please try again later.",
        icon: Icons.error,
        context: context,
      );
    }
  }

  void handleFirebaseAuthErrors(FirebaseAuthException e, BuildContext context) {
    String errorMessage;

    switch (e.code) {
      case 'user-not-found':
        errorMessage = "No account found for this email.";
        break;
      case 'wrong-password':
        errorMessage = "Incorrect password. Please try again.";
        break;
      case 'invalid-email':
        errorMessage = "Invalid email address.";
        break;
      case 'user-disabled':
        errorMessage =
            "This account has been disabled. Please contact support.";
        break;
      case 'too-many-requests':
        errorMessage = "Too many failed attempts. Please try again later.";
        break;
      default:
        errorMessage = "Authentication error: ${e.message ?? 'Unknown error.'}";
    }

    debugPrint("FirebaseAuthException: ${e.code}, message: ${e.message}");

    showCustomSnackBar(
      message: errorMessage,
      icon: Icons.error,
      context: context,
    );
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
            Positioned.fill(
              child: Image.asset(
                Assets.image('bg6.png'),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: screenHeight(context) * 0.20,
              left: 24,
              child: SizedBox(
                child: Text(
                  wrapText("Sign in", 10),
                  style: getTextStyle('xlargeBold', color: Colors.white),
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
                      children: [
                        inputFields(context),
                        addVerticalSpace(60),
                        LoginButton(onLoginPressed: () {
                          handleLogin(context);
                        }),
                        addVerticalSpace(20),
                        GestureDetector(
                          onTap: () {
                            print("Report a problem");
                          },
                          child: Text(
                            "Report a problem",
                            style: getTextStyle('smallBold',
                                color: AppColors.lightTeal),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column inputFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildTextField(
          controller: txtEmailController,
          hintText: "Email",
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icon(
            Icons.email,
            color: emailFocusNode.hasFocus ? AppColors.lightTeal : Colors.grey,
          ),
          suffixIcon: isEmailValid
              ? const Icon(Icons.check, color: AppColors.lightTeal)
              : null,
          focusNode: emailFocusNode,
        ),
        addVerticalSpace(20),
        buildTextField(
          controller: txtPasswordController,
          hintText: "Password",
          obscureText: notVisible,
          prefixIcon: Icon(
            Icons.lock,
            color:
                passwordFocusNode.hasFocus ? AppColors.lightTeal : Colors.grey,
          ),
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
          focusNode: passwordFocusNode,
        ),
        addVerticalSpace(12),
        Row(
          children: [
            Spacer(),
            GestureDetector(
              onTap: () {
                print("Forgot password tapped"); // temporary solution
              },
              child: Text(
                "Forgot password?",
                style: getTextStyle('smallBold', color: AppColors.lightTeal),
              ),
            ),
          ],
        ),
      ],
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
          backgroundColor: AppColors.lightTeal,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
        ),
        child: Text(
          "Log in",
          style: getTextStyle('mediumBold', color: Colors.white),
        ),
      ),
    );
  }
}
