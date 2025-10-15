import 'package:flutter/material.dart';
import '../pages/homework_list_page.dart';
import '../pages/add_homework_page.dart';

enum AppPage { list, add }

class AppRoutePath {
  final AppPage page;
  AppRoutePath(this.page);
}

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
    RouteInformation routeInformation,
  ) async {
    final uri = routeInformation.uri;
    if (uri.pathSegments.isEmpty) return AppRoutePath(AppPage.list);
    final first = uri.pathSegments.first;
    if (first == 'add') return AppRoutePath(AppPage.add);
    return AppRoutePath(AppPage.list);
  }

  @override
  RouteInformation? restoreRouteInformation(AppRoutePath configuration) {
    switch (configuration.page) {
      case AppPage.list:
        return RouteInformation(uri: Uri.parse('/'));
      case AppPage.add:
        return RouteInformation(uri: Uri.parse('/add'));
    }
  }
}

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  AppPage _page = AppPage.list;

  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  void goToList() {
    _page = AppPage.list;
    notifyListeners();
  }

  void goToAdd() {
    _page = AppPage.add;
    notifyListeners();
  }

  @override
  AppRoutePath get currentConfiguration => AppRoutePath(_page);

  @override
  Widget build(BuildContext context) {
    final pages = <Page>[];
    pages.add(
      MaterialPage(
        key: const ValueKey('HomeworkList'),
        child: HomeworkListPage(onAdd: goToAdd),
      ),
    );
    if (_page == AppPage.add) {
      pages.add(
        MaterialPage(
          key: const ValueKey('AddHomework'),
          child: AddHomeworkPage(onSaved: goToList),
        ),
      );
    }

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        // On pop from Add page, go back to list
        if (_page == AppPage.add) {
          _page = AppPage.list;
          notifyListeners();
        }
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath configuration) async {
    _page = configuration.page;
  }
}
