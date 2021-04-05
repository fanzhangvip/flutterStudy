import 'dart:io';

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

  ///选择文件类型图片
  String selectIcon(String ext) {
    String iconImg = 'assets/images/unknown.png';

    switch (ext) {
      case '.ppt':
      case '.pptx':
        iconImg = 'assets/images/ppt.png';
        break;
      case '.doc':
      case '.docx':
        iconImg = 'assets/images/word.png';
        break;
      case '.xls':
      case '.xlsx':
        iconImg = 'assets/images/excel.png';
        break;
      case '.jpg':
      case '.jpeg':
      case '.png':
        iconImg = 'assets/images/image.png';
        break;
      case '.txt':
        iconImg = 'assets/images/txt.png';
        break;
      case '.mp3':
        iconImg = 'assets/images/mp3.png';
        break;
      case '.mp4':
        iconImg = 'assets/images/video.png';
        break;
      case '.rar':
      case '.zip':
        iconImg = 'assets/images/zip.png';
        break;
      case '.psd':
        iconImg = 'assets/images/psd.png';
        break;
      default:
        iconImg = 'assets/images/file.png';
        break;
    }
    return iconImg;
  }

  Future<void> getPermission() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
    }
  }

  Future<void> getSDCardDir() async {
    rootPath = (await getExternalStorageDirectory()).path;
  }
}
