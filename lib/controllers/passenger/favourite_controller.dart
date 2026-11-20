
import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/route_model.dart';

class FavouriteController extends GetxController {
  static const String _storageKey = 'favourite_routes';

  final favourites = <RouteModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavourites();
  }

  Future<void> loadFavourites() async {
    isLoading.value = true;

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedRoutes = prefs.getStringList(_storageKey) ?? [];

      final routes = savedRoutes.map((item) {
        final json = jsonDecode(item) as Map<String, dynamic>;
        return RouteModel.fromJson(json);
      }).toList();

      favourites.assignAll(routes);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not load favourite routes.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool isFavourite(String routeId) {
    return favourites.any((route) => route.id == routeId);
  }

  Future<void> toggleFavourite(RouteModel route) async {
    if (route.id.isEmpty) {
      Get.snackbar('Error', 'This route cannot be saved.');
      return;
    }

    if (isFavourite(route.id)) {
      await removeFavourite(route.id);
    } else {
      favourites.add(route);
      await _saveFavourites();

      Get.snackbar(
        'Added to Favourites',
        '${route.name} has been saved.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> removeFavourite(String routeId) async {
    favourites.removeWhere((route) => route.id == routeId);
    await _saveFavourites();

    Get.snackbar(
      'Removed',
      'Route removed from favourites.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  Future<void> _saveFavourites() async {
    final prefs = await SharedPreferences.getInstance();

    final savedRoutes = favourites.map((route) {
      return jsonEncode({
        '_id': route.id,
        'name': route.name,
        'description': route.description,
        'stops': route.stops.map((stop) {
          return {
            'stopId': {
              '_id': stop.id,
              'name': stop.name,
            },
            'order': stop.order,
          };
        }).toList(),
      });
    }).toList();

    await prefs.setStringList(_storageKey, savedRoutes);
  }
}
