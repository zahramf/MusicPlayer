import 'dart:ui';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MusicScreen extends StatelessWidget {
  MusicScreen({super.key});
  late Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: size.height,
            width: size.width,
            child: Image.asset(
              "assets/images/Mohsen-Chavoshi-Rahayam-Kon.jpeg",
              fit: BoxFit.fill,
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              color: Colors.grey.withOpacity(
                0.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
