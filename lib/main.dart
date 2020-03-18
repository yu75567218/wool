import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:wool/routers/application.dart';
import 'package:wool/routers/routers.dart';
import 'utils/shared_preferences.dart';
import 'utils/shared_preferences_keys.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<SpUtil> sp;

void main() async {
  runApp(new MyApp());
}

// 启动页
class MyApp extends StatelessWidget {

  MyApp() {
    final router = Router();
    Routers.configRouters(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext c) {
    return new MaterialApp(
      debugShowCheckedModeBanner:false,
      localizationsDelegates: [
        //此处
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        //此处
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {

  @override
  void initState() {
    sp = SpUtil.getInstance();
    Future.delayed(Duration(seconds: 2), () {
      sp.then((SpUtil spu) {
        bool hasGuide = spu.getBool(SharedPreferencesKeys.hasGuide) ?? false;
        if(hasGuide) {
          bool hasLogin = spu.getBool(SharedPreferencesKeys.hasLogin) ?? false;
          if(hasLogin) {
            Application.isLogin = true;
            Application.id = spu.getString(SharedPreferencesKeys.id);
            Application.phone = spu.getString(SharedPreferencesKeys.phone);
            Application.token = spu.getString(SharedPreferencesKeys.token);
            Application.score = spu.getString(SharedPreferencesKeys.score);
          }
          Application.router.navigateTo(context, Routers.home, clearStack: true);
        } else {
          Application.router.navigateTo(context, Routers.guide, clearStack: true);
          spu.putBool(SharedPreferencesKeys.hasGuide, true);
        }

      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: new Center(
        child: Image.asset('images/launch.gif',
            fit: BoxFit.fill,
            width: double.infinity,//全屏
            height: double.infinity),
      )
    );
  }

}
