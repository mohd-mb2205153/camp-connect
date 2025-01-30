import 'package:campconnect/providers/show_nav_bar_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campconnect/theme/constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:go_router/go_router.dart';

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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: AppColors.darkTeal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            ref
                .read(showNavBarNotifierProvider.notifier)
                .showBottomNavBar(true);
            context.pop();
          },
        ),
        title: Text(
          'Search Camps',
          style: getTextStyle("mediumBold", color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          // Background
          buildBackground(
              "bg9"), // Assuming you have a method like this in your code

          // Content
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 130, 12, 0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterCamps,
                  style: getTextStyle("small", color: AppColors.teal),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    hintText: "Search camps here",
                    hintStyle: getTextStyle("small", color: Colors.grey),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide:
                          BorderSide(color: AppColors.lightTeal, width: 2),
                    ),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 222, 222, 222),
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              _filterCamps("");
                            },
                          )
                        : null,
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
                                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                    SizedBox(
                                      width: 50,
                                      child: IconButton(
                                        icon: const Icon(Icons.remove_red_eye,
                                            color: Colors.white),
                                        onPressed: () {
                                          //add logic to go to maps and pass campId for focusing
                                        },
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
