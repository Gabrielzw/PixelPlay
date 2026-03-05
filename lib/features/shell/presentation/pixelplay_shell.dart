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

  final Map<_ShellTab, GlobalKey<NavigatorState>> _navigatorKeys =
      <_ShellTab, GlobalKey<NavigatorState>>{
        _ShellTab.library: GlobalKey<NavigatorState>(),
        _ShellTab.webdav: GlobalKey<NavigatorState>(),
        _ShellTab.favorites: GlobalKey<NavigatorState>(),
        _ShellTab.settings: GlobalKey<NavigatorState>(),
      };

  _ShellTab _currentTab = _ShellTab.library;

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
              rootPage: const LocalLibraryPage(),
            ),
            _TabNavigator(
              navigatorKey: _navigatorKeys[_ShellTab.webdav]!,
              rootPage: const WebDavAccountsPage(),
            ),
            _TabNavigator(
              navigatorKey: _navigatorKeys[_ShellTab.favorites]!,
              rootPage: const FavoritesPage(),
            ),
            _TabNavigator(
              navigatorKey: _navigatorKeys[_ShellTab.settings]!,
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
  final Widget rootPage;

  const _TabNavigator({required this.navigatorKey, required this.rootPage});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (settings) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => rootPage,
        );
      },
    );
  }
}
