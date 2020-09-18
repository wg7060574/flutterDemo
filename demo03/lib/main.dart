/*
 * @Descripttion: 
 * @version: 
 * @Author: wg
 * @Date: 2020-09-18 15:15:04
 * @LastEditors: wg
 * @LastEditTime: 2020-09-18 15:57:11
 */
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'demo03',
      home: TAnimations(),
    );
  }
}

class TAnimations extends StatefulWidget {
  TAnimations({Key key}) : super(key: key);

  @override
  _TAnimationsState createState() => _TAnimationsState();
}

//with是dart的关键字，意思是混入的意思，就是说可以将一个或者多个类的功能添加到自己的类无需继承这些类，避免多重继承导致的问题。
//为什么是SingleTickerProviderStateMixin呢，因为初始化animationController的时候需要一个TickerProvider类型的参数Vsync参数，所以我们混入了TickerProvider的子类SingleTickerProviderStateMixin

class _TAnimationsState extends State<TAnimations>
    with SingleTickerProviderStateMixin {
  AnimationController _controller; //该对象管理着animation对象
  Animation _animation; //该对象是当前动画的状态，例如动画是否开始，停止，前进，后退

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);

    // 动画监听结束
    _animation.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomePage()),
              (route) => route == null);
        }
      },
    );

    //  动画播放
    _controller.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //透明度动画组件
    return FadeTransition(
      opacity: _animation,
      child: Image.asset(
        'images/timg.jpg',
        scale: 2.0,
        fit: BoxFit.cover,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('首页'),
      ),
      body: Center(
        child: Text('hello world!!!'),
      ),
    );
  }
}
