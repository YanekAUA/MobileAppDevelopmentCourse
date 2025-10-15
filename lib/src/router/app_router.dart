import 'package:flutter/material.dart';
import '../pages/provider_counter_page.dart';
import '../pages/bloc_counter_page.dart';

enum AppTab { provider, bloc }

class AppRoutePath {
  final AppTab tab;
  AppRoutePath(this.tab);
}

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = Uri.parse(routeInformation.location);
    if (uri.pathSegments.isEmpty) return AppRoutePath(AppTab.provider);
    final first = uri.pathSegments.first;
    if (first == 'bloc') return AppRoutePath(AppTab.bloc);
    return AppRoutePath(AppTab.provider);
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
    switch (configuration.tab) {
      case AppTab.provider:
        return const RouteInformation(location: '/');
      case AppTab.bloc:
        return const RouteInformation(location: '/bloc');
    }
  }
}

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  AppTab _currentTab = AppTab.provider;

  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  AppTab get currentTab => _currentTab;

  void setTab(AppTab tab) {
    if (_currentTab != tab) {
      _currentTab = tab;
      notifyListeners();
    }
  }

  @override
  AppRoutePath get currentConfiguration => AppRoutePath(_currentTab);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
          key: const ValueKey('TabShell'),
          child: TabShell(currentTab: _currentTab, onTabSelected: setTab),
        ),
      ],
      onPopPage: (route, result) => route.didPop(result),
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    _currentTab = configuration.tab;
  }
}

class TabShell extends StatelessWidget {
  final AppTab currentTab;
  final ValueChanged<AppTab> onTabSelected;

  const TabShell({
    super.key,
    required this.currentTab,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (currentTab) {
      case AppTab.provider:
        body = const ProviderCounterPage();
        break;
      case AppTab.bloc:
        body = const BlocCounterPage();
        break;
    }

    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab == AppTab.provider ? 0 : 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Provider'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Bloc'),
        ],
        onTap: (index) =>
            onTabSelected(index == 0 ? AppTab.provider : AppTab.bloc),
      ),
    );
  }
}
