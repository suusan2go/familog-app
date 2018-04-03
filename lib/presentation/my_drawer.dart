import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

final auth = FirebaseAuth.instance;

class Frog extends StatelessWidget {
  const Frog({
    Key key,
    this.color: const Color(0xFF2DBD3A),
    this.child,
  }) : super(key: key);

  final Color color;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return new Container(color: color, child: child);
  }
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({ Key key, this.user }): super(key: key);

  final FirebaseUser user;

  @override
  Widget build(BuildContext context) {
    final List<Widget> lists = <Widget>[];
    if(user != null)
      lists.add(
          new ListTile(
              title: new Text("ユーザー設定"),
              onTap: () {
                Navigator.of(context).pop(); // Hide drawer
                Navigator.of(context).pushNamed('/profile');
              })
      );
    lists.add(
      new ListTile(
          title: new Text("利用規約"),
          onTap: () {
            Navigator.of(context).pop(); // Hide drawer
          }),
    );

    return new Drawer(
      child: new Column(
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: user != null ? new Text(user.displayName) : null,
            accountEmail: user != null ? new Text(user.email) : null,
            currentAccountPicture: user !=null ? new CircleAvatar(
                backgroundColor: Colors.white,
                backgroundImage: new NetworkImage(user.photoUrl)
            ) : null,
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