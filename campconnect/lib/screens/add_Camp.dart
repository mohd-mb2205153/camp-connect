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
  late LatLng _scrolledLocation;
  CameraPosition? _initial;
  String addressStr = '';

  @override
  void initState() {
    _default = LatLng(25.3, 51.487);
    _scrolledLocation = _default;
    _initial = CameraPosition(target: _default, zoom: 17);
    _goToUserPostion();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _body(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _goToUserPostion();
          },
          child: Icon(Icons.location_on),
        ),
      ),
    );
  }

  Widget _body() {
    return Stack(
      children: [_getMap(), _customPin(), showAddress()],
    );
  }

  Widget _getMap() {
    return GoogleMap(
      initialCameraPosition: _initial!,
      mapType: MapType.hybrid,
      zoomControlsEnabled: false,
      onCameraIdle: () {
        getAddress(_scrolledLocation);
      },
      onCameraMove: (position) {
        _scrolledLocation = position.target;
      },
      onMapCreated: (GoogleMapController controller) {
        if (!_googleMapController.isCompleted) {
          _googleMapController.complete(controller);
        }
      },
    );
  }

  Future _goToUserPostion() async {
    Position currentPostion = await _userPosition();
    _goToScrolledPosition(
        LatLng(currentPostion.latitude, currentPostion.longitude));
  }

  Future _goToScrolledPosition(LatLng position) async {
    GoogleMapController googleMapController = await _googleMapController.future;
    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: position, zoom: 17)));
    await getAddress(position);
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
    return Center(
      child: SizedBox(
        width: 70,
        child: Lottie.asset('assets/icon/pin.json'),
      ),
    );
  }

  Widget showAddress() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 50,
      decoration: BoxDecoration(color: const Color.fromARGB(255, 5, 174, 152)),
      child: Center(
        child: Text('Set Location to $addressStr',
            style: TextStyle(fontStyle: FontStyle.italic)),
      ),
    );
  }

  Future getAddress(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark address = placemarks[0];
    String fullAddress =
        "${address.street},${address.locality},${address.administrativeArea},${address.country}";
    setState(() {
      addressStr = fullAddress;
    });
  }
}
