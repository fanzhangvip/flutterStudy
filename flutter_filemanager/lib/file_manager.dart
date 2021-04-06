import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_filemanager/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:my_flutter_plugin/my_flutter_plugin.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart' as path;

class FileManager extends StatefulWidget {
  @override
  _FileManagerState createState() => _FileManagerState();
}

class _FileManagerState extends State<FileManager> {
  List<FileSystemEntity> _currentFiles = []; //保存当前路径下的文件夹与文件
  Directory _currentDir; //当前路径
  List<double> _position = [];
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _getCurrentPathFiles(FileUtils.instance.rootPath);
  }

  Future<bool> _onWillPop() async {
    print('_onwillPop()');
    if (_currentDir?.path != FileUtils.instance.rootPath) {
      _getCurrentPathFiles(_currentDir.parent.path);
      _onGotoPosition(false);
    } else {
      SystemNavigator.pop();
    }
    return false;
  }

  void _onItemClick(int position) {
    // Fluttertoast.showToast(
    //     msg:
    //         'controller.offset: ${_controller.offset}, fileName: ${_currentFiles[position].path}, -> position: $position');
    //使用自定义的Toast
    MyFlutterPlugin.showToast(msg: 'fileName: ${_currentFiles[position].path}');
    //记录这个offset
    _position.add(_controller.offset);
    //获取下一级目录和文件
    _getCurrentPathFiles(_currentFiles[position].path);
    //进入下一级
    _onGotoPosition(true);
  }

  void _onGotoPosition(bool isEnter) async {
    if (isEnter) {
      _controller.jumpTo(0);
    } else {
      try {
        await Future.delayed(Duration(milliseconds: 1));
        var index = _position[_position.length - 1];
        print('length: ${_position.length}, index=$index,  => $_position');
        _controller?.jumpTo(index); //返回进入的位置
      } catch (e) {}
      _position.removeLast();
    }
  }

  @override
  Widget build(BuildContext context) {
    var root = FileUtils.instance.rootPath;
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              //判断是不是根目录
              _currentDir?.path == root
                  ? 'SD Card'
                  : path.basename(_currentDir?.path),
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 1.0,
            leading: _currentDir?.path == root
                ? Container()
                : IconButton(
                    icon: Icon(
                      Icons.chevron_left,
                      color: Colors.black,
                    ),
                    onPressed: _onWillPop),
          ),
          body: _currentFiles.length == 0
              ? Center(
                  child: Text('This is empty'),
                )
              : Scrollbar(
                  child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: _controller,
                      itemCount: _currentFiles.length,
                      itemBuilder: (BuildContext context, int index) {
                        if (FileSystemEntity.isFileSync(
                            _currentFiles[index].path)) {
                          return _buildFileItem(index);
                        } else {
                          return _buildFolderItem(index);
                        }
                      })),
        ),
        onWillPop: _onWillPop);
  }

  Widget _buildFileItem(int position) {
    var file = _currentFiles[position];
    String modifiedTime = DateFormat('yyyy-MM-dd HH:mm:ss', 'zh_CN')
        .format(file.statSync().modified.toLocal());
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.lightBlueAccent))),
        child: ListTile(
          title: Text(file.path.substring(file.parent.path.length + 1)),
          subtitle: Text(
            '$modifiedTime ${FileUtils.instance.getFileSize(file.statSync().size)}',
            style: TextStyle(fontSize: 12.0),
          ),
        ),
      ),
      onTap: () {
        // _onItemClick(position);
        OpenFile.open(file.path);
      },
    );
  }

  Widget _buildFolderItem(int position) {
    var file = _currentFiles[position];
    String modifiedTime = DateFormat('yyyy-MM-dd HH:mm:ss', 'zh_CN')
        .format(file.statSync().modified.toLocal());
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.lightBlueAccent))),
        child: ListTile(
          title: Text(file.path.substring(file.parent.path.length + 1)),
          subtitle: Text(
            '$modifiedTime  共计:${(file as Directory).listSync().length}项',
            style: TextStyle(fontSize: 12.0),
          ),
          trailing: Icon(Icons.chevron_right),
        ),
      ),
      onTap: () {
        //进入下一级目录
        _onItemClick(position);
      },
    );
  }

  void _getCurrentPathFiles(String path) {
    try {
      _currentDir = Directory(path);
      List<FileSystemEntity> _files = [];
      List<FileSystemEntity> _folder = [];
      //遍历当前目录下所以的文件与子目录
      for (var f in _currentDir.listSync()) {
        print('f = ${f.path}');
        if (FileSystemEntity.isFileSync(f.path)) {
          _files.add(f);
        } else {
          _folder.add(f);
        }
      }
      //给文件目录排序
      _files
          .sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));
      _folder
          .sort((a, b) => a.path.toLowerCase().compareTo(b.path.toLowerCase()));
      setState(() {
        _currentFiles.clear();
        _currentFiles.addAll(_folder);
        _currentFiles.addAll(_files);
      });
    } catch (e) {
      print(e);
    }
  }
}
