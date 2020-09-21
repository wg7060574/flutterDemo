/*
 * @Descripttion: 本地存储封装
 * @version: 
 * @Author: wg
 * @Date: 2020-09-21 11:09:04
 * @LastEditors: wg
 * @LastEditTime: 2020-09-21 11:14:18
 */
import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<void> setString(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  static Future<String> getString(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> removeString(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
