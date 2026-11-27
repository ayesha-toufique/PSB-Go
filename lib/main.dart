import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_go/controllers/passenger/favourite_controller.dart';
import 'package:psb_go/utils/theme/app_theme.dart';

import 'controllers/theme_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(ThemeController(), permanent: true);
  Get.put(FavouriteController(), permanent: true);
  runApp(const PSBGoApp());
}

class PSBGoApp extends StatelessWidget {
  const PSBGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (controller) {
        return GetMaterialApp(
          title: 'PSB Go',
          debugShowCheckedModeBanner: false,

          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: controller.isDarkMode.value
              ? ThemeMode.dark
              : ThemeMode.light,

          initialRoute: AppRoutes.LiveTracking,
          getPages: AppPages.pages,
        );
      },
    );
  }
}