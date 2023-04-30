import 'package:flutter/material.dart';

class PageManager {
  final progressBarNotifier = ValueNotifier<ProgressBarState>(
    ProgressBarState(Duration.zero, Duration.zero, Duration.zero),
  );

  final buttonNotifier = ValueNotifier(ButtonState.paused);
}

class ProgressBarState {
  final Duration current;
  final Duration total;
  final Duration buffered;

  ProgressBarState(this.current, this.total, this.buffered);
}

enum ButtonState { playing, paused, loading }
