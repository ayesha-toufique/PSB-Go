
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../constants/app_colors.dart';
import '../utils/helpers/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../routes/app_routes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late final AuthController auth;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final cnicController = TextEditingController();
  final licenseController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    auth = Get.isRegistered<AuthController>()
        ? Get.find<AuthController>()
        : Get.put(AuthController());
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmController.dispose();
    cnicController.dispose();
    licenseController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // LIGHT AND DARK BACKGROUND GRADIENT
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
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 25,
                    vertical: 15,
                  ),
                
                  child: Form(
                    key: formKey,
                
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                
                        // HEADER
                        Row(
                          children: [
                
                            IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: Icon(
                                Icons.arrow_back,
                                color: colors.onSurface,
                              ),
                            ),
                
                            Expanded(
                              child: Text(
                                'Create Account',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: colors.onSurface,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                
                            Icon(
                              Icons.notifications_none,
                              color: colors.onSurface,
                              size: 23,
                            ),
                
                            const SizedBox(width: 8),
                          ],
                        ),
                
                        const SizedBox(height: 15),
                
                        // TAGLINE
                        Text(
                          'Join PSB Go for a smarter journey',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colors.onSurface,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                
                        const SizedBox(height: 25),
                
                        // PASSENGER / DRIVER SELECTION
                        Obx(
                          () => Row(
                            children: [
                
                              Expanded(
                                child: roleButton(
                                  context: context,
                                  title: 'Passenger',
                                  selected:
                                      auth.selectedRole.value ==
                                          'passenger',
                                  onTap: () {
                                    auth.selectRole('passenger');
                                  },
                                ),
                              ),
                
                              const SizedBox(width: 12),
                
                              Expanded(
                                child: roleButton(
                                  context: context,
                                  title: 'Driver',
                                  selected:
                                      auth.selectedRole.value ==
                                          'driver',
                                  onTap: () {
                                    auth.selectRole('driver');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                
                        const SizedBox(height: 20),
                
                        // FULL NAME
                        CustomTextField(
                          hint: 'Full Name',
                          icon: Icons.person_outline,
                          controller: nameController,
                          validator: Validators.name,
                          keyboardType: TextInputType.name,
                        ),
                
                        const SizedBox(height: 15),
                
                        // EMAIL
                        CustomTextField(
                          hint: 'Email Address',
                          icon: Icons.email_outlined,
                          controller: emailController,
                          validator: Validators.email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                
                        const SizedBox(height: 15),
                
                        // PASSWORD
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
                
                        const SizedBox(height: 15),
                
                        // CONFIRM PASSWORD
                        CustomTextField(
                          hint: 'Confirm Password',
                          icon: Icons.lock_outline,
                          controller: confirmController,
                          obscureText: true,
                
                          validator: (value) {
                            return Validators.confirmPassword(
                              value,
                              passwordController.text,
                            );
                          },
                        ),
                
                        // DRIVER-ONLY FIELDS
                        Obx(
                          () {
                            if (auth.selectedRole.value != 'driver') {
                              return const SizedBox.shrink();
                            }
                
                            return Column(
                              children: [
                
                                const SizedBox(height: 15),
                
                                // CNIC
                                CustomTextField(
                                  hint: 'CNIC Number',
                                  icon: Icons.credit_card_outlined,
                                  controller: cnicController,
                                  validator: Validators.cnic,
                                  keyboardType: TextInputType.number,
                                ),
                
                                const SizedBox(height: 15),
                
                                // DRIVING LICENSE
                                CustomTextField(
                                  hint: 'Driving License Number',
                                  icon: Icons.badge_outlined,
                                  controller: licenseController,
                                  validator: Validators.license,
                                ),
                
                                const SizedBox(height: 12),
                
                                Text(
                                  'Your driver account will remain pending until an admin verifies your documents.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.darkSecondaryText
                                        : AppColors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                
                        const SizedBox(height: 30),
                
                        // CREATE ACCOUNT BUTTON
                        Obx(
                          () => CustomButton(
                            title: 'Create Account',
                            isLoading: auth.isLoading.value,
                
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                auth.signup(
                                  name: nameController.text.trim(),
                                  email: emailController.text.trim(),
                                  password: passwordController.text,
                                  cnic: cnicController.text.trim(),
                                  licenseNo:
                                      licenseController.text.trim(),
                                );
                              }
                            },
                          ),
                        ),
                
                        const SizedBox(height: 15),
                
                        // LOGIN NAVIGATION
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                
                            Text(
                              'Already have an account?',
                              style: TextStyle(
                                color: colors.onSurface,
                                fontSize: 13,
                              ),
                            ),
                
                            TextButton(
                              onPressed: () {
                                Get.offNamed(AppRoutes.login);
                              },
                
                              child: Text(
                                'Login',
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
              );
            },
          ),
        ),
      ),
    );
  }

  // PASSENGER / DRIVER ROLE BUTTON
  Widget roleButton({
    required BuildContext context,
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final colors = Theme.of(context).colorScheme;
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,

      child: Container(
        height: 45,
        alignment: Alignment.center,

        decoration: BoxDecoration(
          color: selected
              ? colors.secondary
              : colors.surface,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(
            color: selected
                ? colors.secondary
                : isDark
                    ? AppColors.darkBorder
                    : AppColors.lightBorder,
          ),
        ),

        child: Text(
          title,
          style: TextStyle(
            color: selected
                ? Colors.white
                : colors.onSurface,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
