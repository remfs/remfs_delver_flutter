import 'package:flutter/material.dart';
import 'directory.dart';

class Remote {
}

class RemoteList extends StatefulWidget {

  RemoteList({this.remotes});

  final Map<String, Remote> remotes;

  @override
  _RemoteListState createState() => _RemoteListState();
}

class _RemoteListState extends State<RemoteList> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: widget.remotes.entries.map((entry) {
        return ListTile(
          leading: Icon(Icons.storage),
          title: Text(entry.key),
          onTap: () {
            print(entry.key);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Directory(path: entry.key)),
            );
          },
        );
      }).toList(),
    );
  }
}
