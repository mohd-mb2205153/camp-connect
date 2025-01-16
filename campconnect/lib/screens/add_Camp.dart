import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddCamp extends ConsumerStatefulWidget {
  const AddCamp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddCamp();
}

class _AddCamp extends ConsumerState<AddCamp> {
  late GoogleMapController _googleMapController;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(37.42, -122), zoom: 14);

  Set<Marker> markers = {};

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Enable your Location.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Future.error("Error.");
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Current Location"),
        centerTitle: true,
      ),
      body: GoogleMap(
        initialCameraPosition: initialCameraPosition,
        markers: markers,
        zoomControlsEnabled: false,
        mapType: MapType.hybrid,
        onMapCreated: (GoogleMapController controller) {
          _googleMapController = controller;
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            Position position = await getCurrentLocation();
            _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(position.latitude, position.longitude),
                    zoom: 14)));

            markers.add(Marker(
                markerId: const MarkerId("Current Location"),
                position: LatLng(position.latitude, position.longitude)));

            setState(() {});
          },
          label: Text("Get Current Location"),
          icon: Icon(Icons.location_city)),
    );
  }
}
