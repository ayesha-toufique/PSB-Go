
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../models/route_model.dart';
import '../../routes/app_routes.dart';

class DropPointScreen extends StatefulWidget {
  const DropPointScreen({super.key});

  @override
  State<DropPointScreen> createState() =>
      _DropPointScreenState();
}

class _DropPointScreenState extends State<DropPointScreen> {
  final TextEditingController searchController =
      TextEditingController();

  late RouteModel route;
  late RouteStop pickup;

  String searchQuery = '';

  @override
  void initState() {
    super.initState();

    route = Get.arguments['route'] as RouteModel;
    pickup = Get.arguments['pickup'] as RouteStop;
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final pickupIndex = route.stops.indexWhere(
      (stop) => stop.id == pickup.id,
    );

    final availableStops = route.stops
        .skip(pickupIndex + 1)
        .where((stop) => stop.name.toLowerCase().contains(
              searchQuery.toLowerCase(),
            ))
        .toList();

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
          'Drop Point',
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    onChanged: (value) {
                      setState(() => searchQuery = value);
                    },
                    decoration: InputDecoration(
                      hintText: 'Search drop point...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: colors.surface,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Pickup: ${pickup.name}',
                      style: TextStyle(
                        color: colors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: availableStops.isEmpty
                  ? const Center(
                      child: Text(
                        'No drop-off stops available after this pickup.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                      ),
                      itemCount: availableStops.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final stop = availableStops[index];

                        return Material(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(14),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              Get.toNamed(
                                AppRoutes.liveMap,
                                arguments: {
                                  'route': route,
                                  'pickup': pickup,
                                  'dropoff': stop,
                                },
                              );
                            },
                            child: Container(
                              height: 76,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.darkBorder
                                      : AppColors.lightBorder,
                                ),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.location_on,
                                    color: AppColors.brandRed,
                                    size: 25,
                                  ),
                                  const SizedBox(width: 18),
                                  Expanded(
                                    child: Text(
                                      stop.name,
                                      style: TextStyle(
                                        color: colors.onSurface,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 15,
                                    color: colors.onSurface
                                        .withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
