import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'package:wool/routers/application.dart';
import 'package:wool/routers/routers.dart';
import '../utils/http_util.dart' as httpUtil;

// 任务领取列表
class MissionReceiveListPage extends StatefulWidget {

  @override
  _MyMissionPageState createState() => _MyMissionPageState();
}

class _MyMissionPageState extends State<MissionReceiveListPage> {


  //初始化滚动监听器，加载更多使用
  ScrollController _controller = new ScrollController();

  /**
   * 构造器接收（MovieList）数据
   */
  _MyMissionPageState({Key key}) {
    //固定写法，初始化滚动监听器，加载更多使用
    _controller.addListener(() {
      var maxScroll = _controller.position.maxScrollExtent;
      var pixel = _controller.position.pixels;
      if (maxScroll == pixel && missionList.length < totalSize) {
        setState(() {
          loadMoreText = "正在加载中...";
          loadMoreTextStyle =
          new TextStyle(color: const Color(0xFF4483f6), fontSize: 14.0);
        });
        loadMoreData();
      } else {
        setState(() {
          loadMoreText = "没有更多数据";
          loadMoreTextStyle =
          new TextStyle(color: const Color(0xFF999999), fontSize: 14.0);
        });
      }
    });
  }

  final TextStyle textStyle =
  TextStyle(fontSize: 16, fontWeight: FontWeight.w300,color: Colors.blue);

  int currentPage = 0; //第一页
  int pageSize = 10; //页容量
  int totalSize = 0; //总条数
  List missionList = [];
  String loadMoreText = Application.isLogin?"没有更多数据":"登录后查看数据";
  TextStyle loadMoreTextStyle =
  new TextStyle(color: const Color(0xFF999999), fontSize: 14.0);
  TextStyle titleStyle =
  new TextStyle(color: Colors.blue, fontSize: 14.0);
  TextStyle contentStyle =
  new TextStyle(color: const Color(0xDD757575), fontSize: 12.0);

  @override
  void initState() {
    loadMoreData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: RefreshIndicator(
        // 下拉刷新
        child: ListView.builder(
          controller: _controller,
          itemCount: missionList.length + 1,
            itemBuilder: (context, index){
              if (index == missionList.length) {
                return _buildProgressMoreIndicator();
              } else {
                return renderRow(index, context);
              }
            }),
        onRefresh: _pullToRefresh,
      ),
    );
  }

  /**
   * 下拉刷新,必须异步async不然会报错
   */
  Future _pullToRefresh() async {
    currentPage = 0;
    missionList.clear();
    loadMoreData();
    return null;
  }


  /**
   * 加载更多进度条
   */
  Widget _buildProgressMoreIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(15.0),
      child: new Center(
        child: new Text(loadMoreText, style: loadMoreTextStyle),
      ),
    );
  }

  //加载列表数据
  loadMoreData() async {
    if(!Application.isLogin) {
      return;
    }
    this.currentPage++;
    var start = (currentPage - 1) * pageSize;
    getData(start, pageSize);
  }

  /**
   * 列表的ltem
   */
  renderRow(index, context) {
    var mission = missionList[index];
    var mission_id = mission["mission_id"];
    var mission_receive_id = mission["mission_receive_id"];
    var score = mission["score"];
    var state = mission["state"];
    var stateName = '';
    switch(state) {
      case '0':
        stateName = '已领取';
        break;
      case '1':
        stateName = '提交审核';
        break;
      case '2':
        stateName = '通过';
        break;
      case '3':
        stateName = '不通过';
        break;
    }
    var line_date = mission["line_date"].toString().substring(0, 10);
    var create_date = mission["create_date"].toString().substring(0, 10);
    return new Container(
        height: 91,
        color: Colors.white,
        child: new InkWell(
          onTap: () {
            if("0" == state) {
              Application.router.navigateTo(context,
                  Routers.missionComplete + '?id=' + mission_receive_id);
            } else {
              Application.router.navigateTo(context, Routers.missionAudit+'?id='+mission_receive_id);
            }
          },
          child: new Column(
            children: <Widget>[
              new Container(
                height: 90,
                // color: Colors.blue,
                child: new Row(
                  children: <Widget>[
                    new Container(
                      width: 150.0,
                      height: 100.0,
                      margin: const EdgeInsets.all(10.0),
                      child:  Center(
                        child: ListTile(
                          leading: Icon(
                            Icons.monetization_on,
                            size: 27,
                          ),
                          title: Text(
                            '${score}积分',
                            style: textStyle,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: new Container(
                        height: 100.0,
                        margin: const EdgeInsets.all(12.0),
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text(
                              "领取日期：$create_date",
                              style: contentStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                            new Text(
                              "截止日期：$line_date",
                              style: contentStyle,
                              overflow: TextOverflow.ellipsis,
                            ),new Text(
                              "状态：$stateName",
                              style: new TextStyle(color: Colors.red, fontSize: 12.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              //分割线
              new Divider(height: 1)
            ],
          ),
        ));
  }

// 获取任务列表
  getData(start, pageSize) {
    var url = 'mission/receiveList';
    Map params = {};
    params['start'] = start.toString();
    params['pageSize'] = pageSize.toString();
    httpUtil.post(url, context, params).then((map) {
      if(map['success']) {
        setState(() {
          setState(() {
            var list = map['data']['list'];
            if(list != null) {
              missionList.addAll(list);
            }
            totalSize = map['data']['total'];
          });
        });
      }
    });
  }
}
