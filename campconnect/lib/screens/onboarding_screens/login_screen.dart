import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<LoginScreen> {
  bool notVisible = true;
  bool isRememberMeChecked = false;
  late TextEditingController txtEmailController;
  late TextEditingController txtPasswordController;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
