import 'package:flutter/material.dart';

import '../../favorites/presentation/favorites_page.dart';
import '../../media_library/presentation/local_library_page.dart';
import '../../settings/presentation/settings_page.dart';
import '../../webdav_client/presentation/webdav_accounts_page.dart';

enum _ShellTab { library, webdav, favorites, settings }

const double kShellBarHeight = 92;
const double kShellBarRadius = 28;
const double kShellBarShadowOpacity = 0.08;

const List<_ShellDestinationData> _shellDestinations = <_ShellDestinationData>[
  _ShellDestinationData(
    label: '首页',
    icon: Icons.home_outlined,
    selectedIcon: Icons.home_rounded,
  ),
  _ShellDestinationData(
    label: '云盘',
    icon: Icons.cloud_outlined,
    selectedIcon: Icons.cloud_rounded,
  ),
  _ShellDestinationData(
    label: '收藏',
    icon: Icons.favorite_border_rounded,
    selectedIcon: Icons.favorite_rounded,
  ),
  _ShellDestinationData(
    label: '设置',
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings_rounded,
  ),
];

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
    if (!mounted || _refreshScheduled) return;

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
        body: _ShellIndexedStack(
          currentIndex: currentIndex,
          navigatorKeys: _navigatorKeys,
          observers: _observers,
        ),
        bottomNavigationBar: _ShellBottomNavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: _onDestinationSelected,
        ),
      ),
    );
  }
}

class _ShellIndexedStack extends StatelessWidget {
  final int currentIndex;
  final Map<_ShellTab, GlobalKey<NavigatorState>> navigatorKeys;
  final Map<_ShellTab, NavigatorObserver> observers;

  const _ShellIndexedStack({
    required this.currentIndex,
    required this.navigatorKeys,
    required this.observers,
  });

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentIndex,
      children: <Widget>[
        _TabNavigator(
          navigatorKey: navigatorKeys[_ShellTab.library]!,
          observer: observers[_ShellTab.library]!,
          rootPage: const LocalLibraryPage(),
        ),
        _TabNavigator(
          navigatorKey: navigatorKeys[_ShellTab.webdav]!,
          observer: observers[_ShellTab.webdav]!,
          rootPage: const WebDavAccountsPage(),
        ),
        _TabNavigator(
          navigatorKey: navigatorKeys[_ShellTab.favorites]!,
          observer: observers[_ShellTab.favorites]!,
          rootPage: const FavoritesPage(),
        ),
        _TabNavigator(
          navigatorKey: navigatorKeys[_ShellTab.settings]!,
          observer: observers[_ShellTab.settings]!,
          rootPage: const SettingsPage(),
        ),
      ],
    );
  }
}

class _ShellBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const _ShellBottomNavigationBar({
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(kShellBarRadius),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: kShellBarShadowOpacity),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SizedBox(
            height: kShellBarHeight,
            child: Row(
              children: List<Widget>.generate(_shellDestinations.length, (
                int index,
              ) {
                return Expanded(
                  child: _ShellBottomBarItem(
                    data: _shellDestinations[index],
                    isSelected: selectedIndex == index,
                    onTap: () => onDestinationSelected(index),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShellBottomBarItem extends StatelessWidget {
  final _ShellDestinationData data;
  final bool isSelected;
  final VoidCallback onTap;

  const _ShellBottomBarItem({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = isSelected
        ? colorScheme.primary
        : colorScheme.onSurfaceVariant;

    return Semantics(
      button: true,
      selected: isSelected,
      label: data.label,
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                isSelected ? data.selectedIcon : data.icon,
                color: iconColor,
                size: 30,
              ),
              const SizedBox(height: 6),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 180),
                opacity: isSelected ? 1 : 0,
                child: Text(
                  data.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: iconColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
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
      onGenerateRoute: (RouteSettings settings) {
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

class _ShellDestinationData {
  final String label;
  final IconData icon;
  final IconData selectedIcon;

  const _ShellDestinationData({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });
}
