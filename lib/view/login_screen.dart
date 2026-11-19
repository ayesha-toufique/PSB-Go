import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../routes/app_routes.dart';
import '../constants/app_colors.dart';
import '../utils/helpers/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../controllers/theme_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.put(AuthController());

    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(
                      Icons.arrow_back,
                      color: AppColors.navy,
                    ),
                    Obx(
                      () => IconButton(
                        onPressed: () {
                          Get.find<ThemeController>().toggleTheme();
                        },
                        icon: Icon(
                          Get.find<ThemeController>().isDarkMode.value
                              ? Icons.light_mode
                              : Icons.dark_mode,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                const Icon(
                  Icons.directions_bus_rounded,
                  size: 75,
                  color: AppColors.red,
                ),

                const SizedBox(height: 5),

                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: 'PSB ',
                        style: TextStyle(color: AppColors.navy),
                      ),
                      TextSpan(
                        text: 'Go',
                        style: TextStyle(color: AppColors.teal),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Track • Ride • Explore',
                  style: TextStyle(color: AppColors.navy),
                ),

                const SizedBox(height: 65),

                CustomTextField(
                  hint: 'Email Address',
                  icon: Icons.email_outlined,
                  controller: emailController,
                  validator: Validators.email,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 18),

                Obx(
                  () => CustomTextField(
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    controller: passwordController,
                    validator: Validators.password,
                    obscureText: !auth.isPasswordVisible.value,
                    suffixIcon: IconButton(
                      onPressed: auth.togglePassword,
                      icon: Icon(
                        auth.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: AppColors.navy,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Obx(
                  () => CustomButton(
                    title: 'Login',
                    isLoading: auth.isLoading.value,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        auth.login(
                          email: emailController.text,
                          password: passwordController.text,
                        );
                      }
                    },
                  ),
                ),

                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Get.toNamed(AppRoutes.forgotPassword);
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: AppColors.navy,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: AppColors.navy,
                        fontSize: 13,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(AppRoutes.signup);
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          color: AppColors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}