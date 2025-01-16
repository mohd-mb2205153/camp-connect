import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddCampScreen extends ConsumerStatefulWidget {
  //final String latitude;
  //final String longitude;
  const AddCampScreen({super.key, /*required this.latitude, required this.longitude*/});

  @override
  ConsumerState<AddCampScreen> createState() => _AddCampScreenState();
}

class _AddCampScreenState extends ConsumerState<AddCampScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
