/*
 * @Author: your name
 * @Date: 2020-11-12 10:22:48
 * @LastEditTime: 2020-11-16 10:16:49
 * @LastEditors: wg
 * @Description: In User Settings Edit
 * @FilePath: /hhd-mobile/Volumes/project/flutter/flutterDemo/loginDemo/lib/main.dart
 */
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RootPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class RootPage extends StatefulWidget {
  RootPage({Key key}) : super(key: key);

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  // 默认颜色
  Color normalColor = Color(0x80fafafa);
  // 选中颜色
  Color selectColor = Colors.green;

  // 手机号输入框控制器
  TextEditingController _userPhoneController;

  // 密码输入框控制器
  TextEditingController _userPasswordController;

  // 手机号焦点控制
  FocusNode userPhoneFieldNode = FocusNode();
  // 密码框焦点控制
  FocusNode userPasswordFieldNode = FocusNode();

  // 注册协议点击
  TapGestureRecognizer _privacyProtocolRecognizer;

  // 动画控制器
  AnimationController registerAnimationController;

  // logo 缩放动画
  AnimationController logoAnimationController;
  Animation logoAnimation;

  // 是否选中
  bool _isSelect = false;

  RestureState currentRestureState;

  // 抖动动画控制
  AnimationController inputAnimationController;

  Animation inputAnimation;

  // 抖动次数
  int inputAnimationNumber = 0;

  bool isPhoneError = false;
  bool isPasswordError = false;

  @override
  void initState() {
    super.initState();
    _privacyProtocolRecognizer = TapGestureRecognizer();

    _userPhoneController = TextEditingController();

    _userPasswordController = TextEditingController();

    registerAnimationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    // 动画监听
    registerAnimationController.addListener(() {
      double value = registerAnimationController.value;

      setState(() {});
    });
    // logo 隐藏动画
    logoAnimationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    logoAnimationController.addListener(() {
      setState(() {});
    });
    logoAnimation =
        Tween(begin: 1.0, end: 0.0).animate(logoAnimationController);

    // 抖动 动画
    inputAnimationController =
        AnimationController(duration: Duration(milliseconds: 100), vsync: this);
    inputAnimation =
        Tween(begin: 0.0, end: 10.0).animate(inputAnimationController);
    inputAnimationController.addListener(() {
      setState(() {});
    });
    inputAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        inputAnimationNumber++;
        inputAnimationController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        inputAnimationController.reset();

        if (inputAnimationNumber < 2) {
          inputAnimationController.forward();
        } else {
          inputAnimationNumber = 0;
        }
      }
    });

    // 监听刷新页面
    userPhoneFieldNode.addListener(() {
      setState(() {});
    });

    // 添加监听
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  // 应用尺寸改变回调
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        double keyboderFlexHeight = MediaQuery.of(context).viewInsets.bottom;
        if (keyboderFlexHeight == 0) {
          logoAnimationController.reverse();
        } else {
          logoAnimationController.forward();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // 全局手势
    return Scaffold(
      // 键盘弹起，页面不变形
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () {
          // 隐藏键盘
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          // 失去焦点
          userPasswordFieldNode.unfocus();
          userPhoneFieldNode.unfocus();
        },
        child: Stack(
          children: [
            // 背景图
            buildBgWidget(),
            // 阴影层
            buildBlurBg(),
            // 用户信息输入层
            buildLoginInputWidget(),
          ],
        ),
      ),
    );
  }

  //  背景图
  buildBgWidget() {
    return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        top: 0,
        child: Image.asset('images/bg.jpeg', fit: BoxFit.cover));
  }

  // 阴影层
  buildBlurBg() {
    return Container(
      color: Color.fromRGBO(100, 100, 100, 155),
    );
  }

  // 用户信息输入框
  buildLoginInputWidget() {
    return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        top: 0,
        child: Column(
          children: [
            SizedBox(height: 100.0 * logoAnimation.value),
            // logog
            buildLogoWidget(),
            // 手机
            SizedBox(height: 30),
            buildUserRowWiget(Icons.phone_android, '请输入手机号', userPhoneFieldNode,
                _userPhoneController, isPhoneError),
            // 密码
            SizedBox(height: 20),
            buildUserRowWiget(Icons.lock_open, '请输入密码', userPasswordFieldNode,
                _userPasswordController, isPasswordError),
            // 协议
            buildAgreementWidget(),
            // 注册
            buildRegisterButton()
          ],
        ));
  }

  // logo
  buildLogoWidget() {
    return ScaleTransition(
      alignment: Alignment.center,
      scale: logoAnimation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 14),
            child: ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(8),
              ),
              child: Image.asset('images/logo.jpg',
                  width: 44, height: 44, fit: BoxFit.cover),
            ),
          ),
          Text(
            'Flutter Study',
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontFamily: 'UniTortred'),
          )
        ],
      ),
    );
  }

  // 输入框
  buildUserRowWiget(IconData preIconData, String hintText, FocusNode focusNode,
      TextEditingController controller, bool isError) {
    return Transform.translate(
      offset: Offset(isError ? inputAnimation.value : 0, 0),
      child: Container(
          margin: EdgeInsets.only(left: 22, right: 22),
          decoration: BoxDecoration(
            color: Color(0x50fafafa),
            borderRadius: BorderRadius.all(Radius.circular(30)),
            border: Border.all(
                width: 1,
                color: focusNode.hasFocus ? selectColor : normalColor),
          ),
          child: buildInputItemWidget(
              preIconData, hintText, focusNode, controller)),
    );
  }

  // input
  buildInputItemWidget(IconData preIconData, String hintText,
      FocusNode focusNode, TextEditingController controller) {
    return Row(
      children: [
        // icon
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: Icon(
            preIconData,
            color: Color(0xaafafafa),
            size: 26,
          ),
        ),
        // 竖线
        Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: 1,
            height: 26,
            color: Color(0xaafafafa),
          ),
        ),
        // 输入框
        Expanded(
          flex: 1,
          child: TextField(
            controller: controller,
            // 提交回调
            onSubmitted: (value) {
              userPhoneFieldNode.unfocus();
              FocusScope.of(context).requestFocus(userPasswordFieldNode);
            },
            focusNode: focusNode,
            style: TextStyle(color: Colors.white, fontSize: 16), // 输入框文字样式
            keyboardType: TextInputType.text, // 键盘类型
            inputFormatters: [LengthLimitingTextInputFormatter(11)], // 限制11
            textInputAction: TextInputAction.next, // 键盘下一步
            decoration: InputDecoration(
                hintText: hintText,
                border: InputBorder.none,
                hintStyle: TextStyle(color: Color(0xaafafafa))),
          ),
        ),
        // 清除按钮
        focusNode.hasFocus
            ? InkWell(
                onTap: () {
                  // 清除输入框
                  controller.text = '';
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 12),
                  child: Icon(Icons.cancel, size: 22),
                ),
              )
            : Container()
      ],
    );
  }

  buildAgreementWidget() {
    return Container(
      margin: EdgeInsets.only(left: 22, right: 22, top: 10, bottom: 10),
      child: Row(
        children: [
          buildCircleCheckBox(),

          // Text('注册同意《用户注册协议》与《隐私协议》')
          Expanded(
              flex: 1,
              child: RichText(
                text: TextSpan(
                    text: '注册同意',
                    style: TextStyle(color: Color(0xaafafafa), fontSize: 15),
                    children: [
                      TextSpan(
                          text: '《用户注册协议》',
                          // 点击事件
                          recognizer: _privacyProtocolRecognizer
                            ..onTap = () {
                              print('点击了');
                            },
                          style: TextStyle(color: Colors.orange)),
                      TextSpan(
                          text: '与',
                          style: TextStyle(color: Color(0xaafafafa))),
                      TextSpan(
                          text: '《隐私协议》',
                          style: TextStyle(color: Colors.orange)),
                    ]),
              ))
        ],
      ),
    );
  }

  buildCircleCheckBox() {
    return Container(
      padding: EdgeInsets.all(10),
      child: InkWell(
          onTap: () {
            setState(() {
              this._isSelect = !this._isSelect;
            });
          },
          child: Icon(
            _isSelect ? Icons.check_circle : Icons.panorama_fisheye_outlined,
            size: 20,
          )),
    );
  }

  // 注册按钮
  buildRegisterButton() {
    return InkWell(
        onTap: () {
          userPhoneFieldNode.unfocus();
          userPasswordFieldNode.unfocus();

          String phoneText = _userPhoneController.text;
          if (phoneText.length != 11) {
            isPhoneError = true;
            inputAnimationController.forward();
            return;
          } else {
            isPhoneError = false;
          }

          String passwordText = _userPasswordController.text;
          if (passwordText.length < 6) {
            isPasswordError = true;
            inputAnimationController.forward();
            return;
          } else {
            isPasswordError = false;
          }

          setState(() {
            currentRestureState = RestureState.none;
          });
          // 启动动画
          registerAnimationController.forward();

          // 模仿注册失败
          Future.delayed(Duration(milliseconds: 3000), () {
            setState(() {
              currentRestureState = RestureState.error;
            });
            Future.delayed(Duration(milliseconds: 1500), () {
              registerAnimationController.reverse();
            });
          });
        },
        child: Stack(
          children: [
            Transform(
              alignment: Alignment.center,
              transform: Matrix4.diagonal3Values(
                  1.0 - registerAnimationController.value, 1.0, 1.0),
              child: Container(
                margin: EdgeInsets.only(left: 22, right: 22),
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                    color: Color(0x50fafafa),
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                    border: Border.all(width: 1, color: normalColor)),
                child: Center(
                  child: Text(
                    '注册',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Opacity(
                  opacity: registerAnimationController.value,
                  child: Container(
                    height: 48,
                    width: 48,
                    padding: EdgeInsets.all(10),
                    child: buildLoadingWidget(),
                    decoration: BoxDecoration(
                        color: Color(0x50fafafa),
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        )),
                  ),
                )
              ],
            )
          ],
        ));
  }

  buildLoadingWidget() {
    Widget loadingWidget = CircularProgressIndicator();

    if (currentRestureState == RestureState.success) {
      loadingWidget = Icon(Icons.check, color: Colors.deepOrangeAccent);
    } else if (currentRestureState == RestureState.error) {
      loadingWidget = Icon(Icons.close, color: Colors.red);
    }
    return loadingWidget;
  }
}

enum RestureState {
  none,
  loading,
  success,
  error,
  rever,
}
