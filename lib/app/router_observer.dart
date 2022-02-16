import 'package:flutter/material.dart';

class MyRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  @override
  void didPush(Route<dynamic>? route, Route<dynamic>? oldRoute) {
    super.didPush(route!, oldRoute);
    if (route is PageRoute) _sendScreenView(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute is PageRoute) _sendScreenView(newRoute);
  }

  @override
  void didPop(Route<dynamic>? route, Route<dynamic>? oldRoute) {
    super.didPop(route!, oldRoute);
    if (oldRoute is PageRoute && route is PageRoute) _sendScreenView(oldRoute);
  }

  void _sendScreenView(PageRoute<dynamic> route) {
    var routeName = route.settings.name;
    print('Screen -> $routeName'); // track screen of user
  }
}
