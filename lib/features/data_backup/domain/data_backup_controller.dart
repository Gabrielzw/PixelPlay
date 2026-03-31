import 'package:get/get.dart';

import 'app_restore_refresher.dart';
import 'data_backup_entry.dart';
import 'data_backup_repository.dart';

const String kRestoreProcessingToken = '__restore__';

class DataBackupController extends GetxController {
  final DataBackupRepository repository;
  final AppRestoreRefresher appRestoreRefresher;
  final RxList<DataBackupEntry> backups = <DataBackupEntry>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isCreating = false.obs;
  final RxnString processingBackupId = RxnString();
  final RxnString errorMessage = RxnString();

  DataBackupController({
    required this.repository,
    required this.appRestoreRefresher,
  });

  @override
  void onInit() {
    super.onInit();
    refreshBackups();
  }

  Future<void> refreshBackups({bool rethrowError = false}) async {
    isLoading.value = true;
    errorMessage.value = null;
    try {
      backups.assignAll(await repository.loadBackups());
    } catch (error) {
      errorMessage.value = error.toString();
      if (rethrowError) {
        rethrow;
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> createBackup() async {
    isCreating.value = true;
    try {
      final entry = await repository.createBackup();
      if (entry == null) {
        return false;
      }
      await refreshBackups(rethrowError: true);
      return true;
    } finally {
      isCreating.value = false;
    }
  }

  Future<bool> restoreBackup() async {
    processingBackupId.value = kRestoreProcessingToken;
    try {
      final restored = await repository.restoreBackup();
      if (!restored) {
        return false;
      }
      await appRestoreRefresher.refreshRestoredData();
      await refreshBackups(rethrowError: true);
      return true;
    } finally {
      if (processingBackupId.value == kRestoreProcessingToken) {
        processingBackupId.value = null;
      }
    }
  }

  Future<void> deleteBackup(String backupId) async {
    processingBackupId.value = backupId;
    try {
      await repository.deleteBackup(backupId);
      await refreshBackups(rethrowError: true);
    } finally {
      if (processingBackupId.value == backupId) {
        processingBackupId.value = null;
      }
    }
  }
}
