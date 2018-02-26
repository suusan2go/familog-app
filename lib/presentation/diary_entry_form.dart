import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DiaryEntryForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text("日記を編集"),
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            new Text("設定")
          ],
        ),
      ),
    );
  }
}
