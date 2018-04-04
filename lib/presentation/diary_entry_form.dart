import 'dart:io';

import 'package:familog/domain/diary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DiaryEntryForm extends StatefulWidget {
  const DiaryEntryForm({ Key key, this.currentDiary }): super(key: key);

  final Diary currentDiary;

  @override
  State<StatefulWidget> createState() {
    return new _DiaryEntryFormState();
  }
}

class _DiaryEntryFormState extends State<DiaryEntryForm> {
  String _body;
  String _emoji;
  File _imageFile1;
  File _imageFile2;
  File _imageFile3;

  void onChangeBody(String body) {
    setState(() {
      this._body = body;
    });
  }

  void onPressedSad() {
    setState(() {
      this._emoji = "sad";
    });
  }

  void onPressedTired() {
    setState(() {
      this._emoji = "tired";
    });
  }

  void onPressedHappy() {
    setState(() {
      this._emoji = "happy";
    });
  }

  void getImage1() async {
    var _fileName = await ImagePicker.pickImage();
    setState(() {
      _imageFile1 = _fileName;
    });
  }

  void getImage2() async {
    var _fileName = await ImagePicker.pickImage();
    setState(() {
      _imageFile2 = _fileName;
    });
  }

  void getImage3() async {
    var _fileName = await ImagePicker.pickImage();
    setState(() {
      _imageFile3 = _fileName;
    });
  }

  void deleteImage1() async {
    setState(() {
      _imageFile1 = null;
    });
  }

  void deleteImage2() async {
    setState(() {
      _imageFile2 = null;
    });
  }

  void deleteImage3() async {
    setState(() {
      _imageFile3 = null;
    });
  }

  void _handlePublish() {
    Firestore.instance.collection('diaries/${widget.currentDiary.id}/diary_entries').document()
        .setData({ 'title': 'title', 'author': 'author' });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text("日記を投稿"),
      ),
      body: new ListView(
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
          new ButtonBar(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new RaisedButton.icon(
                icon: const Text('😁'),
                label: const Text('楽しい'),
                onPressed: _emoji == "happy" ? null : this.onPressedHappy,
                color: Colors.white,
              ),
              new RaisedButton.icon(
                color: Colors.white,
                icon: const Text('😩'),
                label: const Text('疲れた'),
                onPressed: _emoji == "tired" ? null : this.onPressedTired,
              ),
              new RaisedButton.icon(
                color: Colors.white,
                icon: const Text('😥'),
                label: const Text('悲しい'),
                onPressed: _emoji == "sad" ? null : this.onPressedSad,
              ),
            ],
          ),
          new ListTile(
            title: new Text("写真"),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                  child: new Container(
                      color: Colors.white,
                      padding: new EdgeInsets.only(left: 10.0, right: 10.0),
                      height: 100.0,
                      child: _imageFile1 == null ? new IconButton(
                          icon: new Icon(Icons.image, size: 80.0),
                          tooltip: 'Increase volume by 10%',
                          onPressed: getImage1
                      ): new Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Image.file(_imageFile1, fit: BoxFit.contain),
                          new IconButton(
                            alignment: new Alignment(1.5, -1.0),
                            icon: new Icon(Icons.close, color: Colors.grey),
                            onPressed: deleteImage1,
                          )
                        ],
                      )
                  )
              ),
              new Expanded(
                  child: new Container(
                      color: Colors.white,
                      padding: new EdgeInsets.only(left: 10.0, right: 10.0),
                      height: 100.0,
                      child: _imageFile2 == null ? new IconButton(
                          icon: new Icon(Icons.image, size: 80.0),
                          tooltip: 'Increase volume by 10%',
                          onPressed: getImage2
                      ): new Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Image.file(_imageFile2, fit: BoxFit.contain),
                          new IconButton(
                            alignment: new Alignment(1.5, -1.0),
                            icon: new Icon(Icons.close, color: Colors.grey),
                            onPressed: deleteImage2,
                          )
                        ],
                      )
                  )
              ),
              new Expanded(
                  child: new Container(
                      color: Colors.white,
                      padding: new EdgeInsets.only(left: 10.0, right: 10.0),
                      height: 100.0,
                      child: _imageFile3 == null ? new IconButton(
                          icon: new Icon(Icons.image, size: 80.0),
                          tooltip: 'Increase volume by 10%',
                          onPressed: getImage3
                      ): new Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Image.file(_imageFile3, fit: BoxFit.contain),
                          new IconButton(
                            alignment: new Alignment(1.5, -1.0),
                            icon: new Icon(Icons.close, color: Colors.grey),
                            onPressed: deleteImage3,
                          )
                        ],
                      )
                  )
              ),
            ],
          ),
          new Container(
            padding: const EdgeInsets.all(20.0),
            child: new RaisedButton(onPressed: (){}, child: new Text("下書き")),
          ),
          new Container(
            padding: const EdgeInsets.only(left: 20.0, top: 0.0, right: 20.0, bottom: 20.0),
            child: new RaisedButton(onPressed: _handlePublish, child: new Text("公開"), color: Theme.of(context).accentColor,textColor: Colors.white,),
          ),
        ],
      ),
    );
  }
}
