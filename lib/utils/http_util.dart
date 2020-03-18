import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import '../routers/application.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

String base_url = Application.isDebugMode ? 'http://192.168.197.2:80/wool/' : 'http://www.integral.vip/wool/';

// post请求
Future<Map> post(String url, BuildContext context, var params) async {
  if(Application.isLogin) {
    params['id'] = Application.id;
    params['token'] = Application.token;
  }
  var result = await http.post(base_url + url, body: params);
  var body = result.body;
  print('url:' + base_url + url);
  print('request:' + params.toString());
  print('response:' + body);
  if(result.statusCode == 200) {
    Map resultMap = convert.jsonDecode(body);
    if(resultMap['code'] == 100) {
      resultMap['success'] = true;
      return resultMap;
    } else {
      Toast.show(resultMap['message'] , context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  } else {
    Toast.show("网络异常", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
  }
  return {'success':false};
}

//上传
Future<Map> upload(String url, BuildContext context,path) async {
  print('path:' + path);
  var file = File(path);
  var requestBody = {
    "id": Application.id,
    "token": Application.token,
    "file": convert.base64Encode(file.readAsBytesSync()),
  };
  var result = await http.post(base_url + url, body: requestBody);

  var body = result.body;
  print('response:' + body);
  if(result.statusCode == 200) {
    Map resultMap = convert.jsonDecode(body);
    if(resultMap['code'] == 100) {
      resultMap['success'] = true;
      return resultMap;
    } else {
      Toast.show(resultMap['message'] , context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  } else {
    Toast.show("网络异常", context, duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
  }
  return {'success':false};
}