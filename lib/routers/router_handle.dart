import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:wool/routers/application.dart';
import 'package:wool/views/guide_page.dart';
import 'package:wool/views/image_preview_page.dart';
import 'package:wool/views/login_page.dart';
import 'package:wool/views/mission_audit_page.dart';
import 'package:wool/views/mission_complete_page.dart';
import 'package:wool/views/mission_detail_page.dart';
import 'package:wool/views/register_page.dart';
import 'package:wool/views/home_page.dart';
import '../views/send_mission_page.dart';

// 引导页
var guideHandle = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new GuidePage();
    }
);

// 登录
var loginHandle = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new LoginPage();
    }
);

// 注册
var registerHandle = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new RegisterPage();
    }
);

// 首页
var homeHandle = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new HomePage();
    }
);

// 发布任务
var sendMissionHandle = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      if(Application.isLogin) {
        return new SendMissionPage();
      } else {
        return new LoginPage();
      }
    }
);

// 任务详情
var missionDetailHandle = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      if(Application.isLogin) {
        return new MissionDetailPage(params['id'][0]);
      } else {
        return new LoginPage();
      }
    }
);

// 完成任务
var missionCompleteHandle = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      if(Application.isLogin) {
        return new MissionCompletePage(params['id'][0]);
      } else {
        return new LoginPage();
      }
    }
);

// 审核任务
var missionAuditHandle = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      if(Application.isLogin) {
        return new MissionAuditPage(params['id'][0]);
      } else {
        return new LoginPage();
      }
    }
);

// 图片预览
var imagePreviewHandle = new Handler(
    handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      return new ImagePreviewPage(params['path'][0]);
    }
);