import 'dart:async';

import 'package:campconnect/models/camp.dart';
import 'package:campconnect/providers/camp_provider.dart';
import 'package:campconnect/theme/styling_constants.dart';
import 'package:campconnect/utils/helper_widgets.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    _loadCustomIcons();
    _startLiveLocationUpdates();
  }

  void _loadCustomIcons() {
    BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      "assets/images/tent_icon.png",
    ).then((icon) {
      if (mounted) {
        setState(() {
          customIcon = icon;
        });
      }
    });

    BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(32, 32)),
      "assets/images/current_location_icon.png",
    ).then((icon) {
      if (mounted) {
        setState(() {
          liveLocationIcon = icon;
        });
      }
    });
  }

  void _startLiveLocationUpdates() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) {
      LatLng userLocation = LatLng(position.latitude, position.longitude);

      if (mounted) {
        setState(() {
          markers.removeWhere(
              (marker) => marker.markerId.value == "live_location");
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
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    _googleMapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(campProviderNotifier).when(
          data: (data) {
            markers.addAll(createMarkers(data));
            return Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: Stack(
                children: [
                  GoogleMap(
                    initialCameraPosition: initialCameraPosition,
                    markers: markers,
                    zoomControlsEnabled: false,
                    mapType: MapType.terrain,
                    myLocationButtonEnabled: false,
                    onMapCreated: (controller) {
                      _googleMapController = controller;
                    },
                    onTap: (LatLng location) {
                      // Stop following user location when the map is tapped
                      setState(() {
                        _followUserLocation = false;
                      });
                    },
                    onCameraMove: (CameraPosition position) {
                      // Stop following user location when the user moves the map
                      setState(() {
                        _followUserLocation = false;
                      });
                    },
                  ),
                  Positioned(
                    top: 64,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 24.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.lightTeal,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.search,
                                      color: Colors.white),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                            const Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                // filter btn action
                              },
                              style: ElevatedButton.styleFrom(
                                elevation: 2,
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 50,
                                ),
                              ),
                              child: Text(
                                "Filter",
                                style: getTextStyle("mediumBold",
                                    color: AppColors.teal),
                              ),
                            ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 24.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppColors.lightTeal,
                                  shape: BoxShape.circle,
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.settings,
                                      color: Colors.white),
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ],
                        ),
                        addVerticalSpace(12),
                        Text(
                          "Last Updated: " + "Now",
                          style: getTextStyle(
                            "small",
                            color: AppColors.white,
                          ).copyWith(
                            shadows: [
                              Shadow(
                                offset: Offset(1.0, 1.0),
                                blurRadius: 2.0,
                                color: Colors.black.withOpacity(0.6),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              floatingActionButton: floatingActionColumn(context),
            );
          },
          error: (err, stack) => Center(child: Text('Error: $err')),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
  }

  Stack floatingActionColumn(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Positioned(
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
                    icon: const Icon(
                      Icons.directions,
                      color: Colors.white,
                    ),
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
        ),
        Positioned(
          bottom: 70.0,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.lightTeal,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () async {
                setState(() {
                  _followUserLocation = true; // Re-enable location tracking
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

                  LatLng userLocation =
                      LatLng(position.latitude, position.longitude);

                  if (_googleMapController != null) {
                    _googleMapController!.animateCamera(
                      CameraUpdate.newLatLngZoom(userLocation, 17),
                    );
                  }

                  setState(() {
                    markers.removeWhere(
                        (marker) => marker.markerId.value == "live_location");
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
              },
              icon: Image.asset(
                "assets/images/track_location_icon.png",
                fit: BoxFit.contain,
                height: 24,
              ),
            ),
          ),
        )
      ],
    );
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
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            builder: (context) => CampDetailsModal(camp: camp),
          );
        },
      );
    }).toList();
  }
}

class CampDetailsModal extends StatelessWidget {
  final Camp camp;

  const CampDetailsModal({Key? key, required this.camp}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> additionalSupport = [
      {"label": "Trauma Support", "icon": Icons.healing},
      {"label": "Medical Clinic", "icon": Icons.local_hospital},
      {"label": "WiFi Access", "icon": Icons.wifi},
      {"label": "Food Stall", "icon": Icons.fastfood},
      {"label": "Water Station", "icon": Icons.water_drop},
      {"label": "Food Stall", "icon": Icons.fastfood},
      {"label": "Water Station", "icon": Icons.water_drop},
      {"label": "Food Stall", "icon": Icons.fastfood},
      {"label": "Water Station", "icon": Icons.water_drop},
    ];

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

    return Container(
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
                          Text(
                            "camp.description",
                            style: getTextStyle("small", color: Colors.black38),
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
                        icon: Image.asset(
                          "assets/images/upload_icon_teal.png",
                          fit: BoxFit.contain,
                          height: 20,
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
                  children: options.map((option) {
                    final label = option["label"] as String;
                    final icon = option["icon"] as IconData;
                    final onPressed = option["onPressed"] as VoidCallback;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
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
                ),
              ),
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
                              "We need more resources to support ongoing projects.",
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
                  children: additionalSupport
                      .map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Chip(
                            backgroundColor: AppColors.lightTeal,
                            avatar: Icon(
                              item["icon"],
                              color: Colors.white,
                            ),
                            label: Text(
                              item["label"],
                              style: getTextStyle('small', color: Colors.white),
                            ),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(
                                color: Colors.transparent,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
