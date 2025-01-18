import 'package:campconnect/models/camp.dart';
import 'package:campconnect/providers/camp_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsScreen extends ConsumerStatefulWidget {
  const MapsScreen({super.key});

  @override
  ConsumerState<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends ConsumerState<MapsScreen> {
  late GoogleMapController _googleMapController;
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(25.3, 51.487), zoom: 10);

  Set<Marker> markers = {};

  Future<Position> getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      return Future.error("Enable your Location.");
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Error.");
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;

  @override
  void initState() {
    super.initState();
    BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(48, 48)),
      "assets/images/tent-logo.png",
    ).then((icon) {
      setState(() {
        customIcon = icon;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(campProviderNotifier).when(
          data: (data) {
            markers.addAll(createMarkers(data));
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(onPressed: () {}, icon: Icon(Icons.search)),
                title: const Text("Camps around you"),
                centerTitle: true,
              ),
              body: GoogleMap(
                initialCameraPosition: initialCameraPosition,
                markers: markers,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                onMapCreated: (controller) {
                  _googleMapController = controller;
                },
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () async {
                  Position position = await getCurrentLocation();
                  markers.add(Marker(
                      markerId: const MarkerId("Current Location"),
                      position: LatLng(position.latitude, position.longitude)));
                  setState(() {});
                },
                label: const Text(""),
                icon: const Icon(Icons.my_location),
              ),
            );
          },
          error: (err, stack) => Text('Error: $err'),
          loading: () => const CircularProgressIndicator(),
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
    return Container(
      height: 300,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            camp.name,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(camp.description),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ActionButton(
                text: "Directions",
                color: Colors.blue,
                onPressed: () {},
              ),
              _ActionButton(
                text: "Teachers",
                color: Colors.greenAccent,
                onPressed: () {},
              ),
              _ActionButton(
                text: "Subjects",
                color: Colors.blueAccent,
                onPressed: () {},
              ),
            ],
          ),
        ],
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
