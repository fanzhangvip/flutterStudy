import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

enum Toast { LENGTH_SHORT, LENGTH_LONG }

class MyFlutterPlugin {
  static const MethodChannel _channel =
      const MethodChannel('com.zero.my_flutter_plugin/path_provider');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  ///自定义通信插件
  ///获取sdcard的目录
  static Future<Directory> getExternalStorageDirectory() async {
    final String path = await _channel.invokeMethod('getStorageDirectory');
    if (path == null) {
      return null;
    }
    return new Directory(path);
  }

  static Future<bool> showToast(
      {@required String msg, Toast toastLength}) async {
    assert(msg != null);
    String toast = "short";
    if (toastLength == Toast.LENGTH_LONG) {
      toast = "long";
    }
    final Map<String, dynamic> params = <String, dynamic>{
      'msg': msg,
      'length': toast,
    };

    bool res = await _channel.invokeMethod('showToast', params);
    return res;
  }
}
