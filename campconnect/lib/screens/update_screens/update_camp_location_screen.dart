import 'dart:async';
import 'package:campconnect/routes/app_router.dart';
import 'package:campconnect/theme/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;

import '../../providers/camp_provider.dart';
import '../../models/camp.dart';

class UpdateCampLocationScreen extends ConsumerStatefulWidget {
  final String campId;

  const UpdateCampLocationScreen({super.key, required this.campId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _UpdateCampLocationScreenState();
}

class _UpdateCampLocationScreenState
    extends ConsumerState<UpdateCampLocationScreen> {
  final Completer<GoogleMapController> _googleMapController = Completer();
  late LatLng _default;
  late LatLng _scrolledLocation;
  late String _transferString;
  CameraPosition? _initial;
  String addressStr = '';
  Set<Marker> markers = {};
  BitmapDescriptor liveLocationIcon = BitmapDescriptor.defaultMarker;
  bool _followUserLocation = true;
  late StreamSubscription<Position> _positionStreamSubscription;

  @override
  void initState() {
    super.initState();
    _default = LatLng(25.3, 51.487); // Default fallback location
    _scrolledLocation = _default;
    _initial = CameraPosition(target: _default, zoom: 17);

    _loadCustomIcons();
    _fetchCampLocation(); // Fetch the actual camp location
    _startLiveLocationUpdates();
  }

  /// Fetches the camp's current location and updates the map accordingly
  Future<void> _fetchCampLocation() async {
    try {
      Camp? camp = await ref
          .read(campProviderNotifier.notifier)
          .getCampById(widget.campId);

      if (camp != null && camp.latitude != null && camp.longitude != null) {
        LatLng campLocation = LatLng(camp.latitude!, camp.longitude!);

        setState(() {
          _default = campLocation;
          _scrolledLocation = _default;
          _initial = CameraPosition(target: _default, zoom: 17);

          // Add marker for the camp's existing location
          markers.clear();
          markers.add(
            Marker(
              markerId: const MarkerId("camp_location"),
              position: _default,
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueBlue),
              infoWindow: const InfoWindow(title: "Camp's Current Location"),
            ),
          );
        });

        final controller = await _googleMapController.future;
        controller.animateCamera(CameraUpdate.newLatLngZoom(_default, 17));
      }
    } catch (e) {
      debugPrint("Error fetching camp location: $e");
    }
  }

  void _loadCustomIcons() {
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

      if (_followUserLocation && _googleMapController.isCompleted) {
        _googleMapController.future.then((controller) {
          controller.animateCamera(CameraUpdate.newLatLng(userLocation));
        });
      }
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: AppColors.lightTeal,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Update Camp Location',
          style: getTextStyle("mediumBold", color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: _initial!,
            markers: markers,
            zoomControlsEnabled: false,
            myLocationButtonEnabled: false,
            onMapCreated: (controller) {
              if (!_googleMapController.isCompleted) {
                _googleMapController.complete(controller);
              }
            },
            onCameraMove: (CameraPosition position) {
              _scrolledLocation = position.target;
              _followUserLocation = false;
            },
          ),
          Center(
            child: SizedBox(
              width: 70,
              child: lottie.Lottie.asset('assets/icon/pin.json'),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    _transferString =
                        '${_scrolledLocation.latitude}|${_scrolledLocation.longitude}|$addressStr';
                    context.pushNamed(AppRouter.updateCamp.name,
                        pathParameters: {
                          'location': _transferString,
                          'campId': widget.campId
                        });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.lightTeal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Update",
                    style: getTextStyle("small", color: AppColors.white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          color: AppColors.lightTeal,
          shape: BoxShape.circle,
        ),
        child: IconButton(
          onPressed: () async {
            setState(() {
              _followUserLocation = true;
            });
            try {
              Position position = await Geolocator.getCurrentPosition(
                locationSettings: const LocationSettings(
                  accuracy: LocationAccuracy.high,
                ),
              );

              LatLng userLocation =
                  LatLng(position.latitude, position.longitude);

              final GoogleMapController controller =
                  await _googleMapController.future;
              controller.animateCamera(
                CameraUpdate.newLatLngZoom(userLocation, 17),
              );

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
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Error getting location: $e")),
              );
            }
          },
          icon: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(4.0),
            child: Image.asset(
              "assets/images/track_location_icon.png",
              fit: BoxFit.contain,
              height: 24,
            ),
          ),
        ),
      ),
    );
  }
}
