import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_go/view/driver1/bus_selection_screen.dart';

import '../../routes/app_routes.dart';
import '../../constants/app_colors.dart';
import 'package:psb_go/controllers/driver/route_details_controller.dart';
import 'package:psb_go/controllers/driver/driver_controller.dart';

class DriverHomeScreen extends StatelessWidget {
  DriverHomeScreen({super.key});

  final DriverController controller = Get.find<DriverController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 12,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.menu,
                      size: 30,
                      color: AppColors.lightPrimaryText,
                    ),
                  ),

                  const SizedBox(width: 10),

                  const Text(
                    'PSB-Go',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: AppColors.lightPrimaryText,
                    ),
                  ),

                  const Spacer(),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none,
                      size: 29,
                      color: AppColors.lightPrimaryText,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              // Driver name using GetX
              Obx(
                () => Text(
                  'Hello, 👋',
                  style: const TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightPrimaryText,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 270,
                child: Image.asset(
                  'assets/images/psb_bus_crop.png',
                  fit: BoxFit.contain,

                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.directions_bus,
                        size: 150,
                        color: AppColors.brandTeal,
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 25),

              const Center(
                child: Text(
                  'Your Journey Starts Here!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: AppColors.lightPrimaryText,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Select your assigned bus to view your '
                'route and duty details.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  height: 1.5,
                  color: AppColors.lightSecondaryText,
                ),
              ),

              const SizedBox(height: 32),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: const Color(0xFFD0F3EB),
                  borderRadius: BorderRadius.circular(28),
                ),

                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 27,
                      backgroundColor: AppColors.brandTeal,
                      child: Icon(
                        Icons.info,
                        color: AppColors.white,
                        size: 35,
                      ),
                    ),

                    const SizedBox(width: 16),

                    Container(
                      width: 3,
                      height: 75,
                      color: AppColors.brandGreen,
                    ),

                    const SizedBox(width: 16),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Before you start',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.lightPrimaryText,
                            ),
                          ),

                          SizedBox(height: 8),

                          Text(
                            'Please select your assigned bus '
                            'to continue.',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: AppColors.lightPrimaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 35),

              SizedBox(
                width: double.infinity,
                height: 72,

                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.busSelection);
                  },

                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandTeal,
                    foregroundColor: AppColors.white,
                    elevation: 0,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(45),
                    ),
                  ),

                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Select Your Bus',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(width: 18),

                      Icon(
                        Icons.arrow_forward,
                        size: 30,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}