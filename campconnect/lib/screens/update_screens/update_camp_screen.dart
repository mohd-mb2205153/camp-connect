import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UpdateCampScreen extends ConsumerStatefulWidget {
  final String location;
  const UpdateCampScreen({super.key, required this.location});

  @override
  ConsumerState<UpdateCampScreen> createState() => _UpdateCampScreenState();
}

class _UpdateCampScreenState extends ConsumerState<UpdateCampScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
