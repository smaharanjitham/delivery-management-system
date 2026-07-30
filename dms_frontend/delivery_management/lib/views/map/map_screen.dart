import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  final String customerName;
  final String address;
  final double latitude;
  final double longitude;

  const MapScreen({
    super.key,
    required this.customerName,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Completer<GoogleMapController> controller = Completer();

  LatLng? currentLocation;

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    Position position = await Geolocator.getCurrentPosition();

    currentLocation = LatLng(position.latitude, position.longitude);

    markers = {
      Marker(
        markerId: const MarkerId("driver"),
        position: currentLocation!,
        infoWindow: const InfoWindow(title: "Your Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),

      Marker(
        markerId: const MarkerId("delivery"),
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: InfoWindow(
          title: widget.customerName,
          snippet: widget.address,
        ),
      ),
    };

    final mapController = await controller.future;

    mapController.animateCamera(
      CameraUpdate.newLatLngZoom(currentLocation!, 14),
    );

    setState(() {});
  }

  Future<void> openGoogleMaps() async {
    final url =
        "https://www.google.com/maps/dir/?api=1&destination=${widget.latitude},${widget.longitude}";

    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Delivery Map")),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(widget.latitude, widget.longitude),
                zoom: 14,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              markers: markers,
              onMapCreated: (mapController) {
                controller.complete(mapController);
              },
            ),
          ),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              boxShadow: const [
                BoxShadow(blurRadius: 8, color: Colors.black12),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.local_shipping),
                  ),
                  title: Text(widget.customerName),
                  subtitle: Text(widget.address),
                ),

                const SizedBox(height: 10),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: openGoogleMaps,
                    icon: const Icon(Icons.navigation),
                    label: const Text("Navigate"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
