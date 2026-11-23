
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/app_colors.dart';
import '../../controllers/passenger/announcement_controller.dart';
import '../../models/announcement_model.dart';

class AnnouncementsScreen extends StatelessWidget {
  const AnnouncementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AnnouncementController());

    final colors = Theme.of(context).colorScheme;
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackgroundStart
          : AppColors.lightBackgroundEnd,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors.surface,
        title: Text(
          'Announcements',
          style: TextStyle(
            color: colors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 19,
          ),
        ),
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: colors.onSurface,
          ),
        ),
      ),
      body: Obx(() {
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stay Updated!',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Get the latest bus service information.',
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 18),

                  // SEARCH FIELD
                  TextField(
                    onChanged: controller.updateSearch,
                    style: TextStyle(color: colors.onSurface),
                    decoration: InputDecoration(
                      hintText: 'Search announcements...',
                      hintStyle: TextStyle(
                        color: colors.onSurface.withOpacity(0.5),
                      ),
                      prefixIcon: Icon(
                        Icons.search_rounded,
                        color: colors.onSurface.withOpacity(0.6),
                      ),
                      filled: true,
                      fillColor: colors.surface,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.lightBorder,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: const BorderSide(
                          color: AppColors.brandRed,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // FILTERS
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _filterChip(
                          controller,
                          'All',
                          'all',
                        ),
                        _filterChip(
                          controller,
                          'Updates',
                          'info',
                        ),
                        _filterChip(
                          controller,
                          'Warnings',
                          'warning',
                        ),
                        _filterChip(
                          controller,
                          'Urgent',
                          'urgent',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ANNOUNCEMENT LIST
            Expanded(
              child: _buildAnnouncementList(
                controller,
                colors,
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _filterChip(
    AnnouncementController controller,
    String label,
    String value,
  ) {
    return Obx(() {
      final isSelected =
          controller.selectedFilter.value == value;

      return Padding(
        padding: const EdgeInsets.only(right: 9),
        child: ChoiceChip(
          label: Text(label),
          selected: isSelected,
          onSelected: (_) => controller.changeFilter(value),
          selectedColor: AppColors.brandRed,
          backgroundColor: Colors.transparent,
          side: BorderSide(
            color: isSelected
                ? AppColors.brandRed
                : AppColors.grey.withOpacity(0.4),
          ),
          labelStyle: TextStyle(
            color: isSelected
                ? Colors.white
                : Get.theme.colorScheme.onSurface,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          showCheckmark: false,
        ),
      );
    });
  }

  Widget _buildAnnouncementList(
    AnnouncementController controller,
    ColorScheme colors,
  ) {
    if (controller.isLoading.value) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.brandRed,
        ),
      );
    }

    if (controller.errorMessage.value.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.wifi_off_rounded,
                size: 48,
                color: AppColors.grey,
              ),
              const SizedBox(height: 14),
              Text(
                controller.errorMessage.value,
                textAlign: TextAlign.center,
                style: TextStyle(color: colors.onSurface),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: controller.loadAnnouncements,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandRed,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    final items = controller.filteredAnnouncements;

    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: controller.loadAnnouncements,
        color: AppColors.brandRed,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            const SizedBox(height: 100),
            Icon(
              Icons.notifications_off_outlined,
              size: 55,
              color: colors.onSurface.withOpacity(0.35),
            ),
            const SizedBox(height: 15),
            Text(
              controller.announcements.isEmpty
                  ? 'No announcements available'
                  : 'No matching announcements found',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.onSurface.withOpacity(0.65),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.loadAnnouncements,
      color: AppColors.brandRed,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(18, 5, 18, 25),
        itemCount: items.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: 13),
        itemBuilder: (context, index) {
          final announcement = items[index];

          return _announcementCard(
            context,
            announcement,
            colors,
          );
        },
      ),
    );
  }

  Widget _announcementCard(
    BuildContext context,
    AnnouncementModel announcement,
    ColorScheme colors,
  ) {
    final typeColor = _typeColor(announcement.type);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => _showDetails(
        context,
        announcement,
        colors,
      ),
      child: Container(
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: typeColor.withOpacity(0.25),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: typeColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _typeLabel(announcement.type),
                    style: TextStyle(
                      color: typeColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Spacer(),
                Icon(
                  _typeIcon(announcement.type),
                  color: typeColor,
                  size: 21,
                ),
              ],
            ),
            const SizedBox(height: 13),
            Text(
              announcement.title,
              style: TextStyle(
                color: colors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              announcement.message,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colors.onSurface.withOpacity(0.65),
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: colors.onSurface.withOpacity(0.5),
                ),
                const SizedBox(width: 5),
                Text(
                  _formatDate(announcement.createdAt),
                  style: TextStyle(
                    color: colors.onSurface.withOpacity(0.55),
                    fontSize: 11,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Read more',
                  style: TextStyle(
                    color: AppColors.brandRed,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 3),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: AppColors.brandRed,
                  size: 11,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDetails(
    BuildContext context,
    AnnouncementModel announcement,
    ColorScheme colors,
  ) {
    final typeColor = _typeColor(announcement.type);

    Get.dialog(
      AlertDialog(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                announcement.title,
                style: TextStyle(
                  color: colors.onSurface,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(
              onPressed: Get.back,
              icon: Icon(
                Icons.close,
                color: colors.onSurface,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _typeLabel(announcement.type),
                  style: TextStyle(
                    color: typeColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(height: 17),
              Text(
                announcement.message,
                style: TextStyle(
                  color: colors.onSurface.withOpacity(0.8),
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Published: ${_formatDate(announcement.createdAt)}',
                style: TextStyle(
                  color: colors.onSurface.withOpacity(0.5),
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text(
              'Close',
              style: TextStyle(
                color: AppColors.brandRed,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'urgent':
        return AppColors.brandRed;
      case 'warning':
        return AppColors.warning;
      default:
        return AppColors.brandCyan;
    }
  }

  String _typeLabel(String type) {
    switch (type) {
      case 'urgent':
        return 'URGENT';
      case 'warning':
        return 'WARNING';
      default:
        return 'SERVICE UPDATE';
    }
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'urgent':
        return Icons.error_outline_rounded;
      case 'warning':
        return Icons.warning_amber_rounded;
      default:
        return Icons.info_outline_rounded;
    }
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Date unavailable';

    final localDate = date.toLocal();

    final day = localDate.day.toString().padLeft(2, '0');
    final month = localDate.month.toString().padLeft(2, '0');
    final year = localDate.year;

    final hour = localDate.hour % 12 == 0
        ? 12
        : localDate.hour % 12;
    final minute = localDate.minute.toString().padLeft(2, '0');
    final period = localDate.hour >= 12 ? 'PM' : 'AM';

    return '$day/$month/$year  $hour:$minute $period';
  }
}
