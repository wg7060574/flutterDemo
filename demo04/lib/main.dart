/*
 * @Descripttion: 监听网络
 * @version: 
 * @Author: wg
 * @Date: 2020-09-18 16:13:31
 * @LastEditors: wg
 * @LastEditTime: 2020-09-21 13:54:17
 */
import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Demo', home: NetworkState());
  }
}

class NetworkState extends StatefulWidget {
  NetworkState({Key key}) : super(key: key);

  @override
  _NetworkStateState createState() => _NetworkStateState();
}

class _NetworkStateState extends State<NetworkState> {
  var subscription;

  String _stateText;
  @override
  void initState() {
    super.initState();

    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile) {
        setState(() {
          _stateText = 'I am connected to a mobile network.';
        });
      } else if (result == ConnectivityResult.wifi) {
        setState(() {
          _stateText = 'I am connected to a wifi network.';
        });
      } else {
        setState(() {
          _stateText = 'no network.';
        });
      }
    });
  }

  @override
  dispose() {
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('检测网络'),
      ),
      body: Center(
        child: Text('${this._stateText}'),
      ),
    );
  }
}
