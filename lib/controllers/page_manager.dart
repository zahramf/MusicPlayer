import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PageManager {
  final progressBarNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      total: Duration.zero,
      buffered: Duration.zero,
    ),
  );

  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);

  final currentSongDetailNotifier = ValueNotifier<AudioMetaData>(
    AudioMetaData(image: "", singerName: "", musicName: ""),
  );

  final playListNotifier = ValueNotifier<List<AudioMetaData>>([]);
  final isFirstSongNotifier = ValueNotifier<bool>(true);
  final isLastSongNotifier = ValueNotifier<bool>(true);
  final repeatNotifier = RepeatStateNotifier();
  final volumeNotifier = ValueNotifier<double>(1);

  late ConcatenatingAudioSource _playList;

  final AudioPlayer _audioPlayer;

  PageManager(this._audioPlayer) {
    _init();
  }

  void _init() async {
    _initialPlayList();
//hande button

    _listenChangePlayerState();

////handle progress bar

//current
    _listenChangePositionStream();

//buffer
    _listenChangeBufferedStream();

//total
    _listenChangeTotalDuration();

    _listenChangeToSequenceState();
  }

  void _initialPlayList() async {
    const prefix = "assets/images";

    final song1 = Uri.parse(
        'https://dl.musicsweb.ir/musics/02/02/Farzad%20Farzin%20-%20avaaher%20-%20128%20-%20musicsweb.ir.mp3');
    final song2 = Uri.parse(
        'https://files.musico.ir/siros/Mohsen%20Chavoshi%20-%20Rahayam%20Kon%20(320).mp3');
    final song3 = Uri.parse(
        'https://ups.music-fa.com/tagdl/1402/Behnam%20Bani%20-%20SagBand(320).mp3');
    final song4 = Uri.parse(
        'https://dls.music-fa.com/tagdl/99/Alireza%20Ghorbani%20-%20Khiale%20Khosh%20(128).mp3');

    _playList = ConcatenatingAudioSource(
      children: [
        AudioSource.uri(
          song1,
          tag: AudioMetaData(
              image: "$prefix/Mohsen-Chavoshi-Rahayam-Kon.jpeg",
              singerName: 'Mohsen Chavoshi',
              musicName: 'Rahayam kon'),
        ),
        AudioSource.uri(
          song2,
          tag: AudioMetaData(
            image: "$prefix/Farzad-Farzin-Javaher.jpg",
            singerName: 'Farzad Farzin',
            musicName: 'Javaher',
          ),

        ),
        AudioSource.uri(
          song3,
          tag: AudioMetaData(
              image: "$prefix/Behnnam-Bani-Sag-Band.jpg",
              singerName: 'Behnam Bani',
              musicName: 'SagBand'),
        ),
        AudioSource.uri(
          song4,
          tag: AudioMetaData(
              image: "$prefix/Khiale-khosh.png",
              singerName: 'Alireza Ghorbani',
              musicName: 'Khiale khosh'),
        ),
      ],
    );
    if (_audioPlayer.bufferedPosition == Duration.zero) {
      _audioPlayer.setAudioSource(_playList);
    }
  }

  void _listenChangePlayerState() {
    _audioPlayer.playerStateStream.listen((playerState) {
      final playing = playerState.playing;
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        buttonNotifier.value = ButtonState.loading;
      } //
      else if (!playing) {
        buttonNotifier.value = ButtonState.paused;
      } //
      else if (processingState == ProcessingState.completed) {
        _audioPlayer.stop();
      } else {
        buttonNotifier.value = ButtonState.playing;
      }
    });
  }

  void _listenChangePositionStream() {
    _audioPlayer.positionStream.listen((position) {
      final oldState = progressBarNotifier.value;
      progressBarNotifier.value = ProgressBarState(
        current: position,
        total: oldState.total,
        buffered: oldState.buffered,
      );
    });
  }

  void _listenChangeBufferedStream() {
    _audioPlayer.bufferedPositionStream.listen((position) {
      final oldState = progressBarNotifier.value;
      progressBarNotifier.value = ProgressBarState(
        current: oldState.current,
        total: oldState.total,
        buffered: position,
      );
    });
  }

  void _listenChangeTotalDuration() {
    _audioPlayer.durationStream.listen((position) {
      final oldState = progressBarNotifier.value;
      progressBarNotifier.value = ProgressBarState(
        current: oldState.current,
        total: position ?? Duration.zero,
        buffered: oldState.buffered,
      );
    });
  }

  void _listenChangeToSequenceState() {
    _audioPlayer.sequenceStateStream.listen((sequenceState) {
      if (sequenceState == null) {
        return;
      }
      //update current song
      final currentItem = sequenceState.currentSource;
      final song = currentItem!.tag as AudioMetaData;
      currentSongDetailNotifier.value = song;

      //update play list
      final playList = sequenceState.effectiveSequence;
      final music = playList.map((song) {
        return song.tag as AudioMetaData;
      }).toList();
      playListNotifier.value = music;

      //update previous and next music
      if (playList.isEmpty || currentItem == null) {
        isFirstSongNotifier.value = true;
        isLastSongNotifier.value = true;
      } //
      else {
        isFirstSongNotifier.value = playList.first == currentItem;
        isLastSongNotifier.value = playList.last == currentItem;
      }

      //update volume
      if (_audioPlayer.volume != 0) {
        volumeNotifier.value = 1;
      } //
      else {
        volumeNotifier.value = 0;
      }
    });
  }

  void onVolumePressed() {
    if (volumeNotifier.value != 0) {
      _audioPlayer.setVolume(0);
      volumeNotifier.value = 0;
    } //
    else {
      _audioPlayer.setVolume(1);
      volumeNotifier.value = 1;
    }
  }

  void onPreviousPressed() {
    _audioPlayer.seekToPrevious();
  }

  void onNextPressed() {
    _audioPlayer.seekToNext();
  }

  void onRepeatPressed() {
    repeatNotifier.nextState();
    if (repeatNotifier.value == RepeatState.off) {
      _audioPlayer.setLoopMode(LoopMode.off);
    } //
    else if (repeatNotifier.value == RepeatState.one) {
      _audioPlayer.setLoopMode(LoopMode.one);
    } //
    else if (repeatNotifier.value == RepeatState.all) {
      _audioPlayer.setLoopMode(LoopMode.all);
    }
  }

  void seek(position) {
    _audioPlayer.seek(position);
  }

  void playFromPlayList(int index) {
    _audioPlayer.seek(Duration.zero, index: index);
  }

  void play() {
    _audioPlayer.play();
    // ignore: avoid_print
  }

  void pause() {
    _audioPlayer.pause();
    // ignore: avoid_print
  }
}

class AudioMetaData {
  final String image;
  final String singerName;
  final String musicName;

  AudioMetaData(
      {required this.image, required this.singerName, required this.musicName});
}

class ProgressBarState {
  final Duration current;
  final Duration total;
  final Duration buffered;

  ProgressBarState(
      {required this.current, required this.total, required this.buffered});
}

enum ButtonState { playing, paused, loading }

enum RepeatState { one, all, off }

class RepeatStateNotifier extends ValueNotifier<RepeatState> {
  RepeatStateNotifier() : super(_initialValue);

  static const _initialValue = RepeatState.off;

  void nextState() {
    var next = (value.index + 1) % RepeatState.values.length;
    value = RepeatState.values[next];
  }
}
