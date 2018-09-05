import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flute_music_player/flute_music_player.dart';
class localSongs extends StatefulWidget {
  @override
  _localSongsState createState() => _localSongsState();
}

class _localSongsState extends State<localSongs> {
  var songs;
  MusicFinder audioPlayer;
  List<Song> _songs;
  @override
  void initState(){
    super.initState();
    initPlayer();
  }
  Future _playLocal(String url ) async {
    final result = await audioPlayer.play(url, isLocal: true);
  }
  void initPlayer() async{
    audioPlayer = new MusicFinder();
    songs =  await MusicFinder.allSongs();
    print(songs.length);// to check the songs have been retrieved or not
    _songs = new List.from(songs);
    print(_songs.length); //another check to the songs have been retrieved or not

    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {
    Widget home(){
      return new Scaffold(
        appBar: new AppBar(title: new Text("Music App"),),
        body: new ListView.builder(itemBuilder: (context,int index){
          return new ListTile(
            leading: new CircleAvatar(
              child: new Text(_songs[index].title[0]),
            ),
            title: new Text(_songs[index].title),
            onTap: ()=>_playLocal(_songs[index].uri),
          );
        }, itemCount: _songs.length,),
      );
    }
    return new MaterialApp(
      home: home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
