class string_util {

  // 手机号脱敏
  static String formatPhone(String phone) {
    if(phone == null || phone.isEmpty) {
      return "";
    }
    return phone.replaceFirst(new RegExp(r'\d{4}'), '****', 3);
  }
}