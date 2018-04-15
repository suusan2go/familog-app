import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:familog/domain/diary.dart';
import 'package:familog/domain/diary_entry.dart';
import 'package:familog/domain/diary_entry_author.dart';
import 'package:familog/domain/diary_entry_repository.dart';
import 'package:familog/presentation/diary_entry_form.dart';
import 'package:familog/presentation/my_drawer.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:familog/presentation/diary_entry_detail.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

typedef increment = void Function();

final googleSignIn = new GoogleSignIn();
final auth = FirebaseAuth.instance;
final analytics = new FirebaseAnalytics();

class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;
  @override
  State<StatefulWidget> createState() {
    return new _HomeState();
  }
}

class _HomeState extends State<Home> {
  FirebaseUser _user;
  Diary _currentDiary;
  DiaryEntryRepository repository;
  List<DiaryEntry> _entries;
  ScrollController _controller = new ScrollController();

  @override
  void initState() {
    super.initState();
    repository =new DiaryEntryRepository();
    _controller.addListener(this._loadMoreEntries);
    var entries = repository.findAll();
    setState(() {
      this._entries = entries;
    });
  }

  void _loadMoreEntries() {
    if(_controller.position.atEdge && _controller.position.pixels == _controller.position.maxScrollExtent) {
      setState(() {
        this._entries.addAll(repository.findAll());
      });
    }
  }

  Future<Null> _onRefresh() {
    var completer = new Completer<FirebaseUser>();
    new Timer(const Duration(seconds: 1), () { completer.complete(null); });
    return completer.future.then((_) {
      setState(() {
        this._entries.insertAll(0, repository.findAll());
      });
    });
  }

  Future<Null> _logIn() async {
    _ensureLoggedIn().then((user) async {
      var diaries = await Firestore.instance.collection('diaries').where("subscribers.${user.uid}", isEqualTo: true).getDocuments();
      if(diaries.documents.length == 0) {
        Firestore.instance.collection('diaries').document()
            .setData({
          'title': '${user.displayName}の日記',
          'subscribers': { user.uid: true}
        });
      }
      Firestore.instance.collection('users').document(user.uid)
          .setData({
        'name': user.displayName,
        'photoUrl': user.photoUrl,
      });
      var diaryRef = await Firestore.instance.collection('diaries').where("subscribers.${user.uid}", isEqualTo: true).getDocuments();
      var diaryDocument = diaryRef.documents.first;
      setState((){
        this._user = user;
        this._currentDiary = new Diary(diaryDocument.documentID, diaryDocument["title"]);
      });
    });
  }

  Future<FirebaseUser> _ensureLoggedIn() async {
    GoogleSignInAccount user = googleSignIn.currentUser;
    if (user == null)
      user = await googleSignIn.signInSilently();
    if (user == null) {
      await googleSignIn.signIn();
      analytics.logLogin();
    }
    if (await auth.currentUser() == null) {
      GoogleSignInAuthentication credentials = await googleSignIn.currentUser.authentication;
      await auth.signInWithGoogle(
        idToken: credentials.idToken,
        accessToken: credentials.accessToken,
      );
    }
    return await auth.currentUser();
  }

  Widget _buildNotLoggedIn(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new RaisedButton.icon(
              onPressed: _logIn,
              label: new Text("Googleアカウントでログイン", style: new TextStyle(fontSize: 18.0),),
              icon: new Icon(FontAwesomeIcons.google)
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: _user == null ? null : new MyDrawer(user: this._user,),
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title),
      ),
      body:
      _user == null ?  _buildNotLoggedIn(context): new RefreshIndicator(
          onRefresh: _onRefresh,
          child: new Scrollbar(
              child: new DiaryEntryStream(currentDiary: _currentDiary)
          )
      ),
      floatingActionButton: _user == null ? null : new FloatingActionButton(
        onPressed: (){
          Navigator.of(context).push(new MaterialPageRoute(
              builder: (context) => new DiaryEntryForm(currentDiary: this._currentDiary),
              fullscreenDialog: true
          ));
        },
        tooltip: 'Increment',
        child: new Icon(Icons.edit),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class DiaryEntryStream extends StatelessWidget {
  const DiaryEntryStream({ Key key, this.currentDiary }): super(key: key);
  final Diary currentDiary;

  @override
  Widget build(BuildContext context){
    return new StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('diaries/${this.currentDiary.id}/diary_entries').orderBy("wroteAt", descending: true).snapshots,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return new Text('Loading...');
        return new DiaryEntryList(documents: snapshot.data.documents, diary: this.currentDiary);
      },

    );
  }
}

class DiaryEntryList extends StatefulWidget {
  const DiaryEntryList({ Key key, this.documents, this.diary }): super(key: key);

  final List<DocumentSnapshot> documents;
  final Diary diary;

  @override
  DiaryEntryListState createState() {
    return new DiaryEntryListState();
  }
}

class DiaryEntryListState extends State<DiaryEntryList> {
  List<DiaryEntry> diaryEntries = [];

  @override
  initState() {
    super.initState();
    setDiaryEntries();
  }

  setDiaryEntries() async {
    if(widget.documents.length == this.diaryEntries.length) return;
    List<DiaryEntry> _entries = [];
    for(var document in widget.documents) {
      var userDocument = await Firestore.instance.document("users/${document.data["authorId"]}").get();
      var entry = new DiaryEntry(
          document.documentID,
          document.data["emoji"],
          document.data["body"],
          document.data["wroteAt"],
          (document.data["images"] as List<dynamic>).map((value){
            return value as String;
          }).toList(),
          new DiaryEntryAuthor(
            userDocument.documentID,
            userDocument.data["name"],
            userDocument.data["photoUrl"],
          )
      );
      _entries.add(entry);
    }
    setState(() {
      this.diaryEntries = _entries;
    });
  }

  @override
  Widget build(BuildContext context){
    setDiaryEntries();
    return new ListView(
      children: diaryEntries.map((diaryEntry) {
        return new DiaryEntryItem(entry: diaryEntry, diary: widget.diary);
      }).toList(),
    );
  }
}

class DiaryEntryItem extends StatelessWidget {
  const DiaryEntryItem({ Key key, this.diary, this.entry }): super(key: key);

  final Diary diary;
  final DiaryEntry entry;

  @override
  Widget build(BuildContext context) {

    return entry != null ? new Card(
      child: new InkWell(
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => new DiaryEntryDetail(diary.id, entry),
          ));
        },
        child: new Row(
          children: <Widget>[
            new Image.network(entry.primaryImageUrl(), height: 100.0, width: 100.0, fit: BoxFit.cover),
            new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      child: new Text(entry.title(), softWrap: true, style: new TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 16.0
                      ),),
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    ),
                    new Container(
                      child: new Text(entry.body,
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
      ),
    ): new Card();
  }
}
