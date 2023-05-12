import 'package:flutter/material.dart';
import 'package:musicplayer/screen/music_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Ubuntu',
      ),
      debugShowCheckedModeBanner: false,
      home: const MusicScreen(),
    );
  }
}
