import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:familog/domain/diary.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

class DiaryEntryForm extends StatefulWidget {
  const DiaryEntryForm({ Key key, this.currentDiary }): super(key: key);

  final Diary currentDiary;

  @override
  State<StatefulWidget> createState() {
    return new _DiaryEntryFormState();
  }
}

final auth = FirebaseAuth.instance;

class _DiaryEntryFormState extends State<DiaryEntryForm> {
  final scaffoldKey = new GlobalKey<ScaffoldState>();

  String _body;
  String _emoji;
  File _imageFile1;
  File _imageFile2;
  File _imageFile3;

  void _onChangeBody(String body) {
    setState(() {
      this._body = body;
    });
  }

  void _onPressedSad() {
    setState(() {
      this._emoji = "sad";
    });
  }

  void _onPressedTired() {
    setState(() {
      this._emoji = "tired";
    });
  }

  void _onPressedHappy() {
    setState(() {
      this._emoji = "happy";
    });
  }

  void _getImage1() async {
    var _fileName = await ImagePicker.pickImage();
    setState(() {
      _imageFile1 = _fileName;
    });
  }

  void _getImage2() async {
    var _fileName = await ImagePicker.pickImage();
    setState(() {
      _imageFile2 = _fileName;
    });
  }

  void _getImage3() async {
    var _fileName = await ImagePicker.pickImage();
    setState(() {
      _imageFile3 = _fileName;
    });
  }

  void _deleteImage1() async {
    setState(() {
      _imageFile1 = null;
    });
  }

  void _deleteImage2() async {
    setState(() {
      _imageFile2 = null;
    });
  }

  void _deleteImage3() async {
    setState(() {
      _imageFile3 = null;
    });
  }

  Future<String> _uploadFile(File file) async {
    if(file == null) return null;
    final String rand = "${new Random().nextInt(10000)}";
    final StorageReference ref = FirebaseStorage.instance.ref()
        .child("/diaries/${widget.currentDiary.id}/diary_entry_images/$rand${extension(file.path)}");
    final StorageUploadTask uploadTask = ref.put(file);
    return (await uploadTask.future).downloadUrl.toString();
  }

  void _handlePublish(BuildContext context) async {
    var currentUser = await auth.currentUser();
    List<String> imageUrls = [];
    imageUrls.add(await _uploadFile(_imageFile1));
    imageUrls.add(await _uploadFile(_imageFile2));
    imageUrls.add(await _uploadFile(_imageFile3));
    Firestore.instance.collection('diaries/${widget.currentDiary.id}/diary_entries').document()
        .setData({
      'body': _body,
      'emoji': _emoji,
      'authorId': currentUser.uid,
      'images': imageUrls.where((url) { return url != null; } ).toList(),
      'wroteAt': DateTime.now(),
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text("日記を投稿"),
      ),
      body: new ListView(
        children: <Widget>[
          new ListTile(
            title: new Text("本文"),
          ),
          new TextField(
            decoration: const InputDecoration(
                hintText: '本文を入力してください',
                filled: true,
                fillColor: Colors.white
            ),
            maxLines: 10,
            onChanged: _onChangeBody,
          ),
          new ListTile(
            title: new Text("今日の気分"),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new RaisedButton.icon(
                icon: const Text('😁'),
                label: const Text('楽しい'),
                onPressed: _emoji == "happy" ? null : this._onPressedHappy,
                color: Colors.white,
              ),
              new RaisedButton.icon(
                color: Colors.white,
                icon: const Text('😩'),
                label: const Text('疲れた'),
                onPressed: _emoji == "tired" ? null : this._onPressedTired,
              ),
              new RaisedButton.icon(
                color: Colors.white,
                icon: const Text('😥'),
                label: const Text('悲しい'),
                onPressed: _emoji == "sad" ? null : this._onPressedSad,
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
                          onPressed: _getImage1
                      ): new Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Image.file(_imageFile1, fit: BoxFit.contain),
                          new IconButton(
                            alignment: new Alignment(1.5, -1.0),
                            icon: new Icon(Icons.close, color: Colors.grey),
                            onPressed: _deleteImage1,
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
                          onPressed: _getImage2
                      ): new Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Image.file(_imageFile2, fit: BoxFit.contain),
                          new IconButton(
                            alignment: new Alignment(1.5, -1.0),
                            icon: new Icon(Icons.close, color: Colors.grey),
                            onPressed: _deleteImage2,
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
                          onPressed: _getImage3
                      ): new Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Image.file(_imageFile3, fit: BoxFit.contain),
                          new IconButton(
                            alignment: new Alignment(1.5, -1.0),
                            icon: new Icon(Icons.close, color: Colors.grey),
                            onPressed: _deleteImage3,
                          )
                        ],
                      )
                  )
              ),
            ],
          ),
//          new Container(
//            padding: const EdgeInsets.all(20.0),
//            child: new RaisedButton(onPressed: (){}, child: new Text("下書き")),
//          ),
          new Container(
            padding: const EdgeInsets.only(left: 20.0, top: 0.0, right: 20.0, bottom: 20.0),
            child: new RaisedButton(onPressed: () {_handlePublish(context);}, child: new Text("公開"), color: Theme.of(context).accentColor,textColor: Colors.white,),
          ),
        ],
      ),
    );
  }
}
