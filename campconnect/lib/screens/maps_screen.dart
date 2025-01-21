import 'dart:async';

import 'package:campconnect/models/camp.dart';
import 'package:campconnect/models/teacher.dart';
import 'package:campconnect/models/user.dart';
import 'package:campconnect/providers/camp_provider.dart';
import 'package:campconnect/providers/class_provider.dart';
import 'package:campconnect/providers/json_provider.dart';
import 'package:campconnect/providers/student_provider.dart';
import 'package:campconnect/providers/teacher_provider.dart';
import 'package:campconnect/routes/app_router.dart';
import 'package:campconnect/theme/constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:campconnect/widgets/edit_screen_fields.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:group_button/group_button.dart';

import '../models/student.dart';
import '../providers/loggedinuser_provider.dart';
import '../providers/show_nav_bar_provider.dart';

class MapsScreen extends ConsumerStatefulWidget {
  const MapsScreen({super.key});

  @override
  ConsumerState<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends ConsumerState<MapsScreen> {
  bool isStudent = false;
  bool isTeacher = false;
  dynamic loggedUser;
  DateTime? lastUpdatedTime;
  bool hasWifi = true; // check connectivity if needed
  List<String> filteredEduLevels = [];
  List<String> filteredLanguages = [];
  List<String> filteredSubjects = [];
  List<String> filteredAdditional = [];
  String? selectedFilterType;

  GoogleMapController? _googleMapController;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(25.3, 51.487), zoom: 10);

  Set<Marker> markers = {};
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor liveLocationIcon = BitmapDescriptor.defaultMarker;

  late StreamSubscription<Position> _positionStreamSubscription;
  bool _followUserLocation = true;

  late LatLng currentLocation;
  late LatLng destinationCampLocation;
  List<LatLng> polyLineCordinates = [];

  TextEditingController areaRadiusController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCustomIcons();
    _startLiveLocationUpdates();
    initializeUserDetails();

    Timer.periodic(const Duration(seconds: 8), (timer) {
      if (mounted) {
        setState(() {
          lastUpdatedTime = DateTime.now();
          checkWifiStatus().then((status) => hasWifi = status);
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<bool> checkWifiStatus() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult == ConnectivityResult.wifi;
  }

  void initializeUserDetails() {
    Future.microtask(() {
      final userNotifier = ref.read(loggedInUserNotifierProvider.notifier);

      isStudent = userNotifier.isStudent;
      isTeacher = userNotifier.isTeacher;

      if (isStudent) {
        loggedUser = userNotifier.student;
      } else if (isTeacher) {
        loggedUser = userNotifier.teacher;
      }

      ref.read(showNavBarNotifierProvider.notifier).showBottomNavBar(true);

      setState(() {});
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    _googleMapController?.dispose();
    areaRadiusController.dispose();
    super.dispose();
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
            origin: PointLatLng(
                currentLocation.latitude, currentLocation.longitude),
            destination: PointLatLng(destinationCampLocation.latitude,
                destinationCampLocation.longitude),
            mode: TravelMode.walking),
        googleApiKey: googleApiKey);

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) =>
          polyLineCordinates.add(LatLng(point.latitude, point.longitude)));
      setState(() {});
    }
  }

  String getTimeDifferenceString(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inSeconds < 60) {
      return "${difference.inSeconds} seconds ago";
    } else if (difference.inMinutes < 60) {
      return "${difference.inMinutes} minutes ago";
    } else if (difference.inHours < 24) {
      return "${difference.inHours} hours ago";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else if (difference.inDays < 30) {
      return "${(difference.inDays / 7).floor()} weeks ago";
    } else if (difference.inDays < 365) {
      return "${(difference.inDays / 30).floor()} months ago";
    } else {
      return "${(difference.inDays / 365).floor()} years ago";
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(loggedInUserNotifierProvider);
    // final student = ref.watch(studentProviderNotifier);
    // final teacher = ref.watch(teacherProviderNotifier);
    // final classSchedule = ref.watch(classProviderNotifier);

    return ref.watch(campProviderNotifier).when(
          data: (data) => _buildMapScreen(context, data),
          error: (err, stack) => _buildErrorScreen(err),
          loading: () => _buildLoadingScreen(),
        );
  }

  void _loadCustomIcons() {
    _loadCustomIcon("assets/images/tent_icon.png", const Size(48, 48), (icon) {
      customIcon = icon;
    });

    _loadCustomIcon(
        "assets/images/current_location_icon.png", const Size(32, 32), (icon) {
      liveLocationIcon = icon;
    });
  }

  void _loadCustomIcon(
      String assetPath, Size size, Function(BitmapDescriptor) callback) {
    BitmapDescriptor.asset(
      ImageConfiguration(size: size), // Set the size here
      assetPath,
    ).then((icon) {
      if (mounted) {
        setState(() {
          callback(icon);
        });
      }
    });
  }

  void _startLiveLocationUpdates() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen(_updateLiveLocationMarker);
  }

  void _updateLiveLocationMarker(Position position) {
    LatLng userLocation = LatLng(position.latitude, position.longitude);

    if (mounted) {
      setState(() {
        currentLocation = userLocation;
        markers
            .removeWhere((marker) => marker.markerId.value == "live_location");
        markers.add(
          Marker(
            markerId: const MarkerId("live_location"),
            position: userLocation,
            icon: liveLocationIcon,
            infoWindow: const InfoWindow(title: "You are here"),
          ),
        );
      });
    }

    if (_followUserLocation && _googleMapController != null) {
      _googleMapController!.animateCamera(
        CameraUpdate.newLatLng(userLocation),
      );
    }
  }

  Widget _buildMapScreen(BuildContext context, List<Camp> data) {
    markers.addAll(createMarkers(data));

    Camp? selectedCamp;
    if (polyLineCordinates.isNotEmpty) {
      selectedCamp = data.firstWhere(
        (camp) =>
            camp.latitude == destinationCampLocation.latitude &&
            camp.longitude == destinationCampLocation.longitude,
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(camp: selectedCamp),
      body: Stack(
        children: [
          _buildGoogleMap(),
          _buildHeader(context),
          AnimatedOpacity(
            opacity: polyLineCordinates.isNotEmpty ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: polyLineCordinates.isNotEmpty
                ? Stack(children: [_routeCancelButton(context)])
                : const SizedBox.shrink(),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButtons(context),
    );
  }

  AppBar _buildAppBar({Camp? camp}) {
    return polyLineCordinates.isEmpty
        ? AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
          )
        : AppBar(
            backgroundColor: AppColors.teal,
            title: Text(
              "Directions to ${camp?.name ?? ''}",
              style: getTextStyle("mediumBold", color: Colors.white),
            ),
          );
  }

  GoogleMap _buildGoogleMap() {
    return GoogleMap(
      initialCameraPosition: initialCameraPosition,
      markers: markers,
      zoomControlsEnabled: false,
      mapType: MapType.terrain,
      myLocationButtonEnabled: false,
      polylines: {
        if (polyLineCordinates.isNotEmpty)
          Polyline(
            polylineId: const PolylineId("route"),
            points: polyLineCordinates,
            color: AppColors.blue,
            width: 5,
          ),
      },
      onMapCreated: (controller) {
        _googleMapController = controller;
      },
      onTap: (_) => _stopFollowingUser(),
      onCameraMove: (_) => _stopFollowingUser(),
    );
  }

  void _stopFollowingUser() {
    setState(() {
      _followUserLocation = false;
    });
  }

  Widget _buildHeader(BuildContext context) {
    return Positioned(
      top: 64,
      left: 0,
      right: 0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildHeaderContent(context),
          addVerticalSpace(12),
          _buildLastUpdatedText(),
        ],
      ),
    );
  }

  Widget _buildHeaderContent(BuildContext context) {
    return polyLineCordinates.isEmpty
        ? Row(
            children: [
              _buildCircleIconButton(Icons.search, () {}),
              const Spacer(),
              _buildFilterButton(context),
              const Spacer(),
              _buildCircleIconButton(Icons.settings, () {}),
            ],
          )
        : Row();
  }

  Widget _buildCircleIconButton(IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightTeal,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          icon: Icon(icon, color: Colors.white),
          onPressed: onPressed,
        ),
      ),
    );
  }

  void showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: screenHeight(context) * .6,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.tune, color: Colors.teal),
                          const SizedBox(width: 10),
                          Text(
                            "Filter Camps",
                            style:
                                getTextStyle('mediumBold', color: Colors.teal),
                          ),
                          Expanded(
                            child: SizedBox(),
                          ),
                          _buildClearAllFilters(context),
                        ],
                      ),
                      Divider(
                        color: AppColors.teal,
                        height: 20,
                      ),
                      createFilterRadios(setModalState),
                      Divider(
                        color: AppColors.teal,
                        height: 20,
                        thickness: 15,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (selectedFilterType == 'Educational Level')
                        buildFilterPicker(
                            setModalState: setModalState,
                            title: 'Filter Educational Level',
                            filteredList: filteredEduLevels,
                            icon: Icons.school,
                            provider: studentEducationLevelProvider),
                      if (selectedFilterType == 'Languages')
                        buildFilterPicker(
                            setModalState: setModalState,
                            title: 'Filter Languages',
                            icon: Icons.language,
                            filteredList: filteredLanguages,
                            provider: languagesProvider),
                      if (selectedFilterType == 'Subjects')
                        buildFilterPicker(
                            setModalState: setModalState,
                            title: 'Filter Subjects',
                            icon: Icons.subject,
                            filteredList: filteredSubjects,
                            provider: subjectsProvider),
                      if (selectedFilterType == 'Additional Support')
                        buildFilterPicker(
                            setModalState: setModalState,
                            title: 'Additional Support',
                            icon: Icons.health_and_safety_rounded,
                            filteredList: filteredAdditional,
                            provider: additionalSupportProvider),
                      if (selectedFilterType == 'Area Radius')
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Filter Area Radius:',
                                  style: getTextStyle('medium',
                                      color: AppColors.teal),
                                ),
                                EditScreenTextField(
                                  label: 'Filter Area Radius',
                                  controller: areaRadiusController,
                                  type: TextInputType.number,
                                ),
                              ],
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget createFilterRadios(StateSetter setModalState) {
    return Wrap(
      children: [
        Row(
          children: [
            Expanded(
              child: RadioListTile(
                title: Text(
                  'Educational Level',
                  style: getTextStyle('small', color: AppColors.teal),
                ),
                value: 'Educational Level',
                groupValue: selectedFilterType,
                onChanged: (value) {
                  setModalState(() {
                    selectedFilterType = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile(
                title: Text(
                  'Languages',
                  style: getTextStyle('small', color: AppColors.teal),
                ),
                value: 'Languages',
                groupValue: selectedFilterType,
                onChanged: (value) {
                  setModalState(() {
                    selectedFilterType = value!;
                  });
                },
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: RadioListTile(
                title: Text(
                  'Subjects',
                  style: getTextStyle('small', color: AppColors.teal),
                ),
                value: 'Subjects',
                groupValue: selectedFilterType,
                onChanged: (value) {
                  setModalState(() {
                    selectedFilterType = value!;
                  });
                },
              ),
            ),
            Expanded(
              child: RadioListTile(
                title: Text(
                  'Area Radius',
                  style: getTextStyle('small', color: AppColors.teal),
                ),
                value: 'Area Radius',
                groupValue: selectedFilterType,
                onChanged: (value) {
                  setModalState(() {
                    selectedFilterType = value!;
                  });
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: RadioListTile(
            title: Text(
              'Additional Support',
              style: getTextStyle('small', color: AppColors.teal),
            ),
            value: 'Additional Support',
            groupValue: selectedFilterType,
            onChanged: (value) {
              setModalState(() {
                selectedFilterType = value!;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget buildFilterPicker({
    required StateSetter setModalState,
    required String title,
    required IconData icon,
    required List<String> filteredList,
    required FutureProvider provider,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.teal),
                addHorizontalSpace(10),
                Text(
                  title,
                  style: getTextStyle('medium', color: Colors.grey),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(
                    Icons.add,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    ref.watch(provider).when(
                          data: (list) {
                            return showModalBottomSheet(
                              context: context,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                              ),
                              builder: (_) {
                                return ListView.builder(
                                  itemCount: list.length,
                                  itemBuilder: (_, index) {
                                    return ListTile(
                                      title: Text(
                                        list[index],
                                        style: getTextStyle("small"),
                                      ),
                                      onTap: () {
                                        setModalState(() {
                                          if (!filteredList
                                              .contains(list[index])) {
                                            filteredList.add(list[index]);
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
                          loading: () => const CircularProgressIndicator(),
                          error: (err, stack) => Text('Error: $err'),
                        );
                  },
                ),
              ],
            ),
            const Divider(
              color: AppColors.lightTeal,
              thickness: 2,
            ),
          ],
        ),
        addVerticalSpace(8),
        Wrap(
          spacing: 8,
          children: filteredList
              .map(
                (language) => Chip(
                  backgroundColor: AppColors.lightTeal,
                  label: Text(
                    language,
                    style: getTextStyle('small', color: Colors.white),
                  ),
                  deleteIcon: const Icon(Icons.close, color: Colors.white),
                  onDeleted: () {
                    setModalState(() {
                      filteredList.remove(language);
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
    );
  }

  ElevatedButton _buildFilterButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        selectedFilterType = null;
        showFilterBottomSheet(context);
      },
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      ),
      child: Text(
        "Filter",
        style: getTextStyle("mediumBold", color: AppColors.teal),
      ),
    );
  }

  ElevatedButton _buildClearAllFilters(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // handleClearAll();
      },
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      ),
      child: Text(
        "Clear All",
        style: getTextStyle("mediumBold", color: AppColors.white),
      ),
    );
  }

  Widget _buildLastUpdatedText() {
    String displayText;
    if (lastUpdatedTime == null) {
      displayText = "Last Updated: Never";
    } else if (hasWifi) {
      displayText = "Last Updated: Now";
    } else {
      displayText =
          "Last Updated: ${getTimeDifferenceString(lastUpdatedTime!)}";
    }

    return Text(
      displayText,
      style: getTextStyle("small", color: AppColors.white).copyWith(
        shadows: [
          Shadow(
            offset: Offset(1.0, 1.0),
            blurRadius: 2.0,
            color: Colors.black.withOpacity(0.6),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButtons(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      switchInCurve: Curves.easeInOut,
      switchOutCurve: Curves.easeInOut,
      child: polyLineCordinates.isEmpty
          ? Stack(
              alignment: Alignment.bottomRight,
              key: const ValueKey("actions"),
              children: [
                _buildFloatingRowActions(),
                _buildTrackUserLocationButton(context),
              ],
            )
          : null,
    );
  }

  Positioned _buildFloatingRowActions() {
    return Positioned(
      bottom: 5,
      child: SizedBox(
        width: 150,
        height: 50.0,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.lightTeal,
            borderRadius: BorderRadius.circular(50.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  print(loggedUser.id);
                  isStudent
                      ? context.pushNamed(AppRouter.viewSavedCamps.name,
                          extra: loggedUser.id)
                      : context.pushNamed(AppRouter.viewTeachingCamps.name,
                          extra: loggedUser.id);
                },
                icon: Image.asset(
                  "assets/images/tent_icon_white.png",
                  fit: BoxFit.contain,
                  height: 24,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.directions, color: Colors.white),
              ),
              IconButton(
                onPressed: () {
                  isStudent
                      ? null
                      : context.pushNamed(AppRouter.addCampLocation.name);
                },
                icon: isStudent
                    ? Icon(
                        Icons.bookmark,
                        color: Colors.white,
                      )
                    : Image.asset(
                        "assets/images/add_icon.png",
                        fit: BoxFit.contain,
                        height: 24,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Positioned _buildTrackUserLocationButton(BuildContext context) {
    return Positioned(
      bottom: 70.0,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.lightTeal,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () => _trackUserLocation(context),
          icon: Image.asset(
            "assets/images/track_location_icon.png",
            fit: BoxFit.contain,
            height: 24,
          ),
        ),
      ),
    );
  }

  Positioned _routeCancelButton(BuildContext context) {
    return Positioned(
      bottom: 60,
      left: 0,
      right: 0,
      child: Center(
        child: ElevatedButton.icon(
          onPressed: () {
            setState(() {
              polyLineCordinates.clear();
              debugPrint("polyLineCordinates: $polyLineCordinates");
            });
          },
          icon: const Icon(Icons.cancel, color: AppColors.lightTeal),
          label: Text(
            "Cancel Route",
            style: getTextStyle("mediumBold", color: AppColors.lightTeal),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 2,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
        ),
      ),
    );
  }

  Future<void> _trackUserLocation(BuildContext context) async {
    setState(() {
      _followUserLocation = true;
    });

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 10,
        ),
      );

      LatLng userLocation = LatLng(position.latitude, position.longitude);

      if (_googleMapController != null) {
        _googleMapController!.animateCamera(
          CameraUpdate.newLatLngZoom(userLocation, 17),
        );
      }

      setState(() {
        markers
            .removeWhere((marker) => marker.markerId.value == "live_location");
        markers.add(
          Marker(
            markerId: const MarkerId("live_location"),
            position: userLocation,
            icon: liveLocationIcon,
            infoWindow: const InfoWindow(title: "You are here"),
          ),
        );
      });

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error getting location: $e")),
      );
    }
  }

  Widget _buildErrorScreen(Object error) {
    return Center(child: Text('Error: $error'));
  }

  Widget _buildLoadingScreen() {
    return const Center(child: CircularProgressIndicator());
  }

  List<Marker> createMarkers(List<Camp> camps) {
    return camps.map((camp) {
      return Marker(
        markerId: MarkerId(camp.id.toString()),
        position: LatLng(camp.latitude, camp.longitude),
        infoWindow: InfoWindow(
          title: camp.name,
          snippet: camp.description,
        ),
        icon: customIcon,
        onTap: () {
          polyLineCordinates.isEmpty
              ? _showCampDetailsModal(context, camp)
              : null;
        },
      );
    }).toList();
  }

  void _showCampDetailsModal(BuildContext context, Camp camp) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      builder: (context) => CampDetailsModal(
        camp: camp,
        isStudent: isStudent,
        onDirectionsPressed: () {
          setState(() {
            destinationCampLocation = LatLng(camp.latitude, camp.longitude);
          });
          Navigator.pop(context);
          getPolyPoints();
        },
      ),
    );
  }
}

class CampDetailsModal extends ConsumerStatefulWidget {
  final Camp camp;
  final VoidCallback onDirectionsPressed;
  final bool isStudent;

  const CampDetailsModal({
    super.key,
    required this.camp,
    required this.onDirectionsPressed,
    required this.isStudent,
  });

  @override
  ConsumerState<CampDetailsModal> createState() => _CampDetailsModalState();
}

class _CampDetailsModalState extends ConsumerState<CampDetailsModal> {
  late bool isSaved;
  late bool isTeaching;

  @override
  void initState() {
    super.initState();
    User? user = ref.read(loggedInUserNotifierProvider);
    user is Student
        ? isSaved = ref.read(studentProviderNotifier.notifier).isSavedCamp(
            ref.read(loggedInUserNotifierProvider) as Student, widget.camp.id!)
        : isTeaching = ref
            .read(teacherProviderNotifier.notifier)
            .isTeachingCamp(ref.read(loggedInUserNotifierProvider) as Teacher,
                widget.camp.id!);
  }

  void toggleSaveCamp() async {
    final loggedInUser = ref.read(loggedInUserNotifierProvider);

    if (loggedInUser is Student) {
      final studentNotifier = ref.read(loggedInUserNotifierProvider.notifier);

      setState(() {
        isTeaching = !isTeaching;
      });

      try {
        if (isSaved) {
          loggedInUser.savedCamps.add(widget.camp.id!);
        } else {
          loggedInUser.savedCamps.remove(widget.camp.id!);
        }

        await studentNotifier.updateStudent(loggedInUser);
      } catch (e) {
        setState(() {
          isSaved = !isSaved;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating saved camps: $e")),
        );
      }
    } else if (loggedInUser is Teacher) {
      final teacherNotifier = ref.read(loggedInUserNotifierProvider.notifier);

      setState(() {
        isTeaching = !isTeaching;
      });

      try {
        if (isTeaching) {
          loggedInUser.teachingCamps.add(widget.camp.id!);
        } else {
          loggedInUser.teachingCamps.remove(widget.camp.id!);
        }

        await teacherNotifier.updateTeacher(loggedInUser);
      } catch (e) {
        setState(() {
          isTeaching = !isTeaching;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating teaching camps: $e")),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text("Error in determining if user is student or teacher")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            addVerticalSpace(12),
            _buildOptions(context, widget.camp.id),
            addVerticalSpace(12),
            _buildStatusOfResources(),
            addVerticalSpace(12),
            _buildSectionTitle("Additional Support"),
            _buildChips(widget.camp.additionalSupport, getIcon),
            addVerticalSpace(12),
            _buildSectionTitle("Languages Spoken"),
            _buildChips(widget.camp.languages, (_) => Icons.language_rounded),
            addVerticalSpace(12),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              addVerticalSpace(12),
              Row(
                children: [
                  Image.asset(
                    'assets/images/tent_icon_teal.png',
                    height: 24,
                    width: 24,
                    fit: BoxFit.contain,
                  ),
                  addHorizontalSpace(12),
                  Text(
                    widget.camp.name,
                    style: getTextStyle("largeBold", color: AppColors.teal),
                  ),
                ],
              ),
              addVerticalSpace(8),
              Row(
                children: [
                  SizedBox(
                    child: Text(
                      wrapText(widget.camp.description, 45),
                      style: getTextStyle("small", color: Colors.black38),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          if (widget.isStudent)
            Material(
              elevation: 2,
              shape: const CircleBorder(),
              color: const Color.fromARGB(255, 247, 247, 247),
              child: SizedBox(
                height: 36,
                child: IconButton(
                  onPressed: toggleSaveCamp,
                  icon: Icon(
                    isSaved ? Icons.bookmark : Icons.bookmark_outline_outlined,
                    color: AppColors.lightTeal,
                    size: 20,
                  ),
                ),
              ),
            ),
          if (!widget.isStudent)
            Material(
              elevation: 2,
              shape: const CircleBorder(),
              color: const Color.fromARGB(255, 247, 247, 247),
              child: SizedBox(
                height: 36,
                child: IconButton(
                  onPressed: toggleSaveCamp,
                  icon: Icon(
                    isTeaching ? Icons.book : Icons.book_outlined,
                    color: AppColors.lightTeal,
                    size: 20,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOptions(BuildContext context, String? campId) {
    final options = [
      {
        "label": "Directions",
        "icon": Icons.directions,
        "onPressed": widget.onDirectionsPressed,
      },
      {
        "label": "Teachers",
        "icon": Icons.person,
        "onPressed": () {
          print(campId);
          context.goNamed(AppRouter.viewTeachers.name, extra: campId);
        },
      },
      {
        "label": "Classes",
        "icon": Icons.class_,
        "onPressed": () =>
            context.goNamed(AppRouter.viewClasses.name, extra: campId),
      },
      {
        "label": "Images",
        "icon": Icons.image,
        "onPressed": () => print("Opening images"),
      },
      {
        "label": "Facilities",
        "icon": Icons.build,
        "onPressed": () => print("Opening facilities"),
      },
      {
        "label": "Contact Information",
        "icon": Icons.contact_mail,
        "onPressed": () => print("Opening contact information"),
      },
    ];

    return SizedBox(
      height: 50,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: options.map((option) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ElevatedButton.icon(
                onPressed: option["onPressed"] as VoidCallback,
                icon: Icon(option["icon"] as IconData,
                    size: 16, color: Colors.white),
                label: Text(
                  option["label"] as String,
                  style: const TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: option["label"] == "Directions"
                      ? AppColors.orange
                      : AppColors.lightTeal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  minimumSize: const Size(140, 40),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatusOfResources() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.teal,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.info, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "Status of Resources",
                    style: getTextStyle("mediumBold", color: Colors.white),
                  ),
                ],
              ),
              addVerticalSpace(8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.camp.statusOfResources,
                      style: getTextStyle("small", color: Colors.white),
                    ),
                  ),
                ],
              ),
              addVerticalSpace(4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        title,
        style: getTextStyle("mediumBold", color: AppColors.teal),
      ),
    );
  }

  Widget _buildChips(
      List<String>? items, IconData Function(String) iconResolver) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 50,
        child: Wrap(
          children: (items ?? []).map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Chip(
                backgroundColor: AppColors.lightTeal,
                avatar: Icon(iconResolver(item), color: Colors.white),
                label: Text(
                  item,
                  style: getTextStyle('small', color: Colors.white),
                ),
                shape: RoundedRectangleBorder(
                  side: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

IconData getIcon(String support) {
  switch (support) {
    case "Trauma Support":
      return Icons.healing;
    case "Medical Clinic":
      return Icons.local_hospital;
    case "WiFi Access":
      return Icons.wifi;
    case "Food Stall":
      return Icons.fastfood;
    case "Water Station":
      return Icons.water_drop;
    case "Security":
      return Icons.security;
    case "Psychological Support":
      return Icons.psychology;
    case "Library":
      return Icons.library_books;
    case "Sports Facilities":
      return Icons.sports_soccer;
    case "Transport":
      return Icons.directions_bus;
    case "Accessibility Support":
      return Icons.accessible;
    case "Child Care":
      return Icons.child_care;
    case "Health and Safety":
      return Icons.health_and_safety;
    case "Housing Support":
      return Icons.house;
    case "Educational Support":
      return Icons.school;
    case "Translation Services":
      return Icons.translate;
    case "Technical Support":
      return Icons.computer;
    case "Volunteer Programs":
      return Icons.volunteer_activism;
    case "Sanitation Facilities":
      return Icons.soap;
    default:
      return Icons.help_outline;
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    Key? key,
    required this.text,
    required this.color,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: color,
        minimumSize: const Size(120, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
