/*
 * @Descripttion: 
 * @version: 
 * @Author: wg
 * @Date: 2020-09-21 14:28:33
 * @LastEditors: wg
 * @LastEditTime: 2020-10-28 15:09:01
 */
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../../service/ScreenAdaper.dart';
import '../../model/PcateModel.dart';
import '../../config/Config.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage>
    with AutomaticKeepAliveClientMixin {
  int _selectIndex = 0;
  List _leftCateList = [];
  List _rightCateList = [];

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this._getLeftCaseData();
  }

  // 获取左侧分类数据
  _getLeftCaseData() async {
    var api = '${Config.apiUrl}api/pcate';
    var result = await Dio().get(api);
    var dataList = PcateModel.fromJson(result.data);
    setState(() {
      this._leftCateList = dataList.result;
    });
    this._getRightCaseData(dataList.result[0].sId);
  }

  // 获取右侧分类数据
  _getRightCaseData(pid) async {
    var api = '${Config.apiUrl}api/pcate?pid=${pid}';
    var result = await Dio().get(api);
    var dataList = PcateModel.fromJson(result.data);
    setState(() {
      this._rightCateList = dataList.result;
    });
  }

  // 左侧分类
  Widget _leftCateWidget(leftWidth) {
    if (this._leftCateList.length > 0) {
      return Container(
        height: double.infinity,
        width: leftWidth,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Column(
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      this._selectIndex = index;
                      this._getRightCaseData(this._leftCateList[index].sId);
                    });
                  },
                  child: Container(
                    width: double.infinity,
                    height: ScreenAdaper.height(84),
                    child: Center(
                        child: Text('${this._leftCateList[index].title}')),
                    color: _selectIndex == index
                        ? Color.fromRGBO(240, 246, 246, 0.9)
                        : Colors.white,
                  ),
                ),
                Divider(height: 1)
              ],
            );
          },
          itemCount: this._leftCateList.length,
        ),
      );
    } else {
      return Container(
        height: double.infinity,
        width: leftWidth,
      );
    }
  }

  // 右侧分类
  Widget _rightCateWidget(rightItemWidth, rightItemHeight) {
    if (this._rightCateList.length > 0) {
      return Expanded(
        flex: 1,
        child: Container(
          color: Color.fromRGBO(240, 246, 246, 0.9),
          height: double.infinity,
          padding: EdgeInsets.all(10),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: rightItemWidth / rightItemHeight,
            ),
            itemCount: this._rightCateList.length,
            itemBuilder: (context, index) {
              String pic = this._rightCateList[index].pic;
              return InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed(
                    '/productList',
                    arguments: {'cid': this._rightCateList[index].sId},
                  );
                },
                child: Container(
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Image.network(
                          "${Config.apiUrl}${pic.replaceAll('\\', '/')}",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: ScreenAdaper.height(40),
                        child: Text('${this._rightCateList[index].title}'),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    } else {
      return Expanded(
        flex: 1,
        child: Container(
          color: Color.fromRGBO(240, 246, 246, 0.9),
          height: double.infinity,
          padding: EdgeInsets.all(10),
          child: Text('加载中...'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);
    // 左侧宽度
    var leftWidth = ScreenAdaper.getScreenWidth() / 4;
    // 右侧宽度 = （总宽度 - 左侧宽度 - gridview padding值 - gridview 中间间距 ）/ 3
    var rightItemWidth =
        (ScreenAdaper.getScreenWidth() - leftWidth - 20 - 20) / 3;
    var rightItemHeight = rightItemWidth + ScreenAdaper.width(40);
    return Row(
      children: [
        this._leftCateWidget(leftWidth),
        this._rightCateWidget(rightItemWidth, rightItemHeight)
      ],
    );
  }
}
