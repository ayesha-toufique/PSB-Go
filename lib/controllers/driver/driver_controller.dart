
import 'package:get/get.dart';
import '../../models/bus_model.dart';
import '../../models/route_model.dart';
import '../../services/driver_service.dart';

class DriverController extends GetxController {
  final DriverService _service = DriverService();

  final buses = <BusModel>[].obs;
  final routes = <RouteModel>[].obs;

  final selectedBus = Rxn<BusModel>();
  final selectedRoute = Rxn<RouteModel>();

  final activeTrip = Rxn<Map<String, dynamic>>();

  final isLoading = false.obs;
  final isStartingJourney = false.obs;
  final isEndingJourney = false.obs;

  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadDriverData();
  }

  Future<void> loadDriverData() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final results = await Future.wait([
        _service.getMyBuses(),
        _service.getRoutes(),
        _service.getActiveTrip(),
      ]);

      buses.assignAll(results[0] as List<BusModel>);
      routes.assignAll(results[1] as List<RouteModel>);
      activeTrip.value = results[2] as Map<String, dynamic>?;

      // Restore bus and route selection from an active trip
      if (activeTrip.value != null) {
        final trip = activeTrip.value!;

        final busData = trip['bus'];
        final routeData = trip['route'];

        final busId = busData is Map
            ? busData['_id']?.toString()
            : busData?.toString();

        final routeId = routeData is Map
            ? routeData['_id']?.toString()
            : routeData?.toString();

        selectedBus.value = buses.firstWhereOrNull(
          (bus) => bus.id == busId,
        );

        selectedRoute.value = routes.firstWhereOrNull(
          (route) => route.id == routeId,
        );
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void selectBus(BusModel bus) {
    selectedBus.value = bus;
  }

  void selectRoute(RouteModel route) {
    selectedRoute.value = route;
  }

  Future<bool> startJourney() async {
    if (selectedBus.value == null) {
      Get.snackbar('Select Bus', 'Please select your assigned bus.');
      return false;
    }

    if (selectedRoute.value == null) {
      Get.snackbar('Select Route', 'Please select your route.');
      return false;
    }

    try {
      isStartingJourney.value = true;

      final trip = await _service.startJourney(
        busId: selectedBus.value!.id,
        routeId: selectedRoute.value!.id,
      );

      activeTrip.value = trip;

      Get.snackbar(
        'Success',
        'Your journey has started.',
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Journey Error',
        e.toString().replaceFirst('Exception: ', ''),
      );

      return false;
    } finally {
      isStartingJourney.value = false;
    }
  }

  Future<bool> endJourney() async {
    final trip = activeTrip.value;

    if (trip == null || trip['_id'] == null) {
      Get.snackbar('Error', 'No active journey found.');
      return false;
    }

    try {
      isEndingJourney.value = true;

      await _service.endJourney(trip['_id'].toString());

      activeTrip.value = null;
      selectedBus.value = null;
      selectedRoute.value = null;

      Get.snackbar(
        'Journey Ended',
        'Your journey has been completed.',
      );

      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString().replaceFirst('Exception: ', ''),
      );

      return false;
    } finally {
      isEndingJourney.value = false;
    }
  }
}
