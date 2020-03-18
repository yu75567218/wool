
import 'package:fluro/fluro.dart';

class Application {
  static Router router;
  static bool isLogin = false; // 是否登录
  static bool isDebugMode = false; // 是否调试模式

  // 用户信息
  static String id = '';
  static String phone = '';
  static String token = '';
  static String score = '0';
}