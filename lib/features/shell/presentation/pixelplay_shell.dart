import 'package:flutter/material.dart';

import '../../favorites/presentation/favorites_page.dart';
import '../../library/presentation/local_library_page.dart';
import '../../settings/presentation/settings_page.dart';
import '../../webdav/presentation/webdav_accounts_page.dart';

enum _ShellTab { library, webdav, favorites, settings }

class PixelPlayShell extends StatefulWidget {
  const PixelPlayShell({super.key});

  @override
  State<PixelPlayShell> createState() => _PixelPlayShellState();
}

class _PixelPlayShellState extends State<PixelPlayShell> {
  static const List<_ShellTab> _tabs = <_ShellTab>[
    _ShellTab.library,
    _ShellTab.webdav,
    _ShellTab.favorites,
    _ShellTab.settings,
  ];

  late final Map<_ShellTab, NavigatorObserver> _observers =
      <_ShellTab, NavigatorObserver>{
        _ShellTab.library: _TabNavigatorObserver(_refreshShell),
        _ShellTab.webdav: _TabNavigatorObserver(_refreshShell),
        _ShellTab.favorites: _TabNavigatorObserver(_refreshShell),
        _ShellTab.settings: _TabNavigatorObserver(_refreshShell),
      };

  final Map<_ShellTab, GlobalKey<NavigatorState>> _navigatorKeys =
      <_ShellTab, GlobalKey<NavigatorState>>{
        _ShellTab.library: GlobalKey<NavigatorState>(),
        _ShellTab.webdav: GlobalKey<NavigatorState>(),
        _ShellTab.favorites: GlobalKey<NavigatorState>(),
        _ShellTab.settings: GlobalKey<NavigatorState>(),
      };

  _ShellTab _currentTab = _ShellTab.library;

  bool _refreshScheduled = false;

  void _refreshShell() {
    if (!mounted) return;
    if (_refreshScheduled) return;

    _refreshScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshScheduled = false;
      if (!mounted) return;
      setState(() {});
    });
  }

  NavigatorState? _currentNavigator() {
    return _navigatorKeys[_currentTab]?.currentState;
  }

  bool get _isOnTabRoot {
    final navigator = _currentNavigator();
    if (navigator == null) return true;
    return !navigator.canPop();
  }

  bool get _canPopApp {
    return _currentTab == _ShellTab.library && _isOnTabRoot;
  }

  void _handlePop(bool didPop, Object? result) {
    if (didPop) return;

    final navigator = _currentNavigator();
    if (navigator != null && navigator.canPop()) {
      navigator.pop();
      return;
    }

    if (_currentTab != _ShellTab.library) {
      setState(() => _currentTab = _ShellTab.library);
    }
  }

  void _onDestinationSelected(int index) {
    setState(() => _currentTab = _tabs[index]);
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _tabs.indexOf(_currentTab);

    return PopScope(
      canPop: _canPopApp,
      onPopInvokedWithResult: _handlePop,
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: <Widget>[
            _TabNavigator(
              navigatorKey: _navigatorKeys[_ShellTab.library]!,
              observer: _observers[_ShellTab.library]!,
              rootPage: const LocalLibraryPage(),
            ),
            _TabNavigator(
              navigatorKey: _navigatorKeys[_ShellTab.webdav]!,
              observer: _observers[_ShellTab.webdav]!,
              rootPage: const WebDavAccountsPage(),
            ),
            _TabNavigator(
              navigatorKey: _navigatorKeys[_ShellTab.favorites]!,
              observer: _observers[_ShellTab.favorites]!,
              rootPage: const FavoritesPage(),
            ),
            _TabNavigator(
              navigatorKey: _navigatorKeys[_ShellTab.settings]!,
              observer: _observers[_ShellTab.settings]!,
              rootPage: const SettingsPage(),
            ),
          ],
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: _onDestinationSelected,
          destinations: const <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Icons.video_library_outlined),
              selectedIcon: Icon(Icons.video_library),
              label: '首页',
            ),
            NavigationDestination(
              icon: Icon(Icons.cloud_outlined),
              selectedIcon: Icon(Icons.cloud),
              label: '网络共享',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_border),
              selectedIcon: Icon(Icons.favorite),
              label: '收藏',
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined),
              selectedIcon: Icon(Icons.settings),
              label: '设置',
            ),
          ],
        ),
      ),
    );
  }
}

class _TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final NavigatorObserver observer;
  final Widget rootPage;

  const _TabNavigator({
    required this.navigatorKey,
    required this.observer,
    required this.rootPage,
  });

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      observers: <NavigatorObserver>[observer],
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => rootPage,
        );
      },
    );
  }
}

class _TabNavigatorObserver extends NavigatorObserver {
  final VoidCallback onStackChanged;

  _TabNavigatorObserver(this.onStackChanged);

  void _notify() => onStackChanged();

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _notify();

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) => _notify();

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _notify();

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) =>
      _notify();
}
