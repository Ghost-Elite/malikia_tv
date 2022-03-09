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
import 'package:malikia_tv/pages/replayPage.dart';
import 'package:malikia_tv/pages/replay_page.dart';
import 'package:video_player/video_player.dart';
import '../animation/fadeanimation.dart';
import '../network/model/alauneByGroup.dart';
import '../network/model/api_list_by_groupe.dart';
import '../network/model/api_malikia.dart';
import '../network/model/api_video_url.dart';
import '../network/model/direct_api.dart';
import '../network/model/list_android.dart';
import '../network/model/live_api.dart';
import 'chaine_page.dart';
import 'drawer.dart';
import 'drawers.dart';
import 'emisions_page.dart';
import 'lecteur_emisions.dart';
import 'lecteur_malikia.dart';

final String menu = 'assets/images/menu.svg';
final String lecteur = 'assets/images/lecteur.svg';
Color gren = const Color(0xFF00722f);
Color wite = const Color(0xFFf8fbf8);
Color bg = const Color(0xFFEBEBEB);

class LecteurMalikiaPage extends StatefulWidget {
  var logger = Logger();
  Apimalikia apimalikia;
  Direct direct;
  String  test, lien;
  ListChannelsbygroup listChannelsbygroup;

  LecteurMalikiaPage({Key key, this.logger, this.apimalikia, this.direct,this.lien,this.test,this.listChannelsbygroup})
      : super(key: key);

  @override
  _LecteurMalikiaPageState createState() => _LecteurMalikiaPageState();
}

class _LecteurMalikiaPageState extends State<LecteurMalikiaPage> {
  ListAndroid listAndroid;
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
      enableSubtitles: false,
      enablePlaybackSpeed: false,
      loadingColor: gren,
      enableSkips: false,
      overflowMenuIconsColor: gren,
    ),
  );
  BetterPlayerController _betterPlayerController;
  VideoPlayerController playerController;
  ChewieController _chewieController;
  bool isVideoLoading = true;
  LiveApi liveApi;
  ListChannelsbygroup listChannelsbygroup;
  var logger = Logger();
  String url, time,test,lien,logo,videoId, title, titre;
  GlobalKey _betterPlayerKey = GlobalKey();
  String api,idVideo,json,related,texte,heure,descpt,tpe,vido_url;
  StreamController<bool> _playController = StreamController.broadcast();
  Direct direct;

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
      liveApi =LiveApi.withError("Data not found / Connection issue");

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
    Uri.parse("https://acanvod.acan.group/myapiv2/listChannelsByChaine/malikia/44/json");
    final response = await http.get(postListUrl);
    if (response.statusCode == 200) {
      return ListChannelsbygroup.fromJson(jsonDecode(response.body));
    } else {
      throw Exception();
    }
  }

  Future<AlauneByGroup> fetchAlauneByGroupe() async {
    var postListUrl = Uri.parse(
        "https://acanvod.acan.group/myapiv2/listChannelsbygroup/malikia/json");
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
  Future<void> testUrl() async {
    String url =
        "https://acanvod.acan.group/myapiv2/directplayback/44/json";
    final response = await http.get(Uri.parse(url));
    print(response.body);

    VideoUrl videoUrl = VideoUrl.fromJson(jsonDecode(response.body));
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


  }
  @override
  void initState() {
    betterPlayerConfiguration;

    _betterPlayerController = BetterPlayerController(betterPlayerConfiguration);
    _betterPlayerController.addEventsListener((event) {
      if (event.betterPlayerEventType == BetterPlayerEventType.play) {
        _playController.add(false);
      }
    });
    fetchListAndroid();
    //fetchList();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.initState();
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
            child: Text(
              "Impossible de lire la vidéo\n",
              style: TextStyle(color: Color(0xFF00722f), fontSize: 18),
            ),
          ),
        );
      },
    );
  }
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

    if (_betterPlayerController !=null) {
      _betterPlayerController.dispose();
      _betterPlayerController=null;
    }
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: wite,
        title: Image.asset("assets/images/1.png"),
        iconTheme: IconThemeData(color: gren,),

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
                child: AspectRatio(
                  aspectRatio: 16 / 9,

                  child: BetterPlayer(controller: _betterPlayerController),
                  key: _betterPlayerKey,
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
                          fontSize: 14,
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
                          children: <Widget>[item(), emissions(), itemVideos()]
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
        betterPlayerController: _betterPlayerController,
      ),
    );
  }

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
                        if (_betterPlayerController != null)_betterPlayerController.pause();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return PlusPage();
                          }),
                        );
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
                        if (_betterPlayerController != null)_betterPlayerController.pause();
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) {
                            return ReplyerPage();
                          }),
                        );
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

  Widget item() {
    return Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        //margin: const EdgeInsets.symmetric(horizontal: 10.2),

        height: 200.0,
        child: Container(
          child: FutureBuilder(
              future: fetchAlauneByGroupe(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.transparent,
                    ),
                  );
                } else
                  return Container(
                    child: ListView.builder(
                        itemCount: snapshot.data.allitems.length==null?0:snapshot.data.allitems.length,
                        shrinkWrap: true,
                        itemBuilder: (_, i) {
                          return Container(
                            margin: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 10),
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
                              child: Container(
                                //padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        height: 80,
                                        width: 140,
                                        //padding: EdgeInsets.all(7),
                                        child: GestureDetector(
                                            child: FadeAnimation(
                                                0.5,
                                                ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(0),
                                                  child: Container(
                                                    child: CachedNetworkImage(
                                                      imageUrl: snapshot
                                                          .data.allitems[i].logo,
                                                      width: 200,
                                                      height: 100,
                                                      fit: BoxFit.cover,
                                                      placeholder: (context, url) =>
                                                          Image.asset(
                                                            "assets/images/malikiaError.png",
                                                            width: 200,
                                                            height: 100,
                                                            fit: BoxFit.contain,
                                                          ),
                                                      errorWidget:
                                                          (context, url, error) =>
                                                          Image.asset(
                                                            "assets/images/malikiaError.png",
                                                            width: 200,
                                                            height: 100,
                                                            fit: BoxFit.contain,
                                                          ),
                                                    ),
                                                    width: MediaQuery.of(context)
                                                        .size
                                                        .width,
                                                    height: 100,
                                                  ),
                                                )),
                                            onTap: () {
                                              if (_betterPlayerController != null)_betterPlayerController.pause();
                                              //logger.d(snapshot.data.allitems[index].video_url);
                                              Navigator.of(context).pushAndRemoveUntil(
                                                  MaterialPageRoute(
                                                      builder: (context) => LecteurDesReplayesEmisions(
                                                        json: snapshot.data.allitems[i].videoUrl,
                                                        //related: snapshot.data.allitems[i].relatedItems,
                                                        texte: snapshot.data.allitems[i].title,
                                                        descpt: snapshot.data.allitems[i].desc,
                                                        heure: snapshot.data.allitems[i].time,
                                                        tpe: snapshot.data.allitems[i].type,
                                                        //vido_url: snapshot.data.allitems[i].feedUrl,
                                                        AlauneByGroup: snapshot.data,
                                                      )
                                                  ),
                                                      (Route<dynamic> route) => true);
                                              var  logger = Logger();
                                              logger.d(snapshot.data.allitems[i].relatedItems);
                                            }
                                        ),
                                      ),),
                                    SizedBox(width: 5,),
                                    Expanded(
                                      flex: 1,
                                      child: RichText(
                                        overflow: TextOverflow.ellipsis,
                                        strutStyle: StrutStyle(fontSize: 12.0),
                                        text: TextSpan(
                                            style: TextStyle(color: Colors.black),
                                            text:
                                            "${snapshot.data.allitems[i].title}"),
                                      ),
                                    ),
                                    Container(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (_betterPlayerController != null)_betterPlayerController.pause();
                                          Navigator.of(context).pushAndRemoveUntil(
                                              MaterialPageRoute(
                                                  builder: (context) => LecteurDesReplayesEmisions(
                                                    json: snapshot.data.allitems[i].videoUrl,
                                                    //related: snapshot.data.allitems[i].relatedItems,
                                                    texte: snapshot.data.allitems[i].title,
                                                    descpt: snapshot.data.allitems[i].desc,
                                                    heure: snapshot.data.allitems[i].time,
                                                    tpe: snapshot.data.allitems[i].type,
                                                    vido_url: snapshot.data.allitems[i].feedUrl,
                                                    AlauneByGroup: snapshot.data,
                                                  )
                                              ),
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
                            ),
                          );
                        }),
                  );
              }),
        ));
  }

  /*
  Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          ListTile(
                            leading: Image.asset("${snapshot.data.allitems[index].logoUrl}"),
                            title: const Text('Card title 1'),
                            subtitle: Text(
                              'Secondary Text',
                              style: TextStyle(color: Colors.black.withOpacity(0.6)),
                            ),
                            trailing: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                color: gren,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18),
                                ),
                              ),

                              child: FlatButton(
                                  onPressed: (){

                                  },
                                  child: Icon(
                                      Icons.play_arrow
                                  )),
                            ),
                          ),

                        ],
                      ),
                    )
  */
  Widget itemVideos() {
    return Container(
      //margin: const EdgeInsets.symmetric(horizontal: 10.2),
        margin: EdgeInsets.symmetric(vertical: 8.0),
        height: 184,
        child: FutureBuilder(
            future: fetchReplay(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.transparent,
                  ),
                );
              } else
                return Container(
                  child: ListView.builder(
                      itemCount: snapshot.data.allitems.length==null?0:snapshot.data.allitems.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (_, i) {
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
                                      width: 140,
                                      child: GestureDetector(
                                        child: FadeAnimation(
                                            0.5,
                                            ClipRRect(
                                              borderRadius:
                                              BorderRadius.circular(0),
                                              child: Container(
                                                child: CachedNetworkImage(
                                                  imageUrl: snapshot
                                                      .data.allitems[i].logo,
                                                  width: 200,
                                                  height: 200,
                                                  fit: BoxFit.cover,
                                                  placeholder: (context, url) =>
                                                      Image.asset(
                                                        "assets/images/2.png",
                                                        width: 200,
                                                        height: 100,
                                                        fit: BoxFit.contain,
                                                      ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                      Image.asset(
                                                        "assets/images/2.png",
                                                        width: 200,
                                                        height: 100,
                                                        fit: BoxFit.contain,
                                                      ),
                                                ),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                height: 140,
                                              ),
                                            )),
                                        onTap: () {
                                          if (_betterPlayerController != null)_betterPlayerController.pause();
                                          //logger.d(snapshot.data.allitems[index].video_url);
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) => EmisionsPage(
                                                    lien: snapshot.data.allitems[i].feedUrl,
                                                    listChannelsbygroup: snapshot.data
                                                )
                                            ),
                                          );
                                          var  logger = Logger();
                                          //logger.d(snapshot.data.allitems[i].relatedItems);
                                        },
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
                                        children: [RichText(
                                          overflow: TextOverflow.ellipsis,
                                          strutStyle: StrutStyle(fontSize: 12.0),
                                          text: TextSpan(
                                              style: TextStyle(color: Colors.black),
                                              text:
                                              "${snapshot.data.allitems[i].desc}\n".substring(0,10)),
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
                                        onPressed: (){

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
                );
            }));
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


}
