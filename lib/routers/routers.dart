import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'router_handle.dart';

class Routers {
  static String root = '/'; // 根目录
  static String guide = '/guide'; // 引导页
  static String login = '/login'; // 登录
  static String register = '/register'; // 注册
  static String home = '/home'; // 首页
  static String sendMission = '/sendMission'; // 发布任务
  static String missionDetail = '/missionDetail'; // 任务详情
  static String missionComplete = '/missionComplete'; // 完成任务
  static String missionAudit = '/missionAudit'; // 审核任务
  static String imagePreview = '/imagePreview'; // 图片预览

  static void configRouters(Router router) {
    router.notFoundHandler = new Handler(
      handlerFunc: (BuildContext context, Map<String, List<String>> params) {
        print('ERROR====>ROUTE WAS NOT FONUND!!!');
      }
    );

    router.define(guide, handler: guideHandle);
    router.define(login, handler: loginHandle);
    router.define(register, handler: registerHandle);
    router.define(home, handler: homeHandle);
    router.define(sendMission, handler: sendMissionHandle);
    router.define(missionDetail, handler: missionDetailHandle);
    router.define(missionComplete, handler: missionCompleteHandle);
    router.define(missionAudit, handler: missionAuditHandle);
    router.define(imagePreview, handler: imagePreviewHandle);
  }
}