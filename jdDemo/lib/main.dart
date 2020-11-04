/*
 * @Descripttion: 
 * @version: 
 * @Author: wg
 * @Date: 2020-09-21 14:04:15
 * @LastEditors: wg
 * @LastEditTime: 2020-11-04 13:51:20
 */
import 'package:flutter/material.dart';

import './routers/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'jdDemo',
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
      theme: ThemeData(primaryColor: Colors.white),
      debugShowCheckedModeBanner: false,
    );
  }
}
