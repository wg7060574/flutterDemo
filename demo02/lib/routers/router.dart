/*
 * @Descripttion: 
 * @version: 
 * @Author: wg
 * @Date: 2020-09-18 10:58:08
 * @LastEditors: wg
 * @LastEditTime: 2020-09-18 14:15:48
 */

import '../page/homePage.dart';
import '../page/minePage.dart';
import '../page/addPage.dart';

var routers = {
  'home': (context) => HomePage(),
  'mine': (context) => MinePage(),
  'add': (context) => AddPage()
};
