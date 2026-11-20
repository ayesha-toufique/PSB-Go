import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:psb_go/constants/app_assets.dart';
import 'package:psb_go/constants/app_colors.dart';
import 'package:psb_go/constants/app_strings.dart';
import 'package:psb_go/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _dotsController;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _navigationTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Get.offNamed(AppRoutes.login);
      }
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: AppColors.splashColor,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppColors.splashColor,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.darkBackgroundEnd,
                AppColors.splashColor,
                AppColors.splashColor,
              ],
              stops: [0.0, 0.48, 1.0],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 5,
                  child: _buildBrandSection(),
                ),
                const Expanded(
                  flex: 2,
                  child: _BusScene(),
                ),
                Expanded(
                  flex: 2,
                  child: _buildLoadingSection(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBrandSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final logoSize = (constraints.maxHeight * 0.43).clamp(104.0, 142.0);

        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              width: logoSize,
              height: logoSize,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.brandTeal, AppColors.brandCyan],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.brandCyan.withValues(alpha: 0.20),
                    blurRadius: 24,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  AppAssets.app_icon,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.directions_bus_rounded,
                    size: 76,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              AppStrings.appName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 31,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              AppStrings.tagline,
              style: TextStyle(
                color: Color(0xFFE4F8FF),
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.25,
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      },
    );
  }

  Widget _buildLoadingSection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _dotsController,
          builder: (context, child) {
            final activeDot = (_dotsController.value * 5).floor() % 5;
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index == activeDot
                        ? AppColors.brandCyan
                        : Colors.white.withValues(alpha: 0.55),
                  ),
                );
              }),
            );
          },
        ),
        const SizedBox(height: 12),
        const Text(
          'Loading...',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

class _BusScene extends StatelessWidget {
  const _BusScene();

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            fit: StackFit.expand,
            children: [
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF63D6F5), Color(0xFFB5F0FF)],
                  ),
                ),
              ),
              Positioned(
                top: 12,
                left: 22,
                child: _cloud(width: 54),
              ),
              Positioned(
                top: 28,
                right: 28,
                child: _cloud(width: 42),
              ),
              ...List.generate(9, (index) {
                final heights = [42.0, 62.0, 48.0, 78.0, 54.0, 88.0, 58.0, 72.0, 46.0];
                final widths = [19.0, 25.0, 22.0, 28.0, 20.0, 25.0, 22.0, 26.0, 20.0];
                final left = constraints.maxWidth * index / 9;

                return Positioned(
                  left: left,
                  bottom: 32,
                  child: Container(
                    width: widths[index],
                    height: heights[index],
                    decoration: BoxDecoration(
                      color: index.isEven
                          ? const Color(0xFF168FC2)
                          : const Color(0xFF0879AE),
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(4),
                      ),
                    ),
                    child: Column(
                      children: List.generate(
                        3,
                        (_) => Container(
                          height: 5,
                          margin: const EdgeInsets.only(
                            top: 5,
                            left: 4,
                            right: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFB8F2FF).withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(1),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
              Positioned(
                left: -20,
                right: -20,
                bottom: 0,
                height: 42,
                child: Transform.rotate(
                  angle: -0.035,
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF087A9E), Color(0xFF003D62)],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: constraints.maxWidth * 0.19,
                right: constraints.maxWidth * 0.13,
                bottom: 21,
                height: 62,
                child: _buildBus(),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                height: 5,
                child: Container(color: AppColors.brandTeal),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _cloud({required double width}) {
    return Container(
      width: width,
      height: 15,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }

  Widget _buildBus() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: 0,
          right: 4,
          top: 3,
          bottom: 8,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE51F35),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(18),
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(8),
              ),
              border: Border.all(color: const Color(0xFF8D1027), width: 1.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x55001D35),
                  blurRadius: 8,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 9),
                Expanded(
                  child: Container(
                    height: 25,
                    decoration: BoxDecoration(
                      color: const Color(0xFFB9F1FF),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: List.generate(
                        4,
                        (index) => Expanded(
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF08749C),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 5),
                Container(
                  width: 20,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFFB9F1FF),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(width: 5),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 12,
          bottom: 13,
          child: Container(
            width: 5,
            decoration: BoxDecoration(
              color: const Color(0xFFFFE8A3),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
        Positioned(
          left: 22,
          bottom: 0,
          child: _wheel(),
        ),
        Positioned(
          right: 22,
          bottom: 0,
          child: _wheel(),
        ),
      ],
    );
  }

  Widget _wheel() {
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: const Color(0xFF142A3A),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFB9D5DF), width: 3),
      ),
    );
  }
}
