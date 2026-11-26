
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() => _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  final MapController mapController = MapController();

  // Karachi demo coordinates
  final LatLng busLocation = LatLng(24.8607, 67.0011);
  final LatLng pickupLocation = LatLng(24.8670, 67.0050);
  final LatLng destinationLocation = LatLng(24.8525, 67.0150);

  double currentZoom = 14;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              height: 65,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF172B4D),
                    ),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        'Live Map',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF172B4D),
                        ),
                      ),
                    ),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none,
                      color: Color(0xFF172B4D),
                      size: 27,
                    ),
                  ),
                ],
              ),
            ),

            // Map
            Expanded(
              child: Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      initialCenter: busLocation,
                      initialZoom: currentZoom,
                      minZoom: 5,
                      maxZoom: 18,
                    ),
                    children: [
                      // OpenStreetMap tiles
                      TileLayer(
                        urlTemplate:
                            'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                        userAgentPackageName: 'com.example.psb_go',
                      ),

                      // Route line
                      PolylineLayer(
                        polylines: [
                          Polyline(
                            points: [
                              pickupLocation,
                              LatLng(24.8645, 67.0060),
                              busLocation,
                              LatLng(24.8570, 67.0090),
                              destinationLocation,
                            ],
                            strokeWidth: 5,
                            color: const Color(0xFF28A745),
                          ),
                        ],
                      ),

                      // Map markers
                      MarkerLayer(
                        markers: [
                          // Pickup marker
                          Marker(
                            point: pickupLocation,
                            width: 50,
                            height: 50,
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 42,
                            ),
                          ),

                          // Bus marker
                          Marker(
                            point: busLocation,
                            width: 55,
                            height: 55,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFF2478E5),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.directions_bus,
                                color: Color(0xFF2478E5),
                                size: 30,
                              ),
                            ),
                          ),

                          // Destination marker
                          Marker(
                            point: destinationLocation,
                            width: 50,
                            height: 50,
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.green,
                              size: 42,
                            ),
                          ),
                        ],
                      ),

                      // Map attribution
                      RichAttributionWidget(
                        attributions: [
                          TextSourceAttribution(
                            'OpenStreetMap contributors',
                            onTap: () {},
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Zoom buttons
                  Positioned(
                    right: 15,
                    top: 20,
                    child: Column(
                      children: [
                        FloatingActionButton.small(
                          heroTag: 'zoom_in',
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF172B4D),
                          onPressed: () {
                            currentZoom++;
                            mapController.move(
                              mapController.camera.center,
                              currentZoom,
                            );
                          },
                          child: const Icon(Icons.add),
                        ),

                        const SizedBox(height: 10),

                        FloatingActionButton.small(
                          heroTag: 'zoom_out',
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF172B4D),
                          onPressed: () {
                            currentZoom--;
                            mapController.move(
                              mapController.camera.center,
                              currentZoom,
                            );
                          },
                          child: const Icon(Icons.remove),
                        ),
                      ],
                    ),
                  ),

                  // Bus information card
                  Positioned(
                    left: 16,
                    right: 16,
                    bottom: 20,
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF2FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.directions_bus,
                              color: Color(0xFF2478E5),
                              size: 29,
                            ),
                          ),

                          const SizedBox(width: 14),

                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bus #0347',
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF172B4D),
                                  ),
                                ),

                                SizedBox(height: 5),

                                Text(
                                  'Your bus is on the way',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE7F7EC),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: Color(0xFF28A745),
                                  size: 9,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  'On Route',
                                  style: TextStyle(
                                    color: Color(0xFF218838),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
