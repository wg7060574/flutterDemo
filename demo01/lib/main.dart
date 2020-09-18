/*
 * @Descripttion: 
 * @version: 
 * @Author: wg
 * @Date: 2020-09-17 09:07:32
 * @LastEditors: wg
 * @LastEditTime: 2020-09-18 10:44:10
 */
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'demo01',
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  MyPage({Key key}) : super(key: key);

  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  //限制一滑动到最下方就刷新，在刷新数据 及 刷新完之后改变状态s
  static var loadStatus = LoadingStatus.STATUS_IDEL;
  // 数据
  List list = List();

  String loadText = '加载中...';

  int _page = 1;

  bool flag = true; // 是否还有要加载的数据

//  加载中的布局
  Widget _loadingView() {
    var loadingTS = TextStyle(color: Colors.blue, fontSize: 16);
    var loadingText = _pad(Text(loadText, style: loadingTS), l: 20.0);
    var loadingIndicator = new Visibility(
        visible: loadStatus == LoadingStatus.STATUS_LOADING ? true : false,
        child: SizedBox(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blue)),
          width: 20.0,
          height: 20.0,
        ));

    return _pad(
        Row(
          children: <Widget>[loadingIndicator, loadingText],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        t: 20.0,
        b: 20.0);
  }

  Widget _pad(Widget widget, {l, t, r, b}) {
    return new Padding(
        padding:
            EdgeInsets.fromLTRB(l ??= 0.0, t ??= 0.0, r ??= 0.0, b ??= 0.0),
        child: widget);
  }

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    this._getData();
    // 监听滚动条事件
    _scrollController.addListener(_updateScrollPosition);
  }

  // 下拉加载
  Future<void> _onRefresh() async {
    setState(() {
      this.flag = true;
      loadStatus = LoadingStatus.STATUS_IDEL;
      list = [];
      // loadText = '加载中...';
      _page = 1;
    });
    await this._getData();
    // return false;
  }

  // 滚动到底部，加载数据
  void _updateScrollPosition() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      this._getData();
    }
  }

  // 移除监听
  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollPosition);
    super.dispose();
  }

  // 获取数据
  _getData() async {
    if (flag) {
      var apiUrl =
          'http://www.phonegap100.com/appapi.php?a=getPortalList&catid=20&page=$_page';

      if (loadStatus == LoadingStatus.STATUS_IDEL) {
        setState(() {
          //先设置状态，防止往下拉就直接加载数据
          loadStatus = LoadingStatus.STATUS_LOADING;
        });
      }
      if (loadStatus == LoadingStatus.STATUS_LOADING) {
        var result = await Dio().get(apiUrl);

        if (result.statusCode == 200) {
          var res = json.decode(result.data)['result'];
          setState(() {
            this.list.addAll(res);
            if (res.length == 20) {
              loadStatus = LoadingStatus.STATUS_IDEL;
              this._page++;
              loadText = '加载中...';
            } else {
              //加载完毕
              this.flag = false;
              loadText = '加载完毕';
              loadStatus = LoadingStatus.STATUS_COMPLETED;
            }
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('上拉加载和下拉刷新'),
      ),
      body: this.list.length > 0
          ? RefreshIndicator(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: this.list.length,
                itemBuilder: (context, index) {
                  if (index == list.length - 1) {
                    return _loadingView();
                  } else {
                    return ListTile(
                      title: Text(
                        this.list[index]['title'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }
                },
              ),
              onRefresh: _onRefresh)
          : Text('加载中++'),
    );
  }
}

// 加载状态
enum LoadingStatus {
  //正在加载中
  STATUS_LOADING,
  //数据加载完毕
  STATUS_COMPLETED,
  //空闲状态
  STATUS_IDEL
}
