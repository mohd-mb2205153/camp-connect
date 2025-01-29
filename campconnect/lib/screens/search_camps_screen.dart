import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campconnect/theme/constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';

class SearchCampsScreen extends ConsumerStatefulWidget {
  const SearchCampsScreen({super.key});

  @override
  ConsumerState<SearchCampsScreen> createState() => _SearchCampsScreenState();
}

class _SearchCampsScreenState extends ConsumerState<SearchCampsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Camp> _filteredCamps = [];
  List<Camp> _dummyCamps = [];

  @override
  void initState() {
    super.initState();
    _dummyCamps = [
      Camp(
        id: "1",
        name: "Sunshine Camp",
        educationLevel: ["Primary", "Secondary"],
        description: "A vibrant camp with excellent resources.",
        latitude: 12.34,
        longitude: 56.78,
        statusOfResources: "Good",
        additionalSupport: ["Wifi", "Counseling"],
        languages: ["English", "French"],
      ),
      Camp(
        id: "2",
        name: "Mountain Learning Hub",
        educationLevel: ["Secondary"],
        description: "An educational hub for mountain communities.",
        latitude: 98.76,
        longitude: 54.32,
        statusOfResources: "Moderate",
        additionalSupport: ["Trauma Support", "Medical Aid"],
        languages: ["English", "Spanish"],
      ),
    ];
    _filteredCamps = _dummyCamps;
  }

  void _filterCamps(String query) {
    setState(() {
      _filteredCamps = _dummyCamps
          .where((camp) =>
              camp.name.toLowerCase().contains(query.toLowerCase()) ||
              camp.description.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: AppColors.darkTeal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Search Camps',
          style: getTextStyle("mediumBold", color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterCamps,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search camps...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: _filteredCamps.isEmpty
                ? const Center(child: Text("No camps found"))
                : ListView.builder(
                    itemCount: _filteredCamps.length,
                    itemBuilder: (context, index) {
                      final camp = _filteredCamps[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 4.0),
                        child: Card(
                          color: AppColors.darkTeal,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: AppColors.lightTeal,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Image.asset(
                                    'assets/images/tent_icon_white.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        camp.name,
                                        style: getTextStyle('mediumBold',
                                            color: Colors.white),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        camp.description,
                                        style: getTextStyle('small',
                                            color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class Camp {
  String? id;
  String name;
  List<String> educationLevel;
  String description;
  double latitude;
  double longitude;
  String statusOfResources;
  List<String>? additionalSupport;
  List<String>? languages;

  Camp({
    this.id,
    required this.name,
    required this.educationLevel,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.statusOfResources,
    this.additionalSupport,
    this.languages,
  });
}
