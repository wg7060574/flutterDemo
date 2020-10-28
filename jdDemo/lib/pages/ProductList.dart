/*
 * @Descripttion: 
 * @version: 
 * @Author: wg
 * @Date: 2020-10-28 14:48:14
 * @LastEditors: wg
 * @LastEditTime: 2020-10-28 16:35:07
 */
import 'package:flutter/material.dart';
import '../service/ScreenAdaper.dart';
import 'package:dio/dio.dart';

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

// 商品列表
  Widget _productListWidget() {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.only(top: ScreenAdaper.height(80)),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Row(
                children: [
                  Container(
                    width: ScreenAdaper.width(180),
                    height: ScreenAdaper.height(180),
                    child: Image.network(
                      'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1705581946,4177791147&fm=26&gp=0.jpg',
                      fit: BoxFit.cover,
                    ),
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
                            '商品商品商品商品商品商品商品商品商品商品商品商品商品商品商品商品商品商品商品商品商品商品商品商品商品',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Container(
                                height: ScreenAdaper.height(36),
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromRGBO(230, 230, 230, 0.9),
                                ),
                                child: Text('3G'),
                              ),
                              Container(
                                height: ScreenAdaper.height(36),
                                margin: EdgeInsets.only(right: 10),
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color.fromRGBO(230, 230, 230, 0.9),
                                ),
                                child: Text('科技'),
                              )
                            ],
                          ),
                          Text(
                            '￥999',
                            style: TextStyle(color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Divider()
            ],
          );
        },
      ),
    );
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
