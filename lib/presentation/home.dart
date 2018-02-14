import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';

typedef increment = void Function();


class Home extends StatelessWidget {
  Home(int counter, increment incrementCounter) {
    this._incrementCounter = incrementCounter;
    this._counter = counter;
  }

  increment _incrementCounter;
  int _counter;
  
  Widget _buildNotLoggedIn(BuildContext context) {
    return new Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: new Column(
        // Column is also layout widget. It takes a list of children and
        // arranges them vertically. By default, it sizes itself to fit its
        // children horizontally, and tries to be as tall as its parent.
        //
        // Invoke "debug paint" (press "p" in the console where you ran
        // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
        // window in IntelliJ) to see the wireframe for each widget.
        //
        // Column has various properties to control how it sizes itself and
        // how it positions its children. Here we use mainAxisAlignment to
        // center the children vertically; the main axis here is the vertical
        // axis because Columns are vertical (the cross axis would be
        // horizontal).
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
            padding: const EdgeInsets.all(20.0),
            child: new RaisedButton(onPressed: _incrementCounter, child: new Text("家族を招待する")),
          ),
          new Container(
            padding: const EdgeInsets.all(20.0),
            child: new RaisedButton(onPressed: _incrementCounter, child: new Text("日記を始める")),
          ),
          new Text(
            'You have pushed the button this many times:',
          ),
          new Text(
            '$_counter',
            style: Theme.of(context).textTheme.display1,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(false) return _buildNotLoggedIn(context);
    String sampleUri = "http://benesse.jp/kosodate/201709/img/KJ_20170908_02.jpg";// "https://www.photolibrary.jp/mhd6/img222/450-20110922175418165134.jpg";
    return new ListView(
      children: <Widget>[
        new Card(
          child: new Container(
            child: new Row(
              children: <Widget>[
                new Image.network(sampleUri, height: 100.0, width: 100.0, fit: BoxFit.cover),
                new Expanded(
                    child:  new Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Container(
                          child: new Text('2018/2/11 すーさんの日記☺', softWrap: true, style: new TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 16.0
                          ),),
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        ),
                        new Container(
                          child: new Text('今日はしほはじーじ・ばーばの家にいって楽しそうだった。このテキストはダミーですこのテキストはダミーですこのテキストはダミーです今日はしほはじーじ・ばーばの家にいって楽しそうだった。このテキストはダミーですこのテキストはダミーですこのテキストはダミーです今日はしほはじーじ・ばーばの家にいって楽しそうだった。このテキストはダミーですこのテキストはダミーですこのテキストはダミーです',
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                            style: new TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87
                            ),
                          ),
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                        )
                      ],
                    )
                )
              ],
            ),
//            child: <Widget>[
//              new ListTile(
//                leading: new CircleAvatar(
//                  backgroundImage: new NetworkImage(sampleUri),
//                ),
//                title: const Text('2018/2/11 すーさんの日記☺'),
//                subtitle: const Text('今日はしほはじーじ・ばーばの家にいって楽しそうだった。このテキストはダミーですこのテキストはダミーですこのテキストはダミーです'),
//                isThreeLine: true,
//              ),
//            ],
          ),
        ),
        new Card(
          child: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const ListTile(
                title: const Text('2018/2/11 すーさんの日記☺'),
                subtitle: const Text('今日はしほはじーじ・ばーばの家にいって楽しそうだった。このテキストはダミーですこのテキストはダミーですこのテキストはダミーです'),
                isThreeLine: true,
              ),
            ],
          ),
        )
      ],
    );
  }
}