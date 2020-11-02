/*
 * @Descripttion: 
 * @version: 
 * @Author: wg
 * @Date: 2020-10-28 14:48:14
 * @LastEditors: wg
 * @LastEditTime: 2020-11-02 13:47:10
 */
import 'package:flutter/material.dart';
import '../service/ScreenAdaper.dart';
import 'package:dio/dio.dart';

import '../model/ProductModel.dart';
import '../config/Config.dart';

import '../widget/LoadWidget.dart';

class ProductListPage extends StatefulWidget {
  Map arguments;

  ProductListPage({Key key, this.arguments}) : super(key: key);

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  int _selectIndex = 0;
  // 给scaffold 一个key,通过key 来打开drawer
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // 上拉加载
  ScrollController _scrollController = ScrollController();

  int _page = 1;

  List _productList = [];

  String _sort = '';
  // 重复请求
  bool _flag = true;

  // 判断是否还有数据
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    this._getData();

    // 监听滚动条事件
    _scrollController.addListener(() {
      // 滚动高度 === 页面高度
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (this._flag == true) {
          this._getData();
        }
      }
    });
  }

  // 获取列表数据
  _getData() async {
    if (this._hasMore == true) {
      setState(() {
        this._flag = false;
      });
      var api =
          '${Config.apiUrl}api/plist?cid=${widget.arguments["cid"]}&page=${this._page}&pageSize=10&sort=${this._sort}';
      var result = await Dio().get(api);
      var dataList = ProductModel.fromJson(result.data);
      print(dataList.result.length);
      if (dataList.result.length < 10) {
        setState(() {
          this._productList.addAll(dataList.result);
          this._flag = true;
          this._hasMore = false;
        });
      }
      setState(() {
        this._productList.addAll(dataList.result);
        this._page++;
        this._flag = true;
      });
    }
  }

  // 展示更多
  Widget _showMore(index) {
    if (this._hasMore) {
      return index == this._productList.length - 1 ? LoadWidget() : Text('');
    } else {
      return index == this._productList.length - 1
          ? Text('---我是有底线的----')
          : Text('');
    }
  }

// 商品列表
  Widget _productListWidget() {
    if (this._productList.length > 0) {
      return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: ScreenAdaper.height(80)),
        child: ListView.builder(
          controller: this._scrollController,
          itemCount: this._productList.length,
          itemBuilder: (context, index) {
            String pic = this._productList[index].pic;
            pic = Config.apiUrl + pic.replaceAll('\\', '/');
            return Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: ScreenAdaper.width(180),
                      height: ScreenAdaper.height(180),
                      child: Image.network(pic, fit: BoxFit.cover),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        height: ScreenAdaper.height(180),
                        padding: EdgeInsets.only(left: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${this._productList[index].title}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text('￥${this._productList[index].price}',
                                style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
                this._showMore(index)
              ],
            );
          },
        ),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: ScreenAdaper.height(80)),
        child: LoadWidget(),
      );
    }
  }

  // 筛选导航
  Widget _subHeaderWidget() {
    return Positioned(
      top: 0,
      width: ScreenAdaper.width(750),
      height: ScreenAdaper.height(80),
      child: Container(
          width: ScreenAdaper.width(750),
          height: ScreenAdaper.height(80),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Color.fromRGBO(233, 233, 233, 0.9),
              ),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          this._selectIndex = 0;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, ScreenAdaper.height(18),
                            0, ScreenAdaper.height(18)),
                        child: Text(
                          '综合',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: this._selectIndex == 0
                                  ? Colors.red
                                  : Colors.black),
                        ),
                      ))),
              Expanded(
                  flex: 1,
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          this._selectIndex = 1;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, ScreenAdaper.height(18),
                            0, ScreenAdaper.height(18)),
                        child: Text(
                          '销量',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: this._selectIndex == 1
                                  ? Colors.red
                                  : Colors.black),
                        ),
                      ))),
              Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        this._selectIndex = 2;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, ScreenAdaper.height(18),
                          0, ScreenAdaper.height(18)),
                      child: Text(
                        '价格',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: this._selectIndex == 2
                                ? Colors.red
                                : Colors.black),
                      ),
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      _scaffoldKey.currentState.openEndDrawer();
                    },
                    child: Container(
                      padding: EdgeInsets.fromLTRB(0, ScreenAdaper.height(18),
                          0, ScreenAdaper.height(18)),
                      child: Text(
                        '筛选',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )),
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text('商品列表'), actions: [Text('')]),
      endDrawer: Drawer(
        child: Text('123'),
      ),
      body: Stack(
        children: [this._productListWidget(), this._subHeaderWidget()],
      ),
    );
  }
}
