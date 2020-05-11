import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'remfs.dart';


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
                  FileListItem(name: item.key, remfs: item.value);
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
    return ListTile(
      leading: Icon(Icons.folder),
      title: Text(name),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Directory(path: path + '/' + name)),
        );
      }
    );
  }
}


class FileListItem extends StatelessWidget {

  final String name;
  final RemFS remfs;

  FileListItem({this.name, this.remfs});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.insert_drive_file),
      title: Text(name),
      onTap: () {
        print("file item");
      },
    );
  }
}
