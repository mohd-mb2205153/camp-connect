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
  
  BitmapDescriptor customIcon =  BitmapDescriptor.defaultMarker;
  @override
  void initState() {
    customMarker();
    super.initState();
  }
  void customMarker() {
    BitmapDescriptor.asset(
      const ImageConfiguration(), 
      "assets/images/tent-icon.png",
      ).then((icon){
      setState(() {
        customIcon = icon;
      });
    });
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: (){}, 
          icon: Icon(Icons.search)),
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

            markers.add(Marker(
                markerId: const MarkerId("Current Location"),
                position: LatLng(position.latitude, position.longitude)));
            
            markers.add(Marker(
              markerId: MarkerId("Camp 1"),
              position: LatLng(25.252094, 51.517181),
              infoWindow: InfoWindow(
                title: "Camp 1",
                snippet: "This is an educational camp for elementary school students"
                ),
              icon: customIcon,
              onTap: () {
                showModalBottomSheet(
                  context: context, 
                  builder: (BuildContext context) {
                    return Container(
                      height: 300,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Camp #1", 
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text("An educational camp ", 
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                  onPressed: (){},
                                  style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: (Colors.blue),
                                  minimumSize: Size(120, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )
                                ), 
                                  child: Text("Directions",
                                  style: TextStyle(color: Colors.white),),
                                  ),
                                ElevatedButton(
                                  onPressed: (){},
                                  style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: (Colors.greenAccent),
                                  minimumSize: Size(120, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )
                                ), 
                                  child: Text("Teachers",
                                  style: TextStyle(color: Colors.white),), 
                                  ),
                                ElevatedButton(
                                  onPressed: (){},
                                  style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: (Colors.blueAccent),
                                  minimumSize: Size(120, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )
                                ), 
                                  child: Text("Subjects",
                                  style: TextStyle(color: Colors.white),),
                                  )
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  });
              },
              ));
            setState(() {});
          },
          label: Text("Get Current Location"),
          icon: Icon(Icons.location_city)),
    );
  }
}
