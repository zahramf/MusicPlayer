import 'dart:ui';

import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:musicplayer/controllers/page_manager.dart';
import 'package:just_audio/just_audio.dart';

// ignore: must_be_immutable
class MusicScreen extends StatefulWidget {
  const MusicScreen(
    this._audioPlayer,
    this._pageController, {
    super.key,
  });

  final AudioPlayer _audioPlayer;
  final PageController _pageController;

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  late Size size;

  late PageManager _pageManager;

  @override
  void initState() {
    super.initState();
    _pageManager = PageManager(widget._audioPlayer);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
            child: ValueListenableBuilder(
              valueListenable: _pageManager.currentSongDetailNotifier,
              builder: (context, AudioMetaData value, child) {
                String image = value.image;
                return Image.asset(
                  image,
                  // "assets/images/Farzad-Farzin-Javaher.jpg",

                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              color: Colors.grey.withOpacity(
                0.4,
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              widget._pageController.animateToPage(0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.bounceIn);
                            },
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'Now Playing',
                            style: TextStyle(fontSize: 28, color: Colors.white),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.menu,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      ValueListenableBuilder(
                        valueListenable: _pageManager.currentSongDetailNotifier,
                        builder: (context, AudioMetaData value, child) {
                          String imagea = value.image;

                          return CircleAvatar(
                            radius: 150,
                            backgroundImage: AssetImage(imagea
                                // "assets/images/Farzad-Farzin-Javaher.jpg",
                                ),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ValueListenableBuilder(
                            valueListenable:
                                _pageManager.currentSongDetailNotifier,
                            builder: (context, AudioMetaData value, child) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    value.singerName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    value.musicName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ValueListenableBuilder(
                        valueListenable: _pageManager.progressBarNotifier,
                        builder: (context, value, _) {
                          return ProgressBar(
                            progress: value.current,
                            total: value.total,
                            buffered: value.buffered,
                            onSeek: _pageManager.seek,
                            thumbColor: Colors.white,
                            baseBarColor: Colors.grey,
                            progressBarColor: Colors.redAccent,
                            bufferedBarColor: Colors.red.shade200,
                            timeLabelTextStyle:
                                const TextStyle(color: Colors.white),
                            thumbGlowColor:
                                const Color.fromARGB(55, 140, 98, 98),
                          );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ValueListenableBuilder(
                            valueListenable: _pageManager.repeatNotifier,
                            builder: (context, value, _) {
                              switch (value){
                                case RepeatState.off:
                                  return  IconButton(
                                    onPressed:_pageManager.onRepeatPressed,
                                    icon: const Icon(
                                      Icons.repeat,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  );
                                case RepeatState.one:
                                  return IconButton(
                                    onPressed:_pageManager.onRepeatPressed,
                                    icon: const Icon(
                                      Icons.repeat_one_outlined,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  );
                                case RepeatState.all:
                                  return IconButton(
                                    onPressed: _pageManager.onRepeatPressed,
                                    icon: const Icon(
                                      Icons.repeat,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                  );
                              }


                            },
                          ),
                          ValueListenableBuilder(
                            valueListenable: _pageManager.isFirstSongNotifier,
                            builder: (context, bool value, child) {
                              return IconButton(
                                onPressed: value
                                    ? null
                                    : _pageManager.onPreviousPressed,
                                icon: const Icon(
                                  Icons.skip_previous,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              );
                            },
                          ),
                          Container(
                            padding: const EdgeInsets.all(
                              15,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              gradient: const LinearGradient(
                                colors: [
                                  Colors.red,
                                  Colors.black,
                                ],
                                begin: Alignment.bottomRight,
                                end: Alignment.topLeft,
                              ),
                            ),
                            child: ValueListenableBuilder<ButtonState>(
                                valueListenable: _pageManager.buttonNotifier,
                                builder: (context, ButtonState value, _) {
                                  switch (value) {
                                    case ButtonState.loading:
                                      return const CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                            Colors.white),
                                      );
                                    case ButtonState.playing:
                                      return IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: _pageManager.pause,
                                        icon: const Icon(
                                          Icons.pause,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      );
                                    case ButtonState.paused:
                                      return IconButton(
                                        padding: EdgeInsets.zero,
                                        onPressed: _pageManager.play,
                                        icon: const Icon(
                                          Icons.play_arrow_rounded,
                                          color: Colors.white,
                                          size: 35,
                                        ),
                                      );
                                  }
                                }),
                          ),
                          ValueListenableBuilder(
                            valueListenable: _pageManager.isLastSongNotifier,
                            builder: (context, bool value, child) {
                              return IconButton(
                                onPressed:
                                    value ? null : _pageManager.onNextPressed,
                                icon: const Icon(
                                  Icons.skip_next,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              );
                            },
                          ),
                          ValueListenableBuilder(valueListenable: _pageManager.volumeNotifier, builder: (context, value, child) {
                           if(value ==0){
                             return IconButton(
                               onPressed: _pageManager.onVolumePressed,
                               icon: const Icon(
                                 Icons.volume_off,
                                 color: Colors.white,
                                 size: 30,
                               ),
                             );

                           }//
                            else{
                             return IconButton(
                               onPressed: _pageManager.onVolumePressed,
                               icon: const Icon(
                                 Icons.volume_up,
                                 color: Colors.white,
                                 size: 30,
                               ),
                             );

                           }
                          },),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
