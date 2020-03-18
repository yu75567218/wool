
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wool/routers/application.dart';
import 'package:wool/routers/routers.dart';
import '../utils/http_util.dart' as httpUtil;
import 'package:toast/toast.dart';


String mission_receive_id;
String mission_id;

// 完成任务
class MissionCompletePage extends StatelessWidget {

  MissionCompletePage(String id1) {
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
        title: Text('完成任务'),
      ),
      body: Container(
        margin: EdgeInsets.only(left: 20),
        child: Column(
          children: <Widget>[
            buildSignInTextForm(),
            buildSignInButton(),
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

  String description = '';
  List assetImages = ['images/add.png'];
  List uploadImages = [];

  Widget getItemContainer(index) {
    String item = assetImages[index];
    File file = File(item);
    return GestureDetector(
      onTap: (){
        if(index == 0) {
          _openGallery();
        } else {
          setState(() {
            assetImages.removeAt(index);
          });
        }
      },
      child: Container(
        color: Color.fromARGB(55, 0, 0, 0),
        alignment: Alignment.center,
        child: item.startsWith('images') ?Image.asset(item, fit: BoxFit.cover,) :Image.file(file, fit: BoxFit.cover),
      ),
    );
  }

  _openGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      descriptionController.text = description;
      assetImages.add(image.path);
    });
  }

  TextEditingController descriptionController = new TextEditingController();

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
                controller: descriptionController,
                onChanged: (value) {
                  description = value;
                },
                maxLines: null,
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.description,
                      color: Colors.blue,
                    ),
                    hintText: "请输入",
                    labelText: "描述",
                    border: InputBorder.none),
                style: textStyle,
                //验证
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "请输入描述!";
                  }
                  return null;
                },
                onSaved: (value) {
                  setState(() {
                    description = value;
                  });
                },
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
                Text('（提供相应的截图，审核会更快通过哦）', style: TextStyle(fontSize: 10, color: Colors.grey),),
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
          "提交审核",
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
          if(assetImages.length <= 1) {
            Toast.show("请选择凭证截图", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            return;
          }
          if(assetImages.length > 5) {
            Toast.show("最多选择5张凭证截图", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            return;
          }
          Toast.show("开始上传截图，请不要重复点击", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          startUpload();
        }
      },
    );
  }

  var startIndex = 1;
// 上传
  startUpload() {
    var url = 'upload/index.php';
      httpUtil.upload(url, context, assetImages[startIndex]).then((map) {
        if (map['success']) {
          startIndex++;
          uploadImages.add(map['data']['path']);
          if(uploadImages.length == assetImages.length -1) {
            //上传完成
            submit();
          } else {
            startUpload();
          }
        } else {
          Toast.show("上传失败", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          startIndex = 1;
          uploadImages.clear();
          return;
        }
      });

  }

// 上传
  upload(String path) {
    var url = 'upload/index.php';
      httpUtil.upload(url, context,path).then((map) {
        if (map['success']) {
          uploadImages.add(map['data']['path']);
          if(uploadImages.length == assetImages.length -1) {
            //上传完成
            Future.delayed(Duration(seconds: 1), () {
              submit();
            });
          }
        } else {
          Toast.show("上传失败", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          uploadImages.clear();
          return;
        }
      });
  }

// 提交
  submit() {
    var url = 'mission/complete';
    Map params = {};
    params['mission_receive_id'] = mission_receive_id;
    params['images'] = json.encode(uploadImages);
    params['description'] = description;
    httpUtil.post(url, context, params).then((map) {
      if(map['success']) {
        Toast.show("提交成功", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
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
        setState(() {
          mission_id = map['data']['mission_id'];
        });
      }
    });
  }
}
