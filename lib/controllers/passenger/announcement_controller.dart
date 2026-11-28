import 'package:get/get.dart';

import '../../models/announcement_model.dart';
import '../../services/announcement_service.dart';

class AnnouncementController extends GetxController {
  final AnnouncementService _service = AnnouncementService();

  final announcements = <AnnouncementModel>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  final searchQuery = ''.obs;
  final selectedFilter = 'all'.obs;

  @override
  void onInit() {
    super.onInit();
    loadAnnouncements();
  }

  Future<void> loadAnnouncements() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await _service.getAnnouncements();
      announcements.assignAll(result);
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  void changeFilter(String filter) {
    selectedFilter.value = filter;
  }

  List<AnnouncementModel> get filteredAnnouncements {
    return announcements.where((announcement) {
      final query = searchQuery.value.toLowerCase().trim();

      final matchesSearch =
          announcement.title.toLowerCase().contains(query) ||
          announcement.message.toLowerCase().contains(query);

      final matchesFilter = selectedFilter.value == 'all' ||
          announcement.type == selectedFilter.value;

      return matchesSearch && matchesFilter;
    }).toList();
  }
}