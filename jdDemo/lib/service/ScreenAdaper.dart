/*
 * @Descripttion: 
 * @version: 
 * @Author: wg
 * @Date: 2020-09-21 15:38:03
 * @LastEditors: wg
 * @LastEditTime: 2020-10-28 15:46:39
 */
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenAdaper { 
  // 初始化
  static init(context) {
    ScreenUtil.init(designSize: Size(750, 1334));
  }

  // 设置宽度
  static width(double value) {
    return ScreenUtil().setWidth(value);
  }

  // 设置高度
  static height(double value) {
    return ScreenUtil().setHeight(value);
  }

  // 获取屏幕 height dp
  static getScreenHeight() {
    return ScreenUtil().screenHeight;
  }

  // 获取屏幕 width dp
  static getScreenWidth() {
    return ScreenUtil().screenWidth;
  }

  // 文字适配
  static setSize(double size, {bool state = true}) {
    return ScreenUtil().setSp(size, allowFontScalingSelf: state);
  }
}
