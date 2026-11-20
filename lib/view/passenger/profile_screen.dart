
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../services/auth_service.dart';
import '../../routes/app_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  bool isLoading = true;
  bool isLoggingOut = false;
  Map<String, dynamic> user = {};

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final result = await _authService.getMe();

      if (!mounted) return;

      setState(() {
        user = result['user'] is Map
            ? Map<String, dynamic>.from(result['user'])
            : Map<String, dynamic>.from(result);
        isLoading = false;
      });
    } catch (e) {
      final savedUser = await _authService.getSavedUser();

      if (!mounted) return;

      setState(() {
        if (savedUser != null) {
          user = {
            'name': savedUser.name,
            'email': savedUser.email,
            'role': savedUser.role,
          };
        }
        isLoading = false;
      });

      Get.snackbar(
        'Profile',
        'Showing saved profile information.',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> confirmLogout() async {
    final shouldLogout = await Get.dialog<bool>(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text(
          'Are you sure you want to logout from PSB Go?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () => Get.back(result: true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await logout();
    }
  }

  Future<void> logout() async {
    if (isLoggingOut) return;

    setState(() => isLoggingOut = true);

    try {
      await _authService.logout();
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoggingOut = false);

      Get.snackbar(
        'Logout Error',
        'Unable to logout. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final name = user['name']?.toString() ?? 'Passenger';
    final email = user['email']?.toString() ?? 'No email available';
    final role = user['role']?.toString() ?? 'passenger';

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackgroundStart
          : AppColors.lightBackgroundEnd,
      appBar: AppBar(
        backgroundColor: colors.surface,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'My Profile',
          style: TextStyle(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.brandRed,
              ),
            )
          : RefreshIndicator(
              onRefresh: loadProfile,
              color: AppColors.brandRed,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // PROFILE HEADER
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.lightBorder,
                      ),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 42,
                          backgroundColor:
                              AppColors.brandRed.withOpacity(0.12),
                          child: Text(
                            name.isNotEmpty
                                ? name[0].toUpperCase()
                                : 'P',
                            style: const TextStyle(
                              color: AppColors.brandRed,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colors.onSurface,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          email,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: colors.onSurface.withOpacity(0.6),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.brandRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            role.toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.brandRed,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 26),

                  Text(
                    'Account Information',
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _infoTile(
                    icon: Icons.person_outline,
                    title: 'Full Name',
                    value: name,
                    colors: colors,
                  ),
                  _infoTile(
                    icon: Icons.email_outlined,
                    title: 'Email Address',
                    value: email,
                    colors: colors,
                  ),
                  _infoTile(
                    icon: Icons.badge_outlined,
                    title: 'Account Type',
                    value: role.toUpperCase(),
                    colors: colors,
                  ),

                  const SizedBox(height: 26),

                  Text(
                    'Account Settings',
                    style: TextStyle(
                      color: colors.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  _actionTile(
                    icon: Icons.notifications_none_rounded,
                    title: 'Announcements',
                    subtitle: 'View service updates',
                    colors: colors,
                    onTap: () {
                      Get.snackbar(
                        'Announcements',
                        'We will connect this screen next.',
                      );
                    },
                  ),

                  _actionTile(
                    icon: Icons.favorite_border_rounded,
                    title: 'Favourite Routes',
                    subtitle: 'Manage your saved routes',
                    colors: colors,
                    onTap: () {
                      Get.toNamed(AppRoutes.favourites);
                    },
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: isLoggingOut ? null : confirmLogout,
                      icon: isLoggingOut
                          ? const SizedBox(
                              height: 18,
                              width: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.logout_rounded),
                      label: Text(
                        isLoggingOut ? 'Logging out...' : 'Logout',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.brandRed,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

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
            ),
    );
  }

  Widget _infoTile({
    required IconData icon,
    required String title,
    required String value,
    required ColorScheme colors,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.brandRed, size: 22),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: colors.onSurface.withOpacity(0.55),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: colors.onSurface,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required ColorScheme colors,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        leading: Icon(icon, color: AppColors.brandRed),
        title: Text(
          title,
          style: TextStyle(
            color: colors.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            color: colors.onSurface.withOpacity(0.55),
            fontSize: 11,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios_rounded,
          size: 15,
          color: colors.onSurface.withOpacity(0.5),
        ),
      ),
    );
  }
}
