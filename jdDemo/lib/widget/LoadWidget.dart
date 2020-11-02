/*
 * @Descripttion: 
 * @version: 
 * @Author: wg
 * @Date: 2020-11-02 10:47:21
 * @LastEditors: wg
 * @LastEditTime: 2020-11-02 13:45:02
 */
import 'package:flutter/material.dart';
import '../service/ScreenAdaper.dart';

class LoadWidget extends StatelessWidget {
  const LoadWidget({Key key}) : super(key: key);

  Widget _pad(Widget widget, {l, t, r, b}) {
    return new Padding(
        padding:
            EdgeInsets.fromLTRB(l ??= 0.0, t ??= 0.0, r ??= 0.0, b ??= 0.0),
        child: widget);
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);

    var loadingTS = TextStyle(color: Colors.blue, fontSize: 16);
    var loadingText =
        _pad(Text('加载中', style: loadingTS), l: ScreenAdaper.width(20));
    var loadingIndicator = new Visibility(
        visible: true,
        child: SizedBox(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blue)),
          width: ScreenAdaper.width(20),
          height: ScreenAdaper.height(20),
        ));

    return _pad(
        Row(
          children: <Widget>[loadingIndicator, loadingText],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        t: ScreenAdaper.height(20),
        b: ScreenAdaper.height(20));
  }
}
