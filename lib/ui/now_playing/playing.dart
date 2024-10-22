import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mucsic_app/data/model/song.dart';

class NowPlaying extends StatelessWidget {
  const NowPlaying({super.key, required this.playingSong, required this.songs});
  final Song playingSong;
  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    return NowPlayingPage(
      songs: songs,
      playingSong: playingSong,
    );
  }
}

class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage(
      {super.key, required this.songs, required this.playingSong});

  final Song playingSong;
  final List<Song> songs;
  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _imageAnimController;
  @override
  void initState() {
    super.initState();
    _imageAnimController = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 12000),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const delta = 64;
    final radius = (screenWidth - delta) / 2;
    // return const Scaffold(
    //   body: Center(
    //     child: Text('Now Playing'),
    //   ),
    // );
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Now Playing'),
        trailing:
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
      ),
      child: Scaffold(
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(widget.playingSong.album),
            const SizedBox(
              height: 16,
            ),
            const Text('_ ___ _'),
            const SizedBox(
              height: 48,
            ),
            RotationTransition(
              turns: Tween(begin: 0.0, end: 1.0).animate(_imageAnimController),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(radius),
                  child: FadeInImage.assetNetwork(
                    placeholder: 'assets/itune.png',
                    image: widget.playingSong.image,
                    width: screenWidth - delta,
                    height: screenWidth - delta,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/itune.png',
                      width: screenWidth-delta,
                      height: screenWidth-delta,
                      );
                    },
                  )),
            )
          ],
        )),
      ),
    );
  }
}
