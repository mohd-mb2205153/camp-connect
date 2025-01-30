import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminTeacherVerificationScreen extends ConsumerStatefulWidget {
  const AdminTeacherVerificationScreen({super.key});

  @override
  ConsumerState<AdminTeacherVerificationScreen> createState() =>
      _AdminTeacherVerificationScreenState();
}

class _AdminTeacherVerificationScreenState
    extends ConsumerState<AdminTeacherVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Admin Teacher Verification Screen'),
      ),
    );
  }
}
