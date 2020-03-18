import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:wool/routers/application.dart';
import 'package:wool/routers/routers.dart';
import '../utils/http_util.dart' as httpUtil;

String id;

// 任务详情
class MissionDetailPage extends StatelessWidget {

  MissionDetailPage(String id1) {
    id = id1;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _SendMissionPageState createState() {
    return _SendMissionPageState();
  }
}

class _SendMissionPageState extends State<MainPage> {

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('任务详情'),
      ),
      body: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.only(left: 20),
        child: Column(
          children: <Widget>[
            buildPlatform(),
            buildSignInTextForm(),
            buildSignInButton(),
          ],
        ),
      )),
    );
  }

  final TextStyle textStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w300, color: Colors.black87);

  String androidName = '';
  String iosName = '';
  String pcName = '';
  String require = '';
  String score = '';
  String num = '';
  String lineDate = '';
  String create_date = '';
  String complete = '';
  String receive = '';
  String user_id = '';

  bool isPc = false;
  bool isAndroid = false;
  bool isIos = false;
  bool isShowSubmit = true;

  // 平台
  Widget buildPlatform() {
    return Container(
      margin: EdgeInsets.only(left:40, top: 20),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              '平台：',
              style: textStyle,
            ),
            isAndroid ? Text('安卓手机',style: textStyle,):Text(''),
            isIos ? Text('  苹果手机',style: textStyle):Text(''),
            isPc ? Text('  电脑',style: textStyle):Text(''),
          ],
        ),
      )
    );
  }

  // 输入框
  Widget buildSignInTextForm() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      width: MediaQuery.of(context).size.width * 0.8,
      //  * Flutter提供了一个Form widget，它可以对输入框进行分组，然后进行一些统一操作，如输入内容校验、输入框重置以及输入内容保存。
      child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Offstage(
                // 可见
                offstage: !isAndroid,
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          controller: androidController,
                          maxLines: null,
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: androidName));
                            Toast.show("复制成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                          },
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.android,
                                color: Colors.blue,
                              ),
                              labelText: "安卓（单击复制）",
                              labelStyle: textStyle,
                              border: InputBorder.none),
                          style: textStyle,
                          readOnly: true,
                        ),
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width * 0.75,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                )),
            Offstage(
                // 可见
                offstage: !isIos,
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          controller: iosController,
                          maxLines: null,
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: iosName));
                            Toast.show("复制成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                          },
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.phone_iphone,
                                color: Colors.blue,
                              ),
                              labelText: "苹果（单击复制）",
                              labelStyle: textStyle,
                              border: InputBorder.none),
                          style: textStyle,
                          readOnly: true,
                        ),
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width * 0.75,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                )),
            Offstage(
                // 可见
                offstage: !isPc,
                child: IntrinsicHeight(
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        child: TextFormField(
                          controller: pcController,
                          maxLines: null,
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: pcName));
                            Toast.show("复制成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                          },
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.computer,
                                color: Colors.blue,
                              ),
                              labelText: "网站（单击复制）",
                              labelStyle: textStyle,
                              border: InputBorder.none),
                          style: textStyle,
                          readOnly: true,
                        ),
                      ),
                      Container(
                        height: 1,
                        width: MediaQuery.of(context).size.width * 0.75,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                )),
            Flexible(
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.monetization_on,
                      color: Colors.blue,
                    ),
                    labelText: "奖励积分：${score}",
                    labelStyle: textStyle,
                    border: InputBorder.none),
                style: textStyle,
                enabled: false,
              ),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.75,
              color: Colors.grey[400],
            ),
            Flexible(
              child: TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.filter_9_plus,
                      color: Colors.blue,
                    ),
                    labelText: "$complete已完成-$receive已领取-$num总任务数",
                    labelStyle: textStyle,
                    border: InputBorder.none),
                style: textStyle,
                enabled: false,
              ),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.75,
              color: Colors.grey[400],
            ),
            Flexible(
              child: TextFormField(
                focusNode: null,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.av_timer,
                      color: Colors.blue,
                    ),
                    labelText: "开始日期:$create_date",
                    labelStyle: textStyle,
                    border: InputBorder.none),
                style: textStyle,
                enabled: false,
              ),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.75,
              color: Colors.grey[400],
            ),
            Flexible(
              child: TextFormField(
                focusNode: null,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.timer_off,
                      color: Colors.blue,
                    ),
                    labelText: "截止日期:$lineDate",
                    labelStyle: textStyle,
                    border: InputBorder.none),
                style: textStyle,
                enabled: false,
              ),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.75,
              color: Colors.grey[400],
            ),
            Flexible(
              child: TextField(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: require));
                  Toast.show("复制成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                },
                controller: requireController,
                maxLines: null,
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.device_unknown,
                      color: Colors.blue,
                    ),
                    labelText: "完成任务后请截图保留凭据",
                    border: InputBorder.none),
                style: textStyle,
                readOnly: true,
              ),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.75,
              color: Colors.grey[400],
            ),
          ],
        ),
    );
  }

  TextEditingController androidController = new TextEditingController();
  TextEditingController iosController = new TextEditingController();
  TextEditingController pcController = new TextEditingController();
  TextEditingController requireController = new TextEditingController();

  // 发布按钮
  Widget buildSignInButton() {
    return GestureDetector(
      child: Offstage(
        offstage: !isShowSubmit,
        child: Container(
          margin: EdgeInsets.only(top: 20, bottom: 20),
          padding: EdgeInsets.only(left: 42, right: 42, top: 10, bottom: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Theme.of(context).primaryColor),
          child: Text(
            "领取任务",
            style: TextStyle(fontSize: 25, color: Colors.white),
          ),
        ),
      ),
      onTap: () {
        submit();
      },
    );
  }

// 获取数据
  getData() {
    var url = 'mission/detail';
    Map params = {};
    params['mission_id'] = id;
    httpUtil.post(url, context, params).then((map) {
      if(map['success']) {
        setState(() {
          androidName = map['data']['android_name'];
          iosName = map['data']['ios_name'];
          pcName = map['data']['website'];
          require = map['data']['requirement'];
          score = map['data']['score'];
          num = map['data']['num'];
          lineDate = map['data']['line_date'].toString().substring(0, 10);
          create_date = map['data']['create_date'].toString().substring(0, 10);
          complete = map['data']['complete'];
          receive = map['data']['receive'];
          user_id = map['data']['user_id'];

          isAndroid = !androidName.isEmpty;
          isIos = !iosName.isEmpty;
          isPc = !pcName.isEmpty;

          requireController = TextEditingController.fromValue(TextEditingValue(
            text: require
          ));
          androidController = TextEditingController.fromValue(TextEditingValue(
              text: androidName
          ));
          iosController = TextEditingController.fromValue(TextEditingValue(
              text: iosName
          ));
          pcController = TextEditingController.fromValue(TextEditingValue(
              text: pcName
          ));

          isShowSubmit = user_id != Application.id;
        });
      }
    });
  }

// 领取任务
  submit() {
    if(!Application.isLogin) {
      Application.router.navigateTo(context, Routers.login, clearStack: false);
      return;
    }
    var url = 'mission/receive';
    Map params = {};
    params['mission_id'] = id;
    params['send_user_id'] = user_id;
    params['score'] = score;
    params['requirement'] = require;
    params['line_date'] = lineDate;
    httpUtil.post(url, context, params).then((map) {
      if(map['success']) {
        Toast.show("领取任务成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        Application.router.pop(context);
      }
    });
  }
}
