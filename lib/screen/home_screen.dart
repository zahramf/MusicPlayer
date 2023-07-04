import 'package:flutter/material.dart';
import 'package:musicplayer/controllers/page_manager.dart';

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  HomeScreen(
    this._pageController,
    this._pageManager, {
    super.key,
  });
  final PageController _pageController;
  final PageManager _pageManager;

  late Size size;

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              height: size.height * 0.08,
              width: size.width,
              color: const Color.fromARGB(255, 149, 148, 148),
              child: const Center(
                child: Text(
                  'Music List',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(3),
                  child: ValueListenableBuilder(
                    valueListenable: _pageManager.playListNotifier,
                    builder: (context, List<AudioMetaData> value, child) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Container(
                            color: const Color.fromARGB(255, 183, 182, 182),
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            child: ListTile(
                              title: Text(value[index].musicName),
                              subtitle: Text(value[index].singerName),
                              onTap: () {
                                _pageController.animateToPage(1,
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.bounceIn);
                                _pageManager.playFromPlayList(index);
                              },
                            ),
                          );
                        },
                      );
                    },
                  )),
            ),
            ValueListenableBuilder(
              valueListenable: _pageManager.currentSongDetailNotifier,
              builder: (context, AudioMetaData value, child) {
                return Container(
                  height: size.height * 0.1,
                  width: size.width,
                  color: const Color.fromARGB(255, 219, 216, 216),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 25,
                      backgroundImage: AssetImage(value.image),
                    ),
                    title: Text(value.musicName),
                    subtitle: Text(value.singerName),
                    trailing: const Padding(
                      padding: EdgeInsets.all(20),
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
