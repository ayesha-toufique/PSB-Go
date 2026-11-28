import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JourneyStartedScreen extends StatefulWidget {
  final String routeCode;
  final String startLocation;
  final String endLocation;

  const JourneyStartedScreen({
    super.key,
    required this.routeCode,
    required this.startLocation,
    required this.endLocation,
  });

  @override
  State<JourneyStartedScreen> createState() =>
      _JourneyStartedScreenState();
}

class _JourneyStartedScreenState
    extends State<JourneyStartedScreen> {

  static const Color darkBlue = Color(0xFF0B3558);
  static const Color primaryColor = Color(0xFF00B995);
  static const Color backgroundColor = Color(0xFFEAF8FC);

  final isJourneyStarted = false.obs;

  void startJourney() {
  isJourneyStarted.value = true;

  Get.snackbar(
    'Success',
    'Your journey has started successfully',
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: Column(
          children: [

            // Back Button
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  top: 8,
                ),
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: darkBlue,
                    size: 25,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            Container(
              height: 66,
              width: 66,
              decoration: const BoxDecoration(
                color: primaryColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check,
                color: Colors.white,
                size: 38,
              ),
            ),

            const SizedBox(height: 23),

            const Text(
              'Journey Started!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),

            const SizedBox(height: 15),

            Text(
              'Route ${widget.routeCode}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: darkBlue,
              ),
            ),

            const SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Text(
                '${widget.startLocation} → ${widget.endLocation}',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: darkBlue,
                ),
              ),
            ),

            const Spacer(),

            Container(
              width: double.infinity,
              height: 150,
              margin: const EdgeInsets.symmetric(
                horizontal: 18,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFD9F4F1),
                borderRadius: BorderRadius.circular(18),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.asset(
                'assets/images/psb_bus_crop.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Center(
                    child: Icon(
                      Icons.directions_bus,
                      size: 100,
                      color: Color(0xFF078B70),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 22),

            // Start Journey Button
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 36,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: 
                Obx(() => ElevatedButton(
                  onPressed: isJourneyStarted.value ? null : startJourney,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    disabledBackgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),),),
                      child: Text(
                        isJourneyStarted.value? 'Journey Started' : 'Start Journey',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          ),
                          ),
                          ),
                          )
              ),
            ),
            const SizedBox(height: 45),
          ],
        ),
      ),
    );
  }
}