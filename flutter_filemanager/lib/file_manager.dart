import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FileManager extends StatefulWidget {
  @override
  _FileManagerState createState() => _FileManagerState();
}

class _FileManagerState extends State<FileManager> {
  List<String> _currentFiles = []; //保存当前路径下的文件夹与文件
  List<int> _position = [];
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _getCurrentPathFiles('');
  }

  Future<bool> _onWillPop() {
    print('_onwillPop()');
  }

  void _onItemClick(String fileName, int position) {
    Fluttertoast.showToast(msg: 'fileName: $fileName, -> position: $position');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              'SD Card',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
            elevation: 0.0,
            leading: IconButton(
                icon: Icon(
                  Icons.chevron_left,
                  color: Colors.black,
                ),
                onPressed: _onWillPop),
          ),
          body: Scrollbar(
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: _controller,
                  itemCount: _currentFiles.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildFileItem(_currentFiles[index], index);
                  })),
        ),
        onWillPop: _onWillPop);
  }

  Widget _buildFileItem(String fileName, int position) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(width: 0.5, color: Colors.lightBlueAccent))),
        child: ListTile(
          title: Text(fileName),
        ),
      ),
      onTap: () {
        _onItemClick(fileName, position);
      },
    );
  }

  void _getCurrentPathFiles(String path) {
    for (int i = 0; i < 100; i++) {
      _currentFiles.add('文件目录：$i');
    }
  }
}
