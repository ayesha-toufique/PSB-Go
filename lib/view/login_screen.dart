
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:psb_go/constants/app_assets.dart';

import '../controllers/auth_controller.dart';
import '../controllers/theme_controller.dart';
import '../routes/app_routes.dart';
import '../constants/app_colors.dart';
import '../utils/helpers/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final AuthController auth;
  late final ThemeController themeController;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    auth = Get.put(AuthController());
    themeController = Get.find<ThemeController>();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // FULL SCREEN GRADIENT
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),

                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 25,
                      vertical: 20,
                    ),

                    child: Form(
                      key: formKey,

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [

                          // BACK BUTTON AND THEME TOGGLE
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [

                              IconButton(
                                onPressed: () {
                                  if (Get.key.currentState?.canPop() ??
                                      false) {
                                    Get.back();
                                  }
                                },
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: colors.onSurface,
                                  size: 26,
                                ),
                              ),

                              Obx(
                                () => IconButton(
                                  onPressed: () {
                                    themeController.toggleTheme();
                                  },
                                  icon: Icon(
                                    themeController.isDarkMode.value
                                        ? Icons.light_mode
                                        : Icons.dark_mode,
                                    color: colors.onSurface,
                                    size: 25,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 25),

                          // APP LOGO
                          SvgPicture.asset(
                            AppAssets.logo,
                            width: 150,
                            height: 130,
                            fit: BoxFit.contain,
                          ),

                          const SizedBox(height: 3),

                          // APP TAGLINE
                          Text(
                            'Track • Ride • Explore',
                            style: TextStyle(
                              color: isDark
                                  ? AppColors.darkPrimaryText
                                  : const Color(0xFF00274F),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 65),

                          // EMAIL FIELD
                          CustomTextField(
                            hint: 'Email Address',
                            icon: Icons.email_outlined,
                            controller: emailController,
                            validator: Validators.email,
                            keyboardType: TextInputType.emailAddress,
                          ),

                          const SizedBox(height: 18),

                          // PASSWORD FIELD
                          Obx(
                            () => CustomTextField(
                              hint: 'Password',
                              icon: Icons.lock_outline,
                              controller: passwordController,
                              validator: Validators.password,
                              obscureText:
                                  !auth.isPasswordVisible.value,

                              suffixIcon: IconButton(
                                onPressed: auth.togglePassword,
                                icon: Icon(
                                  auth.isPasswordVisible.value
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: colors.onSurface,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 25),

                          // LOGIN BUTTON
                          Obx(
                            () => CustomButton(
                              title: 'Login',
                              isLoading: auth.isLoading.value,

                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  auth.login(
                                    email: emailController.text.trim(),
                                    password: passwordController.text,
                                  );
                                }
                              },
                            ),
                          ),

                          // FORGOT PASSWORD
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton(
                              onPressed: () {
                                Get.toNamed(
                                  AppRoutes.forgotPassword,
                                );
                              },

                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: colors.onSurface,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 35),

                          // SIGNUP NAVIGATION
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: colors.onSurface,
                                  fontSize: 13,
                                ),
                              ),

                              TextButton(
                                onPressed: () {
                                  Get.toNamed(AppRoutes.signup);
                                },

                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: colors.secondary,
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
            },
          ),
        ),
      ),
    );
  }
}
