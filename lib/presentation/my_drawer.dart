import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyDrawer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final List<Widget> lists = <Widget>[
      new ListTile(
          title: new Text("日記を書く"),
          onTap: () {
            Navigator.of(context).pop(); // Hide drawer
          }),
      new ListTile(
          title: new Text("ユーザー設定"),
          onTap: () {
            Navigator.of(context).pop(); // Hide drawer
          }),
      new ListTile(
          title: new Text("利用規約"),
          onTap: () {
            Navigator.of(context).pop(); // Hide drawer
          }),
    ];

    return new Drawer(
      child: new Column(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text("suusan2go"),
            accountEmail: new Text("ksuzuki180@gmail.com"),
            currentAccountPicture: new CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: new NetworkImage("https://avatars1.githubusercontent.com/u/8841470?s=460&v=4")
            ),
//              decoration: new BoxDecoration(
//                image: new DecorationImage(
//                  image: new AssetImage(
//                    imgHeader,
//                  ),
//                  fit: BoxFit.cover,
//                ),
//              ),
            margin: EdgeInsets.zero,
          ),
          new MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: new Expanded(
              child: new ListView(
                padding: const EdgeInsets.only(top: 8.0),
                children: <Widget>[
                  new Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: lists,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}