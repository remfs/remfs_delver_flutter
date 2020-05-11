import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'remfs.dart';
import 'package:mime/mime.dart';


class Directory extends StatelessWidget {

  Directory({this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(path + '/'),
      ),
      body: FutureBuilder<http.Response>(
          future: http.get(path + '/remfs.json'),
          builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
            if (snapshot.hasData) {

              RemFS remfs = RemFS.fromJson(jsonDecode(snapshot.data.body));
              print(remfs);

              List<Widget> children = remfs.children.entries.map((item) {
                return item.value.type == 'dir' ?
                  DirectoryListItem(path: path, name: item.key, remfs: item.value)
                  :
                  FileListItem(path: path, name: item.key, remfs: item.value);
              }).toList();

              //return Text("Hi there");
              return ListView(
                children: children,
              );
            }
            else if (snapshot.hasError) {
              return Text("oopsy");
            }
            else {
              return Text(path);
            }
          },
      ),
    );
  }
}


class DirectoryListItem extends StatelessWidget {
  final String path;
  final String name;
  final RemFS remfs;

  DirectoryListItem({this.path, this.name, this.remfs});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(Icons.folder),
          ),
          Text(
            name,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Directory(path: path + '/' + name)),
        );
      },
    );
  }
}


class FileListItem extends StatelessWidget {

  final String path;
  final String name;
  final RemFS remfs;

  FileListItem({this.path, this.name, this.remfs});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(Icons.insert_drive_file),
          ),
          Text(
            name,
            style: TextStyle(
              fontSize: 20.0,
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FilePreview(path: path + '/' + name)),
        );
      },
    );
  }
}


class FilePreview extends StatelessWidget {

  FilePreview({this.path});

  final String path;

  @override
  Widget build(BuildContext context) {
    var body;

    var mime = lookupMimeType(path);

    if (mime == null || isTextFile(mime)) {
      body = FutureBuilder<http.Response>(
        future: http.get(path),
        builder: (BuildContext context, AsyncSnapshot<http.Response> snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.body);
          }
          else if (snapshot.hasError) {
            return Text("error");
          }
          else {
            return Text(path);
          }
        },
      );
    }
    else if (mime.startsWith("image/")) {
      body = Image.network(path);
    }
    else {
      body = Text("No preview available for mime type: " + mime);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(path + '/'),
      ),
      body: body,
    );
  }
}

bool isTextFile(String mime) {
  return mime.startsWith("text/") ||
    mime == "application/javascript" ||
    mime == "application/json";
}
