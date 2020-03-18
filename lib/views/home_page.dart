
import 'package:flutter/material.dart';

/// import 'package:flutter/rendering.dart';

/// import 'package:flutter_go/views/first_page/first_page.dart';
import 'package:fluro/fluro.dart';

import 'user_page.dart';
import 'share_page.dart';
import 'mission_page.dart';
import 'hall_page.dart';

// 首页
class HomePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<HomePage> with SingleTickerProviderStateMixin {

  List<Widget> _list = List();
  int _currentIndex = 0;
  List tabData = [
    {'text': '大厅', 'icon': Icon(Icons.home)},
    {'text': '任务', 'icon': Icon(Icons.import_contacts)},
    {'text': '分享', 'icon': Icon(Icons.share)},
    {'text': '我的', 'icon': Icon(Icons.account_circle)},
  ];
  List<BottomNavigationBarItem> _myTabs = [];
  String appBarTitle;

  @override
  void initState() {
    super.initState();

    appBarTitle = tabData[0]['text'];

    for (int i = 0; i < tabData.length; i++) {
      _myTabs.add(BottomNavigationBarItem(
        icon: tabData[i]['icon'],
        title: Text(
          tabData[i]['text'],
        ),
      ));
    }
    _list
      ..add(HallPage())
      ..add(MissionPage())
      ..add(SharePage())
      ..add(UserPage());
  }

  @override
  void dispose() {
    super.dispose();
  }


  renderAppBar(BuildContext context, Widget widget, int index) {
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: renderAppBar(context, widget, _currentIndex),
      body: IndexedStack(
        index: _currentIndex,
        children: _list,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _myTabs,
        //高亮  被点击高亮
        currentIndex: _currentIndex,
        //修改 页面
        onTap: _itemTapped,
        //shifting :按钮点击移动效果
        //fixed：固定
        type: BottomNavigationBarType.fixed,

        fixedColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void _itemTapped(int index) {
    setState(() {
      _currentIndex = index;
      appBarTitle = tabData[index]['text'];
    });
  }
}
