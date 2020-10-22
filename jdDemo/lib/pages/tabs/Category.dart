/*
 * @Descripttion: 
 * @version: 
 * @Author: wg
 * @Date: 2020-09-21 14:28:33
 * @LastEditors: wg
 * @LastEditTime: 2020-10-22 15:04:51
 */
import 'package:flutter/material.dart';

import '../../service/ScreenAdaper.dart';

class CategoryPage extends StatefulWidget {
  CategoryPage({Key key}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  int _selectIndex = 0;

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
        Container(
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
                      });
                    },
                    child: Container(
                      width: double.infinity,
                      height: ScreenAdaper.height(98),
                      child: Text(
                        'list${index}',
                        textAlign: TextAlign.center,
                      ),
                      color: _selectIndex == index
                          ? Color.fromRGBO(240, 246, 246, 0.9)
                          : Colors.white,
                    ),
                  ),
                  Divider()
                ],
              );
            },
            itemCount: 18,
          ),
        ),
        Expanded(
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
              itemCount: 10,
              itemBuilder: (context, index) {
                return Container(
                  child: Column(
                    children: [
                      AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Image.network(
                          "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1603358099859&di=e3e9d28454a7278f05a275cdca8af0f9&imgtype=0&src=http%3A%2F%2Fa0.att.hudong.com%2F56%2F12%2F01300000164151121576126282411.jpg",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Container(
                        height: ScreenAdaper.height(40),
                        child: Text('女装'),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
          flex: 1,
        )
      ],
    );
  }
}
