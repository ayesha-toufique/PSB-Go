import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:psb_go/constants/app_assets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../passenger/explore_routes_screen.dart';
import '../../constants/app_colors.dart';
import '../../controllers/theme_controller.dart';
import 'profile_screen.dart';

class PassengerHomeScreen extends StatefulWidget {
  const PassengerHomeScreen({super.key});

  @override
  State<PassengerHomeScreen> createState() =>
      _PassengerHomeScreenState();
}

class _PassengerHomeScreenState extends State<PassengerHomeScreen> {
  int selectedIndex = 0;

  final searchController = TextEditingController();

  late final ThemeController themeController;
  final RxString userName = 'Passenger'.obs;

  @override
  void initState() {
    super.initState();

    themeController = Get.find<ThemeController>();
    loadUserName();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
  Future<void> loadUserName() async {
    final prefs = await SharedPreferences.getInstance();

    userName.value = prefs.getString('userName') ?? 'Passenger';
  }
  void showFeatureMessage(String feature) {
    Get.snackbar(
      feature,
      'This feature will be connected soon.',
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(15),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      extendBody: true,

      // FULL SCREEN BACKGROUND
      body: Container(
        width: double.infinity,
        height: double.infinity,

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
          bottom: false,
          child: IndexedStack(
            index: selectedIndex,
            children: [
              _buildHome(context, isDark, colors),
              const ExploreRoutesScreen(),
              _buildPlaceholder(
                context,
                'My Trips',
                Icons.directions_bus_outlined,
              ),
              const ProfileScreen(),
            ],
          ),
        ),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border(
            top: BorderSide(
              color: isDark
                  ? AppColors.darkBorder
                  : AppColors.lightBorder,
            ),
          ),
        ),

        child: NavigationBar(
          height: 68,
          backgroundColor: colors.surface,
          elevation: 0,
          selectedIndex: selectedIndex,

          indicatorColor: isDark
              ? AppColors.darkAccent.withOpacity(0.18)
              : AppColors.lightAccent.withOpacity(0.12),

          onDestinationSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },

          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.explore_outlined),
              selectedIcon: Icon(Icons.explore),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Icon(Icons.confirmation_number_outlined),
              selectedIcon: Icon(Icons.confirmation_number),
              label: 'My Trips',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  // HOME CONTENT
  Widget _buildHome(
    BuildContext context,
    bool isDark,
    ColorScheme colors,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // HEADER
          Row(
            children: [
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: SvgPicture.asset(
                            AppAssets.logo,
                            width: 150,
                            height: 130,
                            fit: BoxFit.contain,
                          )
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'PSB Go',
                      style: TextStyle(
                        color: colors.onSurface,
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Track • Ride • Explore',
                      style: TextStyle(
                        color: colors.onSurface.withOpacity(0.65),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              // THEME TOGGLE
              Obx(
                () => IconButton(
                  onPressed: themeController.toggleTheme,
                  icon: Icon(
                    themeController.isDarkMode.value
                        ? Icons.light_mode
                        : Icons.dark_mode,
                    color: colors.onSurface,
                  ),
                ),
              ),

              // NOTIFICATIONS
              IconButton(
                onPressed: () {
                  showFeatureMessage('Notifications');
                },
                icon: Icon(
                  Icons.notifications_none,
                  color: colors.onSurface,
                  size: 26,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // GREETING
            Obx(
              () => Text(
                'Hello, ${userName.value}!',
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          const SizedBox(height: 5),

          Text(
            'Where would you like to go today?',
            style: TextStyle(
              color: colors.onSurface.withOpacity(0.7),
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 22),

          // SEARCH BAR
          TextField(
            controller: searchController,

            style: TextStyle(
              color: colors.onSurface,
              fontSize: 14,
            ),

            decoration: InputDecoration(
              hintText: 'Search bus, route or destination',
              hintStyle: TextStyle(
                color: colors.onSurface.withOpacity(0.55),
                fontSize: 13,
              ),

              prefixIcon: Icon(
                Icons.search,
                color: colors.secondary,
              ),

              suffixIcon: IconButton(
                onPressed: () {
                  if (searchController.text.trim().isEmpty) {
                    showFeatureMessage('Search');
                  } else {
                    showFeatureMessage(
                      'Searching: ${searchController.text}',
                    );
                  }
                },
                icon: Icon(
                  Icons.arrow_forward,
                  color: colors.secondary,
                ),
              ),

              filled: true,
              fillColor: colors.surface,

              contentPadding: const EdgeInsets.symmetric(
                vertical: 17,
                horizontal: 15,
              ),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: isDark
                      ? AppColors.darkBorder
                      : AppColors.lightBorder,
                ),
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(
                  color: colors.secondary,
                  width: 1.5,
                ),
              ),
            ),
          ),

          const SizedBox(height: 25),

          // LIVE TRACKING BANNER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),

            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.brandGreen,
                  AppColors.brandTeal,
                ],
              ),

              borderRadius: BorderRadius.circular(20),
            ),

            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your journey starts here!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'Find your bus and track it in real time.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 16),

                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedIndex = 1;
                          });
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.brandTeal,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 11,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),

                        child: const Text(
                          'Explore Routes',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                const Icon(
                  Icons.directions_bus_filled_rounded,
                  color: Colors.white,
                  size: 75,
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // QUICK ACTIONS HEADING
          _sectionHeading(
            'Quick Actions',
            'Explore services',
            colors,
          ),

          const SizedBox(height: 16),

          // QUICK ACTION CARDS
          Row(
            children: [
              Expanded(
                child: _quickAction(
                  context: context,
                  icon: Icons.location_on_outlined,
                  title: 'Track Bus',
                  subtitle: 'Live location',
                  colors: colors,
                  onTap: () {
                    showFeatureMessage('Track Bus');
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _quickAction(
                  context: context,
                  icon: Icons.route_outlined,
                  title: 'Find Routes',
                  subtitle: 'Plan your trip',
                  colors: colors,
                  onTap: () {
                    setState(() {
                      selectedIndex = 1;
                    });
                  },
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _quickAction(
                  context: context,
                  icon: Icons.place_outlined,
                  title: 'Nearby Stops',
                  subtitle: 'Find stops',
                  colors: colors,
                  onTap: () {
                    showFeatureMessage('Nearby Stops');
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // POPULAR ROUTES
          _sectionHeading(
            'Popular Routes',
            'View all',
            colors,
            onAction: () {
              setState(() {
                selectedIndex = 1;
              });
            },
          ),

          const SizedBox(height: 15),

          _routeCard(
            context: context,
            routeNumber: 'R1',
            routeName: 'Model Colony to Tower',
            description: 'Karachi Red Bus',
            colors: colors,
          ),

          const SizedBox(height: 12),

          _routeCard(
            context: context,
            routeNumber: 'R2',
            routeName: 'North Karachi to Korangi',
            description: 'Karachi Red Bus',
            colors: colors,
          ),

          const SizedBox(height: 12),

          _routeCard(
            context: context,
            routeNumber: 'R3',
            routeName: 'Nagan Chowrangi to Shahrah-e-Faisal',
            description: 'Karachi Red Bus',
            colors: colors,
          ),

          const SizedBox(height: 25),

          // BOTTOM INFORMATION
          Center(
            child: Text(
              'PSB Go • Making your commute easier',
              style: TextStyle(
                color: colors.onSurface.withOpacity(0.5),
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SECTION HEADING
  Widget _sectionHeading(
    String title,
    String action,
    ColorScheme colors, {
    VoidCallback? onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: colors.onSurface,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),

        TextButton(
          onPressed: onAction,
          child: Text(
            action,
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

  // QUICK ACTION CARD
  Widget _quickAction({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required ColorScheme colors,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),

      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 17,
          horizontal: 8,
        ),

        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkBorder
                : AppColors.lightBorder,
          ),
        ),

        child: Column(
          children: [
            Icon(
              icon,
              color: colors.secondary,
              size: 27,
            ),

            const SizedBox(height: 10),

            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              subtitle,
              textAlign: TextAlign.center,
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

  // ROUTE CARD
  Widget _routeCard({
    required BuildContext context,
    required String routeNumber,
    required String routeName,
    required String description,
    required ColorScheme colors,
  }) {
    return InkWell(
      onTap: () {
        showFeatureMessage('$routeNumber Route');
      },

      borderRadius: BorderRadius.circular(16),

      child: Container(
        padding: const EdgeInsets.all(14),

        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppColors.darkBorder
                : AppColors.lightBorder,
          ),
        ),

        child: Row(
          children: [
            Container(
              height: 47,
              width: 47,

              decoration: BoxDecoration(
                color: AppColors.brandRed.withOpacity(0.12),
                borderRadius: BorderRadius.circular(13),
              ),

              child: const Icon(
                Icons.directions_bus_rounded,
                color: AppColors.brandRed,
                size: 26,
              ),
            ),

            const SizedBox(width: 13),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    routeNumber,
                    style: const TextStyle(
                      color: AppColors.brandTeal,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    routeName,
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    description,
                    style: TextStyle(
                      color: colors.onSurface.withOpacity(0.55),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),

            Icon(
              Icons.arrow_forward_ios,
              color: colors.onSurface.withOpacity(0.5),
              size: 15,
            ),
          ],
        ),
      ),
    );
  }

  // PLACEHOLDER PAGES FOR OTHER TABS
  Widget _buildPlaceholder(
    BuildContext context,
    String title,
    IconData icon,
  ) {
    final colors = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: colors.secondary,
            size: 65,
          ),

          const SizedBox(height: 15),

          Text(
            title,
            style: TextStyle(
              color: colors.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            'This section is coming soon.',
            style: TextStyle(
              color: colors.onSurface.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
