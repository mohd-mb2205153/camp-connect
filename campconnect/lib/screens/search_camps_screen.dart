import 'package:campconnect/models/camp.dart';
import 'package:campconnect/providers/camp_provider.dart';
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

  @override
  void initState() {
    super.initState();
    ref.read(campProviderNotifier).whenData((list) => _filteredCamps = list);
  }

  void setSelectedCampProviderNull() {
    ref.read(selectedCampLocationProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          setSelectedCampProviderNull();
          ref.read(showNavBarNotifierProvider.notifier).showBottomNavBar(true);
          context.pop();
        }
        return;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          scrolledUnderElevation: 0.0,
          backgroundColor: AppColors.darkTeal,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              setSelectedCampProviderNull();
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
                  padding: const EdgeInsets.fromLTRB(12, 100, 12, 0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) async {
                      _filteredCamps = await ref
                          .read(campProviderNotifier.notifier)
                          .filterByName(value);
                      setState(() {});
                    },
                    style: getTextStyle("small", color: AppColors.teal),
                    decoration: InputDecoration(
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.teal,
                      ),
                      hintText: "Search camps here",
                      hintStyle: getTextStyle("small", color: AppColors.beige),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.beige),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.teal, width: 2),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 240, 240, 240),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, color: Colors.grey),
                              onPressed: () async {
                                _searchController.clear();
                                _filteredCamps = await ref
                                    .read(campProviderNotifier.notifier)
                                    .filterByName("");
                                setState(() {});
                              },
                            )
                          : null,
                    ),
                  ),
                ),
                Expanded(
                  child: _filteredCamps.isEmpty
                      ? Center(
                          child: Text(
                            "No camps found.",
                            style: getTextStyle('largeBold',
                                color: AppColors.darkTeal),
                          ),
                        )
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                            ref
                                                .read(
                                                    selectedCampLocationProvider
                                                        .notifier)
                                                .state = [
                                              camp.latitude,
                                              camp.longitude
                                            ];
                                            context.pop();
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
      ),
    );
  }
}
