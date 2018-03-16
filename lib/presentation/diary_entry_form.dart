import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DiaryEntryForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _DiaryEntryFormState();
  }
}

class _DiaryEntryFormState extends State<DiaryEntryForm> {
  String body;

  void onChangeBody(String body) {
    this.body = body;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text("日記を投稿"),
      ),
      body: new Container(
        color: Colors.grey[100],
        child: new Column(
          children: <Widget>[
            new ListTile(
              title: new Text("本文"),
            ),
            new TextFormField(
              decoration: const InputDecoration(
                  hintText: '本文を入力してください',
                filled: true,
                fillColor: Colors.white
              ),
              maxLines: 10,
            ),
            new ListTile(
              title: new Text("今日の気分"),
            ),
          ],
        ),
      ),
    );
  }
}
