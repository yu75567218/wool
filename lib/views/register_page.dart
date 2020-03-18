import 'package:flutter/material.dart';
import 'package:wool/routers/application.dart';
import 'package:toast/toast.dart';
import 'package:wool/routers/routers.dart';
import 'package:wool/utils/shared_preferences.dart';
import 'package:wool/utils/shared_preferences_keys.dart';
import '../utils/http_util.dart' as httpUtil;

// 注册
class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _RegisterPageState createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('注册'),
      ),
      body: SingleChildScrollView(
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            buildSignInTextForm(),
            buildSignInButton(),
          ],
        )),
      ),
    );
  }

  // 利用FocusNode和_focusScopeNode来控制焦点 可以通过FocusNode.of(context)来获取widget树中默认的_focusScopeNode
  FocusNode _phoneFocusNode = new FocusNode();
  FocusNode _codeFocusNode = new FocusNode();
  FocusNode _passwordFocusNode = new FocusNode();
  FocusScopeNode _focusScopeNode = new FocusScopeNode();

  GlobalKey<FormState> _signInFormKey = new GlobalKey();
  TextEditingController _userNameEditingController =
      new TextEditingController();
  TextEditingController _codeEditingController =
      new TextEditingController();
  TextEditingController _passwordEditingController =
  new TextEditingController();

  String username = '';
  String code = '';
  String password = '';
  String invitation = '0';
  bool isShowPassWord = false;

  // 创建登录界面的TextForm
  Widget buildSignInTextForm() {
    return Container(
      padding: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      //  * Flutter提供了一个Form widget，它可以对输入框进行分组，然后进行一些统一操作，如输入内容校验、输入框重置以及输入内容保存。
      child: Form(
        key: _signInFormKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 20),
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: _userNameEditingController,
                  //关联焦点
                  focusNode: _phoneFocusNode,
                  onEditingComplete: () {
                    if (_focusScopeNode == null) {
                      _focusScopeNode = FocusScope.of(context);
                    }
                    _focusScopeNode.requestFocus(_codeFocusNode);
                  },

                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.phone,
                        color: Colors.blue,
                      ),
                      hintText: "手机号",
                      border: InputBorder.none),
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                  //验证
                  validator: (value) {
                    if (value.isEmpty) {
                      return "手机号不可为空!";
                    }
                    RegExp exp = RegExp('^1[0-9]{10}\$');
                    if(!exp.hasMatch(value)) {
                      return "手机号格式错误!";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      username = value;
                    });
                  },
                ),
              ),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.75,
              color: Colors.grey[400],
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                child: TextFormField(
                  controller: _codeEditingController,
                  focusNode: _codeFocusNode,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.message,
                      color: Colors.blue,
                    ),
                    hintText: "验证码",
                    border: InputBorder.none,
                    suffix: GestureDetector(
                      child: Text("获取验证码"),
                      onTap: () {
                        var username = _userNameEditingController.text.toString();
                        if(username == null || username.isEmpty) {
                          Toast.show("手机号不能为空", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                          return;
                        }
                        RegExp exp = RegExp('^1[0-9]{10}\$');
                        if(!exp.hasMatch(username)) {
                          Toast.show("手机号格式错误", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                          return;
                        }
                        getCode(username);
                      },
                    ),
                    suffixStyle: TextStyle(color: Colors.blue)
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "验证码不可为空!";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      code = value;
                    });
                  },
                ),
              ),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.75,
              color: Colors.grey[400],
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                child: TextFormField(
                  controller: _passwordEditingController,
                  focusNode: _passwordFocusNode,
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.lock,
                      color: Colors.blue,
                    ),
                    hintText: "密码",
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.remove_red_eye,
                        color: Colors.blue,
                      ),
                      onPressed: showPassWord,
                    ),
                  ),
                  //输入密码，需要用*****显示
                  obscureText: !isShowPassWord,
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "密码不可为空!";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    setState(() {
                      password = value;
                    });
                  },
                ),
              ),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.75,
              color: Colors.grey[400],
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 20),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      icon: Icon(
                        Icons.person_outline,
                        color: Colors.blue,
                      ),
                      hintText: "邀请人ID",
                      border: InputBorder.none),
                  style: TextStyle(fontSize: 16, color: Colors.blue),
                  //验证
                  onSaved: (value) {
                    setState(() {
                      if(value == null || value.isEmpty) {
                        invitation = '0';
                      } else {
                        invitation = value;
                      }
                    });
                  },
                ),
              ),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.75,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }

  // 登录按钮
  Widget buildSignInButton() {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.only(left: 42, right: 42, top: 10, bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Theme.of(context).primaryColor),
        child: Text(
          "注册",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      onTap: () {
        // 利用key来获取widget的状态FormState,可以用过FormState对Form的子孙FromField进行统一的操作
        _signInFormKey.currentState.save();
        if (_signInFormKey.currentState.validate()) {
          // 如果输入都检验通过，则进行登录操作
          // Scaffold.of(context)
          //     .showSnackBar(new SnackBar(content: new Text("执行登录操作")));
          //调用所有自孩子��save回调，保存表单内容
          doLogin();
        }
      },
    );
  }


// 注册操作
  doLogin() async {
    var url = 'user/register';
    Map params = {};
    params['phone'] = username;
    params['password'] = password;
    params['code'] = code;
    params['invitation'] = invitation;
    httpUtil.post(url, context, params).then((map) {
      if(map['success']) {
        Application.isLogin = true;
        Application.id = map['data']['id'];
        Application.phone = map['data']['phone'];
        Application.token = map['data']['token'];
        Application.score = map['data']['score'];
        SpUtil.getInstance().then((sp) {
          sp.putBool(SharedPreferencesKeys.hasLogin, true);
          sp.putString(SharedPreferencesKeys.id, Application.id);
          sp.putString(SharedPreferencesKeys.phone, Application.phone);
          sp.putString(SharedPreferencesKeys.token, Application.token);
          sp.putString(SharedPreferencesKeys.score, Application.score);
        });
        Application.router.navigateTo(context, Routers.home, clearStack: true);
      }
    });

  }


// 获取验证码
  getCode(phone) async {
    var url = 'user/getCode';
    Map params = {};
    params['phone'] = phone;
    httpUtil.post(url, context, params).then((map) {
      if(map['success']) {
        Toast.show("验证码发送成功", context, duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      }
    });

  }

// 点击控制密码是否显示
  void showPassWord() {
    setState(() {
      isShowPassWord = !isShowPassWord;
    });
  }
}
