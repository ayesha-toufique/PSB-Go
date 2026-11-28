import 'package:get/get.dart';

// Dev branch driver screens
import 'package:psb_go/view/driver/bus_selection_screen.dart';
import 'package:psb_go/view/driver/driver_home_screen.dart';
import 'package:psb_go/view/driver/status_update_screen.dart';
import 'package:psb_go/view/driver/live _tracking_screen.dart'
    as old_driver_tracking;

// dev_sana branch driver screens
import 'package:psb_go/view/driver1/journey_start_screen.dart';
import 'package:psb_go/view/driver1/live _tracking.dart'
    as new_driver_tracking;
import 'package:psb_go/view/driver1/status_update.dart'
    as new_status_update;

// Passenger screens
import 'package:psb_go/view/passenger/announcements_screen.dart';
import 'package:psb_go/view/passenger/explore_routes_screen.dart';
import 'package:psb_go/view/passenger/favourite_screen.dart';
import 'package:psb_go/view/passenger/passenger_home_screen.dart';
import 'package:psb_go/view/passenger/pickup_point_screen.dart';
import 'package:psb_go/view/passenger/drop_point_screen.dart';
import 'package:psb_go/view/passenger/live_map_screen.dart';

// Common screens
import '../view/splash_screen.dart';
import '../view/login_screen.dart';
import '../view/signup_screen.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
    ),

    // Passenger routes
    GetPage(
      name: AppRoutes.passengerHome,
      page: () => const PassengerHomeScreen(),
    ),
    GetPage(
      name: AppRoutes.pickupPoint,
      page: () => const PickupPointScreen(),
    ),
    GetPage(
      name: AppRoutes.dropPoint,
      page: () => const DropPointScreen(),
    ),
    GetPage(
      name: AppRoutes.liveMap,
      page: () => const LiveMapScreen(),
    ),
    GetPage(
      name: AppRoutes.favourites,
      page: () => const FavouriteScreen(),
    ),
    GetPage(
      name: AppRoutes.announcements,
      page: () => const AnnouncementsScreen(),
    ),
    GetPage(
      name: AppRoutes.exploreRoutes,
      page: () => const ExploreRoutesScreen(),
    ),

    // Dev branch driver routes
    GetPage(
      name: AppRoutes.driverHome,
      page: () => DriverHomeScreen(),
    ),
    GetPage(
      name: AppRoutes.driverBusSelection,
      page: () => BusSelectionScreen(),
    ),
    GetPage(
      name: AppRoutes.LiveTracking,
      page: () => old_driver_tracking.LiveTrackingScreen(),
    ),
    GetPage(
      name: AppRoutes.StatusUpdate,
      page: () => StatusUpdateScreen(),
    ),

    // dev_sana driver journey routes
    GetPage(
      name: AppRoutes.journeyStart,
      page: () {
        final args =
            Get.arguments as Map<String, dynamic>? ?? {};

        return JourneyStartedScreen(
          routeCode: args['routeCode'] ?? '',
          startLocation: args['startLocation'] ?? '',
          endLocation: args['endLocation'] ?? '',
        );
      },
    ),
    GetPage(
      name: AppRoutes.liveTracking,
      page: () => const new_driver_tracking.LiveTrackingScreen(),
    ),
    GetPage(
      name: AppRoutes.statusUpdate,
      page: () => const new_status_update.StatusUpdateScreen(),
    ),
  ];
}