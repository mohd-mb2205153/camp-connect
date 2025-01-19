import 'dart:convert';

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
import 'package:campconnect/theme/styling_constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';

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

  List<String> subjects = [];
  List<String> selectedSubjects = [];

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
    loadAdditionalSupports();
  }

  Future<void> loadAdditionalSupports() async {
    try {
      final subjectsData = await DefaultAssetBundle.of(context)
          .loadString("assets/data/additional_support.json");
      subjects = List<String>.from(json.decode(subjectsData) as List);
      setState(() {});
    } catch (error) {
      debugPrint("Error loading additional supports data: $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter new camp details")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: namecontroller,
                    decoration: InputDecoration(
                        labelText: "Name", border: OutlineInputBorder()),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    "Location: ",
                    style:
                        getTextStyle("mediumBold", color: AppColors.lightTeal),
                  ),
                  Expanded(
                    child: Text(address ?? "",
                        style: const TextStyle(fontSize: 16.0)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Choose level",
                      style: getTextStyle("mediumBold",
                          color: AppColors.lightTeal),
                    ),
                    buildEduDropdown()
                  ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Choose Subject",
                    style:
                        getTextStyle("mediumBold", color: AppColors.lightTeal),
                  ),
                  buildSubjectsDropdown(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                TextField(
                  controller: descriptionController,
                  maxLines: 3,
                  decoration: InputDecoration(
                      labelText: "Enter Description",
                      border: OutlineInputBorder()),
                )
              ]),
            ),
            Text(
              "Special Needs",
              style: getTextStyle("mediumBold", color: AppColors.lightTeal),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: RadioListTile(
                      title: Text(
                        'Yes',
                        style:
                            getTextStyle("medium", color: AppColors.lightTeal),
                      ),
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
                      title: Text(
                        'No',
                        style:
                            getTextStyle("medium", color: AppColors.lightTeal),
                      ),
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
            ),
            const SizedBox(height: 16),
            buildPreferredSubjectsPicker(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
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
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.lightTeal, // Text color
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12), // Padding
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                      ),
                      elevation: 4, // Shadow elevation
                    ),
                    child: Text("Add Camp")),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildPreferredSubjectsPicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "Additional Supports",
                textAlign: TextAlign.start,
                style: getTextStyle("small", color: AppColors.lightTeal),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.book, color: Colors.grey),
              const SizedBox(width: 10),
              Text(
                "Additional Supports",
                style: getTextStyle('medium', color: Colors.grey),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.grey),
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
                        itemCount: subjects.length,
                        itemBuilder: (_, index) {
                          return ListTile(
                            title: Text(
                              subjects[index],
                              style: getTextStyle("small"),
                            ),
                            onTap: () {
                              setState(() {
                                if (!selectedSubjects
                                    .contains(subjects[index])) {
                                  selectedSubjects.add(subjects[index]);
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
          const Divider(color: AppColors.lightTeal, thickness: 2),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: selectedSubjects
                .map(
                  (subject) => Chip(
                    backgroundColor: AppColors.lightTeal,
                    label: Text(
                      subject,
                      style: getTextStyle('small', color: Colors.white),
                    ),
                    deleteIcon: const Icon(Icons.close, color: Colors.white),
                    onDeleted: () {
                      setState(() {
                        selectedSubjects.remove(subject);
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
      ),
    );
  }

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
    return ref.watch(studentEducationLevelProvider).when(
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
