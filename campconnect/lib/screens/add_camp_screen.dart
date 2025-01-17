import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddCampScreen extends ConsumerStatefulWidget {
  final String location;
  const AddCampScreen({super.key, required this.location});

  @override
  ConsumerState<AddCampScreen> createState() => _AddCampScreenState();
}

class _AddCampScreenState extends ConsumerState<AddCampScreen> {
  Future<String> getAddress(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark address = placemarks[0];
    String fullAddress =
        "${address.street},${address.locality},${address.administrativeArea},${address.country}";
    return fullAddress;
  }

  @override
  Widget build(BuildContext context) {
    String locationString = widget.location;
    List<String> latlng = locationString.split(",");
    double latitude = double.parse(latlng[0]);
    double longitude = double.parse(latlng[1]);
    LatLng location = LatLng(latitude, longitude);

    return const Placeholder(
      child: Text("it is working lattidue"),
    );
  }
}
