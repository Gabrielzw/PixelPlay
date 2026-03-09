import 'package:flutter_test/flutter_test.dart';

import 'package:pixelplay/features/webdav_client/data/in_memory_webdav_account_repository.dart';
import 'package:pixelplay/features/webdav_client/data/in_memory_webdav_browser_repository.dart';
import 'package:pixelplay/features/webdav_client/data/in_memory_webdav_sort_preference_store.dart';
import 'package:pixelplay/features/webdav_client/domain/entities/webdav_entry.dart';
import 'package:pixelplay/features/webdav_client/domain/webdav_server_config.dart';
import 'package:pixelplay/features/webdav_client/domain/webdav_sort_option.dart';
import 'package:pixelplay/features/webdav_client/presentation/controllers/webdav_browser_controller.dart';

void main() {
  test('uses playlist path as browser root path', () async {
    final accountRepository = InMemoryWebDavAccountRepository();
    final sortPreferenceStore = InMemoryWebDavSortPreferenceStore();
    final account = WebDavServerConfig(
      id: 'webdav-1',
      alias: '家庭云盘',
      url: Uri.parse('https://example.com/dav/'),
      username: 'tester',
      rootPath: '/',
    );
    await accountRepository.saveAccount(account, password: 'pass');

    final controller = WebDavBrowserController(
      browserRepository: const InMemoryWebDavBrowserRepository(
        entriesByPath: <String, List<WebDavEntry>>{
          '/电影': <WebDavEntry>[],
          '/电影/动作': <WebDavEntry>[],
        },
      ),
      accountRepository: accountRepository,
      sortPreferenceStore: sortPreferenceStore,
      account: account,
      initialPath: '/电影',
      rootPath: '/电影',
    );

    expect(controller.state.value.rootPath, '/电影');
    expect(controller.state.value.currentPath, '/电影');
    expect(controller.state.value.isAtRootPath, isTrue);

    await controller.openPath('/电影/动作');
    expect(controller.state.value.currentPath, '/电影/动作');
    expect(controller.state.value.isAtRootPath, isFalse);

    final didGoBack = await controller.goBack();
    expect(didGoBack, isTrue);
    expect(controller.state.value.currentPath, '/电影');
    expect(controller.state.value.isAtRootPath, isTrue);

    final canGoBackAgain = await controller.goBack();
    expect(canGoBackAgain, isFalse);
    expect(controller.state.value.currentPath, '/电影');
  });

  test('persists selected sort option across controllers', () async {
    final accountRepository = InMemoryWebDavAccountRepository();
    final sortPreferenceStore = InMemoryWebDavSortPreferenceStore();
    final account = WebDavServerConfig(
      id: 'webdav-2',
      alias: '家庭云盘',
      url: Uri.parse('https://example.com/dav/'),
      username: 'tester',
      rootPath: '/',
    );
    await accountRepository.saveAccount(account, password: 'pass');

    final controller = WebDavBrowserController(
      browserRepository: const InMemoryWebDavBrowserRepository(),
      accountRepository: accountRepository,
      sortPreferenceStore: sortPreferenceStore,
      account: account,
    );
    await controller.updateSortOption(WebDavSortOption.newest);

    final restoredController = WebDavBrowserController(
      browserRepository: const InMemoryWebDavBrowserRepository(),
      accountRepository: accountRepository,
      sortPreferenceStore: sortPreferenceStore,
      account: account,
    );
    await restoredController.initialize();

    expect(restoredController.state.value.sortOption, WebDavSortOption.newest);
  });
}
