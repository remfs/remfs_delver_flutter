import 'package:flutter/material.dart';
import 'remote_list.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(RemFSDelverApp());
}


class RemFSDelverApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'remFS delver',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: RemFSDelver(title: 'remFS Delver Home Page'),
    );
  }
}

class RemFSDelver extends StatefulWidget {
  RemFSDelver({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RemFSDelverState createState() => _RemFSDelverState();
}

class _RemFSDelverState extends State<RemFSDelver> {

  final Map<String, Remote> remotes = new Map();

  @override
  Widget build(BuildContext context) {

    print("build");

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          RemoteList(remotes: remotes),
          RaisedButton(
            onPressed: () async {
              final remoteUrl = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddRemote(remotes: remotes)),
              );

              if (remoteUrl != null) {
                setState(() {
                  remotes[remoteUrl] = new Remote();
                });
              }
            },
            child: Text("Add Remote"),
          ),
        ],
      ),
    );
  }
}

class AddRemote extends StatefulWidget {

  AddRemote({this.remotes});

  final Map<String, Remote> remotes;

  @override
  _AddRemoteState createState() => _AddRemoteState();
}

class _AddRemoteState extends State<AddRemote> {

  final textController = TextEditingController();

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Remote"),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            controller: textController,
            decoration: InputDecoration(
              hintText: 'Enter address of remote'
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              RaisedButton(
                child: Text("Login to Remote"),
                onPressed: () {
                  print("login: " + textController.text);
                },
                color: Colors.orange,
              ),
              SizedBox(width: 20),
              RaisedButton(
                child: Text("Access as Public"),
                onPressed: () {

                  final remoteUrl = textController.text;
                  final remfsUrl = remoteUrl + "/remfs.json";

                  if (!widget.remotes.containsKey(remoteUrl)) {
                    http.get(remfsUrl)
                      .then((response) {
                        if (response.statusCode != 200) {
                          print("No public goods");
                        }
                        else {
                          Navigator.pop(context, remoteUrl);
                        }
                      },
                      onError: (e) {
                        print("Error fetching " + remfsUrl);
                      });
                  }
                  else {
                    print(remoteUrl + " already exists");
                  }
                },
                color: Colors.orange,
              ),
            ]
          )
        ],
      ),
    );
  }
}
