import 'package:flutter/material.dart';
import 'remote_list.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(RemFSDelverApp());
}


class RemFS {
  final String type;
  final List<RemFS> children;

  RemFS({this.type, this.children});
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
  int _counter = 0;

  //void _incrementCounter() {
  //  setState(() {
  //    _counter++;
  //  });
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the RemFSDelver object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RemoteList(
          ),
          RaisedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddRemote()),
              );
            },
            child: Text("Add Remote"),
          ),
          //Text(
          //  'You have pushed the button this many times:',
          //),
          //Text(
          //  '$_counter',
          //  style: Theme.of(context).textTheme.headline4,
          //),
        ],
      ),
      //floatingActionButton: FloatingActionButton(
      //  onPressed: _incrementCounter,
      //  tooltip: 'Increment',
      //  child: Icon(Icons.add),
      //),
    );
  }
}

class AddRemote extends StatefulWidget {
  @override
  _AddRemoteState createState() => _AddRemoteState();
}

class _AddRemoteState extends State<AddRemote> {

  //Future<RemFS> futureRemfs;

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
                  print("public: " + textController.text);

                  final remfsUrl = textController.text + "/remfs.json";

                  http.get(remfsUrl)
                    .then((response) {
                      if (response.statusCode != 200) {
                        print("No public goods");
                      }
                      else {
                        print(response.body);
                      }
                    },
                    onError: (e) {
                      print("oops");
                    });
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
