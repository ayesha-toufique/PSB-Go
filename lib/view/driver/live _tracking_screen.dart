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

class LiveTrackingScreen extends StatelessWidget {
  const LiveTrackingScreen({super.key});

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
          child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                 _buildHeader(colors),

                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(12, 70, 12, 24),
                  child: Column(
                    children: [
                      _buildMap(isDark),
                        const SizedBox(height: 30),
                         _buildNextStopCard(
                        context,
                        colors,
                        isDark,
                        'Malir Halt',
                      ),
                    ],
                  )
                  )
                  ),
                  _buildEndJourneyButton(context),
              ],
            ),
          ),
        ),
      ),
    );
    
  }
   Widget _buildHeader(ColorScheme colors) {
    return SizedBox(
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: IconButton(
              onPressed: Get.back,
              icon: Icon(
                Icons.arrow_back_rounded,
                color: colors.onSurface,
                size: 25,
              ),
            ),
          ),
          Text(
            'Live Tracking',
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
   Widget _buildMap(bool isDark) {
    return Container(
      height: 350,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF17334A)
            : const Color(0xFFF0EDE5),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: _LiveRouteMapPainter(isDark: isDark),
            ),
          ),
          const Positioned(
            left: 0,
            right: 0,
            top: 0,
            bottom: 0,
            child: _MapRouteMarkers(),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStopCard(
    BuildContext context,
    ColorScheme colors,
    bool isDark,
    String nextStop,
  ) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 124),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.12 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 64,
            width: 64,
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.darkBackgroundEnd
                  : const Color(0xFFE1F7FC),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(
              Icons.directions_bus_outlined,
              color: isDark ? AppColors.brandCyan : AppColors.brandTeal,
              size: 37,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Next Stop',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  nextStop,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Arriving in 2 min',
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: Colors.lightBlue,
            size: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildEndJourneyButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 18),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF4058),
                Color(0xFFFF0038),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF1744).withOpacity(0.18),
                blurRadius: 12,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () => _confirmEndJourney(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Text(
              'End Journey',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _confirmEndJourney(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('End Journey?'),
        content: const Text(
          'Are you sure you want to end your current journey?',
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Continue'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              Get.back();
              Get.snackbar(
                'Journey Ended',
                'Your journey has been ended.',
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(14),
              );
            },
            child: const Text(
              'End Journey',
              style: TextStyle(color: AppColors.brandRed),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapRouteMarkers extends StatelessWidget {
  const _MapRouteMarkers();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;

        return Stack(
          children: [
            Positioned(
              left: width * 0.47,
              top: height * 0.34,
              child: Container(
                height: 34,
                width: 34,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.18),
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.directions_bus_rounded,
                  color: Color(0xFF0878F9),
                  size: 25,
                ),
              ),
            ),
            Positioned(
              right: width * 0.12,
              top: height * 0.02,
              child: const Icon(
                Icons.location_on,
                color: Color(0xFF00A86B),
                size: 38,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LiveRouteMapPainter extends CustomPainter {
  final bool isDark;

  const _LiveRouteMapPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final background = Paint()
      ..color = isDark
          ? const Color(0xFF17334A)
          : const Color(0xFFF4F0E7);

    canvas.drawRect(Offset.zero & size, background);

    final blockPaint = Paint()
      ..color = isDark
          ? const Color(0xFF24465A)
          : const Color(0xFFE9E5D9);

    final blocks = [
      Rect.fromLTWH(size.width * 0.03, size.height * 0.08, 45, 20),
      Rect.fromLTWH(size.width * 0.24, size.height * 0.05, 48, 25),
      Rect.fromLTWH(size.width * 0.72, size.height * 0.62, 55, 24),
      Rect.fromLTWH(size.width * 0.12, size.height * 0.66, 42, 22),
      Rect.fromLTWH(size.width * 0.82, size.height * 0.34, 38, 20),
      Rect.fromLTWH(size.width * 0.58, size.height * 0.05, 35, 20),
    ];

    for (final block in blocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(block, const Radius.circular(5)),
        blockPaint,
      );
    }

    final minorRoadPaint = Paint()
      ..color = isDark
          ? Colors.white.withOpacity(0.12)
          : Colors.white.withOpacity(0.95)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roads = [
      Path()
        ..moveTo(-10, size.height * 0.28)
        ..lineTo(size.width * 0.32, size.height * 0.18)
        ..lineTo(size.width * 0.62, size.height * 0.35)
        ..lineTo(size.width + 10, size.height * 0.18),
      Path()
        ..moveTo(size.width * 0.08, size.height + 8)
        ..lineTo(size.width * 0.30, size.height * 0.48)
        ..lineTo(size.width * 0.52, -8),
      Path()
        ..moveTo(size.width * 0.67, size.height + 8)
        ..lineTo(size.width * 0.76, size.height * 0.50)
        ..lineTo(size.width * 0.94, -8),
    ];

    for (final road in roads) {
      canvas.drawPath(road, minorRoadPaint);
    }

    final routePaint = Paint()
      ..color = const Color(0xFF1599E8)
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final routePath = Path()
      ..moveTo(size.width * 0.22, size.height * 0.76)
      ..lineTo(size.width * 0.36, size.height * 0.64)
      ..lineTo(size.width * 0.48, size.height * 0.55)
      ..lineTo(size.width * 0.62, size.height * 0.43)
      ..lineTo(size.width * 0.77, size.height * 0.32)
      ..lineTo(size.width * 0.85, size.height * 0.20);

    canvas.drawPath(routePath, routePaint);

    final stopPaint = Paint()
      ..color = const Color(0xFF1599E8)
      ..style = PaintingStyle.fill;

    for (final point in [
      Offset(size.width * 0.36, size.height * 0.64),
      Offset(size.width * 0.62, size.height * 0.43),
      Offset(size.width * 0.77, size.height * 0.32),
    ]) {
      canvas.drawCircle(point, 4, stopPaint);
      canvas.drawCircle(
        point,
        2,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LiveRouteMapPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}