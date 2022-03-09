import 'dart:async';
import 'dart:convert';
import 'package:better_player/better_player.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logger/logger.dart';
import 'package:http/http.dart' as http;
import 'package:malikia_tv/pages/replay_page.dart';
import 'package:malikia_tv/pages/ytoubeplayer.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:youtube_api/youtube_api.dart';
import 'package:youtube_api/yt_video.dart';
import '../animation/fadeanimation.dart';
import '../constains.dart';
import '../network/model/alauneByGroup.dart';
import '../network/model/api_list_by_groupe.dart';
import '../network/model/api_malikia.dart';
import '../network/model/api_video_url.dart';
import '../network/model/direct_api.dart';
import '../network/model/list_android.dart';
import '../network/model/live_api.dart';
import 'AllPlayListScreen.dart';

import 'chaine_page.dart';

import 'drawers.dart';
import 'emisions_page.dart';
import 'lecteur_malikia.dart';



final String menu = 'assets/images/menu.svg';
final String lecteur = 'assets/images/lecteur.svg';
Color gren = const Color(0xFF00722f);
Color wite = const Color(0xFFf8fbf8);
Color bg = const Color(0xFFEBEBEB);

class Malikiatv_HomePage extends StatefulWidget {
  var logger = Logger();
  Apimalikia apimalikia;
  Direct direct;
  String  test, lien;
  ListChannelsbygroup listChannelsbygroup;
  BetterPlayerController betterPlayerController;
  Malikiatv_HomePage({Key key, this.logger, this.apimalikia,this.betterPlayerController, this.direct,this.lien,this.test,this.listChannelsbygroup})
      : super(key: key);

  @override
  _Malikiatv_HomePageState createState() => _Malikiatv_HomePageState();
}

class _Malikiatv_HomePageState extends State<Malikiatv_HomePage> {

  ListAndroid listAndroid;
  var betterPlayerConfiguration = BetterPlayerConfiguration(
    autoPlay: true,
    looping: false,
    fullScreenByDefault: false,
    allowedScreenSleep: false,
    showPlaceholderUntilPlay: true,
    placeholderOnTop: false,
    translations: [
      BetterPlayerTranslations(
        languageCode: "fr",
        generalDefaultError: "Impossible de lire la vidéo",
        generalNone: "Rien",
        generalDefault: "Défaut",
        generalRetry: "Réessayez",
        playlistLoadingNextVideo: "Chargement de la vidéo suivante",
        controlsNextVideoIn: "Vidéo suivante dans",
        overflowMenuPlaybackSpeed: "Vitesse de lecture",
        overflowMenuSubtitles: "Sous-titres",
        overflowMenuQuality: "Qualité",
        overflowMenuAudioTracks: "Audio",
        qualityAuto: "Auto",
      ),
    ],
    deviceOrientationsAfterFullScreen: [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
    //autoDispose: true,
    controlsConfiguration: BetterPlayerControlsConfiguration(
      iconsColor: gren,
      //controlBarColor: colorPrimary,
      liveTextColor: Colors.red,
      playIcon: Icons.play_arrow,
      enablePip: true,
      //enableFullscreen: true,
      enableSubtitles: false,
      enablePlaybackSpeed: false,
      loadingColor: gren,
      enableSkips: false,
      overflowMenuIconsColor: gren,
      //enableOverflowMenu: false,
    ),
  );
  BetterPlayerController _betterPlayerController;
  VideoPlayerController playerController;
  ChewieController _chewieController;
  bool isVideoLoading = true;
  LiveApi liveApi;
  Apimalikia apimalikia;
  ListChannelsbygroup listChannelsbygroup;
  var logger = Logger();
  String url, time,test,lien,logo,videoId, title, titre;
  GlobalKey _betterPlayerKey = GlobalKey();
  String api,idVideo,json,related,texte,heure,descpt,tpe,vido_url;
  StreamController<bool> _playController = StreamController.broadcast();
  Direct direct;
  YoutubeAPI ytApi;
  YoutubeAPI ytApiPlaylist;
  List<YT_API> ytResult = [];
  List<YT_APIPlaylist> ytResultPlaylist = [];
  bool isLoading = true;
  bool isLoadingPlaylist = true;
  VideoUrl _videoUrl;
  //String title;
  //String query = "JoyNews";
  String API_Key = 'AIzaSyA6qu7Yw62GjwAsCyviSKnUsWZ3od9-6uk';
  String API_CHANEL = 'UC0V1TlLFybhr0MJzxxXgdWw';

  Future<void> callAPI() async {
    print('UI callled');
    //await Jiffy.locale("fr");
    ytResult = await ytApi.channel(API_CHANEL);
    setState(() {
      print('UI Updated');
      isLoading = false;
      callAPIPlaylist();
    });
  }

  Future<void> callAPIPlaylist() async {
    print('UI callled');
    //await Jiffy.locale("fr");
    ytResultPlaylist = await ytApiPlaylist.playlist(API_CHANEL);
    setState(() {
      print('UI Updated');
      print(ytResultPlaylist[0].title);
      isLoadingPlaylist = false;
    });
  }


  Future<LiveApi> fetchListAndroid() async {
    try {
      var postListUrl = Uri.parse("https://tveapi.acan.group/myapiv2/directplayback/46/json");
      final response = await http.get(postListUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var logger = Logger();
        logger.w(data);
        logger.w("acan");
        setState(() {
          liveApi = LiveApi.fromJson(jsonDecode(response.body));
          //print(leral);
        });

        BetterPlayerDataSource dataSource = BetterPlayerDataSource(
            BetterPlayerDataSourceType.network,
            liveApi.directUrl,
            liveStream: true,


            notificationConfiguration: BetterPlayerNotificationConfiguration(
              showNotification: true,

              //notificationChannelName: "7TV Direct",
              //activityName: "7TV Direct",
              title: "Vous suivez MALIKIA TV en direct",
              imageUrl:
              "https://telepack.net/wp-content/uploads/2020/11/WhatsApp-Image-2020-11-03-at-15.12.32.jpeg",
            )
        );

        _betterPlayerController.setupDataSource(dataSource);
        _betterPlayerController.setupDataSource(dataSource);
        _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);


        /*playerController = VideoPlayerController.network(liveApi.directUrl);
        await playerController.initialize().then((value) {
          setState(() {
            isVideoLoading = false;
          });
        });
        _chewieController = ChewieController(
          videoPlayerController: playerController,
          aspectRatio: 16 / 9,
          autoPlay: true,
          looping: true,
          isLive: true,
          allowedScreenSleep: false,
          autoInitialize: true,
          errorBuilder: (context, String message) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message = "Erreur de connexion",
                  style: TextStyle(color: Color(0xFF00722f), fontSize: 18),
                ),
              ),
            );
          },
          //fullScreenByDefault: true
        );

        _chewieController.addListener(() {
          if (!_chewieController.isFullScreen) {
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitDown]);
          }
        });
        playerController.setLooping(true);*/
      }
    } catch (error, stacktrace) {
      return LiveApi.withError("Data not found / Connection issue");
    }
  }

  Future<Apimalikia> fetchList() async {
    try {
      var postListUrl =
      Uri.parse("https://acanvod.acan.group/myapiv2/appdetails/malikia");
      final response = await http.get(postListUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        var logger = Logger();
        logger.w(data,"test");

        Apimalikia.fromJson(jsonDecode(response.body));
        //print(leral);

      }
    } catch (error, stacktrace) {
      return Apimalikia.withError("Data not found / Connection issue");
    }


  }



  Future<ListChannelsbygroup> fetchReplay() async {
    var postListUrl =
    Uri.parse("https://acanvod.acan.group/myapiv2/listChannelsByChaine/malikia/44//json");
    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      return ListChannelsbygroup.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }

  Future<AlauneByGroup> fetchAlauneByGroupe() async {
    var postListUrl = Uri.parse(
        "https://acanvod.acan.group/myapiv2/alauneByGroup/malikia/json");
    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      logger.w(data);

      //logger.w(listChannelsbygroup);
      return AlauneByGroup.fromJson(jsonDecode(response.body));

      // model= AlauneModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }


  loadData() {
    Future<LiveApi> fetchListAndroid() async {
      try {
        var postListUrl = Uri.parse(widget.direct.allitems[0].feedUrl);
        final response = await http.get(postListUrl);
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          var logger = Logger();
          logger.w(data);
          setState(() {
            liveApi = LiveApi.fromJson(jsonDecode(response.body));
            //print(leral);
          });
          BetterPlayerDataSource dataSource = BetterPlayerDataSource(
              BetterPlayerDataSourceType.network,
              liveApi.directUrl,
              liveStream: true,
              notificationConfiguration: BetterPlayerNotificationConfiguration(
                showNotification: true,
                //notificationChannelName: "7TV Direct",
                //activityName: "7TV Direct",
                title: "Vous suivez MALIKIA TV en direct",
                imageUrl:
                "https://telepack.net/wp-content/uploads/2020/11/WhatsApp-Image-2020-11-03-at-15.12.32.jpeg",
              )
          );

          _betterPlayerController.setupDataSource(dataSource);
          _betterPlayerController.setupDataSource(dataSource);
          _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);


          /*playerController = VideoPlayerController.network(liveApi.directUrl);
        await playerController.initialize().then((value) {
          setState(() {
            isVideoLoading = false;
          });
        });
        _chewieController = ChewieController(
          videoPlayerController: playerController,
          aspectRatio: 16 / 9,
          autoPlay: true,
          looping: true,
          isLive: true,
          allowedScreenSleep: false,
          autoInitialize: true,
          errorBuilder: (context, String message) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  message = "Erreur de connexion",
                  style: TextStyle(color: Color(0xFF00722f), fontSize: 18),
                ),
              ),
            );
          },
          //fullScreenByDefault: true
        );

        _chewieController.addListener(() {
          if (!_chewieController.isFullScreen) {
            SystemChrome.setPreferredOrientations(
                [DeviceOrientation.portraitDown]);
          }
        });
        playerController.setLooping(true);*/
        }
      } catch (error, stacktrace) {
        return LiveApi.withError("Data not found / Connection issue");
      }
    }
    setState(() {
      isVideoLoading = false;//setting state to false after data loaded
    });
  }

  Future<void> testUrl() async {
    String url = "https://acanvod.acan.group/myapiv2/directplayback/44/json";
    final response = await http.get(Uri.parse(url));
    print(response.body);
    bool isVideoLoading = false;
    setState(() {
      _videoUrl = VideoUrl.fromJson(jsonDecode(response.body));
    });

    logger.w("axakkk",_videoUrl.videoUrl);
    /*BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        _videoUrl.videoUrl,
        liveStream: true,
        notificationConfiguration: BetterPlayerNotificationConfiguration(
          showNotification: true,
          //notificationChannelName: "7TV Direct",
          //activityName: "7TV Direct",
          title: "Vous suivez MALIKIA TV en direct",
          imageUrl:
          "https://telepack.net/wp-content/uploads/2020/11/WhatsApp-Image-2020-11-03-at-15.12.32.jpeg",
        )
    );
    _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.setupDataSource(dataSource);
    _betterPlayerController.setBetterPlayerGlobalKey(_betterPlayerKey);*/
    playerController = VideoPlayerController.network(_videoUrl.videoUrl);
      await playerController.initialize().then((value) {
        setState(() {
          isVideoLoading = false;
        });
      });
      _chewieController = ChewieController(
        videoPlayerController: playerController,
        aspectRatio: 16 / 9,
        autoPlay: true,
        looping: true,
        isLive: true,
        allowedScreenSleep: false,
        autoInitialize: true,

        //fullScreenByDefault: true
      );
      _chewieController.addListener(() {
        if (!_chewieController.isFullScreen) {
          SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
        }
      });
      playerController.setLooping(true);
  }

  Widget _buildPlaceholder() {
    return StreamBuilder<bool>(
      stream: _playController.stream,
      builder: (context, snapshot) {
        bool showPlaceholder = snapshot.data ?? true;
        return AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: showPlaceholder ? 1.0 : 0.0,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: IconButton(
              icon: Icon(
                Icons.picture_in_picture,color: gren,
              ),
              onPressed: (){
                _betterPlayerController.enablePictureInPicture(_betterPlayerKey);
              },
            ),

          ),
        );
      },
    );
  }
  @override
  void initState() {

    ytApi = new YoutubeAPI(API_Key, maxResults: 50, type: "video");
    ytApiPlaylist =
    new YoutubeAPI(API_Key, maxResults: 9, type: "playlist");
    callAPI();
    betterPlayerConfiguration;
    /* BetterPlayerConfiguration betterPlayerConfiguration =
    BetterPlayerConfiguration(
      aspectRatio: 16 / 9,
      fit: BoxFit.contain,
        handleLifecycle: true,
        autoPlay: true,
        autoDispose: false,
        looping: true,
        placeholder: _buildPlaceholder(),
        showPlaceholderUntilPlay: true,
        placeholderOnTop: false,
        errorBuilder: (context, String message) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    message = "Impossible de lire la vidéo\n ",
                    style: TextStyle(color: Color(0xFF00722f), fontSize: 18),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      child: Text("Réessayez",),
                      onPressed: (){
                        _buildPlaceholder();
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        },
        controlsConfiguration: BetterPlayerControlsConfiguration(
            enableSkips: false,
            controlBarHeight: 60,
          playIcon:Icons.play_arrow,
          iconsColor: gren,
            loadingColor: gren,
          enableRetry: true,
          showControls: true,
          showControlsOnInitialize: true,


        )
    );*/
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.play) {
        _playController.add(false);
        // _betterPlayerController.enablePictureInPicture(_betterPlayerKey);
      }

    });
    fetchListAndroid();
    //testUrl();
    //fetchListAndroid();

    //fetchListAndroid();
    //fetchList();
    //navigationPage();
    /*BackButtonInterceptor.add(myInterceptor);*/
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
  }

  /*bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    _betterPlayerController.enablePictureInPicture(_betterPlayerKey); // Do some stuff.
    return false;
  }*/



  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      switch (state) {
        case AppLifecycleState.resumed:
          playerController.play();
          break;
        case AppLifecycleState.inactive:
        // widget is inactive
          break;
        case AppLifecycleState.paused:
        // widget is paused

          break;
        case AppLifecycleState.detached:
        // widget is detached
          break;
      }
    });
  }
  @override
  void dispose() {
   // BackButtonInterceptor.remove(myInterceptor);
    if (_betterPlayerController !=null) {
      _betterPlayerController.dispose();
      _betterPlayerController=null;
    }
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Wakelock.enable();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: wite,
          title: Image.asset("assets/images/1.png"),
          iconTheme: IconThemeData(color: gren,)
      ),
      body: SafeArea(
        child: Container(
          width: double.infinity,
          //height: double.infinity,
          color: bg,
          child: Column(
            children: <Widget>[
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.black,
                child:

                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: BetterPlayer(
                      controller: _betterPlayerController
                  ),
                  //key: _betterPlayerKey,
                ),
                //child: playerVideo(),
              ),
              Container(
                width: double.infinity,
                height: 40,
                color: wite,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      child: Icon(
                        Icons.tv,
                        color: gren,
                        size: 20,
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      child: Text(
                        "Vous suivez MALIKIA TV en direct",
                        style: TextStyle(
                          color: gren,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          fontFamily: "helvetica",
                        ),
                      ),
                    )
                  ],
                ),
              ),
              dernierVideo(),
              Expanded(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(),
                      child:  Wrap(
                          spacing: 2,
                          children: <Widget>[youtubeEmissions(), emissions(), itemVideos()]
                      )
                      /*Column(
                        children: [item(), emissions(), itemVideos()],
                      )*/,
                    ),
                  ))
            ],
          ),
        ),
      ),
      drawer: DrawerPage(
        apimalikia: apimalikia,
        betterPlayerController: _betterPlayerController,
      ),
    );
  }
  /*Widget playerVideos() {
    return Container(
      width: double.infinity,
      color: Colors.black,
      child: Column(
        children:  <Widget>[
          Expanded(
            child: Center(
              child: (_chewieController != null &&
                  _chewieController
                      .videoPlayerController.value.isInitialized)
                  ? Chewie(
                controller: _chewieController,
              )
                  : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('Loading'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }*/

  Widget dernierVideo() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                //margin: const EdgeInsets.symmetric(horizontal: 10.2),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Dernières Vidéos",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: "helvetica",
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: gren,
                        size: 30,
                      ),
                      onPressed: () {
                        /*if(widget.betterPlayerController !=null)widget.betterPlayerController.pause();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    YoutubeVideoChannelScreen(

                                      ytResult: ytResult,

                                      apikey: API_Key,)
                            ),
                                (Route<dynamic> route) => true);*/
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget emissions() {
    return Container(
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                //margin: const EdgeInsets.symmetric(horizontal: 10.2),
                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Emissions",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: "helvetica",
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.add,
                        color: gren,
                        size: 30,
                      ),
                      onPressed: () {
                        /*if(widget.betterPlayerController !=null)widget.betterPlayerController.pause();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    AllPlayListScreen(ytResult: ytResultPlaylist,apikey:API_Key)),
                                (Route<dynamic> route) => true);*/

                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget youtubeEmissions(){
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      //margin: const EdgeInsets.symmetric(horizontal: 10.2),

      height: 200.0,
      child: Container(
        child: ListView.builder(
            itemCount: ytResult.length,
            itemBuilder: (context, position) {
              return Container(
                margin: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(0),
                    color: wite,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 2,
                          offset: Offset(0, 0),
                          color: Colors.grey.withOpacity(0.2)),
                    ]),
                child: Container(
                  child: Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                          child: Container(
                            height: 80,
                            width: 140,
                            child: GestureDetector(
                              child: FadeAnimation(
                                0.5,
                                  ClipRRect(
                                  borderRadius: BorderRadius.circular(0),
                                  child: Container(
                                    child: CachedNetworkImage(
                                      height: 110,
                                      width: MediaQuery.of(context).size.width,
                                      imageUrl:  ytResult[position].thumbnail['medium']['url'],
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Image.asset(
                                        "assets/images/malikiaError.png",
                                        fit: BoxFit.contain,
                                        height: 120,
                                        width: 120,
                                        //color: colorPrimary,
                                      ),
                                      errorWidget: (context, url, error) => Image.asset(
                                        "assets/images/malikiaError.png",
                                        fit: BoxFit.contain,
                                        height: 120,
                                        width: 120,
                                        //color: colorPrimary,
                                      ),
                                    ),
                                  ),
                                )
                              ),
                                onTap: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => YtoubePlayerPage(
                                            videoId: ytResult[position].url,
                                            title: ytResult[position].title,

                                            ytResult: ytResult,
                                          )),
                                          (Route<dynamic> route) => true);
                                }
                            ),
                      )
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        flex: 1,
                        child: RichText(
                          overflow: TextOverflow.ellipsis,
                          strutStyle: StrutStyle(fontSize: 12.0),
                          text: TextSpan(
                              style: TextStyle(color: Colors.black),
                              text:
                              ytResult[position].title),
                        ),
                      ),
                      Container(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_betterPlayerController != null)_betterPlayerController.pause();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => YtoubePlayerPage(
                                      videoId: ytResult[position].url,
                                      title: ytResult[position].title,

                                      ytResult: ytResult,
                                    )),
                                    (Route<dynamic> route) => true);
                          },
                          child: Icon(Icons.play_arrow,
                              color: Colors.white),
                          style: ElevatedButton.styleFrom(
                              shape: CircleBorder(), primary: gren),
                        ),
                        alignment: Alignment.bottomRight,
                      )
                    ],
                  ),
                ),
              );
            }
        ),
      ),
    );
  }



  Widget itemVideos() {
    return Container(
      //margin: const EdgeInsets.symmetric(horizontal: 10.2),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        height: 184,
        child: Container(
          child: ListView.builder(
              itemCount: ytResultPlaylist.length>9?9:ytResultPlaylist.length>0?ytResultPlaylist.length:0,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, position) {
                return Container(
                  margin: const EdgeInsets.only(left: 6,  top: 0, bottom: 6),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        color: wite,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 2,
                              offset: Offset(0, 0),
                              color: Colors.grey.withOpacity(0.2)),
                        ]),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Column(
                          children:<Widget> [
                            Container(
                              height: 120,
                              width: 152,
                              child: GestureDetector(
                                child: FadeAnimation(
                                    0.5,
                                    Hero(
                                      tag: new Text(ytResultPlaylist[position].url.replaceAll("https://www.youtube.com/playlist?list=", "")),
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(0),
                                        child: Container(
                                          child:Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: NetworkImage("${ytResultPlaylist[position].thumbnail["medium"]["url"]}"),
                                                fit: BoxFit.cover
                                              )
                                            ),
                                          ),
                                          width: MediaQuery.of(context).size.width, height: 140,
                                        ),
                                      ),
                                    ),
                                    ),
                                  onTap: () {
                                  logger.w(ytResultPlaylist[position].id);
                                  /*if (_betterPlayerController != null)_betterPlayerController.pause();
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => PlayListVideoScreen(

                                            title: ytResultPlaylist[position].id,apiKey: apiKey,)),
                                          (Route<dynamic> route) => true,);*/
                                  }
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 9,),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,

                          children: <Widget>[
                            Container(
                              child: Stack(
                                children: [
                                  RichText(
                                  overflow: TextOverflow.ellipsis,
                                  strutStyle: StrutStyle(fontSize: 12.0),
                                  text: TextSpan(
                                      style: TextStyle(color: Colors.black),
                                      text:
                                      ytResultPlaylist[position].title.substring(0,10)),
                                )],
                              ),
                            ),
                            SizedBox(width: 30,),
                            Container(
                              child: IconButton(
                                icon: SvgPicture.asset(
                                  lecteur,
                                  color: gren,
                                  width: 27,
                                ),
                                iconSize: 14,
                                onPressed: () {
                                  if (_betterPlayerController != null)_betterPlayerController.pause();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return ReplyerPage();
                                    }),
                                  );
                                },
                              ),
                              alignment: Alignment.bottomRight,
                            )
                          ],
                        ),

                      ],
                    ),
                  ),
                );
              }),
        ));
  }

  /*Widget playerVideo() {
    return Container(
      width: double.infinity,
      color: Colors.black,
      child: Container(
        child: (_chewieController != null &&
            _chewieController.videoPlayerController.value.isInitialized)
            ? Chewie(
          controller: _chewieController,
        )
            : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading'),
          ],
        ),
      ),
    );

  }*/
/*Future<void> navigationPage() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LecteurMalikiaPage(
        apimalikia: apimalikia,
        direct: direct,
      ),
      ),
          (Route<dynamic> route) => false,
    );
  }*/


}
