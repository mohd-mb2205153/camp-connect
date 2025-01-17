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
                      labelText: "Name",
                      border: OutlineInputBorder()
                      ),
                    
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Text("Location: ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Text(address ?? "", style: const TextStyle(fontSize: 16.0)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Choose level"), buildEduDropdown()
                ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Choose Subject"),
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
            const Text("Special Needs", style: TextStyle(fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
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
            ),
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
                      foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Padding
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12), // Rounded corners
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
