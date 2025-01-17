import 'package:campconnect/models/camp.dart';
import 'package:campconnect/providers/camp_provider.dart';
import 'package:campconnect/providers/json_provider.dart';
import 'package:campconnect/routes/app_router.dart';
import 'package:campconnect/widgets/filter_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddCampScreen extends ConsumerStatefulWidget {
  final String location;
  const AddCampScreen({super.key, required this.location});

  @override
  ConsumerState<AddCampScreen> createState() => _AddCampScreenState();
}

class _AddCampScreenState extends ConsumerState<AddCampScreen> {
  final namecontroller = TextEditingController();
  final descriptionController = TextEditingController();
  String? locationString;
  List<String>? latlng;
  double? latitude;
  double? longitude;
  LatLng? location;
  String? address;
  String? _selectedSpecNeeds;

  String? selectedEducationLevel;
  String? selectedSubject;

  @override
  void initState() {
    ref.read(campProviderNotifier);
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
            Column(
              children: [
                Text("Enter Name: "),
                TextField(
                  controller: namecontroller,
                  decoration: InputDecoration(labelText: "Name"),
                )
              ],
            ),
            Row(
              children: [Text("Location"), Text("$address")],
            ),
            Row(children: [Text("Choose level"), buildEduDropdown()]),
            Row(
              children: [
                Text("Choose Subject"),
                buildSubjectsDropdown(),
              ],
            ),
            Column(children: [
              Text("Description"),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Enter Description"),
              )
            ]),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text('Yes'),
                    value: 'Yes',
                    groupValue: _selectedSpecNeeds,
                    onChanged: (value) {
                      setState(() {
                        _selectedSpecNeeds = value!;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text('No'),
                    value: 'No',
                    groupValue: _selectedSpecNeeds,
                    onChanged: (value) {
                      setState(() {
                        _selectedSpecNeeds = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () {
                  addCamp(
                      namecontroller,
                      selectedEducationLevel!,
                      selectedSubject!,
                      descriptionController,
                      _selectedSpecNeeds!,
                      latitude!,
                      longitude!);
                  context.go(AppRouter.home.path);
                },
                child: Text("Add Camp"))
          ],
        ),
      ),
    );
  }

  //IMPORTANNTTTTT need to change so user info is updated
  void addCamp(
    TextEditingController name,
    String selectedEducationLevel,
    String selectedSubject,
    TextEditingController description,
    String specNeed,
    double latitude,
    double longitude,
  ) {
    bool specNeeds = specNeed == "Yes" ? true : false;
    Camp camp = Camp(
        name: name.text,
        educationLevel: selectedEducationLevel,
        subject: selectedSubject,
        description: description.text,
        specialNeeds: specNeeds,
        latitude: latitude,
        longitude: longitude,
        teachers: [],
        students: []);
    ref.read(campProviderNotifier.notifier).addCamp(camp);
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
                  selectedSubject = newLevel;
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
