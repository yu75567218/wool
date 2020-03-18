
import 'package:flutter/material.dart';


String path;

// 图片预览
class ImagePreviewPage extends StatelessWidget {

  ImagePreviewPage(String p) {
    path = Uri.decodeComponent(p);
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
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('图片预览'),
      ),
      body: Container(
        child: Center(
          child: Image.network(path, fit: BoxFit.contain,),
        ),
      ),
    );
  }

}
