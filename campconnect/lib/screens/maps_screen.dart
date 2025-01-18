import 'package:campconnect/models/camp.dart';
import 'package:campconnect/providers/camp_provider.dart';
import 'package:campconnect/theme/styling_constants.dart';
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
  GoogleMapController? _googleMapController; // Make it nullable
  static const CameraPosition initialCameraPosition =
      CameraPosition(target: LatLng(25.3, 51.487), zoom: 10);

  Set<Marker> markers = {};
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor liveLocationIcon = BitmapDescriptor.defaultMarker;

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
      setState(() {
        customIcon = icon;
      });
    });

    BitmapDescriptor.asset(
      const ImageConfiguration(size: Size(32, 32)),
      "assets/images/current_location_icon.png",
    ).then((icon) {
      setState(() {
        liveLocationIcon = icon;
      });
    });
  }

  Future<void> _startLiveLocationUpdates() async {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) {
      LatLng userLocation = LatLng(position.latitude, position.longitude);

      // Update the live location marker
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

      // Move the camera only if _googleMapController is initialized
      if (_googleMapController != null) {
        _googleMapController!.animateCamera(
          CameraUpdate.newLatLng(userLocation),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(campProviderNotifier).when(
          data: (data) {
            markers.addAll(createMarkers(data));
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                    onPressed: () {}, icon: const Icon(Icons.search)),
                title: const Text("Camps around you"),
                centerTitle: true,
              ),
              body: GoogleMap(
                initialCameraPosition: initialCameraPosition,
                markers: markers,
                zoomControlsEnabled: false,
                mapType: MapType.normal,
                myLocationButtonEnabled: false,
                onMapCreated: (controller) {
                  _googleMapController = controller;
                },
              ),
              floatingActionButton: floatingActionColumn(context),
            );
          },
          error: (err, stack) => Text('Error: $err'),
          loading: () => const CircularProgressIndicator(),
        );
  }

  Stack floatingActionColumn(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Small container under the FAB
        Positioned(
          bottom: 5, // Adjust position below the FAB
          child: Container(
            width: 20.0,
            height: 5.0,
            decoration: BoxDecoration(
              color: AppColors.lightTeal, // Small container color
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ),
        // Floating Action Button
        Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Container(
            width: 56.0,
            height: 56.0,
            decoration: BoxDecoration(
              color: AppColors.lightTeal,
              shape: BoxShape.circle, // Enforces circular shape
            ),
            child: IconButton(
              onPressed: () async {
                try {
                  // Get the user's current position
                  Position position = await Geolocator.getCurrentPosition();
                  LatLng userLocation =
                      LatLng(position.latitude, position.longitude);

                  if (_googleMapController != null) {
                    // Animate the camera to the user's location with zoom and compass reset
                    _googleMapController!.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: userLocation,
                          zoom: 17.0, // Street-level zoom
                          bearing: 0.0, // Resets compass direction to north
                          tilt: 0.0, // Resets any tilt to a flat map view
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  // Handle any errors, e.g., location permissions
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error fetching location: $e')),
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
        ),
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
