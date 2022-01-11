import 'package:hive_flutter/hive_flutter.dart';

const boxKey = 'jenkins_box__key';
const tokenKey = 'token__key';
const authed = 'authed__key';
const baseUrlKey = 'base_url__key';

class HiveBox {
  HiveBox._();
  static late Box _box;

  static init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(boxKey);
  }

  static String getToken() {
    return _box.get(tokenKey, defaultValue: '');
  }

  static saveToken(String token) {
    return _box.put(tokenKey, token);
  }

  static String getBaseUrl() {
    return _box.get(baseUrlKey, defaultValue: 'https://cicd.abmatrix.cn/');
  }

  static saveBaseUrl(String url) {
    return _box.put(tokenKey, url);
  }
}
