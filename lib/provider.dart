import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

class MusicProvider with ChangeNotifier {
  Duration totalDuration = new Duration();
  Duration progress = new Duration();
  AudioPlayer advancedPlayer;
  AudioCache audioCache;
  // String currentTime = "00:00";
  // String completeTime = "00:00";
  AudioPlayerState audioPlayerState;

  void initPlayer() {
    advancedPlayer = new AudioPlayer();
    audioCache = new AudioCache(fixedPlayer: advancedPlayer);
    advancedPlayer.onAudioPositionChanged.listen((Duration position) {
      // currentTime = position.toString().split(".")[0];
      progress = position;
      notifyListeners();
    });

    advancedPlayer.onDurationChanged.listen((Duration duration) {
      // completeTime = duration.toString().split(".")[0];
      totalDuration = duration;
      notifyListeners();
    });
    advancedPlayer.onPlayerStateChanged.listen((AudioPlayerState s) {
      audioPlayerState = s;
      notifyListeners();
    });
  }

  void seekToSecond(int second) {
    Duration newDuration = Duration(seconds: second);

    advancedPlayer.seek(newDuration);
  }

  void _playAudio() async {
    await audioCache.play('disco.mp3');
    notifyListeners();
  }

  void _resumeAudio() async {
    await advancedPlayer.resume();
    notifyListeners();
  }

  void _pauseAudio() async {
    await advancedPlayer.pause();
    notifyListeners();
  }

  void _stopAudio() async {
    await advancedPlayer.stop();
    notifyListeners();
  }

  void handlePlaying() {
    switch (audioPlayerState) {
      case AudioPlayerState.STOPPED:
        _playAudio();
        break;
      case AudioPlayerState.PAUSED:
        _resumeAudio();
        break;
      case AudioPlayerState.PLAYING:
        _pauseAudio();
        break;
      case AudioPlayerState.COMPLETED:
        _playAudio();
        break;
      default:
        _playAudio();
    }
  }
}
