import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'package:wool/routers/application.dart';
import 'package:wool/routers/routers.dart';
import 'package:wool/utils/shared_preferences.dart';
import 'package:wool/utils/shared_preferences_keys.dart';
import '../utils/http_util.dart' as httpUtil;
import '../utils/string_util.dart';


class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final TextStyle textStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w300);

  var score = Application.score.isEmpty ? 0 : int.parse(Application.score);
  var username = Application.phone.isEmpty ? "未登录": string_util.formatPhone(Application.phone);
  var score_value = "积分可用于发布任务，比如他人帮你去注册新号，你就可以在该平台上完成拉新，获取相应的收益。";
  var how_money = "发布任务即有无数人帮你，无论是下载APP，还是注册手机号，或者是地推等等。";

  @override
  void initState() {
    getConfig();
    if (Application.isLogin) {
      getData();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            UserAccountsDrawerHeader(
              onDetailsPressed: (){
                if(Application.isLogin) {
                  logout();
                } else {
                  login();
                }
                },
              accountName: Text(username),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('images/header.png'),
              ),
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                image: new DecorationImage(
                  fit: BoxFit.cover,
                  image: new ExactAssetImage('images/header_bg.png'),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.monetization_on,
                size: 27,
              ),
              title: Text(
                '${score}积分',
                style: textStyle,
              ),
            ),
            new Divider(),
            ListTile(
              leading: Icon(
                Icons.question_answer,
                size: 27,
              ),
              title: Text(
                '积分的用处？',
                style: textStyle,
              ),
              onTap: () {
                showQuestion();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.flag,
                size: 27,
              ),
              title: Text(
                '我们的使命',
                style: textStyle,
              ),
              onTap: () {
                showMission();
              },
            ),
            new Divider(),
            ListTile(
              leading: Icon(
                Icons.contact_phone,
                size: 27,
              ),
              title: Text(
                '联系我们',
                style: textStyle,
              ),
              onTap: () {
                contactUs();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.picture_in_picture,
                size: 27,
              ),
              title: Text(
                '图文介绍',
                style: textStyle,
              ),
              onTap: () {
                Application.router.navigateTo(context, Routers.guide, clearStack: false);
              },
            ),
          ],
        ),
      ),
    );
  }

  //积分的用处
  showQuestion() {
    final TextStyle questionTextStyle =
        TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    final TextStyle answerTextStyle =
        TextStyle(fontSize: 14, fontWeight: FontWeight.w300);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('积分的用处'),
            content: SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text(
                    '积分有什么作用？',
                    style: questionTextStyle,
                  ),
                  new Text(
                    '$score_value',
                    style: answerTextStyle,
                  ),
                  new Divider(),
                  new Text(
                    '如何获取积分？',
                    style: questionTextStyle,
                  ),
                  new Text(
                    '1、分享邀请码给他人，成功注册之后，每人发放3个积分；',
                    style: answerTextStyle,
                  ),
                  new Text(
                    '2、做任务获得指定的积分；',
                    style: answerTextStyle,
                  ),
                  new Text(
                    '3、联系我们。',
                    style: answerTextStyle,
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)), // 圆角

            actions: <Widget>[
              new Container(
                  width: 250,
                  child: FlatButton(
                    child: Text('知道了',
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ))
            ],
          );
        });
  }

  //使命
  showMission() {
    final TextStyle questionTextStyle =
    TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
    final TextStyle answerTextStyle =
    TextStyle(fontSize: 14, fontWeight: FontWeight.w300);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('我们的使命'),
            content: SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text(
                    '让所有人互助互惠！！！',
                    style: questionTextStyle,
                  ),
                  new Text(
                    '$how_money',
                    style: answerTextStyle,
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)), // 圆角

            actions: <Widget>[
              new Container(
                  width: 250,
                  child: FlatButton(
                    child: Text('知道了',
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ))
            ],
          );
        });
  }

  //联系我们
  contactUs() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          final TextStyle answerTextStyle =
          TextStyle(fontSize: 14, fontWeight: FontWeight.w300);
          return AlertDialog(
            title: Text('联系我们'),
            content: SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Text(
                    '单击复制联系方式',
                    style: answerTextStyle,
                  ),
                  TextFormField(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: 'wongwoo@qq.com'));
                      Toast.show("复制成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                    },
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.alternate_email,
                          color: Colors.blue,
                        ),
                        labelText: "邮箱：wongwoo@qq.com",
                        labelStyle: textStyle,
                        border: InputBorder.none),
                    style: textStyle,
                    readOnly: true,
                  ),
                  TextFormField(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: 'yu75567218'));
                      Toast.show("复制成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                    },
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.message,
                          color: Colors.blue,
                        ),
                        labelText: "微信：yu75567218",
                        labelStyle: textStyle,
                        border: InputBorder.none),
                    style: textStyle,
                    readOnly: true,
                  ),
                  TextFormField(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: '669087050'));
                      Toast.show("复制成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                    },
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.group_add,
                          color: Colors.blue,
                        ),
                        labelText: "QQ：669087050",
                        labelStyle: textStyle,
                        border: InputBorder.none),
                    style: textStyle,
                    readOnly: true,
                  ),
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)), // 圆角

            actions: <Widget>[
              new Container(
                  width: 250,
                  child: FlatButton(
                    child: Text('知道了',
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ))
            ],
          );
        });
  }

// 获取信息
    getData() {
      var url = 'user/info';
      Map params = {};
      httpUtil.post(url, context, params).then((map) {
        if(map['success']) {
          setState(() {
            score = int.parse(map['data']['score']);
            username = string_util.formatPhone(map['data']['phone']);
          });
        }
      });
    }

// 获取配置
  getConfig() {
    var url = 'open/config';
    Map params = {};
    httpUtil.post(url, context, params).then((map) {
      if(map['success']) {
        setState(() {
          score_value = map['data']['score_value'];
          how_money = map['data']['how_money'];
        });
      }
    });
  }

// 登录
  login() {
    Application.router.navigateTo(context, Routers.login);
  }

  //登出
  logout() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('确定退出？'),
            content: SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                ],
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(20.0)), // 圆角

            actions: <Widget>[
              new Container(
                  width: 250,
                  child: FlatButton(
                    child: Text('确定',
                        style: TextStyle(
                            fontSize: 16,
                            color: Theme.of(context).primaryColor)),
                    onPressed: () {
                      Application.isLogin = false;
                      Application.id = '';
                      Application.phone = '';
                      Application.token = '';
                      Application.score = '';
                      SpUtil.getInstance().then((sp) {
                        sp.putBool(SharedPreferencesKeys.hasLogin, false);
                        sp.putString(SharedPreferencesKeys.id, Application.id);
                        sp.putString(SharedPreferencesKeys.phone, Application.phone);
                        sp.putString(SharedPreferencesKeys.token, Application.token);
                        sp.putString(SharedPreferencesKeys.score, Application.score);
                      });

                      Navigator.of(context).pop();
                      Application.router.navigateTo(context, Routers.login, clearStack: false);
                    },
                  ))
            ],
          );
        });
  }
}
