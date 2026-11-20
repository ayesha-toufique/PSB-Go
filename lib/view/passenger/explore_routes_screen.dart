
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../controllers/passenger/explore_routes_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../models/route_model.dart';
import '../../routes/app_routes.dart';

class ExploreRoutesScreen extends StatefulWidget {
  const ExploreRoutesScreen({super.key});

  @override
  State<ExploreRoutesScreen> createState() =>
      _ExploreRoutesScreenState();
}

class _ExploreRoutesScreenState extends State<ExploreRoutesScreen> {
  late final ExploreRoutesController controller;
  late final ThemeController themeController;

  final searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller = Get.isRegistered<ExploreRoutesController>()
        ? Get.find<ExploreRoutesController>()
        : Get.put(ExploreRoutesController());

    themeController = Get.find<ThemeController>();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;
    final colors = Theme.of(context).colorScheme;

    return Container(
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
        child: Column(
          children: [
            _buildHeader(context, colors),

            Expanded(
              child: RefreshIndicator(
                onRefresh: controller.refreshRoutes,
                color: colors.secondary,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          20, 12, 20, 18,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Find your route',
                              style: TextStyle(
                                color: colors.onSurface,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Explore routes and discover stops across the city.',
                              style: TextStyle(
                                color: colors.onSurface.withOpacity(0.65),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 22),
                            _buildSearchField(context, colors, isDark),
                            const SizedBox(height: 22),
                            _buildRouteHeading(colors),
                          ],
                        ),
                      ),
                    ),

                    Obx(() {
                      if (controller.isLoading.value &&
                          controller.routes.isEmpty) {
                        return const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (controller.errorMessage.isNotEmpty &&
                          controller.routes.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: _buildError(
                            context,
                            colors,
                            controller.errorMessage.value,
                          ),
                        );
                      }

                      if (controller.filteredRoutes.isEmpty) {
                        return SliverFillRemaining(
                          hasScrollBody: false,
                          child: _buildEmptyState(colors),
                        );
                      }

                      return SliverPadding(
                        padding: const EdgeInsets.fromLTRB(
                          20, 0, 20, 30,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final route =
                                  controller.filteredRoutes[index];

                              return Padding(
                                padding: const EdgeInsets.only(bottom: 14),
                                child: _routeCard(
                                  context,
                                  route,
                                  colors,
                                  isDark,
                                  index,
                                ),
                              );
                            },
                            childCount:
                                controller.filteredRoutes.length,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ColorScheme colors,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 18, 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: colors.onSurface,
              size: 20,
            ),
          ),
          Expanded(
            child: Text(
              'Explore Routes',
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Obx(
            () => IconButton(
              onPressed: themeController.toggleTheme,
              icon: Icon(
                themeController.isDarkMode.value
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded,
                color: colors.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(
    BuildContext context,
    ColorScheme colors,
    bool isDark,
  ) {
    return TextField(
      controller: searchController,
      onChanged: controller.filterRoutes,
      style: TextStyle(
        color: colors.onSurface,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        hintText: 'Search route, destination or stop',
        hintStyle: TextStyle(
          color: colors.onSurface.withOpacity(0.5),
          fontSize: 13,
        ),
        prefixIcon: Icon(
          Icons.search_rounded,
          color: colors.secondary,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            searchController.clear();
            controller.filterRoutes('');
          },
          icon: Icon(
            Icons.close_rounded,
            color: colors.onSurface.withOpacity(0.6),
          ),
        ),
        filled: true,
        fillColor: colors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: isDark
                ? AppColors.darkBorder
                : AppColors.lightBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: colors.secondary,
            width: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildRouteHeading(ColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Available Routes',
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        Obx(
          () => Text(
            '${controller.filteredRoutes.length} routes',
            style: TextStyle(
              color: colors.secondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }


Widget _routeCard(
  BuildContext context,
  RouteModel route,
  ColorScheme colors,
  bool isDark,
  int index,
) {
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
          color: Colors.black.withOpacity(isDark ? 0.12 : 0.04),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Get.toNamed(
            AppRoutes.pickupPoint,
            arguments: {
              'route': route,
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: AppColors.brandRed.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.directions_bus_rounded,
                      color: AppColors.brandRed,
                      size: 27,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          route.name,
                          style: TextStyle(
                            color: colors.onSurface,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          route.description.isEmpty
                              ? 'Karachi public transport route'
                              : route.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colors.onSurface.withOpacity(0.6),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: colors.onSurface.withOpacity(0.5),
                    size: 16,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Divider(
                color: isDark
                    ? AppColors.darkBorder
                    : AppColors.lightBorder,
                height: 1,
              ),

              const SizedBox(height: 13),

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
                      color: colors.onSurface.withOpacity(0.7),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'View Route',
                    style: TextStyle(
                      color: AppColors.brandRed,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.brandRed,
                    size: 16,
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


  Widget _buildStops(
    List<RouteStop> stops,
    ColorScheme colors,
  ) {
    return Column(
      children: List.generate(stops.length, (index) {
        final stop = stops[index];
        final isLast = index == stops.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              child: Column(
                children: [
                  Icon(
                    isLast
                        ? Icons.location_on
                        : Icons.circle,
                    color: isLast
                        ? AppColors.brandRed
                        : colors.secondary,
                    size: isLast ? 18 : 11,
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 27,
                      color: colors.secondary.withOpacity(0.35),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 9),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Text(
                  stop.name,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildError(
    BuildContext context,
    ColorScheme colors,
    String message,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.wifi_off_rounded,
              size: 48,
              color: colors.error,
            ),
            const SizedBox(height: 14),
            Text(
              'Could not load routes',
              style: TextStyle(
                color: colors.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.onSurface.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: controller.fetchRoutes,
              icon: const Icon(Icons.refresh),
              label: const Text('Try again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(ColorScheme colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.route_outlined,
              size: 55,
              color: colors.secondary,
            ),
            const SizedBox(height: 14),
            Text(
              'No routes found',
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'Try another route name, destination or stop.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.onSurface.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
