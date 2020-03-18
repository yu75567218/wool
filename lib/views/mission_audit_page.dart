
import 'package:flutter/material.dart';
import 'package:wool/routers/application.dart';
import 'package:wool/routers/routers.dart';
import '../utils/http_util.dart' as httpUtil;
import 'package:toast/toast.dart';
import 'dart:convert' as convert;


String mission_receive_id;
String mission_id;

// 审核任务
class MissionAuditPage extends StatelessWidget {

  MissionAuditPage(String id1) {
    mission_receive_id = id1;
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
        title: Text('审核任务'),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20),
        child: Column(
          children: <Widget>[
            buildSignInTextForm(),
            buildSignInButton(),
            auditResult(),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: GestureDetector(
                onTap: () {
                  Application.router.navigateTo(context, Routers.missionDetail+'?id='+mission_id);
                },
                child: Text('查看任务', style: TextStyle(fontSize: 16, color: Colors.lightBlue, decoration: TextDecoration.underline),),
              ),
            )

          ],
        ),
      ),
    );
  }

  final TextStyle textStyle =
      TextStyle(fontSize: 16, fontWeight: FontWeight.w300);

  GlobalKey<FormState> _signInFormKey = new GlobalKey();

  List assetImages = [];

  Widget getItemContainer(index) {
    String item = assetImages[index];
    String path = httpUtil.base_url + "upload/"+item;
    return GestureDetector(
      onTap: (){
        Application.router.navigateTo(context, Routers.imagePreview+'?path='+Uri.encodeComponent(path));
      },
      child: Container(
        color: Color.fromARGB(55, 0, 0, 0),
        alignment: Alignment.center,
        child: Image.network(path),
      ),
    );
  }

  TextEditingController textController = new TextEditingController();

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
            Flexible(
              child: TextFormField(
                controller: textController,
                enabled: false,
                maxLines: null,
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.description,
                      color: Colors.blue,
                    ),
                    labelText: "描述",
                    border: InputBorder.none),
                style: textStyle,
              ),
            ),
            Container(
              height: 1,
              width: MediaQuery.of(context).size.width * 0.75,
              color: Colors.grey[400],
              margin: EdgeInsets.only(bottom: 20),
            ),
            Row(
              children: <Widget>[
                Text('凭证'),
              ],
            ),
            Container(
              height: 200,
              child:  GridView.builder(
                  itemCount: assetImages.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      childAspectRatio: 1
                  ),
                  itemBuilder: (context, index) {
                    return getItemContainer(index);
                  }
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isShowSubmit = false;
  String state;

  // 发布按钮
  Widget buildSignInButton() {
    return Offstage(
      offstage: !isShowSubmit,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            child: Container(
              width: 150,
              padding: EdgeInsets.only(left: 42, right: 42, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Theme.of(context).primaryColor),
              child: Center(
                child: Text(
                  "通过",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            onTap: () {
              audit(2);
            },
          ),
          Container(width: 10,),
          GestureDetector(
            child: Container(
              width: 150,
              padding: EdgeInsets.only(left: 42, right: 42, top: 10, bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Theme.of(context).primaryColor),
              child: Center(
                child: Text(
                  "不通过",
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
            onTap: () {
              audit(3);
            },
          )
        ],
      ),
    );
  }

  // 审核结果
  Widget auditResult() {
    var stateName = '';
    switch(state) {
      case "1":
        stateName = '审核中';
        break;
      case "2":
        stateName = '审核结果：通过';
        break;
      case "3":
        stateName = '审核结果：不通过';
        break;
    }
    return Offstage(
      offstage: isShowSubmit,
      child: Container(
        margin: EdgeInsets.only(top: 40),
        child: Center(
          child: Text(stateName, style: TextStyle(fontSize: 16, color: Colors.redAccent)),
        ),
      ),
    );
  }

// 提交 0领取，1提交审核，2通过，3不通过
  audit(state) {
    var url = 'mission/audit';
    Map params = {};
    params['mission_receive_id'] = mission_receive_id;
    params['state'] = state.toString();
    httpUtil.post(url, context, params).then((map) {
      if(map['success']) {
        Toast.show("审核成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
        Application.router.pop(context);
      }
    });
  }

// 获取数据
  getData() {
    var url = 'mission/auditDetail';
    Map params = {};
    params['mission_receive_id'] = mission_receive_id;
    httpUtil.post(url, context, params).then((map) {
      if(map['success']) {
        textController.text = map['data']['description'];
        mission_id = map['data']['mission_id'];
        var images = map['data']['images'];
        var send_user_id = map['data']['send_user_id'];
        setState(() {
          assetImages = convert.jsonDecode(images);
          state = map['data']['state'];
          isShowSubmit = (Application.id == send_user_id) && state == "1";
        });
      }
    });
  }
}
