import 'dart:async';
import 'package:campconnect/models/camp.dart';
import 'package:campconnect/models/teacher.dart';
import 'package:campconnect/models/user.dart';
import 'package:campconnect/providers/camp_provider.dart';
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
  // List<String> filteredLanguages = [];
  // List<String> filteredSubjects = [];
  // List<String> filteredAdditional = [];

  String? selectedFilterType;
  TextEditingController areaRadiusController = TextEditingController();

  GoogleMapController? _googleMapController;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(31.525033, 34.442683), zoom: 10);

  Set<Marker> markers = {};
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor liveLocationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor customIconMarked = BitmapDescriptor.defaultMarker;

  // late StreamSubscription<Position> _positionStreamSubscription;
  bool _followUserLocation = true;

  late LatLng currentLocation;
  late LatLng destinationCampLocation;
  List<LatLng> polyLineCordinates = [];
  List<String> savedOrTeachingCamps = [];

  DateTime? _lastWifiConnectionTime;

  @override
  void initState() {
    super.initState();
    _loadCustomIcons();
    // _startLiveLocationUpdates();
    initializeUserDetails();
    ref.read(campProviderNotifier.notifier).initializeCamps();

    Timer.periodic(const Duration(seconds: 8), (timer) {
      if (mounted) {
        checkWifiStatus().then((status) {
          if (status) {
            _lastWifiConnectionTime = DateTime.now();
          }
          setState(() {
            hasWifi = status;
          });
        });
      } else {
        timer.cancel();
      }
    });
  }

  Future<bool> checkWifiStatus() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    bool wifiConnected = connectivityResult == ConnectivityResult.wifi;

    if (!wifiConnected && _lastWifiConnectionTime == null) {
      _lastWifiConnectionTime = DateTime.now();
    }

    return wifiConnected;
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

  void initializeUserDetails() {
    Future.microtask(() {
      final userNotifier = ref.read(loggedInUserNotifierProvider.notifier);

      isStudent = userNotifier.isStudent;
      isTeacher = userNotifier.isTeacher;

      if (isStudent) {
        loggedUser = userNotifier.student;
        savedOrTeachingCamps = loggedUser.savedCamps;
      } else if (isTeacher) {
        loggedUser = userNotifier.teacher;
        savedOrTeachingCamps = loggedUser.teachingCamps;
      }

      ref.read(showNavBarNotifierProvider.notifier).showBottomNavBar(true);

      setState(() {});
    });
  }

  @override
  void dispose() {
    // _positionStreamSubscription.cancel();
    _googleMapController?.dispose();
    areaRadiusController.dispose();
    super.dispose();
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        request: PolylineRequest(
            origin: PointLatLng(31.525033, 34.442683),
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

  @override
  Widget build(BuildContext context) {
    ref.watch(loggedInUserNotifierProvider);

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

    _loadCustomIcon("assets/images/tent_icon_marked.png", const Size(48, 48),
        (icon) {
      customIconMarked = icon;
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

  // void _startLiveLocationUpdates() {
  //   _positionStreamSubscription = Geolocator.getPositionStream(
  //     locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
  //   ).listen(_updateLiveLocationMarker);
  // }

  void _updateLiveLocationMarker(Position position) {
    //LatLng userLocation = LatLng(position.latitude, position.longitude);
    LatLng userLocation = LatLng(31.525033, 34.442683);

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

  AppBar? _buildAppBar({Camp? camp}) {
    return polyLineCordinates.isEmpty
        ? null
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
              _buildCircleIconButton(Icons.search, () {
                context.pushNamed(AppRouter.searchCamps.name).then((_) {
                  List<double>? selectedCampLocation =
                      ref.read(selectedCampLocationProvider);
                  if (selectedCampLocation == null) {
                    return;
                  }
                  setState(() {
                    _googleMapController?.moveCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                            target: LatLng(selectedCampLocation[0],
                                selectedCampLocation[1]),
                            zoom: 17.75),
                      ),
                    );
                  });
                });
                ref
                    .read(showNavBarNotifierProvider.notifier)
                    .showBottomNavBar(false);
              }),
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

  void _buildFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SizedBox(
          height: screenHeight(context) * .45,
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Row(
                          children: [
                            const Icon(Icons.tune, color: Colors.teal),
                            const SizedBox(width: 10),
                            Text(
                              "Filter Camps",
                              style: getTextStyle('mediumBold',
                                  color: Colors.teal),
                            ),
                            Spacer(),
                            _buildApplyFilterButton(setModalState),
                            Spacer(),
                            _buildClearAllFilters(setModalState),
                          ],
                        ),
                      ),
                      addVerticalSpace(8),
                      Divider(
                        color: AppColors.teal,
                        height: 20,
                      ),
                      Wrap(
                        children: [
                          Row(
                            children: [
                              _buildFilterRadio(
                                title: 'Educational Level',
                                onChanged: (value) {
                                  setModalState(() {
                                    areaRadiusController.text = '';
                                    selectedFilterType = value!;
                                  });
                                },
                              ),
                              _buildFilterRadio(
                                title: 'Area Radius',
                                onChanged: (value) {
                                  setModalState(() {
                                    filteredEduLevels = [];
                                    selectedFilterType = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     _buildFilterRadio(
                          //         setModalState: setModalState,
                          //         title: 'Subjects'),
                          //     _buildFilterRadio(
                          //         setModalState: setModalState,
                          //         title: 'Languages'),
                          //   ],
                          // ),
                          // Expanded(
                          //   child: RadioListTile(
                          //     title: Text(
                          //       'Additional Support',
                          //       style: getTextStyle('small',
                          //           color: AppColors.teal),
                          //     ),
                          //     value: 'Additional Support',
                          //     groupValue: selectedFilterType,
                          //     onChanged: (value) {
                          //       setModalState(() {
                          //         selectedFilterType = value!;
                          //       });
                          //     },
                          //   ),
                          // ),
                        ],
                      ),
                      Divider(
                        color: AppColors.teal,
                        height: 20,
                        thickness: 1,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (selectedFilterType == 'Educational Level')
                        _buildFilterPicker(
                          setModalState: setModalState,
                          title: 'Filter Educational Level',
                          filteredList: filteredEduLevels,
                          icon: Icons.school,
                          provider: studentEducationLevelProvider,
                        ),
                      // if (selectedFilterType == 'Languages')
                      //   _buildFilterPicker(
                      //       setModalState: setModalState,
                      //       title: 'Filter Languages',
                      //       icon: Icons.language,
                      //       filteredList: filteredLanguages,
                      //       provider: languagesProvider),
                      // if (selectedFilterType == 'Subjects')
                      //   _buildFilterPicker(
                      //       setModalState: setModalState,
                      //       title: 'Filter Subjects',
                      //       icon: Icons.subject,
                      //       filteredList: filteredSubjects,
                      //       provider: subjectsProvider),
                      // if (selectedFilterType == 'Additional Support')
                      //   _buildFilterPicker(
                      //       setModalState: setModalState,
                      //       title: 'Additional Support',
                      //       icon: Icons.health_and_safety_rounded,
                      //       filteredList: filteredAdditional,
                      //       provider: additionalSupportProvider),
                      if (selectedFilterType == 'Area Radius')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Filter Area Radius (Km):',
                              style:
                                  getTextStyle('medium', color: AppColors.teal),
                            ),
                            SizedBox(
                              width: 150,
                              child: EditScreenTextField(
                                label: 'Radius',
                                controller: areaRadiusController,
                                type: TextInputType.number,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    ).whenComplete(() {
      setState(
        () {
          markers.clear();
        },
      );
      filteredEduLevels = [];
      areaRadiusController.text = '';
    });
  }

  ElevatedButton _buildApplyFilterButton(StateSetter setModalState) {
    return ElevatedButton(
      onPressed: () async {
        if (areaRadiusController.text.isNotEmpty) {
          ref.read(campProviderNotifier.notifier).initializeCamps();
          try {
            //Get current location
            Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high,
            );

            double radius = double.parse(areaRadiusController.text);

            setModalState(() {
              ref.read(campProviderNotifier.notifier).filterByRange(
                    position.latitude,
                    position.longitude,
                    radius,
                  );

              // Pan the camera to users location
              if (_googleMapController != null) {
                _googleMapController!.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(position.latitude, position.longitude),
                    12,
                  ),
                );
              }
            });
            Navigator.pop(context);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${e.toString()}'),
              ),
            );
            print(e);
          }
        }
        if (filteredEduLevels.isNotEmpty) {
          setState(() {
            ref
                .read(campProviderNotifier.notifier)
                .filterByEducationLevel(filteredEduLevels);
          });
        }
      },
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: AppColors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 2,
          horizontal: 10,
        ),
      ),
      child: Text(
        "Apply",
        style: getTextStyle("smallBold", color: AppColors.white),
      ),
    );
  }

  Widget _buildFilterRadio(
      {required String title, required Function(String?)? onChanged}) {
    return Expanded(
      child: RadioListTile(
        title: Text(
          title,
          style: getTextStyle('small', color: AppColors.teal),
        ),
        value: title,
        groupValue: selectedFilterType,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildFilterPicker({
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
                    ref.watch(provider).whenData(
                      (list) {
                        setState(() {
                          showModalBottomSheet(
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
                        });
                      },
                    );
                  },
                ),
              ],
            ),
            addVerticalSpace(8),
            const Divider(
              color: AppColors.lightTeal,
              thickness: 1,
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
        debugPrint("Showing filter");
        _buildFilterBottomSheet(context);
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

  void handleClearFilter() {
    setState(() {
      ref.read(campProviderNotifier.notifier).initializeCamps();
      filteredEduLevels = [];
      areaRadiusController.text = '';
      markers.clear();
      // filteredAdditional = [];
      // filteredLanguages = [];
      // filteredSubjects = [];
    });
  }

  ElevatedButton _buildClearAllFilters(StateSetter setModalState) {
    return ElevatedButton(
      onPressed: () {
        setModalState(() {
          handleClearFilter();
        });
      },
      style: ElevatedButton.styleFrom(
        elevation: 2,
        backgroundColor: Colors.teal,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      ),
      child: Text(
        "Clear All",
        style: getTextStyle("smallBold", color: AppColors.white),
      ),
    );
  }

  Widget _buildLastUpdatedText() {
    String displayText;

    if (hasWifi) {
      displayText = "Last Updated: Now";
    } else if (_lastWifiConnectionTime != null) {
      displayText =
          "Last Updated: ${getTimeDifferenceString(_lastWifiConnectionTime!)}";
    } else {
      displayText = "Last Updated: Unknown";
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
        width: isTeacher ? 100 : 50,
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
              if (isTeacher)
                IconButton(
                  onPressed: () {
                    context.pushNamed(AppRouter.addCampLocation.name);
                  },
                  icon: Image.asset(
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
      // LatLng userLocation = LatLng(position.latitude, position.longitude);
      LatLng userLocation = LatLng(31.525033, 34.442683);

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
        icon: savedOrTeachingCamps.contains(camp.id!)
            ? customIconMarked
            : customIcon,
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
        campId: camp.id!,
        isStudent: isStudent,
        onDirectionsPressed: () {
          setState(() {
            destinationCampLocation = LatLng(camp.latitude, camp.longitude);
          });
          Navigator.pop(context);
          getPolyPoints();
        },
      ),
    ).whenComplete(() {
      setState(() {
        loggedUser = ref.read(loggedInUserNotifierProvider);
        savedOrTeachingCamps =
            isTeacher ? loggedUser.teachingCamps : loggedUser.savedCamps;
        markers.clear();
      });
    });
  }
}

class CampDetailsModal extends ConsumerStatefulWidget {
  final String campId;
  final VoidCallback onDirectionsPressed;
  final bool isStudent;

  const CampDetailsModal({
    super.key,
    required this.campId,
    required this.onDirectionsPressed,
    required this.isStudent,
  });

  @override
  ConsumerState<CampDetailsModal> createState() => _CampDetailsModalState();
}

class _CampDetailsModalState extends ConsumerState<CampDetailsModal> {
  Camp? camp;
  int savedStudentCount = 0;
  late bool isSaved;
  late bool isTeaching;

  @override
  void initState() {
    super.initState();
    initializeStates();
    fetchSavedStudentCount();
  }

  void fetchSavedStudentCount() async {
    if (widget.campId.isNotEmpty) {
      int count = await ref
          .read(campProviderNotifier.notifier)
          .getSavedStudentCountForCamp(widget.campId);

      if (mounted) {
        setState(() {
          savedStudentCount = count;
        });
      }
    }
  }

  void initializeStates() {
    ref
        .read(campProviderNotifier.notifier)
        .getCampById(widget.campId)
        .then((data) => camp = data)
        .whenComplete(() => setState(() {}));
    User? user = ref.read(loggedInUserNotifierProvider);
    if (user is Student) {
      isSaved = ref.read(studentProviderNotifier.notifier).isSavedCamp(
          ref.read(loggedInUserNotifierProvider) as Student, widget.campId);
      isTeaching = false;
    } else {
      isTeaching = ref.read(teacherProviderNotifier.notifier).isTeachingCamp(
          ref.read(loggedInUserNotifierProvider) as Teacher, widget.campId);
      isSaved = false;
    }
  }

  void toggleCamp() {
    final loggedInUser = ref.watch(loggedInUserNotifierProvider);
    final campNotifer = ref.read(campProviderNotifier.notifier);

    if (loggedInUser is Student) {
      final studentNotifier = ref.read(studentProviderNotifier.notifier);

      setState(() {
        isSaved = !isSaved;
      });

      try {
        if (isSaved) {
          loggedInUser.savedCamps.add(widget.campId);
        } else {
          loggedInUser.savedCamps.remove(widget.campId);
        }

        studentNotifier.updateStudent(loggedInUser);
      } catch (e) {
        setState(() {
          isSaved = !isSaved;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating saved camps: $e")),
        );
      }
    } else if (loggedInUser is Teacher) {
      final teacherNotifier = ref.read(teacherProviderNotifier.notifier);

      setState(() {
        isTeaching = !isTeaching;
      });

      try {
        if (isTeaching) {
          teacherNotifier.addCampToTeacher(
              teacherId: loggedInUser.id!, campId: widget.campId);
          campNotifer.addTeacherToCamp(
              teacherId: loggedInUser.id!, campId: widget.campId);
        } else {
          teacherNotifier.removeTeachingCampFromTeacher(
              teacherId: loggedInUser.id!, campId: widget.campId);
          campNotifer.removeCampsClass(
              targetTeacherId: loggedInUser.id!, campId: widget.campId);
        }
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
            addVerticalSpace(12),
            _buildHeader(context),
            addVerticalSpace(12),
            _buildOptions(context, widget.campId),
            addVerticalSpace(12),
            _buildSectionTitle("Current Capacity"),
            addVerticalSpace(12),
            _buildCapacity(),
            addVerticalSpace(12),
            _buildStatusOfResources(),
            addVerticalSpace(12),
            _buildSectionTitle("Offered Educational Levels"),
            _buildChips(
                camp?.educationLevel, (_) => Icons.school, AppColors.lightTeal),
            addVerticalSpace(12),
            _buildSectionTitle("Additional Support"),
            _buildChips(camp?.additionalSupport, getIcon, AppColors.lightTeal),
            addVerticalSpace(12),
            _buildSectionTitle("Languages Spoken"),
            _buildChips(camp?.languages, (_) => Icons.language_rounded,
                AppColors.orange),
            addVerticalSpace(12),
          ],
        ),
      ),
    );
  }

  Padding _buildCapacity() {
    final savedStudentCount =
        ref.watch(savedStudentCountProvider(widget.campId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Chip(
        backgroundColor: AppColors.orange,
        avatar: Icon(
          Icons.person,
          color: Colors.white,
          size: 16,
        ),
        label: savedStudentCount.when(
          data: (count) => Text(
            "Enrolled $count out of ${camp?.capacity ?? 0} Students",
            style: getTextStyle('small', color: Colors.white),
          ),
          loading: () => Text(
            "Loading...",
            style: getTextStyle('small', color: Colors.white),
          ),
          error: (err, _) => Text(
            "Error",
            style: getTextStyle('small', color: Colors.white),
          ),
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.transparent),
          borderRadius: BorderRadius.circular(20),
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
                    wrapText(camp?.name ?? '', 22),
                    style: getTextStyle("largeBold", color: AppColors.teal),
                  ),
                ],
              ),
              addVerticalSpace(8),
              Row(
                children: [
                  SizedBox(
                    child: Text(
                      wrapText(camp?.description ?? '', 45),
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
                  onPressed: toggleCamp,
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
                  onPressed: toggleCamp,
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
          context
              .pushNamed(AppRouter.viewTeachers.name, extra: campId)
              .then((_) => initializeStates());
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
                      camp?.statusOfResources ?? '',
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

  Widget _buildChips(List<String>? items,
      IconData Function(String) iconResolver, Color? color) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        height: 50,
        child: Wrap(
          children: (items ?? []).map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Chip(
                backgroundColor: color ?? AppColors.lightTeal,
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
