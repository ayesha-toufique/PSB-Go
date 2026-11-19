import 'package:get/get.dart';
import '../view/login_screen.dart';
import '../view/signup_screen.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    // GetPage(
    //   name: AppRoutes.splash,
    //   page: () => const SplashScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.onboarding,
    //   page: () => const OnboardingScreen(),
    // ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
    ),
    // GetPage(
    //   name: AppRoutes.forgotPassword,
    //   page: () => const ForgotPasswordScreen(),
    // ),
    // GetPage(
    //   name: AppRoutes.driverVerification,
    //   page: () => const DriverVerificationScreen(),
    // ),
  ];
}