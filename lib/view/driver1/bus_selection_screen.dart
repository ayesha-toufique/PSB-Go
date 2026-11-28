import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import 'package:psb_go/controllers/driver/route_details_controller.dart';
import 'package:psb_go/models/bus_model.dart';
import 'package:psb_go/controllers/driver/driver_controller.dart';


class BusSelectionScreen extends StatelessWidget { BusSelectionScreen({super.key});

  final DriverController controller = Get.find<DriverController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF8FC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF8FC),
        elevation: 0,
        foregroundColor: const Color(0xFF0B3558),
        title: const Text(
          'Select Your Bus',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColors.brandTeal,
            ),
          );
        }

        if (controller.errorMessage.value.isNotEmpty &&
            controller.buses.isEmpty) {
          return _errorState(
            controller,
            controller.errorMessage.value,
          );
        }

        if (controller.buses.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_bus_outlined,
                    size: 65,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'No buses assigned yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0B3558),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Please contact the administrator to assign a bus to your account.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 12, 22, 5),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${controller.buses.length} Assigned Bus(es)',
                  style: const TextStyle(
                    color: Color(0xFF426681),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(18),
                itemCount: controller.buses.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 13),
                itemBuilder: (context, index) {
                  final bus = controller.buses[index];

                  return _busCard(
                    bus,
                    controller,
                  );
                },
              ),
            ),
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(22, 10, 22, 20),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: Obx(() {
                    return ElevatedButton(
                      onPressed: controller.selectedBus.value == null
                          ? null
                          : () {
                              Get.back(
                                result: controller.selectedBus.value,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00B995),
                        disabledBackgroundColor: Colors.grey,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(35),
                        ),
                      ),
                      child: const Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _busCard(
    BusModel bus,
    DriverController controller,
  ) {
    return Obx(() {
      final isSelected =
          controller.selectedBus.value?.id == bus.id;

      return InkWell(
        onTap: () {
          controller.selectBus(bus);
        },
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF00B995)
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFFE4F6FF),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.directions_bus_rounded,
                  color: Color(0xFFFF1744),
                  size: 29,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bus.registrationNumber,
                      style: const TextStyle(
                        color: Color(0xFF0B3558),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Capacity: ${bus.capacity} passengers',
                      style: const TextStyle(
                        color: Color(0xFF426681),
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      bus.isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        color: bus.isActive
                            ? Colors.green
                            : Colors.red,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isSelected
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: isSelected
                    ? const Color(0xFF00B995)
                    : Colors.grey,
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _errorState(
    DriverController controller,
    String message,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.wifi_off_rounded,
              size: 50,
              color: Colors.grey,
            ),
            const SizedBox(height: 15),
            Text(
              message,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            ElevatedButton(
              onPressed: controller.loadDriverData,
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}