/*
 * @Descripttion: 
 * @version: 
 * @Author: wg
 * @Date: 2020-11-04 14:11:11
 * @LastEditors: wg
 * @LastEditTime: 2020-11-04 14:59:28
 */
import 'package:flutter/material.dart';
import '../service/ScreenAdaper.dart';

class SearchPage extends StatefulWidget {
  SearchPage({Key key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    ScreenAdaper.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: ScreenAdaper.height(76),
          child: TextField(
            autofocus: true,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(top: 4, bottom: 4, right: 10),
              prefixIcon: Icon(Icons.search),
              hintText: '请输入搜索内容',
              fillColor: Color.fromRGBO(233, 233, 233, 0.8),
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none),
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {
              return null;
            },
            child: Container(
              height: ScreenAdaper.height(76),
              width: ScreenAdaper.width(80),
              child: Row(
                children: [Text('搜索')],
              ),
            ),
          )
        ],
      ),
      body: Text('123'),
    );
  }
}
