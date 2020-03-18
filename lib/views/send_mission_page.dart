import 'package:flutter/material.dart';
import 'package:wool/routers/application.dart';
import 'package:wool/routers/routers.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import '../utils/http_util.dart' as httpUtil;
import 'package:toast/toast.dart';

// 发布任务
class SendMissionPage extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('发布任务'),
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
      TextStyle(fontSize: 16, fontWeight: FontWeight.w300);

  GlobalKey<FormState> _signInFormKey = new GlobalKey();

  String androidName = '';
  String iosName = '';
  String pcName = '';
  String require = '';
  String score = '';
  String num = '';
  String lineDate = '';

  bool isPc = false;
  bool isAndroid = false;
  bool isIos = false;

  // 平台
  Widget buildPlatform() {
    return Container(
//      margin: EdgeInsets.only(left: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            '平台：',
            style: textStyle,
          ),
          Text('安卓手机'),
          Checkbox(
            value: isAndroid,
            onChanged: (newValue) {
              setState(() {
                isAndroid = newValue;
              });
            },
          ),
          Text('苹果手机'),
          Checkbox(
            value: isIos,
            onChanged: (newValue) {
              setState(() {
                isIos = newValue;
              });
            },
          ),
          Text('电脑'),
          Checkbox(
            value: isPc,
            onChanged: (newValue) {
              setState(() {
                isPc = newValue;
              });
            },
          ),
        ],
      ),
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
      child: Form(
        key: _signInFormKey,
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
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.android,
                                color: Colors.blue,
                              ),
                              hintText: "请输入",
                              labelText: "安卓应用名称",
                              border: InputBorder.none),
                          style: textStyle,
                          //验证
                          onSaved: (value) {
                            setState(() {
                              androidName = value;
                            });
                          },
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
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.phone_iphone,
                                color: Colors.blue,
                              ),
                              hintText: "请输入",
                              labelText: "苹果应用名称",
                              border: InputBorder.none),
                          style: textStyle,
                          //验证
                          onSaved: (value) {
                            setState(() {
                              iosName = value;
                            });
                          },
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
                          decoration: InputDecoration(
                              icon: Icon(
                                Icons.computer,
                                color: Colors.blue,
                              ),
                              hintText: "请输入",
                              labelText: "网址",
                              border: InputBorder.none),
                          style: textStyle,
                          //验证
                          onSaved: (value) {
                            setState(() {
                              pcName = value;
                            });
                          },
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
                    hintText: "请输入",
                    labelText: "每个任务奖励积分，总积分：${Application.score}",
                    border: InputBorder.none),
                style: textStyle,
                //验证
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "请输入任务奖励积分!";
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    score = value;
                  });
                },
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
                    hintText: "请输入",
                    labelText: "最大任务数量",
                    border: InputBorder.none),
                style: textStyle,
                //验证
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "请输入最大任务数量!";
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    num = value;
                  });
                },
              ),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.75,
              color: Colors.grey[400],
            ),
            Flexible(
              child: TextFormField(
                controller: _dateController,
                focusNode: null,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.date_range,
                      color: Colors.blue,
                    ),
                    hintText: "请输入",
                    labelText: "截止日期",
                    border: InputBorder.none),
                style: textStyle,
                readOnly: true,
                onTap: () {
                  _selectDate(context);
                },
                //验证
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "请选择截止日期!";
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    lineDate = value;
                  });
                },
              ),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.75,
              color: Colors.grey[400],
            ),
            Flexible(
              child: TextFormField(
                maxLines: null,
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.device_unknown,
                      color: Colors.blue,
                    ),
                    hintText: "请输入",
                    labelText: "要求",
                    border: InputBorder.none),
                style: textStyle,
                //验证
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "请输入要求!";
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    require = value;
                  });
                },
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

  TextEditingController _dateController = new TextEditingController();

  DateTime _date = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        locale: Locale('zh'),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != _date)
      print("data selectied :${_date.toString()}");
    setState(() {
      _date = picked;
      lineDate = '${_date.year}-${_date.month}-${_date.day}';
      _dateController.text = lineDate;
    });

    if (picked == null) _date = DateTime.now();
  }

  // 发布按钮
  Widget buildSignInButton() {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.only(left: 42, right: 42, top: 10, bottom: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: Theme.of(context).primaryColor),
        child: Text(
          "发布",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
      ),
      onTap: () {
        // 利用key来获取widget的状态FormState,可以用过FormState对Form的子孙FromField进行统一的操作
        _signInFormKey.currentState.save();
        if (_signInFormKey.currentState.validate()) {
          // 如果输入都检验通过，则进行发布操作
          // Scaffold.of(context)
          //     .showSnackBar(new SnackBar(content: new Text("执行发布操作")));
          //调用所有自孩子��save回调，保存表单内容
          getData();
        }
      },
    );
  }

// 提交
  getData() {
    var url = 'mission/add';
    Map params = {};
    params['score'] = score;
    params['num'] = num;
    params['requirement'] = require;
    params['line_date'] = lineDate;
    params['website'] = pcName;
    params['android_name'] = androidName;
    params['ios_name'] = iosName;
    httpUtil.post(url, context, params).then((map) {
      if(map['success']) {
        Toast.show("发布成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        Application.router.navigateTo(context, Routers.home, clearStack: true);
      }
    });
  }
}
