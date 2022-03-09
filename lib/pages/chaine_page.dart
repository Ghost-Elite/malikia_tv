import 'dart:convert';
import 'package:better_player/better_player.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../animation/fadeanimation.dart';
import '../network/model/alauneByGroup.dart';
import '../network/model/api_list_by_groupe.dart';
import '../network/model/api_video_url.dart';
import 'home_page.dart';

class LecteurDesReplayesEmisions extends StatefulWidget {
  String lien,videoId, title, time, api;
  ListChannelsbygroup listChannelsbygroup;



  VideoPlayerController playerController;
  var logger = Logger();
  bool isVideoLoading = true;
  String url, titre,test,idVideo,json,related,texte,heure,descpt,tpe,vido_url;
  bool isVisible = true;


  LecteurDesReplayesEmisions({Key key,
    this.url,
    this.listChannelsbygroup,
    this.test,
    this.vido_url,
    this.idVideo,
    this.related,
    this.heure,
    this.descpt,
    this.texte,
    this.titre,
    this.logger,
    this.lien,
    this.title,
    this.videoId,
    this.time,
    this.api,
    this.json,
    this.playerController,
    this.isVideoLoading,
    this.isVisible,
    this.tpe, AlauneByGroup
  }) : super(key: key);

  @override
  _LecteurDesReplayesEmisionsState createState() => _LecteurDesReplayesEmisionsState();
}

class _LecteurDesReplayesEmisionsState extends State<LecteurDesReplayesEmisions> with AutomaticKeepAliveClientMixin<LecteurDesReplayesEmisions> {
  @override
  bool get wantKeepAlive => true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();
  YoutubePlayerController _controller;
  ChewieController _chewieController;
  bool isLoading;
  String lien;
  bool vrai;
  var logger = Logger();
  VideoUrl videoUrl;
  var betterPlayerConfiguration = BetterPlayerConfiguration(

    autoPlay: true,
    looping: false,
    fullScreenByDefault: false,
    allowedScreenSleep: false,
    translations: [
      BetterPlayerTranslations(
        languageCode: "fr",
        generalDefaultError: "Impossible de lire la vidéo",
        generalNone: "Rien",
        generalDefault: "Défaut",
        //generalRetry: "Réessayez",
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
      enableSubtitles: false,
      enablePlaybackSpeed: false,
      loadingColor: gren,
      enableSkips: false,
      overflowMenuIconsColor: gren,
    ),
  );
  BetterPlayerController _betterPlayerController;
  GlobalKey _betterPlayerKey = GlobalKey();



  Future<AlauneByGroup> fetchReplay() async {
    var postListUrl =
    Uri.parse(widget.related);
    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      // print(widget.listChanel.allitems[0].feedUrl);
      return AlauneByGroup.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }
  Future<AlauneByGroup> fetchAlauneByGroupe() async {
    var postListUrl =
    Uri.parse("https://acanvod.acan.group/myapiv2/alauneByChaine/44/json");
    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);


      //logger.w(listChannelsbygroup);
      return AlauneByGroup.fromJson(jsonDecode(response.body));


      // model= AlauneModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }
  Future<void> testUrl() async {
    String url =
        "${widget.vido_url}";
    final response = await http.get(Uri.parse(url));
    print(response.body);

    VideoUrl videoUrl = VideoUrl.fromJson(jsonDecode(response.body));
    logger.w(videoUrl.videoUrl);
    BetterPlayerDataSource dataSource = BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        videoUrl.videoUrl,
        //liveStream: true,

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
  }

  /*Future<RelatedItems> fetchEmission() async {
    var postListUrl = Uri.parse(widget.related);
    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      widget.logger.d(jsonDecode(response.body));
      return RelatedItems.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }
*/
  @override
  void initState() {
    betterPlayerConfiguration;
    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    players();

    super.initState();
  }


  @override
  void dispose() {
    widget.playerController.dispose();
    _chewieController.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }
  players(){
    if (widget.tpe == "youtube") {
      _controller = YoutubePlayerController(
          initialVideoId:
          YoutubePlayer.convertUrlToId(widget.json),
          flags: YoutubePlayerFlags(
            controlsVisibleAtStart: false,
            autoPlay: true,
            mute: false,
          ));

    } else{
      var logger = Logger();
      logger.w("video");
      testUrl();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: wite,
          title: Image.asset("assets/images/1.png"),
          iconTheme: IconThemeData(color: gren,)
      ),
      body: Container(
        color: bg,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: ConstrainedBox(
            constraints: BoxConstraints(),
            child: Column(
              children: <Widget>[
                Container(
                  height: 250,
                  child: widget.tpe=="youtube"?youtube():playerVideo(),
                ),
                description(),
                SizedBox(
                  height: 30,
                ),
                programmeVideo(),
                SizedBox(
                  height: 25,
                ),
                _alauneVideos(),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget youtube(){
    return Container(
      width: double.infinity,
      color: Colors.black,
      child: Center(
        child: YoutubePlayer(
          controller: _controller,
          showVideoProgressIndicator: true,
          /*bottomActions: <Widget>[
                   IconButton(
                     padding: EdgeInsets.all(30.0),
                     icon: Icon(
                       Icons.arrow_back,
                       color: Colors.white,
                     ),
                     onPressed: () {
                       _controller.toggleFullScreenMode();
                     },
                   ),
                 ],*/
        ),
      ),
    );
  }
  Widget playerVideo() {
    return Container(
      height: 200,
      width: double.infinity,
      color: Colors.black,
      child: AspectRatio(
        aspectRatio: 16 / 9,

        child: BetterPlayer(controller: _betterPlayerController),
        key: _betterPlayerKey,
      ),
      //child: playerVideo(),
    );
  }

  /*Widget playerVideo() {
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

  Widget programmeVideo() {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [
                    Text(
                      "Videos Similaires",
                      style: TextStyle(
                        color: gren,
                        fontSize: 17,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _alauneVideos() {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      child: ConstrainedBox(
        constraints: BoxConstraints(),
        child: FutureBuilder(
            future: fetchAlauneByGroupe(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                );
              } else
                return GridView.count(
                  //scrollDirection: Axis.vertical,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  padding: EdgeInsets.all(8),
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 5,
                  children:
                  List.generate(snapshot.data.allitems.length, (index) {
                    return Column(
                      //mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                            child: FadeAnimation(
                                0.5,
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(

                                    child: CachedNetworkImage(
                                      imageUrl: snapshot.data.allitems[index].logo,width: 100,height: 100,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Image.asset(
                                        "assets/images/malikiaError.png",width: 150,
                                        fit: BoxFit.contain,
                                      ),
                                      errorWidget: (context, url, error) => Image.asset(
                                        "assets/images/malikiaError.png",width: 150,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    width: MediaQuery.of(context).size.width,
                                    height: 130,
                                  ),
                                )
                            ),
                            onTap: () {
                              //logger.d(snapshot.data.allitems[index].video_url);
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => LecteurDesReplayesEmisions(
                                      json: snapshot.data.allitems[index].videoUrl,
                                      //related: snapshot.data.allitems[index].relatedItems,
                                      texte: snapshot.data.allitems[index].title,
                                      descpt: snapshot.data.allitems[index].desc,
                                      heure: snapshot.data.allitems[index].time,
                                      tpe: snapshot.data.allitems[index].type,
                                      vido_url: snapshot.data.allitems[index].feedUrl,
                                      AlauneByGroup: snapshot.data,
                                    )
                                ),
                              );
                              var  logger = Logger();
                              logger.d(snapshot.data.allitems[index].feedUrl);
                            }
                        ),

                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            child: Text("${snapshot.data.allitems[index].title}",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: gren
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                      ],
                    );
                  }),
                );
            }),
      ),
    );
  }

  Widget description(){
    return Container(
      width: double.infinity,
      height: 50,
      color: wite,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: RichText(
              overflow: TextOverflow.ellipsis,
              strutStyle: StrutStyle(fontSize: 14),
              text: TextSpan(
                  style: TextStyle(color: gren),
                  text:
                  "${widget.texte}"),
            ),
          )



        ],
      ),
    );
  }
}
/*
Container(
            alignment: Alignment.centerLeft,
            child: Text(
              "${widget.heure}",
              style: TextStyle(fontSize: 16, color: gren),
            ),
          )
*/