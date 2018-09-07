import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter_radio/flutter_radio.dart';

class RadioState extends StatefulWidget {
  @override
  _RadioStateState createState() => _RadioStateState();
}

class _RadioStateState extends State<RadioState> {
  String url =
      "https://ia802708.us.archive.org/3/items/count_monte_cristo_0711_librivox/count_of_monte_cristo_001_dumas.mp3";
  @override
  void initState() {
    super.initState();
    audioStart();
  }
  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Audio Plugin Android'),
        ),
        body: new Center(
            child: Column(
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.play_circle_filled),
                  onPressed: () => FlutterRadio.play(url: url)
                ),
                FlatButton(
                  child: Icon(Icons.pause_circle_filled),
                  onPressed: () => FlutterRadio.playOrPause(url: url),
                )
              ],
            )),
      ),
    );
  }
}