import 'package:familog/domain/diary_entry.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';


class DotsIndicator extends AnimatedWidget {
  DotsIndicator({
    this.controller,
    this.itemCount,
    this.onPageSelected,
    this.color: Colors.white,
  }) : super(listenable: controller);

  /// The PageController that this DotsIndicator is representing.
  final PageController controller;

  /// The number of items managed by the PageController
  final int itemCount;

  /// Called when a dot is tapped
  final ValueChanged<int> onPageSelected;

  /// The color of the dots.
  ///
  /// Defaults to `Colors.white`.
  final Color color;

  // The base size of the dots
  static const double _kDotSize = 4.0;

  // The increase in the size of the selected dot
  static const double _kMaxZoom = 2.0;

  // The distance between the center of each dot
  static const double _kDotSpacing = 25.0;

  Widget _buildDot(int index) {
    double selectedness = Curves.easeOut.transform(
      max(
        0.0,
        1.0 - ((controller.page ?? controller.initialPage) - index).abs(),
      ),
    );
    double zoom = 1.0 + (_kMaxZoom - 1.0) * selectedness;
    return new Container(
      width: _kDotSpacing,
      child: new Center(
        child: new Material(
          color: color,
          type: MaterialType.circle,
          child: new Container(
            width: _kDotSize * zoom,
            height: _kDotSize * zoom,
            child: new InkWell(
              onTap: () => onPageSelected(index),
            ),
          ),
        ),
      ),
    );
  }

  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: new List<Widget>.generate(itemCount, _buildDot),
    );
  }
}

class DiaryEntryDetail extends StatefulWidget {
  DiaryEntryDetail(String diaryId, DiaryEntry diaryEntry): diaryId = diaryId, diaryEntry = diaryEntry;

  final String diaryId;
  final DiaryEntry diaryEntry;

  @override
  State<StatefulWidget> createState() {
    return new _DiaryEntryState();
  }
}

class _DiaryEntryState extends State<DiaryEntryDetail> {

  PageController pageController;
  int page = 0;

  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;

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

  String titleForAppBar(){
    return widget.diaryEntry.title();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: new Text(titleForAppBar()),
        ),
        body: widget.diaryEntry != null ? new ListView(
            children: <Widget>[
              new Container(
                  height: 200.0,
                  color: Colors.black12,
                  child:  new Stack(
                    children: <Widget>[
                      new PageView(
                          children: widget.diaryEntry.images.map((image) {
                            return new Image.network(image, height: 100.0, width: 100.0, fit: BoxFit.contain);
                          }).toList(),
                          controller: pageController,
                          onPageChanged: onPageChanged
                      ),
                      new Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: new Container(
                          padding: const EdgeInsets.all(10.0),
                          child: new Center(
                            child: new DotsIndicator(
                              controller: pageController,
                              itemCount: 3,
                              onPageSelected: (int page) {
                                pageController.animateToPage(
                                  page,
                                  duration: _kDuration,
                                  curve: _kCurve,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
              new Container(
                child: new Text(widget.diaryEntry.title(), softWrap: true, style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0
                ),),
                padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
              ),
              new Container(
                child: new Text(widget.diaryEntry.body,
                  softWrap: true,
                  style: new TextStyle(
                      fontSize: 16.0,
                      color: Colors.black87
                  ),
                ),
                padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              )
            ],
        ) : new ListView(),
    );
  }
}
