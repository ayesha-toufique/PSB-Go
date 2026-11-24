
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:psb_go/constants/app_colors.dart';
import 'package:psb_go/controllers/driver/driver_controller.dart';

class LiveTrackingScreen extends StatefulWidget {
  const LiveTrackingScreen({super.key});

  @override
  State<LiveTrackingScreen> createState() =>
      _LiveTrackingScreenState();
}

class _LiveTrackingScreenState extends State<LiveTrackingScreen> {
  GoogleMapController? mapController;

  // Sample Karachi coordinates.
  // Replace these with actual GPS coordinates from your backend.
  static const LatLng busLocation = LatLng(24.8945, 67.1910);
  static const LatLng nextStopLocation = LatLng(24.8958, 67.1980);

  late final Set<Marker> markers = {
    Marker(
      markerId: const MarkerId('bus'),
      position: busLocation,
      infoWindow: const InfoWindow(title: 'PSB Go Bus'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueAzure,
      ),
    ),
    Marker(
      markerId: const MarkerId('next_stop'),
      position: nextStopLocation,
      infoWindow: const InfoWindow(title: 'Malir Halt'),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueGreen,
      ),
    ),
  };

  late final Set<Polyline> polylines = {
    const Polyline(
      polylineId: PolylineId('bus_route'),
      points: [
        LatLng(24.8890, 67.1790),
        LatLng(24.8910, 67.1830),
        LatLng(24.8930, 67.1870),
        busLocation,
        nextStopLocation,
      ],
      color: Color(0xFF00A6D6),
      width: 5,
    ),
  };

  static const CameraPosition initialCameraPosition =
      CameraPosition(
    target: busLocation,
    zoom: 14.5,
  );

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    AppColors.darkBackgroundStart,
                    AppColors.darkBackgroundEnd,
                  ]
                : [
                    AppColors.lightBackgroundStart,
                    AppColors.lightBackgroundEnd,
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // HEADER
              _buildHeader(colors),

              // MAP AND NEXT STOP
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(
                    10,
                    75,
                    10,
                    20,
                  ),
                  child: Column(
                    children: [
                      _buildGoogleMap(),

                      const SizedBox(height: 26),

                      _buildNextStopCard(
                        colors,
                        isDark,
                      ),
                    ],
                  ),
                ),
              ),

              // END JOURNEY BUTTON
              _buildEndJourneyButton(),
            ],
          ),
        ),
      ),
    );
  }

  // HEADER
  Widget _buildHeader(ColorScheme colors) {
    return SizedBox(
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_rounded,
                color: colors.onSurface,
                size: 25,
              ),
            ),
          ),

          Text(
            'Live Tracking',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // GOOGLE MAP
  Widget _buildGoogleMap() {
    return Container(
      height: 145,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      child: GoogleMap(
        initialCameraPosition: initialCameraPosition,

        markers: markers,

        polylines: polylines,

        mapType: MapType.normal,

        compassEnabled: false,

        mapToolbarEnabled: false,

        zoomControlsEnabled: false,

        myLocationButtonEnabled: false,

        onMapCreated: (controller) {
          mapController = controller;
        },
      ),
    );
  }

  // NEXT STOP CARD
  Widget _buildNextStopCard(
    ColorScheme colors,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(
        minHeight: 110,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark
              ? AppColors.darkBorder
              : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 58,
            width: 58,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkBackgroundEnd
                  : const Color(0xFFE1F7FC),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              Icons.directions_bus_outlined,
              color: isDark
                  ? AppColors.brandCyan
                  : AppColors.brandTeal,
              size: 35,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Next Stop',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'Malir Halt',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  'Arriving in 2 min',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const Icon(
            Icons.chevron_right_rounded,
            color: Colors.lightBlue,
            size: 30,
          ),
        ],
      ),
    );
  }

  // END JOURNEY BUTTON
  Widget _buildEndJourneyButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        18,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF4058),
                Color(0xFFFF0038),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF1744)
                    .withOpacity(0.18),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _confirmEndJourney,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'End Journey',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // CONFIRM AND END JOURNEY USING EXISTING CONTROLLER
  void _confirmEndJourney() {
    Get.dialog(
      AlertDialog(
        title: const Text('End Journey?'),
        content: const Text(
          'Are you sure you want to end your current journey?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Continue'),
          ),

          TextButton(
            onPressed: _endJourney,
            child: const Text(
              'End Journey',
              style: TextStyle(
                color: AppColors.brandRed,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _endJourney() async {
    if (!Get.isRegistered<DriverController>()) {
      Get.back();

      Get.snackbar(
        'Error',
        'Driver controller is not registered.',
      );

      return;
    }

    final controller = Get.find<DriverController>();

    if (controller.isEndingJourney.value) return;

    final success = await controller.endJourney();

    if (success) {
      Get.back();
      Get.back();
    }
  }
}
