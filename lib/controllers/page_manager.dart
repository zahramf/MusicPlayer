import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class PageManager {
  static const String _url =
      'https://files.musico.ir/siros/Mohsen%20Chavoshi%20-%20Rahayam%20Kon%20(320).mp3';
  late AudioPlayer _audioPlayer;

  PageManager() {
    _init();
  }

  void seek(position) {
    _audioPlayer.seek(position);
  }

  void play() async {
    await _audioPlayer.setUrl(_url);

    _audioPlayer.play();
    // ignore: avoid_print
    print("play");
  }

  void pause() {
    _audioPlayer.pause();
    // ignore: avoid_print
    print("pause");
  }

  void _init() async {
    _audioPlayer = AudioPlayer();

//hande button
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
      else {
        buttonNotifier.value = ButtonState.playing;
      }
    });

////handle progress bar

//current
    _audioPlayer.positionStream.listen((position) {
      final oldState = progressBarNotifier.value;
      progressBarNotifier.value = ProgressBarState(
        current: position,
        total: oldState.total,
        buffered: oldState.buffered,
      );
    });

//buffer
    _audioPlayer.bufferedPositionStream.listen((position) {
      final oldState = progressBarNotifier.value;
      progressBarNotifier.value = ProgressBarState(
        current: oldState.current,
        total: oldState.total,
        buffered: position,
      );
    });

//total
    _audioPlayer.durationStream.listen((position) {
      final oldState = progressBarNotifier.value;
      progressBarNotifier.value = ProgressBarState(
        current: oldState.current,
        total: position ?? Duration.zero,
        buffered: oldState.buffered,
      );
    });
  }

  final progressBarNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(
      current: Duration.zero,
      total: Duration.zero,
      buffered: Duration.zero,
    ),
  );

  final buttonNotifier = ValueNotifier<ButtonState>(ButtonState.paused);
}

class ProgressBarState {
  final Duration current;
  final Duration total;
  final Duration buffered;

  ProgressBarState(
      {required this.current, required this.total, required this.buffered});
}

enum ButtonState { playing, paused, loading }
