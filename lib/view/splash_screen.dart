import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_go/constants/app_assets.dart';
import 'package:psb_go/constants/app_colors.dart';
import 'package:psb_go/constants/app_strings.dart';
import 'package:psb_go/controllers/passenger/favourite_controller.dart';
import 'package:psb_go/routes/app_routes.dart';
import 'package:psb_go/utils/theme/app_theme.dart';

import 'controllers/theme_controller.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
void initState() {
  super.initState();

  Future.delayed(const Duration(seconds: 3), () {
    if (mounted) {
      Get.offNamed(AppRoutes.login);
    }
  });
}
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: AppColors.splashColor,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.lightSecondaryText,
              AppColors.lightPrimaryText,
            ]
          )
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex:5,
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                 children: [
                  Container(
                    width: 140,
                    height: 140,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      
                       color: AppColors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow:[
                          BoxShadow(
                            color: AppColors.brandTeal.withOpacity(0.15),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                  ),
                  child:Image.asset(
                   AppAssets.app_icon,
                   fit: BoxFit.contain, 
                  )
                  

                  ),
                   const SizedBox(height: 22),

                   const Text(
                      AppStrings.appName,
                      style: TextStyle(
                        color: AppColors. lightBackgroundEnd ,
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 7),
                   const Text(
                      AppStrings.tagline,
                      style: TextStyle(
                        color: AppColors. lightBackgroundEnd ,
                        fontSize: 13,
                        fontWeight: FontWeight.w300,
                      ),
                    ),

                    const SizedBox(height: 10),
 
                  
                 ], 
                ),
                 ),

                 Expanded(
                  flex:5,
                  child: Container(
                    width: double.infinity,

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      //   Image.asset(
                      //     AppAssets.splash_image,
                      //     fit: BoxFit.contain,
                      //     height: 150,
                      //     width: double.infinity,
                      //   ),

                      // const SizedBox( height: 10,),
                        const SizedBox( 
        height: 30,
        width: 30,
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(
            AppColors.brandCyan,
          ),
        ),
      ),

                      ],
                    ),
                  ),

                  )
                  
            ],
          )),
      ),
    );
  }
}
