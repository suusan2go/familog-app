import 'dart:async';

import 'package:familog/domain/diary_entry.dart';
import 'package:familog/domain/diary_entry_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:familog/presentation/diary_entry_detail.dart';

typedef increment = void Function();

class Home extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return new _HomeState();
  }
}

class _HomeState extends State<Home> {

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
    final Completer<Null> completer = new Completer<Null>();
    new Timer(const Duration(seconds: 1), () { completer.complete(null); });
    return completer.future.then((_) {
      setState(() {
        this._entries.insertAll(0, repository.findAll());
      });
    });
  }

  Widget _buildNotLoggedIn(BuildContext context) {
    return new Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text(
            'You have pushed the button this many times:',
          ),
        ],
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    var entry = this._entries[index];
    return new DiaryEntryItem(entry);
  }

  @override
  Widget build(BuildContext context) {
    if(false) return _buildNotLoggedIn(context);
    return new RefreshIndicator(
        onRefresh: _onRefresh,
        child: new Scrollbar(
          child: new ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: _itemBuilder,
            itemCount: _entries.length,
            controller: _controller,
          )
        )
    );
  }
}

class DiaryEntryItem extends StatelessWidget {
  DiaryEntryItem(DiaryEntry diaryEntry): diaryEntry = diaryEntry;

  final DiaryEntry diaryEntry;

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new InkWell(
        onTap: () {
          Navigator.of(context).push(new MaterialPageRoute(
            builder: (context) => new DiaryEntryDetail("日記ですよ！", 1),
          ));
        },
        child: new Row(
          children: <Widget>[
            new Image.network(diaryEntry.images.first.url, height: 100.0, width: 100.0, fit: BoxFit.cover),
            new Expanded(
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      child: new Text(diaryEntry.title(), softWrap: true, style: new TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 16.0
                      ),),
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    ),
                    new Container(
                      child: new Text(diaryEntry.body,
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
    );
  }
}
