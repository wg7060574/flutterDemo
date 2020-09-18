/*
 * @Descripttion: 
 * @version: 
 * @Author: wg
 * @Date: 2020-09-18 10:48:31
 * @LastEditors: wg
 * @LastEditTime: 2020-09-18 15:08:21
 */
import 'package:flutter/material.dart';

import '../homePage.dart';
import '../minePage.dart';

class AppBottomBar extends StatefulWidget {
  AppBottomBar({Key key}) : super(key: key);

  @override
  _AppBottomBarState createState() => _AppBottomBarState();
}

class _AppBottomBarState extends State<AppBottomBar> {
  List _pageList = [];
  int _index = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageList..add(HomePage())..add(MinePage());
  }

  Color getColor(int value) {
    return this._index == value ? Theme.of(context).cardColor : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlue,
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 6),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      this._index = 0;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.home, color: getColor(0)),
                      Text("首页", style: TextStyle(color: getColor(0)))
                    ],
                  )),
              GestureDetector(
                  child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.publish,
                    color: Colors.transparent,
                  ),
                  Text("发布")
                ],
              )),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      this._index = 1;
                    });
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.people, color: getColor(1)),
                      Text("我的", style: TextStyle(color: getColor(1)))
                    ],
                  )),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).pushNamed('add');
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: this._pageList[this._index],
    );
  }
}
