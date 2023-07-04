import 'package:flutter/material.dart';
import 'package:musicplayer/screen/home_screen.dart';
import 'package:musicplayer/screen/music_screen.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});
  AudioPlayer audioPlayer = AudioPlayer();
  PageController pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Ubuntu',
      ),
      debugShowCheckedModeBanner: false,
      home: PageView(
        controller: pageController,
        scrollDirection: Axis.vertical,
        children: [
          HomeScreen(audioPlayer,pageController),
          MusicScreen(audioPlayer, pageController),
        ],
      ),
    );
  }
}
