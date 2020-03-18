import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'package:wool/views/mission_receive_list_page.dart';
import 'package:wool/views/my_mission_list_page.dart';

import 'mission_audit_list_page.dart';

//任务
class MissionPage extends StatefulWidget {


  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<MissionPage> {

  final TextStyle textStyle =
  TextStyle(fontSize: 16, fontWeight: FontWeight.w300);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('我的任务'),
          bottom: TabBar(tabs: [
            Tab(
              text: "领取",
            ),
            Tab(
              text: "审核",
            ),
            Tab(
              text: "发布",
            ),
          ]),
        ),
        body: TabBarView(children: [
          MissionReceiveListPage(),
          MissionAuditListPage(),
          MyMissionListPage(),
        ]),
      ),
    );
  }
}
