/*
 * @Descripttion: 
 * @version: 
 * @Author: wg
 * @Date: 2020-09-21 14:42:47
 * @LastEditors: wg
 * @LastEditTime: 2020-11-04 14:15:56
 */

import 'package:flutter/material.dart';

import '../pages/tabs/Tabs.dart';
import '../pages/ProductList.dart';
import '../pages/Search.dart';

final routes = {
  '/': (context) => Tabs(),
  '/productList': (context, {arguments}) =>
      ProductListPage(arguments: arguments),
  '/search': (context) => SearchPage()
};

var onGenerateRoute = (RouteSettings settings) {
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];

  if (pageContentBuilder != null) {
    if (settings.arguments != null) {
      final Route route = MaterialPageRoute(builder: (context) {
        return pageContentBuilder(context, arguments: settings.arguments);
      });
      return route;
    } else {
      final Route route = MaterialPageRoute(builder: (context) {
        return pageContentBuilder(context);
      });
      return route;
    }
  } else {
    final Route route = MaterialPageRoute(builder: (context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('404'),
        ),
        body: Center(
          child: Text('404'),
        ),
      );
    });
    return route;
  }
};
