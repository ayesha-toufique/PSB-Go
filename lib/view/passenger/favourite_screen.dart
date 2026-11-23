
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:psb_go/view/passenger/explore_routes_screen.dart';

import '../../constants/app_colors.dart';
import '../../controllers/passenger/favourite_controller.dart';
import '../../routes/app_routes.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavouriteController>();
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackgroundStart
          : AppColors.lightBackgroundEnd,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors.surface,
        title: Text(
          'Favourite Routes',
          style: TextStyle(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colors.onSurface,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.brandRed,
            ),
          );
        }

        if (controller.favourites.isEmpty) {
          return _emptyState(colors);
        }

        return RefreshIndicator(
          onRefresh: controller.loadFavourites,
          color: AppColors.brandRed,
          child: ListView.separated(
            padding: const EdgeInsets.all(18),
            itemCount: controller.favourites.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: 14),
            itemBuilder: (context, index) {
              final route = controller.favourites[index];

              return Container(
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBorder
                        : AppColors.lightBorder,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: AppColors.brandRed.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Icon(
                              Icons.directions_bus_rounded,
                              color: AppColors.brandRed,
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  route.name,
                                  style: TextStyle(
                                    color: colors.onSurface,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  route.description.isEmpty
                                      ? 'Karachi public transport route'
                                      : route.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: colors.onSurface
                                        .withOpacity(0.6),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            tooltip: 'Remove favourite',
                            onPressed: () =>
                                controller.removeFavourite(route.id),
                            icon: const Icon(
                              Icons.favorite_rounded,
                              color: AppColors.brandRed,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            color: colors.secondary,
                            size: 17,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${route.stops.length} stops',
                            style: TextStyle(
                              color: colors.onSurface.withOpacity(0.65),
                              fontSize: 12,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {
                              Get.toNamed(
                                AppRoutes.pickupPoint,
                                arguments: {
                                  'route': route,
                                },
                              );
                            },
                            child: const Text(
                              'Plan Journey',
                              style: TextStyle(
                                color: AppColors.brandRed,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }

  Widget _emptyState(ColorScheme colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: AppColors.brandRed.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 48,
                color: AppColors.brandRed,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'No Favourite Routes Yet',
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Save your frequently used bus routes\n'
              'and access them quickly here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.onSurface.withOpacity(0.6),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Get.offNamed(
                AppRoutes.exploreRoutes,
              ),
              icon: const Icon(Icons.explore_outlined),
              label: const Text('Explore Routes'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
