import 'package:get/get.dart';

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

      Get.snackbar('Success', result['message'] ?? 'Login successful');

      if (nextStep == 'driver_verification') {
        Get.offAllNamed(AppRoutes.driverVerification);
      } else {
        // Temporary destination until the role dashboards are implemented.
        Get.snackbar('Logged in', 'Your ${result['user']['role']} account is active.');
      }
    } catch (e) {
      Get.snackbar('Login Error', e.toString().replaceFirst('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }
}