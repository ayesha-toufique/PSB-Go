
import 'package:get/get.dart';

import '../../models/route_model.dart';
import '../../services/route_service.dart';

class ExploreRoutesController extends GetxController {
  final RouteService _routeService = RouteService();

  final routes = <RouteModel>[].obs;
  final filteredRoutes = <RouteModel>[].obs;

  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRoutes();
  }

  Future<void> fetchRoutes() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _routeService.getRoutes();

      routes.assignAll(result);
      filterRoutes(searchQuery.value);
    } catch (e) {
      errorMessage.value =
          e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void filterRoutes(String query) {
    searchQuery.value = query;

    if (query.trim().isEmpty) {
      filteredRoutes.assignAll(routes);
      return;
    }

    final search = query.trim().toLowerCase();

    final result = routes.where((route) {
      final routeName = route.name.toLowerCase();
      final description = route.description.toLowerCase();

      final stopMatches = route.stops.any(
        (stop) => stop.name.toLowerCase().contains(search),
      );

      return routeName.contains(search) ||
          description.contains(search) ||
          stopMatches;
    }).toList();

    filteredRoutes.assignAll(result);
  }

  Future<void> refreshRoutes() async {
    await fetchRoutes();
  }
}
