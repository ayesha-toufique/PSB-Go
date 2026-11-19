import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../constants/app_colors.dart';
import '../utils/helpers/validators.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../routes/app_routes.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.put(AuthController());

    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmController = TextEditingController();
    final cnicController = TextEditingController();
    final licenseController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                 Text(
                  'Join PSB Go for a smarter journey',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 25),

                // Role selection
                Obx(
                  () => Row(
                    children: [
                      Expanded(
                        child: roleButton(
                          context:context,
                          title: 'Passenger',
                          selected: auth.selectedRole.value == 'passenger',
                          onTap: () => auth.selectRole('passenger'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: roleButton(
                          context:context,
                          title: 'Driver',
                          selected: auth.selectedRole.value == 'driver',
                          onTap: () => auth.selectRole('driver'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                CustomTextField(
                  hint: 'Full Name',
                  icon: Icons.person_outline,
                  controller: nameController,
                  validator: Validators.name,
                ),

                const SizedBox(height: 15),

                CustomTextField(
                  hint: 'Email Address',
                  icon: Icons.email_outlined,
                  controller: emailController,
                  validator: Validators.email,
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 15),

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
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                CustomTextField(
                  hint: 'Confirm Password',
                  icon: Icons.search,
                  controller: confirmController,
                  obscureText: true,
                  validator: (value) => Validators.confirmPassword(
                    value,
                    passwordController.text,
                  ),
                ),

                // Driver-only fields
                Obx(
                  () => auth.selectedRole.value == 'driver'
                      ? Column(
                          children: [
                            const SizedBox(height: 15),
                            CustomTextField(
                              hint: 'CNIC Number',
                              icon: Icons.credit_card,
                              controller: cnicController,
                              validator: Validators.cnic,
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: 15),
                            CustomTextField(
                              hint: 'Driving License Number',
                              icon: Icons.badge_outlined,
                              controller: licenseController,
                              validator: Validators.license,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Your driver account will remain pending until an admin verifies your documents.',
                              style: TextStyle(
                                color: AppColors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        )
                      : const SizedBox.shrink(),
                ),

                const SizedBox(height: 30),

                Obx(
                  () => CustomButton(
                    title: 'Create Account',
                    isLoading: auth.isLoading.value,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        auth.signup(
                          name: nameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                          cnic: cnicController.text,
                          licenseNo: licenseController.text,
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     Text(
                      'Already have an account?',
                      style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.offNamed(AppRoutes.login);
                      },
                      child:  Text(
                        'Login',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
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

Widget roleButton({
  required BuildContext context,
  required String title,
  required bool selected,
  required VoidCallback onTap,
}) {
  final colors = Theme.of(context).colorScheme;

  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 45,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? colors.secondary : colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: selected
              ? colors.secondary
              : Theme.of(context).brightness == Brightness.light
                  ? AppColors.lightBorder
                  : AppColors.darkBorder,
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: selected ? Colors.white : colors.onSurface,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
}