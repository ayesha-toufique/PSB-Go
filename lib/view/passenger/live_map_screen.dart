
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../models/route_model.dart';
import '../../controllers/passenger/favourite_controller.dart';
import '../../routes/app_routes.dart';
class LiveMapScreen extends StatelessWidget {
  const LiveMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final args = Get.arguments as Map<String, dynamic>;
    final route = args['route'] as RouteModel;
    final pickup = args['pickup'] as RouteStop;
    final dropoff = args['dropoff'] as RouteStop;
    final favouriteController = Get.find<FavouriteController>();
    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackgroundStart
          : AppColors.lightBackgroundEnd,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colors.onSurface,
          ),
        ),
        title: Text(
          'Live Map',
          style: TextStyle(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        actions: [
  IconButton(
    tooltip: 'Favourite Routes',
    onPressed: () {
      Get.toNamed(AppRoutes.favourites);
    },
    icon: Icon(
      Icons.favorite_rounded,
      color: AppColors.brandRed,
    ),
  ),
  const SizedBox(width: 8),
],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: Column(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF17334A)
                              : const Color(0xFFE5EEF0),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _MapPlaceholderPainter(
                                  isDark: isDark,
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: colors.surface.withOpacity(0.94),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.map_outlined,
                                      size: 36,
                                      color: AppColors.brandRed,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Map integration coming next',
                                      style: TextStyle(
                                        color: colors.onSurface,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Real GPS coordinates are required',
                                      style: TextStyle(
                                        color: colors.onSurface
                                            .withOpacity(0.6),
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            route.name,
                            style: TextStyle(
                              color: colors.onSurface,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 14),
                          _journeyPoint(
                            icon: Icons.trip_origin,
                            iconColor: AppColors.brandGreen,
                            label: 'Pickup Point',
                            value: pickup.name,
                            colors: colors,
                          ),
                          const SizedBox(height: 12),
                          _journeyPoint(
                            icon: Icons.location_on,
                            iconColor: AppColors.brandRed,
                            label: 'Drop-off Point',
                            value: dropoff.name,
                            colors: colors,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Four requested bottom features
            Container(
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 18),
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(22),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _bottomFeature(
                      icon: Icons.access_time_rounded,
                      title: 'ETA',
                      value: 'Unavailable',
                      colors: colors,
                      onTap: () => _showMessage(
                        'ETA',
                        'ETA will be available when live bus GPS is connected.',
                      ),
                    ),
                  ),
                  Expanded(
                    child: _bottomFeature(
                      icon: Icons.directions_bus_rounded,
                      title: 'Buses',
                      value: 'Unavailable',
                      colors: colors,
                      onTap: () => _showMessage(
                        'Buses',
                        'Live bus count will be connected to bus tracking data.',
                      ),
                    ),
                  ),
                  Expanded(
                  child: Obx(() {
                    final isSaved =
                        favouriteController.isFavourite(route.id);

                    return _bottomFeature(
                      icon: isSaved
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      title: 'Favourite',
                      value: isSaved ? 'Saved' : 'Save route',
                      colors: colors,
                      onTap: () {
                        favouriteController.toggleFavourite(route);
                      },
                    );
                  }),
                ),
                  Expanded(
                    child: _bottomFeature(
                      icon: Icons.people_outline_rounded,
                      title: 'Ride Share',
                      value: 'Connect',
                      colors: colors,
                      onTap: () => _showMessage(
                        'Ride Share',
                        'Ride sharing will be implemented next.',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _journeyPoint({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required ColorScheme colors,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 21),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: colors.onSurface.withOpacity(0.55),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _bottomFeature({
    required IconData icon,
    required String title,
    required String value,
    required ColorScheme colors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 2,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: AppColors.brandRed,
              size: 23,
            ),
            const SizedBox(height: 7),
            Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: TextStyle(
                color: colors.onSurface.withOpacity(0.55),
                fontSize: 9,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(14),
    );
  }
}

class _MapPlaceholderPainter extends CustomPainter {
  final bool isDark;

  _MapPlaceholderPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final roadPaint = Paint()
      ..color = isDark
          ? Colors.white.withOpacity(0.08)
          : Colors.white.withOpacity(0.9)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final routePaint = Paint()
      ..color = AppColors.brandRed
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final road1 = Path()
      ..moveTo(0, size.height * 0.25)
      ..lineTo(size.width * 0.4, size.height * 0.4)
      ..lineTo(size.width, size.height * 0.2);

    final road2 = Path()
      ..moveTo(size.width * 0.2, 0)
      ..lineTo(size.width * 0.5, size.height)
      ..lineTo(size.width * 0.8, size.height * 0.6);

    canvas.drawPath(road1, roadPaint);
    canvas.drawPath(road2, roadPaint);

    final routePath = Path()
      ..moveTo(size.width * 0.2, size.height * 0.75)
      ..lineTo(size.width * 0.42, size.height * 0.55)
      ..lineTo(size.width * 0.65, size.height * 0.48)
      ..lineTo(size.width * 0.82, size.height * 0.22);

    canvas.drawPath(routePath, routePaint);
  }

  @override
  bool shouldRepaint(covariant _MapPlaceholderPainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}
