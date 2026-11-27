
import 'package:get/get.dart';
import 'package:psb_go/view/driver/bus_selection_screen.dart';
import 'package:psb_go/view/driver/driver_home_screen.dart';
import 'package:psb_go/view/driver/status_update_screen.dart';
import 'package:psb_go/view/passenger/announcements_screen.dart';
import 'package:psb_go/view/passenger/explore_routes_screen.dart';
import 'package:psb_go/view/passenger/favourite_screen.dart';
import '../view/driver/live _tracking_screen.dart';
import 'app_routes.dart';
import '../view/splash_screen.dart';
import '../view/login_screen.dart';
import '../view/signup_screen.dart';
import '../view/passenger/passenger_home_screen.dart';
import '../view/passenger/pickup_point_screen.dart';
import '../view/passenger/drop_point_screen.dart';
import '../view/passenger/live_map_screen.dart';

class AppPages {
  
  static final pages = [
    GetPage(name: AppRoutes.splash, 
    page: () => const SplashScreen()
    ),

    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
    ),
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
  page: () => LiveTrackingScreen(),
),

GetPage(
  name: AppRoutes.StatusUpdate,
  page: () => StatusUpdateScreen(),
),
  ];
}
