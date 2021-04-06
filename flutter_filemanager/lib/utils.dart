import 'dart:io';

import 'package:flutter/material.dart';
import 'package:my_flutter_plugin/my_flutter_plugin.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FileUtils {
  static FileUtils get instance => _getInstance();
  static FileUtils _instance; //单例

  ///单例模式
  static FileUtils _getInstance() {
    if (_instance == null) {
      _instance = FileUtils._internal();
    }
    return _instance;
  }

  FileUtils._internal();

  factory FileUtils() => _getInstance();

  String rootPath; //根路径

  ///格式化文件大小
  String getFileSize(int fileSize) {
    String str = '';

    if (fileSize < 1024) {
      str = '${fileSize.toStringAsFixed(2)}B';
    } else if (1024 <= fileSize && fileSize < 1048576) {
      str = '${(fileSize / 1024).toStringAsFixed(2)}KB';
    } else if (1048576 <= fileSize && fileSize < 1073741824) {
      str = '${(fileSize / 1024 / 1024).toStringAsFixed(2)}MB';
    }

    return str;
  }

  Future<void> getPermission() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
    }
  }

  Future<void> getSDCardDir() async {
    // rootPath = (await getExternalStorageDirectory()).path;//使用第三方插件path_provider
    rootPath = (await MyFlutterPlugin.getExternalStorageDirectory())
        .path; //使用自定义插件path_provider
    print('rootPath=$rootPath');
  }
}
