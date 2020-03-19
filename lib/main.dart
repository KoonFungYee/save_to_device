import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:logger/logger.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FileDownloadView(),
    );
  }
}

class FileDownloadView extends StatefulWidget {
  @override
  _FileDownloadViewState createState() => _FileDownloadViewState();
}

class _FileDownloadViewState extends State<FileDownloadView> {
  String _filePath = "";

  Future<String> get _localDevicePath async {
    final _devicePath = await getApplicationDocumentsDirectory();
    return _devicePath.path;
  }

  Future<File> _localFile({String path, String type}) async {
    String _path = await _localDevicePath;

    var _newPath = await Directory("$_path/$path").create();
    return File("${_newPath.path}/name.$type");
  }

  Future _downloadSampleVCard() async {
    final _response =
        await http.get("https://vvinoa.vvin.com/vcard/kclau");
    if (_response.statusCode == 200) {
      final _file = await _localFile(path: "vcard", type: "html");
      final _saveFile = await _file.writeAsBytes(_response.bodyBytes);
      Logger().i("File write complete. File Path ${_saveFile.path}");
      setState(() {
        _filePath = _saveFile.path;
      });
    } else {
      Logger().e(_response.statusCode);
    }
  }

  Future _downloadSamplePDF() async {
    final _response =
        await http.get("http://www.africau.edu/images/default/sample.pdf");
    if (_response.statusCode == 200) {
      final _file = await _localFile(path: "pdf", type: "pdf");
      final _saveFile = await _file.writeAsBytes(_response.bodyBytes);
      Logger().i("File write complete. File Path ${_saveFile.path}");
      setState(() {
        _filePath = _saveFile.path;
      });
    } else {
      Logger().e(_response.statusCode);
    }
  }

  Future _downloadSampleVideo() async {
    final _response = await http.get(
        "https://sample-videos.com/video123/mp4/720/big_buck_bunny_720p_2mb.mp4");
    if (_response.statusCode == 200) {
      final _file = await _localFile(path: "videos", type: "mp4");
      final _saveFile = await _file.writeAsBytes(_response.bodyBytes);
      // Logger().i("File write complete. File Path ${_saveFile.path}");
      setState(() {
        _filePath = _saveFile.path;
        print(_filePath);
      });
    } else {
      Logger().e(_response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.file_download),
              label: Text("Vcard with no connection"),
              onPressed: () {
                _downloadSampleVCard();
              },
            ),

            FlatButton.icon(
              icon: Icon(Icons.file_download),
              label: Text("Download PDF"),
              onPressed: () {
                _downloadSamplePDF();
              },
            ),
            
            FlatButton.icon(
              icon: Icon(Icons.file_download),
              label: Text("Sample Videos"),
              onPressed: () {
                _downloadSampleVideo();
              },
            ),
            Text(_filePath),
            
            FlatButton.icon(
              icon: Icon(Icons.shop_two),
              label: Text("Show VCard"),
              onPressed: () async {
                final _openFile = await OpenFile.open("/data/user/0/com.example.openfile/app_flutter/vcard/name.html");
                Logger().i(_openFile);
              },
            ),

            FlatButton.icon(
              icon: Icon(Icons.shop_two),
              label: Text("Show PDF"),
              onPressed: () async {
                final _openFile = await OpenFile.open("/data/user/0/com.example.openfile/app_flutter/pdf/name.pdf");
                Logger().i(_openFile);
              },
            ),

            FlatButton.icon(
              icon: Icon(Icons.shop_two),
              label: Text("Show Video"),
              onPressed: () async {
                final _openFile = await OpenFile.open("/data/user/0/com.example.openfile/app_flutter/videos/name.mp4");
                Logger().i(_openFile);
              },
            ),
          ],
        ),
      ),
    );
  }
}