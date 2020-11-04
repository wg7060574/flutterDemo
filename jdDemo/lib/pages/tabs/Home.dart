/*
 * @Descripttion: 
 * @version: 
 * @Author: wg
 * @Date: 2020-09-21 14:28:33
 * @LastEditors: wg
 * @LastEditTime: 2020-11-04 14:19:19
 */
import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';

import '../../service/ScreenAdaper.dart';
import 'package:dio/dio.dart';

import '../../model/FocusModel.dart'; // 轮播图类模型
import '../../model/ProductModel.dart'; // 轮播图类模型

import '../../config/Config.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List _focusModel = [];
  List _guessData = [];
  List _hotData = [];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    this._getSwiperData();
    this._getGuessData();
    this._getHotData();
  }

  // 获取轮播图数据
  _getSwiperData() async {
    var url = '${Config.apiUrl}api/focus';
    var result = await Dio().get(url);
    var focusList = FocusModel.fromJson(result.data);
    setState(() {
      this._focusModel = focusList.result;
    });
  }

  // 获取猜你喜欢数据
  _getGuessData() async {
    var url = '${Config.apiUrl}api/plist?is_hot=1';
    var result = await Dio().get(url);
    var _guessList = ProductModel.fromJson(result.data);
    setState(() {
      this._guessData = _guessList.result;
    });
  }

  // 获取热门推荐数据
  _getHotData() async {
    var url = '${Config.apiUrl}api/plist?is_best=1';
    var result = await Dio().get(url);
    var _hotList = ProductModel.fromJson(result.data);
    setState(() {
      this._hotData = _hotList.result;
    });
  }

  // 轮播图
  Widget _swiperWidget() {
    if (this._focusModel.length > 0) {
      return Container(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Swiper(
            itemBuilder: (BuildContext context, int index) {
              String pic = this._focusModel[index].pic;
              return new Image.network(
                '${Config.apiUrl}${pic.replaceAll("\\", '/')}',
                fit: BoxFit.cover,
              );
            },
            itemCount: this._focusModel.length,
            autoplay: true,
            pagination: new SwiperPagination(),
          ),
        ),
      );
    } else {
      return Text('加载中。。。');
    }
  }

  // 标题
  Widget _titleWidget(String title) {
    return Container(
      margin: EdgeInsets.all(ScreenAdaper.width(20)),
      padding: EdgeInsets.only(left: ScreenAdaper.width(20)),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(color: Colors.red, width: ScreenAdaper.width(8)),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(color: Colors.black54),
      ),
    );
  }

  // 猜你喜欢
  Widget _guessProductListWidget() {
    if (this._guessData.length > 0) {
      return Container(
        margin: EdgeInsets.only(
            left: ScreenAdaper.width(20), right: ScreenAdaper.width(20)),
        height: ScreenAdaper.height(180),
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            String pic = this._guessData[index].pic;
            return Column(
              children: [
                Container(
                  width: ScreenAdaper.width(140),
                  height: ScreenAdaper.height(140),
                  margin: EdgeInsets.only(
                      right: ScreenAdaper.width(10),
                      left: ScreenAdaper.width(10)),
                  child: Image.network(
                    '${Config.apiUrl}${pic.replaceAll("\\", '/')}',
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  '￥${this._guessData[index].price}',
                  style: TextStyle(color: Colors.red),
                )
              ],
            );
          },
          itemCount: this._guessData.length,
        ),
      );
    } else {
      return Text('加载中...');
    }
  }

  // 热门推荐
  Widget _hotProductListWidget() {
    return Container(
      padding: EdgeInsets.only(
        left: ScreenAdaper.width(20),
        right: ScreenAdaper.width(20),
      ),
      child: Wrap(
        runSpacing: ScreenAdaper.width(20),
        spacing: ScreenAdaper.width(20),
        children:
            this._hotData.map((e) => this._hotProductItemWidget(e)).toList(),
      ),
    );
  }

  // 热门推荐item
  Widget _hotProductItemWidget(item) {
    double itemWidth =
        (ScreenAdaper.getScreenWidth() - ScreenAdaper.width(20) * 3) / 2;
    return Container(
      padding: EdgeInsets.all(ScreenAdaper.width(20)),
      width: itemWidth,
      decoration:
          BoxDecoration(border: Border.all(width: 1, color: Colors.black12)),
      child: Column(
        children: [
          Container(
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  '${Config.apiUrl}${item.pic.replaceAll("\\", '/')}',
                  fit: BoxFit.cover,
                ),
              )),
          Padding(
            padding: EdgeInsets.only(top: ScreenAdaper.width(20)),
            child: Text('${item.title}',
                maxLines: 2,
                style: TextStyle(color: Colors.black54),
                overflow: TextOverflow.ellipsis),
          ),
          Padding(
            padding: EdgeInsets.only(top: ScreenAdaper.width(20)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '￥${item.price}',
                  style: TextStyle(
                      color: Colors.red, fontSize: ScreenAdaper.setSize(32)),
                ),
                Text(
                  '￥${item.oldPrice}',
                  style: TextStyle(
                      decoration: TextDecoration.lineThrough,
                      fontSize: ScreenAdaper.setSize(28)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          icon: Icon(Icons.center_focus_strong),
          onPressed: () {
            return null;
          },
        ),
        title: InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            Navigator.of(context).pushNamed('/search');
          },
          child: Container(
            height: ScreenAdaper.height(76),
            padding: EdgeInsets.fromLTRB(ScreenAdaper.width(20), 0, 0, 0),
            decoration: BoxDecoration(
              color: Color.fromRGBO(233, 233, 233, 0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.search),
                Text(
                  '笔记本',
                  style: TextStyle(fontSize: ScreenAdaper.setSize(28)),
                )
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            icon: Icon(Icons.message),
            onPressed: () {
              return null;
            },
          )
        ],
      ),
      body: ListView(
        children: [
          this._swiperWidget(),
          this._titleWidget('猜你喜欢'),
          this._guessProductListWidget(),
          this._titleWidget('热门推荐'),
          this._hotProductListWidget()
        ],
      ),
    );
  }
}
