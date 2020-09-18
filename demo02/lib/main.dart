/*
 * @Descripttion: 
 * @version: 
 * @Author: wg
 * @Date: 2020-09-18 10:46:11
 * @LastEditors: wg
 * @LastEditTime: 2020-09-18 14:56:12
 */
import 'package:flutter/material.dart';

import './page/bottomAppBar/appBottomBar.dart';
import './routers/router.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'demo02',
      routes: routers,
      home: AppBottomBar(),
    );
  }
}
