import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:github_flutter/access_token.dart';
import 'package:github_flutter/model/event.dart';
import 'package:github_flutter/model/user.dart';
import 'package:http/http.dart' as http;

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: new FutureBuilder(future: new Future(() async {
        var token = await AccessToken.getInstance().getOrCreate();
        var user = await fetchUser(token);
        return await fetchEvents(user, token);
      }), builder: (BuildContext context, AsyncSnapshot<EventList> feedState) {
        if (feedState.error != null) {
          // TODO: error handling
        }
        if (feedState.data == null) {
          return new Center(child: new CircularProgressIndicator());
        }
        return new MyHomePage(title: 'GitHub Events', events: feedState.data);
      }),
    );
  }

  Future<User> fetchUser(String token) async {
    var userResponse =
        await http.get('https://api.github.com/user?access_token=' + token);
    return new User.fromJson(json.decode(userResponse.body));
  }

  Future<EventList> fetchEvents(User user, String token) async {
    var response = await http.get('https://api.github.com/users/${user
        .login}/events?access_token=' +
        token);
    print(response.body);
    final responseJson = json.decode(response.body);
    return new EventList.fromJson(responseJson);
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.events}) : super(key: key);

  final String title;
  final EventList events;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _incrementCounter() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var notifiationList = widget.events.events;
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: new ListView.builder(
            itemCount: notifiationList.length,
            itemBuilder: (context, index) {
              return new ListTile(
                onTap: _launchURL(notifiationList[index]
                    .url
                    .replaceFirst("api.github.com/repos", "github.com")),
                title: new Text('${notifiationList[index]
                    .repoFullName} : ${notifiationList[index].type}'),
              );
            }),
        floatingActionButton: new FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: new Icon(Icons.add),
        ));
  }

  _launchURL(String url) {
    return () async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not launch $url';
      }
    };
  }
}
