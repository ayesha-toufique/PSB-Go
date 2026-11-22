
import 'package:get/get.dart';
import 'package:psb_go/view/passenger/favourite_screen.dart';

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
  ];
}
