import 'package:flutter/material.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
import 'package:better_player/better_player.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body: MyNotifier(),
      ),
    );
  }
}

class MyNotifier extends StatelessWidget {
  final List<String> urls = [
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_640_3MG.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://file-examples-com.github.io/uploads/2017/04/file_example_MP4_640_3MG.mp4'
  ];
  @override
  Widget build(BuildContext context) {
    return InViewNotifierList(
      scrollDirection: Axis.vertical,
      initialInViewIds: [urls[0]],
      isInViewPortCondition:
          (double deltaTop, double deltaBottom, double viewPortDimension) {
        return deltaTop < (0.5 * viewPortDimension) &&
            deltaBottom > (0.5 * viewPortDimension);
      },
      itemCount: urls.length,
      contextCacheCount: 500,
      addAutomaticKeepAlives: true,
      builder: (BuildContext context, int index) {
        return CachePage(url: urls[index]);
      },
    );
  }
}

class CachePage extends StatefulWidget {
  final String url;
  CachePage({@required this.url});
  @override
  _CachePageState createState() => _CachePageState();
}

class _CachePageState extends State<CachePage> {
  BetterPlayerController _betterPlayerController;

  @override
  void initState() {
    BetterPlayerConfiguration betterPlayerConfiguration =
        BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
    );
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
      BetterPlayerDataSourceType.NETWORK,
      widget.url,
      cacheConfiguration: BetterPlayerCacheConfiguration(useCache: true),
    );
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.setupDataSource(dataSource);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InViewNotifierWidget(
      id: widget.url,
      builder: (BuildContext context, bool isInView, Widget child) {
        if(isInView)
          {
            _betterPlayerController.play();
            _betterPlayerController.setLooping(false);
          }
        else{
          _betterPlayerController.pause();
        }
        return Container(
          height: 350,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Player with cache enabled. To test this feature, first plays "
                      "video, then leave this page, turn internet off and enter "
                      "page again. You should be able to play video without "
                      "internet connection.",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              AspectRatio(
                aspectRatio: 16 / 9,
                child: BetterPlayer(controller: _betterPlayerController),
              ),
            ],
          ),
        );
      },

    );
  }
}

