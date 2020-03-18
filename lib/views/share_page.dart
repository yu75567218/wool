import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'package:wool/routers/application.dart';
import '../utils/http_util.dart' as httpUtil;

class SharePage extends StatefulWidget {

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<SharePage> {

  var score = 0;
  var num = 0;
  List shareList = [];

  @override
  void initState() {
    if(Application.isLogin) {
      getData();
      getList();
    }
    super.initState();
  }

  final TextStyle textStyle =
  TextStyle(fontSize: 16, fontWeight: FontWeight.w300);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(children: <Widget>[

          Container(
            child: Text("通过分享获得积分：${score}", style: textStyle,),
            margin: EdgeInsets.only(top: 50),
          ),
          Container(
            child: Text("已分享：${num}人", style: textStyle,),
            margin: EdgeInsets.only(top: 20),
          ),
          GestureDetector(
            onTap: () {
              Clipboard.setData(ClipboardData(text: Application.id));
              Toast.show("邀请码复制成功,去分享吧", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            },
            child:Container(
              child: Text("邀请码：${Application.id}", style: textStyle,),
              margin: EdgeInsets.only(top: 20),
            ),
          ),

          Container(
            child: Text("分享规则：新用户注册时填写分享的邀请码即可，每成功分享一人，将获得3个积分。积分可用于发布任务，其他用户完成任务后自动获取到相应的积分。", style: TextStyle(fontSize: 14, color: Colors.grey),),
            margin: EdgeInsets.only(top: 20, left: 20, right: 20),
          ),
          Expanded(
            child:
            ListView.builder(
                itemCount:shareList.length <=0 ? 0: shareList.length+1 ,
                itemBuilder: (BuildContext context, int index) {
                  if(index == 0) {
                    return buildItem('时间', '手机号', '获得积分');
                  }
                  var row = shareList[index - 1];
                  var phone = row['invitationed_phone'];
                  phone = phone.replaceFirst(new RegExp(r'\d{4}'), '****', 3);
                  return buildItem(row['createDate'], phone, row['score']);
                }),
          )

        ],),
      ),
    );
  }

  Widget buildItem(var date, var phone, var score) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Expanded(child:  Text(date),flex: 2,),
          Expanded(child:  Text(phone),flex: 2,),
          Expanded(child:  Text(score),flex: 1,)
        ],
      ),
    );
  }

// 获取信息
  getData() {
    var url = 'share/shareTotal';
    Map params = {};
    httpUtil.post(url, context, params).then((map) {
      if(map['success']) {
        setState(() {
          try {
            score = int.parse(map['data']['score']);
          } catch (e) {
            score = 0;
          }
          num = map['data']['count'];
        });
      }
    });
  }

// 获取列表
  getList() {
    var url = 'share/shareList';
    Map params = {};
    httpUtil.post(url, context, params).then((map) {
      if(map['success']) {
        setState(() {
          shareList = map['data'];
        });
      }
    });
  }
}
