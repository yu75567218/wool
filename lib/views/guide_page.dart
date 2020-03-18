import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wool/routers/application.dart';
import 'package:wool/routers/routers.dart';


class GuidePage extends StatefulWidget {
  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  @override
  Widget build(BuildContext context) {
    List images = ['images/guide1.gif','images/guide2.gif'];
    return PageView.builder(
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: InkWell(
              onTap: () {
                if(index == images.length-1) {
                  Application.router.navigateTo(context, Routers.home, clearStack: true);
                }
              },
              child: Image.asset(
                  images[index],
                  fit: BoxFit.fill,
                  width: double.infinity,//全屏
                  height: double.infinity
              ),
            ),
          ) ;
        });
  }
}

