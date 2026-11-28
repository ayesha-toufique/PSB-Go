
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:psb_go/routes/app_routes.dart';
import 'package:psb_go/controllers/driver/route_details_controller.dart';

import '../../models/route_model.dart';

class RouteDetailsScreen extends StatelessWidget {
  final String routeCode;
  final RouteModel route;

  // Continue button ke liye
  final WidgetBuilder? nextScreenBuilder;

  const RouteDetailsScreen({
    super.key,
    required this.routeCode,
    required this.route,
    this.nextScreenBuilder,
  });

  static const Color darkBlue = Color(0xFF0B3558);
  static const Color primaryColor = Color(0xFF00B995);
  static const Color backgroundColor = Color(0xFFEAF8FC);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      RouteDetailsController(
        routeCode: routeCode,
        route: route,
      ),
    );

    return Scaffold(
      backgroundColor: backgroundColor,

      // Bottom Buttons
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            22,
            12,
            22,
            20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // View Live Tracking Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: controller.openLiveTracking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  child: const Text(
                    'View Live Tracking',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    controller.continueToNext(
                      context,
                      nextScreenBuilder,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: darkBlue,
                    side: const BorderSide(
                      color: primaryColor,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: controller.goBack,
                    icon: const Icon(
                      Icons.arrow_back,
                      color: darkBlue,
                    ),
                  ),

                  const Expanded(
                    child: Text(
                      'Route Details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                      ),
                    ),
                  ),

                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Route Details Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    // Selected Route Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE4F6FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.directions_bus_outlined,
                              color: Color(0xFF00A6B5),
                              size: 30,
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Route $routeCode',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: darkBlue,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  '${controller.startPoint} → '
                                  '${controller.endPoint}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: darkBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.chevron_right,
                            color: primaryColor,
                            size: 27,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Distance and Stops Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            title: 'Total Distance',
                            value: controller.distance,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _buildInfoCard(
                            title: 'Total Stops',
                            value: controller.totalStops.toString(),
                          ),
                        ),
                      ],
                    ),

                    // Map Placeholder
                    const SizedBox(height: 85),

                    Container(
                      width: double.infinity,
                      height: 155,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCEBF0),
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Information Card
  Widget _buildInfoCard({
    required String title,
    required String value,
  }) {
    return Container(
      height: 105,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: darkBlue,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
        ],
      ),
    );
  }
}
