/*
 * @Descripttion: 
 * @version: 
 * @Author: wg
 * @Date: 2020-10-28 14:48:14
 * @LastEditors: Please set LastEditors
 * @LastEditTime: 2020-11-10 14:00:24
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
  int _selectIndex = 1;
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

  List _subHeaderList = [
    {'id': 1, 'title': "综合", 'fileds': '', 'sort': -1},
    {'id': 2, 'title': "销量", 'fileds': "salecount", 'sort': -1},
    {'id': 3, 'title': "价格", 'fileds': "price", 'sort': -1},
    {'id': 4, 'title': "筛选"}
  ];

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

  // 导航改变触发
  _subHeaderChange(id) {
    if (id == 4) {
      // 打开侧边栏
      this._scaffoldKey.currentState.openEndDrawer();
    } else {
      setState(() {
        this._selectIndex = id;

        if (id != 1) {
          this._sort =
              '${this._subHeaderList[id - 1]['fileds']}_${this._subHeaderList[id - 1]['sort']}';

          this._subHeaderList[id - 1]['sort'] =
              this._subHeaderList[id - 1]['sort'] * -1;
        } else {
          this._sort = '';
        }
        // 重置分页
        this._page = 1;
        // 重置数据
        this._productList = [];
        this._hasMore = true;
        // 请求数据
        this._getData();
      });
    }
  }

  // icon展示
  Widget _showIcon(id) {
    if (id == 1 || id == 4) {
      return Text('');
    } else {
      if (this._subHeaderList[id - 1]['sort'] == 1) {
        return Icon(Icons.arrow_drop_down);
      } else {
        return Icon(Icons.arrow_drop_up);
      }
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
              children: this._subHeaderList.map((v) {
            return Expanded(
                flex: 1,
                child: InkWell(
                    onTap: () {
                      this._subHeaderChange(v['id']);
                    },
                    child: Container(
                        padding: EdgeInsets.fromLTRB(0, ScreenAdaper.height(18),
                            0, ScreenAdaper.height(18)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${v["title"]}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: this._selectIndex == v['id']
                                        ? Colors.red
                                        : Colors.black)),
                            this._showIcon(v['id'])
                          ],
                        ))));
          }).toList())),
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
