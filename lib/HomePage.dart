import 'package:flutter/material.dart';
import 'package:fluttery_audio/fluttery_audio.dart';
import 'package:music_player_final/Waves.dart';
import 'package:music_player_final/localSongsList.dart';
import 'package:music_player_final/onlineMusic.dart';
import 'dart:math';
import 'dart:ui';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return new AudioPlaylist(
      playlist: demoPlaylist.songs.map((DemoSong song) {
        return song.audioUrl;
      }).toList(growable: false),
      playbackState: PlaybackState.paused,
      child: new Scaffold(
        appBar: new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          actions: <Widget>[

            new RaisedButton(
              child: new Text('Load Local Songs'),
              color: Colors.blue,
              splashColor: Colors.red,
               elevation: 10.0,
              onPressed: () {
                setState(() {
                 var router = new MaterialPageRoute(builder:(BuildContext context)=>new localSongs());
                  Navigator.of(context).push(router);
                });
              },
            ),
          ],
        ),

        body: new Column(
          children: <Widget>[
            new AudioPlaylistComponent(
              playlistBuilder: (BuildContext context, Playlist playlist, Widget child) {
                String albumArtUrl = demoPlaylist.songs[playlist.activeIndex].albumArtUrl;
                return new Stack(
                  children: <Widget>[
                    new Center(
                      child: new Waves(),// digital effects around the song picture
                    ),
                    new Padding(
                        padding: const EdgeInsets.all(65.00),
                        child: new Center(
                          child: new Container(
                            width: 200.00,
                            height: 200.00,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    image: new NetworkImage(
                                        albumArtUrl),
                                    fit: BoxFit.contain,
                                    colorFilter: new ColorFilter.mode(
                                        Colors.black, BlendMode.softLight)
                                ) // Image
                            ),
                          ),
                        ) // Container,
                    ), // Padding
                  ],

                );
              },
            ),

            new Expanded(
              child: new DemoPage(),// double waves effect
            )
          ],
        ),
      ),
    );
  }
}
class VibesTween extends Tween<Wave> {
  VibesTween(Wave begin, Wave end) : super(begin: begin, end: end);

  @override
  Wave lerp(double t) => Wave.lerp(begin, end, t);
}
class WavesPainter extends CustomPainter {

  WavesPainter(Animation<Wave> animation)
      : animation = animation,
        super(repaint: animation);

  final Animation<Wave> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = new Paint();
    canvas.translate(size.width / 2, size.height / 2);

    canvas.save();

    final radius = size.width / 2;
    final chart = animation.value;

    for (final wave in chart.wave)  {

      paint.color = wave.color;
      canvas.drawLine(
        new Offset(0.0, -radius),
        new Offset(1.0, -radius - (wave.height * 30)),
        paint,
      );

      canvas.drawRect(
        new Rect.fromLTRB(
            0.00, -radius, 2.00, -radius - (wave.height * 15)
        ),
        paint,
      );
      canvas.rotate(2 * pi / chart.wave.length);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(WavesPainter old) => true;
}
class Waves extends StatefulWidget {
  final state = new WavesState();

  @override
  WavesState createState() => state;

  void changeWaves() {
    state.changeWave();
  }
}

class WavesState extends State<Waves> with TickerProviderStateMixin {
  static const size = const Size(100.0, 5.0);
  Random random = new Random();
  AnimationController animation;
  VibesTween tween;

  @override
  void initState() {
    super.initState();
    animation = new AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    tween = new VibesTween(
      new Wave.empty(size),
      new Wave.random(size, random),
    );
    animation.forward();
  }

  @override
  void dispose() {
    animation.dispose();
    super.dispose();
  }

  void changeWave() {
    setState(() {
      tween = new VibesTween(
        tween.evaluate(animation),
        new Wave.random(size, random),
      );
      animation.forward(from: 0.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return

      new Container(
        width: 330.00,
        height: 330.00,
        padding: const EdgeInsets.all(55.0),
        child: new CustomPaint(
          size: size,
          painter: new WavesPainter(tween.animate(animation)),
        ),
      );
  }
}
class Vibes {
  Vibes(this.height, this.color);

  final double height;
  final Color color;

  Vibes get collapsed => new Vibes(0.0, color);

  static Vibes lerp(Vibes begin, Vibes end, double t) {
    return new Vibes(
      lerpDouble(begin.height, end.height, t),
      Color.lerp(begin.color, end.color, t),
    );
  }
}
List colors = [Colors.green,Colors.blue,Colors.amberAccent];
int index=0;
class Wave {
  Wave(this.wave);

  factory Wave.empty(Size size) {
    return new Wave(<Vibes>[]);
  }

  factory Wave.random(Size size, Random random) {

    final waveLenght = 550;
    final bars = new List.generate(
      waveLenght,
          (i) =>
      new Vibes(
        random.nextDouble(),
        colors[random.nextInt(3)],
      ),
    );
    return new Wave(bars);
  }

  final List<Vibes> wave;

  static Wave lerp(Wave begin, Wave end, double t) {
    final waveLength = max(begin.wave.length, end.wave.length);
    final waves = new List.generate(
      waveLength,
          (i) =>
          Vibes.lerp(
            begin._getWaves(i) ?? end.wave[i].collapsed,
            end._getWaves(i) ?? begin.wave[i].collapsed,
            t,
          ),
    );
    return new Wave(waves);
  }

  Vibes _getWaves(int index) => (index < wave.length ? wave[index] : null);
}
class MaterialAccentColor extends ColorSwatch<int> {
  /// Creates a color swatch with a variety of shades appropriate for accent
  /// colors.
  const MaterialAccentColor(int primary, Map<int, Color> swatch) : super(primary, swatch);

  /// The lightest shade.
  Color get shade50 => this[50];

  /// The second lightest shade.
  Color get shade100 => this[100];

  /// The default shade.
  Color get shade200 => this[200];

  /// The second darkest shade.
  Color get shade400 => this[400];

  /// The darkest shade.
  Color get shade700 => this[700];
}

