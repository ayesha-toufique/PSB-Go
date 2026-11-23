import 'package:flutter/material.dart';

class RouteDetailsScreen extends StatelessWidget {
  final String routeCode;

  // Next screen ko connect karne ke liye
  final WidgetBuilder? nextScreenBuilder;

  const RouteDetailsScreen({
    super.key,
    required this.routeCode,
    this.nextScreenBuilder,
  });

  static const Color darkBlue = Color(0xFF0B3558);
  static const Color primaryColor = Color(0xFF00B995);
  static const Color backgroundColor = Color(0xFFEAF8FC);

  // Route information
  static const Map<String, Map<String, dynamic>> routeData = {
    'R1': {
      'start': 'Khokharapar 04',
      'end': 'Dockyard',
      'distance': '31 KM',
      'stops': 18,
    },
    'R2': {
      'start': 'North Karachi',
      'end': 'Korangi Crossing',
      'distance': '31 KM',
      'stops': 15,
    },
    'R3': {
      'start': 'North Karachi',
      'end': 'Nasir Jump',
      'distance': '32 KM',
      'stops': 13,
    },
    'R4': {
      'start': 'North Karachi',
      'end': 'Keamari',
      'distance': '26 KM',
      'stops': 14,
    },
    'R5': {
      'start': 'Surjani',
      'end': 'Masroor',
      'distance': '28.2 KM',
      'stops': 8,
    },
    'R6': {
      'start': 'Gulshan-e-Bihar Orangi Town',
      'end': 'Singer Chowrangi',
      'distance': '29.6 KM',
      'stops': 16,
    },
    'R7': {
      'start': 'Mosamiyat',
      'end': 'Gulshan-e-Ghazi',
      'distance': 'Not available',
      'stops': 10,
    },
    'R8': {
      'start': 'Yousuf Goth',
      'end': 'Tower',
      'distance': '17 KM',
      'stops': 13,
    },
    'R9': {
      'start': 'Gulshan-e-Hadeed',
      'end': 'Tower',
      'distance': '48 KM',
      'stops': 18,
    },
    'R10': {
      'start': 'Numaish',
      'end': 'Ibrahim Hyderi',
      'distance': '30 KM',
      'stops': 15,
    },
    'R11': {
      'start': 'Mera Naka',
      'end': 'Ziauddin Hospital',
      'distance': '21 KM',
      'stops': 11,
    },
    'R12': {
      'start': 'Memon Goth',
      'end': 'Saddar Lucky Star',
      'distance': '36 KM',
      'stops': 15,
    },
    'R13': {
      'start': 'Hawksbay',
      'end': 'Tower',
      'distance': '19 KM',
      'stops': 10,
    },
    'R14': {
      'start': 'Maymar',
      'end': 'Tower',
      'distance': '29 KM',
      'stops': 16,
    },
    'EV1': {
      'start': 'CMH Malir Cantt',
      'end': 'Dolmen Mall',
      'distance': '41 KM',
      'stops': 18,
    },
    'EV2': {
      'start': 'Bahria Town',
      'end': 'Malir Halt',
      'distance': '44 KM',
      'stops': 8,
    },
    'EV3': {
      'start': 'Quaid-e-Azam Square Malir Cantt',
      'end': 'Numaish',
      'distance': '23 KM',
      'stops': 16,
    },
    'EV4': {
      'start': 'Bahria Town',
      'end': 'Ayesha Manzil',
      'distance': '58 KM',
      'stops': 10,
    },
    'EV5': {
      'start': 'DHA City',
      'end': 'Sohrab Goth',
      'distance': '48 KM',
      'stops': 10,
    },
    'DD01': {
      'start': 'Model Colony',
      'end': 'Tower',
      'distance': '24 KM',
      'stops': 14,
    },
  };

  @override
  Widget build(BuildContext context) {
    final route = routeData[routeCode];

    if (route == null) {
      return Scaffold(
        backgroundColor: backgroundColor,
        body: Center(
          child: Text('Route $routeCode details not found'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: backgroundColor,

      // Bottom Buttons
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            22,
            12,
            22,
            20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // View Live Tracking Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Live tracking will be connected later.',
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  child: const Text(
                    'View Live Tracking',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Continue Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: () {
                    if (nextScreenBuilder != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: nextScreenBuilder!,
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Next screen will be connected.',
                          ),
                        ),
                      );
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: darkBlue,
                    side: const BorderSide(
                      color: primaryColor,
                      width: 1.5,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(35),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(
                        Icons.arrow_forward,
                        size: 22,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      body: SafeArea(
        child: Column(
          children: [

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: darkBlue,
                    ),
                  ),

                  const Expanded(
                    child: Text(
                      'Route Details',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: darkBlue,
                      ),
                    ),
                  ),

                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Route Details Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                child: Column(
                  children: [

                    // Selected Route Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 48,
                            width: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE4F6FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.directions_bus_outlined,
                              color: Color(0xFF00A6B5),
                              size: 30,
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Route $routeCode',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: darkBlue,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  '${route['start']} → ${route['end']}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: darkBlue,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.chevron_right,
                            color: primaryColor,
                            size: 27,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Distance and Stops Cards
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            title: 'Total Distance',
                            value: route['distance'].toString(),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: _buildInfoCard(
                            title: 'Total Stops',
                            value: route['stops'].toString(),
                          ),
                        ),
                      ],
                    ),

                    // Map Placeholder
                    const SizedBox(height: 85),

                    Container(
                      width: double.infinity,
                      height: 155,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDCEBF0),
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Information Card
  Widget _buildInfoCard({
    required String title,
    required String value,
  }) {
    return Container(
      height: 105,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: darkBlue,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            value,
            style: const TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: darkBlue,
            ),
          ),
        ],
      ),
    );
  }
}