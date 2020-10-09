/*
 * @Descripttion: 
 * @version: 
 * @Author: wg
 * @Date: 2020-09-21 14:28:33
 * @LastEditors: wg
 * @LastEditTime: 2020-10-09 17:44:24
 */
import 'package:flutter/material.dart';

import 'package:flutter_swiper/flutter_swiper.dart';

import '../../service/ScreenAdaper.dart';
import 'package:dio/dio.dart';

import '../../model/FocusModel.dart'; // 轮播图类模型

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _focusModel = [];

  @override
  void initState() {
    super.initState();
    this._getSwiperData();
  }

  // 获取轮播图
  _getSwiperData() async {
    var url = 'http://jd.itying.com/api/focus';

    var result = await Dio().get(url);
    var focusList = FocusModel.fromJson(result.data);
    setState(() {
      this._focusModel = focusList.result;
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
                'http://jd.itying.com/${pic.replaceAll("\\", '/')}',
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
    return Container(
      margin: EdgeInsets.only(
          left: ScreenAdaper.width(20), right: ScreenAdaper.width(20)),
      height: ScreenAdaper.height(180),
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                width: ScreenAdaper.width(140),
                height: ScreenAdaper.height(140),
                margin: EdgeInsets.only(right: ScreenAdaper.width(20)),
                child: Image.network(
                  'https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3129286175,524940541&fm=26&gp=0.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Text('第${index + 1}条')
            ],
          );
        },
        itemCount: 10,
      ),
    );
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
        children: [
          this._hotProductItemWidget(),
          this._hotProductItemWidget(),
          this._hotProductItemWidget(),
          this._hotProductItemWidget()
        ],
      ),
    );
  }

  // 热门推荐item
  Widget _hotProductItemWidget() {
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
                  'https://ss3.bdstatic.com/70cFv8Sh_Q1YnxGkpoWK1HF6hhy/it/u=1115762551,1087844924&fm=26&gp=0.jpg',
                  fit: BoxFit.cover,
                ),
              )),
          Padding(
            padding: EdgeInsets.only(top: ScreenAdaper.width(20)),
            child: Text(
                '刘亦菲，1987年8月25日出生于湖北省武汉市，华语影视女演员、歌手，毕业于北京电影学院2002级表演系本科。2002年，因出演电视剧《金粉世家》中白秀珠一角踏入演艺圈。2003年因主演武侠剧《天龙八部》崭露头角',
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
                  '￥188.0',
                  style: TextStyle(
                      color: Colors.red, fontSize: ScreenAdaper.setSize(32)),
                ),
                Text(
                  '￥288.0',
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
    return ListView(
      children: [
        this._swiperWidget(),
        this._titleWidget('猜你喜欢'),
        this._guessProductListWidget(),
        this._titleWidget('热门推荐'),
        this._hotProductListWidget()
      ],
    );
  }
}
