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
                return ListTile(
                  leading: Icon(item.value.type == 'dir' ? Icons.folder : Icons.insert_drive_file),
                  title: Text(item.key),
                  onTap: () {
                    if (item.value.type == 'dir') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Directory(path: path + '/' + item.key)),
                      );
                    }
                  },
                );
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
