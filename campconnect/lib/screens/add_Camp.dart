import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart';

class AddCamp extends ConsumerStatefulWidget {
  const AddCamp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddCamp();
}

class _AddCamp extends ConsumerState<AddCamp> {
  Completer<GoogleMapController> _googleMapController = Completer();
  late LatLng _default;
  CameraPosition? _initial;

  @override
  void initState() {
    _default = LatLng(25.3, 51.487);
    _initial = CameraPosition(target: _default, zoom: 15);
    _goToUserPostion();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
    );
  }

  Widget _body() {
    return Stack(
      children: [_getMap()],
    );
  }

  Widget _getMap() {
    return GoogleMap(
      initialCameraPosition: _initial!,
      mapType: MapType.hybrid,
      onCameraIdle: () {},
      onCameraMove: (position) {},
      onMapCreated: (GoogleMapController controller) {
        if (!_googleMapController.isCompleted) {
          _googleMapController.complete(controller);
        }
      },
    );
  }

  Future _goToUserPostion() async {
    Position currentPostion = await _userPosition();
    _goToPosition(LatLng(currentPostion.latitude, currentPostion.longitude));
  }

  Future _goToPosition(LatLng position) async {
    GoogleMapController googleMapController = await _googleMapController.future;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 15)));
  }

  Future _userPosition() async {
    LocationPermission locationPermission;
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!isLocationServiceEnabled) {
      print("Please enable Location Permission.");
    }

    locationPermission = await Geolocator.checkPermission();

    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        Future.error("Permission denied");
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      Future.error("Permission denied.");
    }

    // ignore: deprecated_member_use
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Widget _customPin() {
    return Container(child: Lottie.asset('/'));
  }
}
