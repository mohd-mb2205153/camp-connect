import 'dart:async';

import 'package:campconnect/models/camp.dart';
import 'package:campconnect/providers/camp_provider.dart';
import 'package:campconnect/theme/constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:group_button/group_button.dart';

class MapsScreen extends ConsumerStatefulWidget {
  const MapsScreen({super.key});

  @override
  ConsumerState<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends ConsumerState<MapsScreen> {
  GoogleMapController? _googleMapController;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(25.3, 51.487), zoom: 10);

  Set<Marker> markers = {};
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor liveLocationIcon = BitmapDescriptor.defaultMarker;

  late StreamSubscription<Position> _positionStreamSubscription;
  bool _followUserLocation = true;

  LatLng currentLocation = LatLng(25.186226, 51.555231);
  LatLng destinationCampLocation = LatLng(25.263923, 51.532632);
  List<LatLng> polyLineCordinates = [];

  @override
  void initState() {
    super.initState();
    _loadCustomIcons();
    _startLiveLocationUpdates();
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    _googleMapController?.dispose();
    super.dispose();
  }

  void getPolyPoints() async {
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      request: 
        PolylineRequest(
          origin: PointLatLng(currentLocation.latitude, currentLocation.longitude), 
          destination: PointLatLng(destinationCampLocation.latitude, destinationCampLocation.longitude), 
          mode: TravelMode.driving),
      googleApiKey: google_api_key
      );

      print("This is the current Location: $currentLocation");
      print("This is the camp locations: $destinationCampLocation");

      if (result.points.isNotEmpty){
        result.points.forEach((PointLatLng point) => 
          polyLineCordinates.add(LatLng(point.latitude, point.longitude)));
      setState(() {});
      }
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(campProviderNotifier).when(
          data: (data) => _buildMapScreen(context, data),
          error: (err, stack) => _buildErrorScreen(err),
          loading: () => _buildLoadingScreen(),
        );
  }

  // Method to load custom marker icons
  void _loadCustomIcons() {
    _loadCustomIcon("assets/images/tent_icon.png", (icon) {
      customIcon = icon;
    });
    _loadCustomIcon("assets/images/current_location_icon.png", (icon) {
      liveLocationIcon = icon;
    });
  }

  void _loadCustomIcon(String assetPath, Function(BitmapDescriptor) callback) {
    BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      assetPath,
    ).then((icon) {
      if (mounted) {
        setState(() {
          callback(icon);
        });
      }
    });
  }

  // Method to start live location updates
  void _startLiveLocationUpdates() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen(_updateLiveLocationMarker);
  }

  void _updateLiveLocationMarker(Position position) {
    LatLng userLocation = LatLng(position.latitude, position.longitude);

    if (mounted) {
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
    }

    if (_followUserLocation && _googleMapController != null) {
      _googleMapController!.animateCamera(
        CameraUpdate.newLatLng(userLocation),
      );
    }
  }

  // Method to build the main map screen
  Widget _buildMapScreen(BuildContext context, List<Camp> data) {
    markers.addAll(createMarkers(data));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _buildTransparentAppBar(),
      body: Stack(
        children: [
          _buildGoogleMap(),
          _buildHeader(context),
        ],
      ),
      floatingActionButton: _buildFloatingActionButtons(context),
    );
  }

  AppBar _buildTransparentAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
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
        Polyline(polylineId: PolylineId("route"),
          points: polyLineCordinates,
          color: Colors.redAccent)
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
          _buildHeaderButtons(context),
          addVerticalSpace(12),
          _buildLastUpdatedText(),
        ],
      ),
    );
  }

  Row _buildHeaderButtons(BuildContext context) {
    return Row(
      children: [
        _buildCircleIconButton(Icons.search, () {}),
        const Spacer(),
        _buildFilterButton(),
        const Spacer(),
        _buildCircleIconButton(Icons.settings, () {}),
      ],
    );
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

  ElevatedButton _buildFilterButton() {
    return ElevatedButton(
      onPressed: () {
        // Filter button action
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

  Widget _buildLastUpdatedText() {
    return Text(
      "Last Updated: Now",
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

  Stack _buildFloatingActionButtons(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        _buildFloatingRowActions(),
        _buildTrackUserLocationButton(context),
      ],
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
                onPressed: () {},
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
                onPressed: () {},
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

  Future<void> _trackUserLocation(BuildContext context) async {
    setState(() {
      _followUserLocation = true;
    });

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Fetching your location...")),
      );

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

  // Error screen builder
  Widget _buildErrorScreen(Object error) {
    return Center(child: Text('Error: $error'));
  }

  // Loading screen builder
  Widget _buildLoadingScreen() {
    return const Center(child: CircularProgressIndicator());
  }

  // Marker creation
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
          _showCampDetailsModal(context, camp);
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
      builder: (context) => CampDetailsModal(camp: camp),
    );
  }
}

class CampDetailsModal extends StatelessWidget {
  final Camp camp;

  const CampDetailsModal({Key? key, required this.camp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String>? additionalSupport = camp.additionalSupport;
    final List<String>? languages = camp.languages;

    final List<Map<String, dynamic>> options = [
      {
        "label": "Directions",
        "icon": Icons.directions,
        "onPressed": () {
          print("opening directions");
        },
      },
      {
        "label": "Teachers",
        "icon": Icons.person,
        "onPressed": () {
          print("opening teachers");
        },
      },
      {
        "label": "Classes",
        "icon": Icons.class_,
        "onPressed": () {
          print("opening classes");
        },
      },
      {
        "label": "Images",
        "icon": Icons.image,
        "onPressed": () {
          print("opening images");
        },
      },
      {
        "label": "Facilities",
        "icon": Icons.build,
        "onPressed": () {
          print("opening facilities");
        },
      },
      {
        "label": "Contact Information",
        "icon": Icons.contact_mail,
        "onPressed": () {
          print("opening contact information");
        },
      },
    ];

    return SizedBox(
      height: 500,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
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
                            camp.name,
                            style: getTextStyle("largeBold",
                                color: AppColors.teal),
                          ),
                        ],
                      ),
                      addVerticalSpace(8),
                      Row(
                        children: [
                          SizedBox(
                            child: Text(
                              wrapText(camp.description, 50),
                              style:
                                  getTextStyle("small", color: Colors.black38),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Material(
                    elevation: 2,
                    shape: const CircleBorder(),
                    color: const Color.fromARGB(255, 247, 247, 247),
                    child: SizedBox(
                      height: 36,
                      child: IconButton(
                        onPressed: () {},
                        icon: SizedBox(
                          child: Icon(
                            Icons.bookmark,
                            color: AppColors.lightTeal,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
              child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: options.asMap().entries.map((entry) {
                      int index = entry.key;
                      final option = entry.value;
                      final label = option["label"] as String;
                      final icon = option["icon"] as IconData;
                      final onPressed = option["onPressed"] as VoidCallback;
                      return Padding(
                        padding: index == 0
                            ? const EdgeInsets.symmetric(horizontal: 8)
                            : const EdgeInsets.only(right: 8),
                        child: ElevatedButton.icon(
                          onPressed: onPressed,
                          icon: Icon(
                            icon,
                            size: 16,
                            color: Colors.white,
                          ),
                          label: Text(
                            label,
                            style: const TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: label == "Directions"
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
                  )),
            ),
            addVerticalSpace(12),
            Padding(
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
                          Icon(
                            Icons.info,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            "Status of Resources",
                            style:
                                getTextStyle("mediumBold", color: Colors.white),
                          ),
                        ],
                      ),
                      addVerticalSpace(8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              camp.statusOfResources,
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
            ),
            addVerticalSpace(12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Text(
                    "Additional Support",
                    style: getTextStyle(
                      "mediumBold",
                      color: AppColors.teal,
                    ),
                  ),
                ],
              ),
            ),
            addVerticalSpace(12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: 50,
                child: Wrap(
                  children: (additionalSupport ?? []).map((support) {
                    return Padding(
                      padding: additionalSupport?.indexOf(support) == 0
                          ? EdgeInsets.symmetric(horizontal: 8)
                          : EdgeInsets.only(right: 8),
                      child: Chip(
                        backgroundColor: AppColors.lightTeal,
                        avatar: Icon(
                          getIcon(support), // Use the String to map the icon
                          color: Colors.white,
                        ),
                        label: Text(
                          support,
                          style: getTextStyle('small', color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            addVerticalSpace(12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Text(
                    "Languages Spoken",
                    style: getTextStyle(
                      "mediumBold",
                      color: AppColors.teal,
                    ),
                  ),
                ],
              ),
            ),
            addVerticalSpace(12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                height: 50,
                child: Wrap(
                  children: (languages ?? []).map((lang) {
                    return Padding(
                      padding: languages?.indexOf(lang) == 0
                          ? EdgeInsets.symmetric(horizontal: 8)
                          : EdgeInsets.only(right: 8),
                      child: Chip(
                        backgroundColor: AppColors.lightTeal,
                        avatar: Icon(
                          Icons.language_rounded,
                          color: Colors.white,
                        ),
                        label: Text(
                          lang,
                          style: getTextStyle('small', color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            addVerticalSpace(12),
          ],
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
