import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/auth_service.dart';
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  final isLoading = false.obs;
  final isPasswordVisible = false.obs;

  final selectedRole = 'passenger'.obs;

  void togglePassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void selectRole(String role) {
    selectedRole.value = role;
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
    String? cnic,
    String? licenseNo,
  }) async {
    try {
      isLoading.value = true;

      final result = await _authService.register(
        name: name,
        email: email,
        password: password,
        role: selectedRole.value,
        cnic: cnic,
        licenseNo: licenseNo,
      );

      Get.snackbar(
        'Success',
        result['message'] ?? 'Account created successfully',
      );

      if (selectedRole.value == 'driver') {
        Get.offAllNamed(AppRoutes.driverVerification);
      } else {
        Get.offAllNamed(AppRoutes.login);
      }
    } catch (e) {
      Get.snackbar('Registration Error', e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;

      final result = await _authService.login(
        email: email,
        password: password,
      );

      final nextStep = result['nextStep'];
      final user = result['user'];

final prefs = await SharedPreferences.getInstance();

await prefs.setString(
  'userName',
  user['name'] ?? 'Passenger',
);

      Get.snackbar('Success', result['message'] ?? 'Login successful');
      if (nextStep == 'driver_verification') {
  Get.offAllNamed(AppRoutes.driverVerification);
} else if (nextStep == 'driver_dashboard') {
  Get.offAllNamed(AppRoutes.driverHome);
} else if (nextStep == 'passenger_home') {
  Get.offAllNamed(AppRoutes.passengerHome);
} else {
  Get.snackbar(
    'Login Error',
    'Unable to identify your account role.',
  );
}
    } catch (e) {
      Get.snackbar('Login Error', e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }
}