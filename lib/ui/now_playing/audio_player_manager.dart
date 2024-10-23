import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart';

class AudioPlayerManager {
  AudioPlayerManager({required this.songUrl});
  final player = AudioPlayer();
  Stream<DurationState>? durationState;
  String songUrl;

  void init() {
    durationState = Rx.combineLatest2<Duration, PlaybackEvent, DurationState>(
        player.positionStream,
        player.playbackEventStream,
        (position, PlaybackEvent) => DurationState(
            progress: position,
            buffered: PlaybackEvent.bufferedPosition,
            total: PlaybackEvent.duration));
    player.setUrl(songUrl);
  }
}

class DurationState {
  const DurationState({
    required this.progress,
    required this.buffered,
    this.total,
  });
  final Duration progress;
  final Duration buffered;
  final Duration? total;
}