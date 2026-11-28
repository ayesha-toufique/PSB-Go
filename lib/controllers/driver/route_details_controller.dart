
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:psb_go/models/route_model.dart';
import 'package:psb_go/routes/app_routes.dart';

class RouteDetailsController extends GetxController {
  final String routeCode;
  final RouteModel route;

  RouteDetailsController({
    required this.routeCode,
    required this.route,
  });

  // Temporary hardcoded distance
  // Backend connect hone par yahan se remove kar dena
  final Map<String, String> routeDistances = {
    'R1': '31 KM',
    'R2': '31 KM',
    'R3': '32 KM',
    'R4': '26 KM',
    'R5': '28.2 KM',
    'R6': '29.6 KM',
    'R7': 'Not available',
    'R8': '17 KM',
    'R9': '48 KM',
    'R10': '30 KM',
    'R11': '21 KM',
    'R12': '36 KM',
    'R13': '19 KM',
    'R14': '29 KM',
    'EV1': '41 KM',
    'EV2': '44 KM',
    'EV3': '23 KM',
    'EV4': '58 KM',
    'EV5': '48 KM',
    'DD01': '24 KM',
  };

  // Starting stop
  String get startPoint {
    if (route.stops.isEmpty) {
      return 'Not available';
    }

    return route.stops.first.name;
  }

  // Ending stop
  String get endPoint {
    if (route.stops.isEmpty) {
      return 'Not available';
    }

    return route.stops.last.name;
  }

  // Route distance
  String get distance {
    return routeDistances[routeCode] ?? 'Not available';
  }

  // Total stops
  int get totalStops {
    return route.stops.length;
  }

  // Back button
  void goBack() {
    Get.back();
  }

  // Live tracking button
  void openLiveTracking() {
    Get.toNamed(AppRoutes.liveTracking);
  }

  // Continue button
  void continueToNext(
    BuildContext context,
    WidgetBuilder? nextScreenBuilder,
  ) {
    if (nextScreenBuilder != null) {
      Get.to(() => nextScreenBuilder(context));
    } else {
      Get.snackbar(
        'Now',
        'Next screen will be connected',
      );
    }
  }
}
