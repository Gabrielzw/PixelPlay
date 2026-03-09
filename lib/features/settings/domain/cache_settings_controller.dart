import 'package:get/get.dart';

import 'cache_cleaner.dart';

class CacheSettingsController extends GetxController {
  final CacheCleaner cacheCleaner;
  final RxBool isClearing = false.obs;

  CacheSettingsController({required this.cacheCleaner});

  Future<void> clearCache() async {
    if (isClearing.value) {
      return;
    }

    isClearing.value = true;
    try {
      await cacheCleaner.clearAll();
    } finally {
      isClearing.value = false;
    }
  }
}
