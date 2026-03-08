import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../media_library/presentation/widgets/album_page_body.dart';
import '../../webdav_client/domain/contracts/webdav_account_repository.dart';
import '../domain/watch_history_repository.dart';
import 'watch_history_player_launcher.dart';
import 'widgets/watch_history_confirm_dialog.dart';
import 'widgets/watch_history_page_app_bar.dart';
import 'widgets/watch_history_records_view.dart';

class WatchHistoryPage extends StatefulWidget {
  const WatchHistoryPage({super.key});

  @override
  State<WatchHistoryPage> createState() => _WatchHistoryPageState();
}

class _WatchHistoryPageState extends State<WatchHistoryPage>
    with SingleTickerProviderStateMixin {
  late final WatchHistoryRepository _watchHistoryRepository;
  late final WebDavAccountRepository _webDavAccountRepository;
  late final TextEditingController _searchController;
  late final TabController _tabController;

  List<WatchHistoryRecord> _records = const <WatchHistoryRecord>[];
  Set<String> _selectedRecordIds = const <String>{};
  Object? _error;
  bool _isLoading = true;
  bool _isSearching = false;
  String _searchQuery = '';

  bool get _isSelectionMode => _selectedRecordIds.isNotEmpty;
  WatchHistoryFilter get _currentFilter =>
      WatchHistoryFilter.values[_tabController.index];
  List<WatchHistoryRecord> get _currentVisibleRecords =>
      buildVisibleWatchHistoryRecords(_records, _currentFilter, _searchQuery);
  bool get _canSelectAllInCurrentTab => _currentVisibleRecords.any(
    (WatchHistoryRecord record) => !_selectedRecordIds.contains(record.mediaId),
  );

  @override
  void initState() {
    super.initState();
    _watchHistoryRepository = Get.find<WatchHistoryRepository>();
    _webDavAccountRepository = Get.find<WebDavAccountRepository>();
    _searchController = TextEditingController();
    _tabController = TabController(
      length: WatchHistoryFilter.values.length,
      vsync: this,
    )..addListener(_handleTabChanged);
    _reloadRecords();
  }

  @override
  void dispose() {
    _tabController
      ..removeListener(_handleTabChanged)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<void>(
      canPop: !_isSearching && !_isSelectionMode,
      onPopInvokedWithResult: _handlePopInvoked,
      child: Scaffold(
        appBar: WatchHistoryPageAppBar(
          tabController: _tabController,
          isSearching: _isSearching,
          isSelectionMode: _isSelectionMode,
          canSelectAllInCurrentTab: _canSelectAllInCurrentTab,
          selectedCount: _selectedRecordIds.length,
          searchController: _searchController,
          onSearchChanged: _updateSearchQuery,
          onStartSearching: _startSearching,
          onStopSearching: _stopSearching,
          onSelectAllInCurrentTab: _selectAllInCurrentTab,
          onRemoveSelected: _removeSelectedRecords,
          onClearAllRequested: _clearAllRecords,
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_error != null) {
      return AlbumPageErrorView(
        message: _error.toString(),
        onRetry: _reloadRecords,
      );
    }
    if (_isLoading) {
      return const AlbumPageLoadingView();
    }

    return TabBarView(
      controller: _tabController,
      children: WatchHistoryFilter.values
          .map(
            (WatchHistoryFilter filter) => WatchHistoryRecordsView(
              records: _records,
              filter: filter,
              searchQuery: _searchQuery,
              selectedRecordIds: _selectedRecordIds,
              onTapRecord: _openRecord,
              onLongPressRecord: _toggleRecordSelection,
              onToggleSelection: _toggleRecordSelection,
            ),
          )
          .toList(growable: false),
    );
  }

  Future<void> _openRecord(WatchHistoryRecord record) async {
    await openWatchHistoryRecord(
      context: context,
      record: record,
      webDavAccountRepository: _webDavAccountRepository,
    );
    if (!mounted) {
      return;
    }
    await _reloadRecords();
  }

  Future<void> _reloadRecords() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final records = await _watchHistoryRepository.loadAll();
      if (!mounted) {
        return;
      }
      setState(() {
        _records = records;
        _selectedRecordIds = _retainSelectableIds(records);
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = error;
        _isLoading = false;
      });
    }
  }

  void _startSearching() => setState(() => _isSearching = true);

  void _stopSearching() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _searchQuery = '';
    });
  }

  void _updateSearchQuery(String value) => setState(() => _searchQuery = value);

  void _toggleRecordSelection(WatchHistoryRecord record) {
    final nextSelectedIds = Set<String>.of(_selectedRecordIds);
    if (!nextSelectedIds.remove(record.mediaId)) {
      nextSelectedIds.add(record.mediaId);
    }
    setState(() {
      _selectedRecordIds = Set<String>.unmodifiable(nextSelectedIds);
    });
  }

  void _selectAllInCurrentTab() {
    final nextSelectedIds = Set<String>.of(_selectedRecordIds)
      ..addAll(
        _currentVisibleRecords.map(
          (WatchHistoryRecord record) => record.mediaId,
        ),
      );
    setState(() {
      _selectedRecordIds = Set<String>.unmodifiable(nextSelectedIds);
    });
  }

  Future<void> _clearAllRecords() async {
    final confirmed = await showWatchHistoryConfirmationDialog(
      context,
      title: '清空全部观看记录？',
      content: '清空后将移除全部观看记录，此操作不可撤销。',
      confirmLabel: '清空',
    );
    if (!confirmed) {
      return;
    }

    await _watchHistoryRepository.clearAll();
    if (!mounted) {
      return;
    }
    setState(() => _selectedRecordIds = const <String>{});
    await _reloadRecords();
  }

  Future<void> _removeSelectedRecords() async {
    final selectedIds = _selectedRecordIds.toList(growable: false);
    if (selectedIds.isEmpty) {
      return;
    }

    final confirmed = await showWatchHistoryConfirmationDialog(
      context,
      title: '移除所选观看记录？',
      content: '移除后将删除已选择的观看记录，此操作不可撤销。',
      confirmLabel: '移除',
    );
    if (!confirmed) {
      return;
    }

    await _watchHistoryRepository.removeAll(selectedIds);
    if (!mounted) {
      return;
    }
    setState(() => _selectedRecordIds = const <String>{});
    await _reloadRecords();
  }

  void _handlePopInvoked(bool didPop, Object? result) {
    if (didPop) {
      return;
    }
    if (_isSelectionMode) {
      setState(() => _selectedRecordIds = const <String>{});
      return;
    }
    if (_isSearching) {
      _stopSearching();
    }
  }

  void _handleTabChanged() {
    if (!mounted) {
      return;
    }
    setState(() {});
  }

  Set<String> _retainSelectableIds(List<WatchHistoryRecord> records) {
    final availableIds = records
        .map((WatchHistoryRecord record) => record.mediaId)
        .toSet();
    return _selectedRecordIds
        .where((String mediaId) => availableIds.contains(mediaId))
        .toSet();
  }
}
