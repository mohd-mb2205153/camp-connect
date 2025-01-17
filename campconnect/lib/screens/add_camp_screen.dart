import 'package:campconnect/providers/json_provider.dart';
import 'package:campconnect/widgets/filter_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddCampScreen extends ConsumerStatefulWidget {
  final String location;
  const AddCampScreen({super.key, required this.location});

  @override
  ConsumerState<AddCampScreen> createState() => _AddCampScreenState();
}

class _AddCampScreenState extends ConsumerState<AddCampScreen> {
  final locationController = TextEditingController();
  final descriptionController = TextEditingController();
  String? locationString;
  List<String>? latlng;
  double? latitude;
  double? longitude;
  LatLng? location;
  String? address;

  String? selectedEducationLevel;
  String? selectedSubject;

  @override
  void initState() {
    super.initState();
    locationString = widget.location;
    latlng = locationString!.split("|");
    latitude = double.parse(latlng![0]);
    longitude = double.parse(latlng![1]);
    address = latlng![2];
    location = LatLng(latitude!, longitude!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Camp")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [Text("Location"), Text("$address")],
            ),
            buildEduDropdown(),
            buildSubjectsDropdown(),
          ],
        ),
      ),
    );
  }

  Widget buildEduDropdown() {
    return ref.watch(educationLevelProvider).when(
        data: (data) {
          return FilterDropdown(
            selectedFilter: selectedEducationLevel ?? "Primary School",
            options: data,
            onSelected: (String? newLevel) {
              if (newLevel != null) {
                setState(() {
                  selectedEducationLevel = newLevel;
                });
              }
            },
          );
        },
        error: (err, stack) => Text('Error: $err'),
        loading: () => const CircularProgressIndicator());
  }

  Widget buildSubjectsDropdown() {
    return ref.watch(subjectsProvider).when(
        data: (data) {
          return FilterDropdown(
            selectedFilter: selectedSubject ?? "Arabic",
            options: data,
            onSelected: (String? newLevel) {
              if (newLevel != null) {
                setState(() {
                  selectedEducationLevel = newLevel;
                });
              }
            },
          );
        },
        error: (err, stack) => Text('Error: $err'),
        loading: () => const CircularProgressIndicator());
  }

  Future<String> convertAddress(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark address = placemarks[0];
    String fullAddress =
        "${address.street},${address.locality},${address.administrativeArea},${address.country}";
    return fullAddress;
  }
}
