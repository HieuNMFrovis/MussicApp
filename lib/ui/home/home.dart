import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:mucsic_app/data/model/song.dart';
import 'package:mucsic_app/ui/discovery/discovery.dart';
import 'package:mucsic_app/ui/home/viewmodel.dart';
import 'package:mucsic_app/ui/now_playing/playing.dart';
import 'package:mucsic_app/ui/settings/settings.dart';
import 'package:mucsic_app/ui/uses/user.dart';

class MussicApp extends StatelessWidget {
  const MussicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mussic App",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MussicHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MussicHomePage extends StatefulWidget {
  const MussicHomePage({super.key});

  @override
  State<MussicHomePage> createState() => _MussicHomePageState();
}

class _MussicHomePageState extends State<MussicHomePage> {
  final List<Widget> _tabs = [
    const HomeTab(),
    const DiscoveryTab(),
    const AccountTab(),
    const SettingsTab(),
  ];
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Mussic'),
        ),
        child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.album), label: "Discovery"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: "Account"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: "Setting")
            ],
          ),
          tabBuilder: (BuildContext context, int index) {
            return _tabs[index];
          },
        ));
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeTabPage();
  }
}

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  List<Song> songs = [];
  late MusicAppViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = MusicAppViewModel();
    _viewModel.loadSongs();
    observerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  @override
  void dispose() {
    _viewModel.songStream.close();
    super.dispose();
  }

  Widget getBody() {
    bool showLoading = songs.isEmpty;
    if (showLoading) {
      return getProgressBar();
    } else {
      return getListView();
    }
  }

  Widget getProgressBar() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  ListView getListView() {
    // có đường phân tách ở giữa các phần tử thì sẽ dùng separated.
    return ListView.separated(
      itemBuilder: (context, position) {
        return getRow(position);
      },
      separatorBuilder: (context, index) {
        return const Divider(
          color: Colors.grey,
          thickness: 1,
          indent: 24,
          endIndent: 24,
        );
      },
      itemCount: songs.length,
      shrinkWrap: true,
    );
  }

  Widget getRow(int index) {
    return _SongItemSection(
      song: songs[index],
      parent: this,
    );
  }

  void observerData() {
    _viewModel.songStream.stream.listen((songList) {
      print("Received songs: ${songList.length}"); // Debug statement
      setState(() {
        songs.addAll(songList);
      });
    });
  }

  void showBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Container(
              height: 400,
              color: Colors.grey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    const Text('Modal Bottom Sheet'),
                    ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text("Close Bottom Sheet"))
                  ],
                ),
              ),
            ),
          );
        });
  }

  void navigate(Song song) {
    Navigator.push(context, CupertinoPageRoute(builder: (context) {
      return NowPlaying(
        songs: songs,
        playingSong: song,
      );
    }));
  }
}

class _SongItemSection extends StatelessWidget {
  const _SongItemSection({required this.song, required this.parent});
  final _HomeTabPageState parent;
  final Song song;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FadeInImage.assetNetwork(
          placeholder: 'assets/itune.png',
          image: song.image,
          width: 48,
          height: 48,
          imageErrorBuilder: (context, error, stackTrace) {
            return Image.asset(
              "assets/itune.png",
              width: 48,
              height: 48,
            );
          }),
      title: Text(song.title),
      subtitle: Text(song.artist),
      trailing: IconButton(
          onPressed: () {
            parent.showBottomSheet();
          },
          icon: const Icon(Icons.more_horiz)),
      onTap: () {
        parent.navigate(song);
      },
    );
  }
}
