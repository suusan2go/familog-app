import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DiaryEntry extends StatefulWidget {
  DiaryEntry(String title): title = title;

  final String title;

  @override
  State<StatefulWidget> createState() {
    return new _DiaryEntryState();
  }
}

class _DiaryEntryState extends State<DiaryEntry> {

  PageController pageController;
  int page = 0;

  @override
  void initState() {
    super.initState();
    pageController = new PageController();
  }


  void onTap(int index) {
    pageController.animateToPage(
        index, duration: const Duration(milliseconds: 300),
        curve: Curves.ease);
  }

  void onPageChanged(int page) {
    setState(() {
      this.page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    String sampleUri = "http://benesse.jp/kosodate/201709/img/KJ_20170908_02.jpg";// "https://www.photolibrary.jp/mhd6/img222/450-20110922175418165134.jpg";
    return new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text('2018/2/11  by すーさん'),
        ),
        body: new ListView(
            children: <Widget>[
              new Container(
                  height: 200.0,
                  color: Colors.black12,
                  child: new PageView(
                      children: [
                        new Image.network(sampleUri, height: 100.0, width: 100.0, fit: BoxFit.contain),
                        new Container(color: Colors.blue),
                        new Container(color: Colors.grey)
                      ],
                      controller: pageController,
                      onPageChanged: onPageChanged
                  )
              ),
              new Container(
                child: new Text('2018/2/11 すーさんの日記☺', softWrap: true, style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0
                ),),
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
              ),
              new Container(
                child: new Text("今日はしほはじーじ・ばーばの家にいって楽しそうだった。\n"
                    'このテキストはダミーですこのテキストはダミーですこのテキストはダミーです'
                    '今日はしほはじーじ・ばーばの家にいって楽しそうだった。このテキストはダミーですこのテキストはダミーですこのテキストはダミーです今日はしほはじーじ・ばーばの家にいって楽しそうだった。このテキストはダミーですこのテキストはダミーですこのテキストはダミーです',
                  softWrap: true,
                  style: new TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87
                  ),
                ),
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              )
            ],
        ),
    );
  }
}
