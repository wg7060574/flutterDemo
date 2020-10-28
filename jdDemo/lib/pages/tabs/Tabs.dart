/*
 * @Descripttion: 
 * @version: 
 * @Author: wg
 * @Date: 2020-09-21 14:27:35
 * @LastEditors: wg
 * @LastEditTime: 2020-10-28 14:41:21
 */
import 'package:flutter/material.dart';

import './Home.dart';
import './Category.dart';
import './Cart.dart';
import './User.dart';

class Tabs extends StatefulWidget {
  Tabs({Key key}) : super(key: key);

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _currentIndex = 0;

  PageController _pageController;

  @override
  void initState() {
    super.initState();
    this._pageController = new PageController(initialPage: this._currentIndex);
  }

  List<Widget> _pageList = [HomePage(), CategoryPage(), CartPage(), UserPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('jd'),
      ),
      body: PageView(
        controller: this._pageController,
        children: this._pageList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: this._currentIndex,
        onTap: (value) {
          setState(() {
            this._currentIndex = value;
            this._pageController.jumpToPage(this._currentIndex);
          });
        },
        fixedColor: Colors.red,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('首页'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            title: Text('分类'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            title: Text('购物车'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            title: Text('我的'),
          ),
        ],
      ),
    );
  }
}
