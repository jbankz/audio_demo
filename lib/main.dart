import 'package:audio_demo/provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef void OnError(Exception exception);

void main() {
  runApp(new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiProvider(providers: [
        ChangeNotifierProvider(create: (_) => MusicProvider()),
      ], child: LocalAudio())));
}

class LocalAudio extends StatefulWidget {
  @override
  _LocalAudio createState() => _LocalAudio();
}

class _LocalAudio extends State<LocalAudio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Colors.teal,
        title: Center(child: Text('LOCAL AUDIO')),
      ),
      body: MediaPlayer(),
    );
  }
}

class MediaPlayer extends StatefulWidget {
  @override
  _MediaPlayerState createState() => _MediaPlayerState();
}

class _MediaPlayerState extends State<MediaPlayer> {
  MusicProvider _musicProvider;
  double _value = 0.0;

  @override
  void initState() {
    _musicProvider = Provider.of<MusicProvider>(context, listen: false);
    _musicProvider.initPlayer();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MusicProvider>(
      builder: (_, provider, __) {
        return SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Container(
                  height: 150,
                  width: 150,
                  color: Colors.red,
                ),
                SizedBox(
                  height: 50,
                ),
                Text(
                  'Music Title Should be Here',
                  style: TextStyle(fontSize: 34),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${provider.progress.toString().split(".")[0]}',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    Slider(
                        activeColor: Colors.black,
                        inactiveColor: Colors.pink,
                        value: _musicProvider.progress.inSeconds.toDouble(),
                        min: 0.0,
                        max: _musicProvider.totalDuration.inSeconds.toDouble(),
                        onChanged: (double value) {
                          setState(() {
                            provider.seekToSecond(value.toInt());
                            _value = value;
                          });
                        }),
                    Text(
                      '${provider.totalDuration.toString().split(".")[0]}',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                        icon: Icon(
                          Icons.skip_previous_outlined,
                          size: 50,
                        ),
                        onPressed: () {}),
                    SizedBox(
                      width: 40,
                    ),
                    IconButton(
                        icon: Icon(
                          provider.audioPlayerState == AudioPlayerState.PLAYING
                              ? Icons.pause
                              : Icons.play_arrow,
                          size: 50,
                        ),
                        onPressed: () => _musicProvider.handlePlaying()),
                    SizedBox(
                      width: 40,
                    ),
                    IconButton(
                        icon: Icon(
                          Icons.skip_next,
                          size: 50,
                        ),
                        onPressed: () {}),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
