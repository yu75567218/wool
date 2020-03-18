import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'package:wool/routers/application.dart';
import 'package:wool/routers/routers.dart';
import '../utils/http_util.dart' as httpUtil;

// 我的任务列表
class MyMissionListPage extends StatefulWidget {

  @override
  _MyMissionPageState createState() => _MyMissionPageState();
}

class _MyMissionPageState extends State<MyMissionListPage> {


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
    var id = mission["id"];
    var score = mission["score"];
    var complete = mission["complete"];
    var receive = mission["receive"];
    var num = mission["num"];
    var website = mission["website"];
    var android_name = mission["android_name"];
    var ios_name = mission["ios_name"];
    var line_date = mission["line_date"].toString().substring(0, 10);
    var create_date = mission["create_date"].toString().substring(0, 10);
    return new Container(
        height: 111,
        color: Colors.white,
        child: new InkWell(
          onTap: () {
            Application.router.navigateTo(context, Routers.missionDetail+'?id='+id);
          },
          child: new Column(
            children: <Widget>[
              new Container(
                height: 110,
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
                              "$complete已完成-$receive已领取-$num总量",
                              style: titleStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                            new Text(
                              "发布日期：$create_date",
                              style: contentStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                            new Text(
                              "截止日期：$line_date",
                              style: contentStyle,
                              overflow: TextOverflow.ellipsis,
                            ),
                            new Row(
                              children: <Widget>[
                                Icon(
                                  Icons.android,
                                  size: android_name.toString().isEmpty?0: 27,
                                ),
                                Icon(
                                  Icons.phone_iphone,
                                  size: ios_name.toString().isEmpty?0: 27,
                                ),
                                Icon(
                                  Icons.computer,
                                  size: website.toString().isEmpty?0: 27,
                                )
                              ],
                            )
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
    var url = 'mission/myList';
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
