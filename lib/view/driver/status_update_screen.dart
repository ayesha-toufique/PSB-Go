
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_go/constants/app_assets.dart';
import 'package:psb_go/constants/app_colors.dart';
import 'package:psb_go/constants/app_strings.dart';
import 'package:psb_go/controllers/passenger/favourite_controller.dart';
import 'package:psb_go/routes/app_routes.dart';
import 'package:psb_go/utils/theme/app_theme.dart';

import '../../utils/theme/theme_controller.dart';


class StatusUpdateScreen extends StatefulWidget {
  const StatusUpdateScreen({super.key});

  @override
  State<StatusUpdateScreen> createState() => _StatusUpdateScreenState();
}

class _StatusUpdateScreenState extends State<StatusUpdateScreen> {
  String selectedStatus = 'On Route';

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
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
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                SizedBox(
                  height: 65,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.arrow_back,
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                      Text(
                        'Status Update',
                        style: TextStyle(
                          color: colors.onSurface,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                  
                // Status options
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      'On Route',
                      'Delayed',
                      'Reached Stop',
                      'Break',
                      'Other',
                    ].map((status) {
                      bool isSelected = selectedStatus == status;
                
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedStatus = status;
                          });
                        },
                        child: Container(
                          height: 90,
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.darkSurface
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.radio_button_checked
                                    : Icons.radio_button_unchecked,
                                color: isSelected
                                    ? AppColors.brandTeal
                                    : Colors.grey,
                                size: 28,
                              ),
                              const SizedBox(width: 30),
                              Text(
                                status,
                                style: TextStyle(
                                  color: colors.onSurface,
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                  
                // Update button
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 10, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.snackbar(
                          'Status Updated',
                          'Your status is $selectedStatus',
                          snackPosition: SnackPosition.BOTTOM,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandTeal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'Update Status',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
